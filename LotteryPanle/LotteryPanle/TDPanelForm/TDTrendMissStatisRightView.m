//
//  TDTrendMissStatisRightView.m
//  ZCLottery
//
//  Created by 任义春 on 2018/10/9.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "TDTrendMissStatisRightView.h"

@interface TDTrendMissStatisRightView()

/** 记录连线点 */
@property (nonatomic, strong) NSMutableDictionary * nodes;

@end

@implementation TDTrendMissStatisRightView

- (void)correctorFrame{
    [super correctorFrame];
    self.nodes                  = [[NSMutableDictionary alloc] init];

    // 计算行高
    CGFloat allHeight = 0.0;
    for (int i = 0 ; i < self.rowNumber ; i++){
        if (self.delegate && [self.delegate respondsToSelector:@selector(panelView:heightForRow:)] &&[self.delegate panelView:self heightForRow:i] != 0){
            allHeight = allHeight + [self.delegate panelView:self heightForRow:i];
            [self.heightOfRowArray addObject:[NSNumber numberWithFloat:[self.delegate panelView:self heightForRow:i]]];
        }else{
            allHeight = allHeight + [TDPanelFormManager formHeight];
            [self.heightOfRowArray addObject:[NSNumber numberWithFloat:[TDPanelFormManager formHeight]]];
        }
        self.height = allHeight;
    }

    // 获取内容  自适应处理
    CGFloat allWidth = 0.0;
    if (self.dataSource){
        for (int n = 0 ; n < self.columnNumber ; n++) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(panelView:widthForColumn:)] && [self.delegate panelView:self widthForColumn:n] != 0){
                allWidth = allWidth + [self.delegate panelView:self widthForColumn:n];
                [self.centreXOfColumnArray addObject:[NSNumber numberWithFloat:allWidth - [self.delegate panelView:self widthForColumn:n]/2]];
                [self.widthOfColumnArray addObject:[NSNumber numberWithFloat:[self.delegate panelView:self widthForColumn:n]]];
            }else{
                NSMutableArray * titles = [[NSMutableArray alloc] init];
                for (int i = 0 ; i < self.rowNumber ; i++){
                    TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:n inSection:i]];
                    if (model){
                        [titles addObject:model.content];
                    }
                }
                CGFloat oneWidth = [TDPanelFormManager calculationTextSizeWithString:[TDPanelFormManager getLongestStringWithArray:titles]].width + [TDPanelFormManager insetleft]*2;
                allWidth = allWidth + oneWidth;
                [self.widthOfColumnArray addObject:[NSNumber numberWithFloat:oneWidth]];
                [self.centreXOfColumnArray addObject:[NSNumber numberWithFloat:(allWidth - oneWidth/2)]];
            }
        }
    }
    self.width = allWidth;
    if (!self.showRow){
        self.showRow = 25;
    }
    if (!self.drawRow){
        self.drawRow = 10;
    }
}

- (void)setStartRow:(int)startRow{
    _startRow = startRow;
    [self drawRectA];
}

- (void)drawRectA{

    // 绘制的起始坐标
    CGFloat drawStartY = self.startRow * [TDPanelFormManager formHeight];

    // 绘制行数
     __block int drawNumberRow = (drawStartY + self.showRow * [TDPanelFormManager formHeight]) >= self.height ? (int)(self.rowNumber - self.startRow) : self.showRow ;

    //  绘制底层的风格样式
    [self drawSeparationEffectDrawSeparateColmnLine:!self.isEmpty];

    //  绘制节点连线样式
    if (!self.hideLine){
        [self drawNodesEffects];
    }

    if (self.isEmpty){
        [self drawViewIsEmpty];
        return;
    }

    [self drawAreaWithStartRow:self.startRow drawCount:drawNumberRow];
    
    if (drawNumberRow < self.rowNumber){

        int start = self.startRow;
        while (start > 0) {
            int count = (start - self.drawRow) > 0 ? self.drawRow : start;
            start = start - count;
            WeakSelf(self);
            [[TDRunLoop shareTDRunLoop] addTask:^BOOL{
                [weakSelf drawAreaWithStartRow:start drawCount:count];
                return YES;
            } withId:@"第二次"];
        }

        int ostart = drawNumberRow + self.startRow;
        while (ostart < self.rowNumber) {
            int count = (int)(self.rowNumber - ostart - self.drawRow) > 0 ? self.drawRow : (int)(self.rowNumber - ostart) ;
            WeakSelf(self);
            [[TDRunLoop shareTDRunLoop] addTask:^BOOL{
                [weakSelf drawAreaWithStartRow:ostart drawCount:count];
                return YES;
            } withId:@"第三次"];
            ostart = ostart + count;
        }
    }
}

