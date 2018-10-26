//
//  TDPanelHeaderView.m
//  ZCLottery
//
//  Created by 任义春 on 2018/10/13.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "TDPanelHeaderView.h"

@interface TDPanelHeaderView()


@end

@implementation TDPanelHeaderView

- (void)correctorFrame{
    [super correctorFrame];

    self.centreXOfColumnArray   = [[NSMutableArray alloc] init];
    [self.heightOfRowArray addObject:[NSNumber numberWithFloat:[self.delegate panelView:self heightForRow:0]]];
    // 获取内容  自适应处理
    CGFloat allWidth = 0.0;
    if (self.dataSource){
        for (int n = 0 ; n < self.columnNumber ; n++) {
            TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:n inSection:0]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(panelView:widthForColumn:)] && [self.delegate panelView:self widthForColumn:n] != 0){
                allWidth = allWidth + [self.delegate panelView:self widthForColumn:n];
                [self.centreXOfColumnArray addObject:[NSNumber numberWithFloat:allWidth - [self.delegate panelView:self widthForColumn:n]/2]];
                [self.widthOfColumnArray addObject:[NSNumber numberWithFloat:[self.delegate panelView:self widthForColumn:n]]];
            }else{
                CGFloat oneWidth = [TDPanelFormManager calculationTextSizeWithString:model.content].width + [TDPanelFormManager insetleft]*2;
                allWidth = allWidth + oneWidth;
                [self.widthOfColumnArray addObject:[NSNumber numberWithFloat:oneWidth]];
                [self.centreXOfColumnArray addObject:[NSNumber numberWithFloat:(allWidth - oneWidth/2)]];
            }
        }
    }
    self.width = allWidth;
    self.height = [self.delegate panelView:self heightForRow:0];
    self.userInteractionEnabled = YES;
    [self addClickAction];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    [self drawSeparatebackgroundColor:self.layer ForRow:0 withY:0.0f];

    [self drawSeparateColmnLine];

    for (int j = 0 ; j < self.columnNumber; j++) {
        // 绘制文字
        [self drawTextForRow:0 forColmn:j withY:0.0f];
    }

}

/**
 添加点击事件
 */
- (void)addClickAction{
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickResponder:)];
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:recognizer];
}

/**
 点击区域确认

 @param recognizer 点击手势
 */
- (void)clickResponder:(UIGestureRecognizer *)recognizer{
    CGPoint cliclPoint = [recognizer locationInView:self];
    NSInteger colmn = 0;
    NSInteger row = 0;
    for (int n = 0 ; n < self.centreXOfColumnArray.count ; n ++){
        if (cliclPoint.x > [self.centreXOfColumnArray[n] floatValue]){
            colmn = n;
        }
    }
    for (long n = self.heightOfRowArray.count-1 ; n > 0 ; n --){
        if (cliclPoint.y > [self.heightOfRowArray[n] floatValue]){
            row = n;
        }
    }

    if(self.delegate && [self.delegate respondsToSelector:@selector(panelView:didSelectRowAtIndexPath:)]){
        [self.delegate panelView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:colmn inSection:row]];
    }
}

/**
 绘制文字

 @param row                 行
 @param colmn               列
 @param startY              绘制起始Y位置
 */
- (void)drawTextForRow:(NSInteger)row forColmn:(NSInteger)colmn withY:(CGFloat)startY{
    TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:colmn inSection:row]];
    CGFloat oneFormH = [TDPanelFormManager formHeight];
    if(self.delegate && [self.delegate respondsToSelector:@selector(panelView:heightForRow:)]){
        oneFormH = [self.delegate panelView:self heightForRow:row];
    }
    if (model.order){
        CGSize size = [TDPanelFormManager calculationTextSizeWithString:model.content formFont:kFontSizeWith(12)];
        CGFloat offsetLeft = [self.centreXOfColumnArray[colmn] floatValue] - [TDPanelFormManager formOrderWidth]/2 - size.width/2 - [TDPanelFormManager formOrderInterval];
        CGFloat insetTop = (oneFormH - size.height)/2.0;
        CGFloat orderTop = (oneFormH - [TDPanelFormManager formOrderHeight]*2 -[TDPanelFormManager formOrderInterval])/2.0;
        CATextLayer * textLayer = [CATextLayer layer];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.frame = CGRectMake(offsetLeft, insetTop + startY, size.width + 2 , size.height);
        // 字体颜色
        textLayer.foregroundColor = model.contentColor.CGColor != nil ?  model.contentColor.CGColor : self.textColor.CGColor;
        // 字体名称、大小
        UIFont *font = kFontSizeWith(12);
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef =CGFontCreateWithFontName(fontName);
        textLayer.font = fontRef;
        textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        textLayer.string = model.content;
        [self.layer addSublayer:textLayer];
        [self drawOrderArrow:model.order withY:startY + orderTop withX:offsetLeft + size.width + [TDPanelFormManager formOrderInterval]];
    }else{
        CGSize size = [TDPanelFormManager calculationTextSizeWithString:model.content];
        CGFloat insetTop = (oneFormH - size.height)/2.0;
        [self drawTextLayerFrame:CGRectMake([self.centreXOfColumnArray[colmn] floatValue] - size.width/2, insetTop + startY, size.width, size.height) foregroundColor:self.textColor font:[TDPanelFormManager formFont] content:model.content];
    }

}

/**
 绘制排序箭头

 @param order           文字
 @param startY          绘制起始Y
 @param startX          绘制起始X
 */
- (void)drawOrderArrow:(NSString *)order withY:(CGFloat)startY withX:(CGFloat)startX{

    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startX+[TDPanelFormManager formOrderWidth]/2, startY)];
    [path addLineToPoint:CGPointMake(startX + [TDPanelFormManager formOrderWidth],startY + [TDPanelFormManager formOrderHeight])];
    [path addLineToPoint:CGPointMake(startX,startY + [TDPanelFormManager formOrderHeight])];
    [path closePath];
    layer.path = path.CGPath;
    if ([order isEqualToString:@"1"]){
        layer.fillColor = ZCHexColor(@"#DD3048").CGColor;
    }else{
        layer.fillColor = ZCHexColor(@"#D7D6D2").CGColor;
    }
    [self.layer addSublayer:layer];

    CAShapeLayer * layerD = [CAShapeLayer layer];
    UIBezierPath * pathd = [UIBezierPath bezierPath];
    [pathd moveToPoint:CGPointMake(startX, startY + [TDPanelFormManager formOrderHeight] + [TDPanelFormManager formOrderInterval])];
    [pathd addLineToPoint:CGPointMake(startX + [TDPanelFormManager formOrderWidth],startY + [TDPanelFormManager formOrderHeight] + [TDPanelFormManager formOrderInterval])];
    [pathd addLineToPoint:CGPointMake(startX + [TDPanelFormManager formOrderWidth]/2,startY + [TDPanelFormManager formOrderHeight] + [TDPanelFormManager formOrderInterval] + [TDPanelFormManager formOrderHeight])];
    [pathd closePath];
    layerD.path = pathd.CGPath;
    if ([order isEqualToString:@"2"]){
        layerD.fillColor = ZCHexColor(@"#DD3048").CGColor;
    }else{
        layerD.fillColor = ZCHexColor(@"#D7D6D2").CGColor;
    }
    [self.layer addSublayer:layerD];
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

@end
