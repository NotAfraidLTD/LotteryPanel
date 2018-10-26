//
//  TDTrendSidePanelView.m
//  ZCLottery
//
//  Created by 任义春 on 2018/10/8.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "TDTrendSidePanelView.h"

@interface TDTrendSidePanelView()

/** 展示数据 */
@property (nonatomic,strong) NSMutableArray<NSString *> * contents;

@end

@implementation TDTrendSidePanelView

- (void)correctorFrame{
    [super correctorFrame];

    // 获取内容  自适应处理
    CGFloat allWidth = 0.0;
    if (self.dataSource){
        for (int n = 0 ; n < self.columnNumber ; n++) {
            NSMutableArray * titles = [[NSMutableArray alloc] init];
            for (int i = 0 ; i < self.rowNumber ; i++){
                TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:n inSection:i]];
                if (model){
                    [titles addObject:model.content];
                }
            }

            if (self.delegate && [self.delegate respondsToSelector:@selector(panelView:widthForColumn:)] && [self.delegate panelView:self widthForColumn:n] != 0){
                allWidth = allWidth + [self.delegate panelView:self widthForColumn:n];
                [self.centreXOfColumnArray addObject:[NSNumber numberWithFloat:allWidth - [self.delegate panelView:self widthForColumn:n]/2]];
                [self.widthOfColumnArray addObject:[NSNumber numberWithFloat:[self.delegate panelView:self widthForColumn:n]]];
            }else{
                CGFloat oneWidth = [TDPanelFormManager calculationTextSizeWithString:[TDPanelFormManager getLongestStringWithArray:titles]].width + [TDPanelFormManager insetleft]*2;
                allWidth = allWidth + oneWidth;
                [self.widthOfColumnArray addObject:[NSNumber numberWithFloat:oneWidth]];
                [self.centreXOfColumnArray addObject:[NSNumber numberWithFloat:(allWidth - oneWidth/2)]];
            }
        }
    }
    self.width = allWidth;

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
    }
    self.height = allHeight;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    //  绘制底层的风格样式
    [self drawSeparationEffects];

    CGFloat drawStartY = 0.0;

    for (int i = 0; i < self.rowNumber ; i++) {
        CGFloat drawWidth = 0.0;
        CGFloat oneformH = 0.0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(panelView:heightForRow:)]){
            oneformH = [self.delegate panelView:self heightForRow:i] != 0 ? [self.delegate panelView:self heightForRow:i] : [TDPanelFormManager formHeight];
        }else{
            oneformH = [TDPanelFormManager formHeight];
        }
        for (int j = 0 ; j < self.columnNumber; j++){
            TDPanelModel * model = [self.dataSource panelView:self ContentForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            CGSize size = [TDPanelFormManager calculationTextSizeWithString:model.content];
            CGFloat insetTop = (oneformH - size.height)/2.0;
            CGFloat offsetLeft = 0.0f;
            if (size.width < [self.widthOfColumnArray[j] floatValue]){
                offsetLeft = [self.centreXOfColumnArray[j] floatValue] - size.width/2;
            }else{
                offsetLeft = [self.centreXOfColumnArray[j] floatValue] - [TDPanelFormManager calculationTextSizeWithString:model.content formFont:kFontSizeWith(12)].width/2;
            }
            [self drawTextLayerFrame:CGRectMake(offsetLeft, insetTop + drawStartY, size.width, size.height) foregroundColor:self.textColor font:size.width < [self.widthOfColumnArray[j] floatValue] ? [TDPanelFormManager formFont] : kFontSizeWith(12) content:model.content];
            drawWidth = drawWidth + [self.widthOfColumnArray[j] floatValue];
        }
        drawStartY = drawStartY + oneformH;
    }
}

/**
 绘制底层的风格样式
 */
- (void)drawSeparationEffects{
    // 绘制的起始坐标
    CGFloat drawStartY = 0.0;
    // 绘制文字
    for (int i = 0 ; i < self.rowNumber; i++) {
        // 绘制行背景分隔线
        [self drawSeparatebackgroundColor:self.layer ForRow:i withY:drawStartY];

        drawStartY = drawStartY + [self.heightOfRowArray[i] floatValue];
    }
    // 绘制列分隔线
    [self drawSeparateColmnLine];
}

/**
 绘制列分隔线
 */
- (void)drawSeparateColmnLine{

    // 绘制列分隔线
    CGFloat drawWidth = 0.0;
    for (int i = 0 ; i < self.widthOfColumnArray.count ; i++) {
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