/**
 单独绘制某个区域

 @param start       起始行
 @param count       绘制行数
 */
- (void)drawAreaWithStartRow:(int)start drawCount:(int)count{
    // 绘制的起始坐标
    CGFloat drawStartY = start * [TDPanelFormManager formHeight];
    // 绘制文字
    for (int i = 0 ; i < count ; i++) {

        for (int j = 0 ; j < self.columnNumber; j++) {
            TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i+start]];
            if (model == nil){
                // 未开奖
                [self drawTheRowIsEmptyForRow:i+start forColmn:j withY:drawStartY];
            }else{
                // 添加形状
                model.customWidth = [self.widthOfColumnArray[j] floatValue];
                [self drawDiffFormFormmodel:model ArcCenter:CGPointMake([self.centreXOfColumnArray[j] floatValue], drawStartY + ([self.heightOfRowArray[i+start] floatValue]/2))];
                // 绘制文字
                [self drawTextForRow:i+start forColmn:j withY:drawStartY];
            }
        }
        drawStartY = drawStartY + [self.heightOfRowArray[i+start] floatValue];
    }
}

- (void)drawViewIsEmpty{
    NSString * emptyStr = @"等待开奖后更新";
    CGSize size = [TDPanelFormManager calculationTextSizeWithString:emptyStr formFont:kFontSizeWith(16)];
    CGFloat insetTop = (self.height - size.height)/2.0;
    [self drawTextLayerFrame:CGRectMake(self.width/2 - size.width/2, insetTop, size.width, size.height) foregroundColor:self.textColor font:kFontSizeWith(16) content:emptyStr];
}

/**
 未开奖展示

 @param row             行
 @param colmn           列
 @param startY          绘制起始坐标
 */
- (void)drawTheRowIsEmptyForRow:(NSInteger)row forColmn:(NSInteger)colmn withY:(CGFloat)startY{

    // 绘制分隔行颜色
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(1 , startY)];
    [path addLineToPoint:CGPointMake(self.width,startY)];
    [path addLineToPoint:CGPointMake(self.width,startY + [self.heightOfRowArray[row] floatValue])];
    [path addLineToPoint:CGPointMake(1 , startY + [self.heightOfRowArray[row] floatValue])];
    [path closePath];
    layer.fillColor = ZCHexColor(self.heightOfRowArray.count == 1 ? self.differenceColors.lastObject : self.differenceColors[row%self.differenceColors.count]).CGColor;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];

    NSString * emptyStr = @"等待开奖...";
    CGSize size = [TDPanelFormManager calculationTextSizeWithString:emptyStr];
    CGFloat oneFormH = [TDPanelFormManager formHeight];
    if(self.delegate && [self.delegate respondsToSelector:@selector(panelView:heightForRow:)]){
        oneFormH = [self.delegate panelView:self heightForRow:row];
    }
    CGFloat insetTop = (oneFormH - size.height)/2.0;
    [self drawTextLayerFrame:CGRectMake(self.width/2 - size.width/2, insetTop + startY, size.width, size.height) foregroundColor:self.textColor font:[TDPanelFormManager formFont] content:emptyStr];
}


/**
 绘制底层的风格样式
 */
- (void)drawSeparationEffectDrawSeparateColmnLine:(BOOL)isDraw{
    // 绘制的起始坐标
    CGFloat drawStartY = 0.0;
    // 绘制文字
    for (int i = 0 ; i < self.rowNumber; i++) {
        // 绘制行背景分隔线
        [self drawSeparatebackgroundColor:self.layer ForRow:i withY:drawStartY];
        drawStartY = drawStartY + [self.heightOfRowArray[i] floatValue];
    }
    if (isDraw){
        // 绘制列分隔线
        [self drawSeparateColmnLine];
    }
}

/**
 绘制列分隔线
 */
- (void)drawSeparateColmnLine{

    // 绘制列分隔线
    if (self.widthOfColumnArray.count > 0){
        CAShapeLayer * layer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0 , 0)];
        [path addLineToPoint:CGPointMake(0, self.height)];
        path.lineWidth = 1;
        layer.strokeColor = self.lineColor.CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
    }

    CGFloat drawWidth = 0.0;
    for (int i = 0 ; i < self.widthOfColumnArray.count; i++) {
        CAShapeLayer * layer = [CAShapeLayer layer];
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake([self.widthOfColumnArray[i] floatValue] + drawWidth , 0)];
        [path addLineToPoint:CGPointMake([self.widthOfColumnArray[i] floatValue] + drawWidth ,self.height)];
        drawWidth = drawWidth + [self.widthOfColumnArray[i] floatValue];
        path.lineWidth = 1;
        layer.strokeColor = self.lineColor.CGColor;
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
    }
}


/**
 绘制节点连线样式
 */
- (void)drawNodesEffects{
    // 绘制的起始坐标
    CGFloat drawStartY1 = 0.0;
    // 绘制节点连线
    for (int i = 0 ; i < self.rowNumber; i++) {
        for (int j = 0 ; j < self.columnNumber; j++) {
            TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            // 连线
            if (model.isNode){
                [self drawLineWithPanelModel:model forRow:i forColmn:j withY:drawStartY1];
            }
        }
        drawStartY1 = drawStartY1 + [self.heightOfRowArray[i] floatValue];
    }
}

/**
 节点连线

 @param model               模型
 @param row                 行
 @param colmn               列
 @param startY              绘制起始Y坐标
 */
- (void)drawLineWithPanelModel:(TDPanelModel *)model forRow:(NSInteger)row forColmn:(NSInteger)colmn withY:(CGFloat)startY{

    // 记录连线节点
    if (!self.nodes[model.nodeIdentity]){
        model.row = row;
        model.colmn = colmn;
        [self.nodes setObject:model forKey:model.nodeIdentity];
        return;
    }
    TDPanelModel * oldNode = self.nodes[model.nodeIdentity];
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake([self.centreXOfColumnArray[oldNode.colmn] floatValue], startY - ([self.heightOfRowArray[oldNode.row] floatValue]/2))];
    [path addLineToPoint:CGPointMake([self.centreXOfColumnArray[colmn] floatValue], startY + ([self.heightOfRowArray[row] floatValue]/2))];
    layer.lineWidth = 1.5;
    layer.strokeColor = model.lineColor.CGColor != nil ? model.lineColor.CGColor : self.lineColor.CGColor;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];

    [self.nodes removeObjectForKey:model.nodeIdentity];
    model.row = row;
    model.colmn = colmn;
    [self.nodes setObject:model forKey:model.nodeIdentity];
}

/**
 绘制特殊效果

 @param model               模型
 @param center              中心点
 */
- (void)drawDiffFormFormmodel:(TDPanelModel *)model ArcCenter:(CGPoint)center{
    if (model.diffType){
        switch (model.diffType) {
            case TDPanelFormRound:
                // 添加中心圆
                [self drawRound:self.layer ArcCenter:center fill:model.diffTypeColor != nil? model.diffTypeColor : self.nodeColor];
                break;
            case TDPanelFormRectangle:
                // 添加矩形
                [self drawRectangleFormmodel:model arcCenter:center fill:model.diffTypeColor != nil? model.diffTypeColor : self.nodeColor];
                break;
            default:
                break;
        }
    }
    if (model.badgeNumber){
        // 添加角标
        [self drawBadgeRoundWithCenter:CGPointMake(center.x + [TDPanelFormManager formRadius], center.y - [TDPanelFormManager formRadius] + 3 ) radius:ZC_SCALE_WIDTH(6) fill:model.badgeColor != nil? model.badgeColor : self.nodeColor number:model.badgeNumber numberColor:self.nodeTextColor];
    }
}

/**
 绘制矩形样式

 @param center              中心
 @param color               颜色
 */
- (void)drawRectangleFormmodel:(TDPanelModel *)model arcCenter:(CGPoint)center fill:(UIColor *)color{

    CGSize size = [TDPanelFormManager calculationTextSizeWithString:model.content];
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(center.x - model.customWidth/2 + [TDPanelFormManager formInternal], center.y - size.height/2 - [TDPanelFormManager formInternal], model.customWidth - [TDPanelFormManager formInternal] *2, size.height + [TDPanelFormManager formInternal] *2)];
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    layer.fillColor = color.CGColor;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
}

/**
 绘制文字

 @param row                 行
 @param colmn               列
 @param startY              绘制起始Y位置
 */

- (void)drawTextForRow:(NSInteger)row forColmn:(NSInteger)colmn withY:(CGFloat)startY{
    TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:colmn inSection:row]];
    if (model.isMiss && self.hideMiss){
        return;
    }
    CGSize size = [TDPanelFormManager calculationTextSizeWithString:model.content];

    CGFloat oneFormH = [TDPanelFormManager formHeight];
    if(self.delegate && [self.delegate respondsToSelector:@selector(panelView:heightForRow:)]){
        oneFormH = [self.delegate panelView:self heightForRow:row];
    }
    CGFloat insetTop = (oneFormH - size.height)/2.0;

    if (model.attributeContent){

        NSString * firstString = [model.content substringToIndex:model.content.length - model.attributeContent.length];
        
        CGSize presize = [TDPanelFormManager calculationTextSizeWithString:firstString];
        
        CGSize attsize = [TDPanelFormManager calculationTextSizeWithString:model.attributeContent];
        
        [self drawTextLayerFrame:CGRectMake([self.centreXOfColumnArray[colmn] floatValue] - size.width/2, insetTop + startY, presize.width, presize.height) foregroundColor:model.contentColor != nil ?  model.contentColor : self.textColor font:[TDPanelFormManager formFont] content:firstString];
        
        [self drawTextLayerFrame:CGRectMake([self.centreXOfColumnArray[colmn] floatValue] - size.width/2 + presize.width, insetTop + startY, attsize.width, attsize.height) foregroundColor: model.attributeDict[NSForegroundColorAttributeName] ?  model.attributeDict[NSForegroundColorAttributeName] : self.textColor font:[TDPanelFormManager formFont] content:model.attributeContent];
        
    }else{

        CGFloat offsetLeft = 0.0f;
        if (size.width < [self.widthOfColumnArray[colmn] floatValue]){

            offsetLeft = [self.centreXOfColumnArray[colmn] floatValue] - size.width/2;

            [self drawTextLayerFrame:CGRectMake(offsetLeft, insetTop + startY, size.width, size.height) foregroundColor: model.contentColor != nil ?  model.contentColor : self.textColor font:[TDPanelFormManager formFont] content:model.content];
        }else{

            CGSize osize = [TDPanelFormManager calculationTextSizeWithString:model.content formFont:kFontSizeWith(12)];

            offsetLeft = [self.centreXOfColumnArray[colmn] floatValue] - osize.width/2;

            [self drawTextLayerFrame:CGRectMake(offsetLeft, insetTop + startY, osize.width, osize.height) foregroundColor: model.contentColor != nil ?  model.contentColor : self.textColor font:kFontSizeWith(12) content:model.content];
        }
    }
}

/**
 绘制角标小圆

 @param center          小圆的中心
 @param radius          小圆的半径  
 @param color           小圆的颜色
 @param number          小圆显示的数字
 */
- (void)drawBadgeRoundWithCenter:(CGPoint)center radius:(CGFloat)radius fill:(UIColor *)color number:(NSString *)number numberColor:(UIColor*)numberColor{
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:NO];
    layer.fillColor = color.CGColor;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
    CGSize size = [TDPanelFormManager calculationTextSizeWithString:number];
    [number drawInRect:CGRectMake(center.x - size.width/3, center.y - size.height/3.3, size.width, size.height) withAttributes:@{NSFontAttributeName : [TDPanelFormManager badgeFont] , NSForegroundColorAttributeName : numberColor}];
    [self drawTextLayerFrame:CGRectMake(center.x - size.width/3, center.y - size.height/3.3, size.width, size.height) foregroundColor:numberColor font:[TDPanelFormManager badgeFont] content:number];
}

- (void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    [self setNeedsDisplay];
}


- (void)setHideMiss:(BOOL)hideMiss{
    _hideMiss = hideMiss;
    [self setNeedsDisplay];
}


// 圆点字体颜色
-(UIColor *)nodeTextColor{
    return ZCHexColor(@"#FFFFFF");
}

// 圆点颜色
-(UIColor *)nodeColor{
    return ZCHexColor(@"#DD3048");
}



@end
