//
//  TDPanelView.m
//  ZCLottery
//
//  Created by 任义春 on 2018/10/8.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "TDPanelView.h"


@implementation TDPanelView

- (void)setDelegate:(id<TDPanelViewDelegate>)delegate{
    _delegate = delegate;
}

- (void)setDataSource:(id<TDPanelViewDataSource>)dataSource{
    _dataSource = dataSource;
}

/**
 绘制表格中心圆

 @param superLayer      父视图layer
 @param center          圆的中心
 @param color           圆的填充色
 */
- (void)drawRound:(CALayer *)superLayer ArcCenter:(CGPoint)center fill:(UIColor *)color{
    //ArcCenter:中心点 //radius:半径 //startAngle：起始角度 //endAngle：结束角度 //clockwise：是否逆时针
    CAShapeLayer * layer = [CAShapeLayer layer];
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:center radius:[TDPanelFormManager formRadius] startAngle:0 endAngle:M_PI*2 clockwise:NO];
    layer.path = path.CGPath;
    layer.fillColor = color.CGColor;
    [superLayer addSublayer:layer];
}

/**
 绘制分隔背景色

 @param superLayer          父视图layer
 @param row                 第几行
 @param startY              起始Y坐标
 */
- (void)drawSeparatebackgroundColor:(CALayer *)superLayer ForRow:(NSInteger)row withY:(CGFloat)startY{
    if (self.heightOfRowArray.count < row){
        return;
    }
    CAShapeLayer * layer = [CAShapeLayer layer];
    // 绘制分隔行颜色
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0 , startY)];
    [path addLineToPoint:CGPointMake(self.width,startY)];
    [path addLineToPoint:CGPointMake(self.width,startY + [self.heightOfRowArray[row] floatValue])];
    [path addLineToPoint:CGPointMake(0 , startY + [self.heightOfRowArray[row] floatValue])];
    [path closePath];
    layer.path = path.CGPath;
    layer.fillColor = ZCHexColor(self.heightOfRowArray.count == 1 ? self.differenceColors.lastObject : self.differenceColors[row%self.differenceColors.count]).CGColor;
    [superLayer addSublayer:layer];
}

/**
绘制文字到固定区域

 @param frame               绘制区域
 @param color               绘制颜色
 @param font                字体大小
 @param string              文字内容
 */
- (void)drawTextLayerFrame:(CGRect)frame foregroundColor:(UIColor *)color font:(UIFont *)font content:(NSString *)string{
    CATextLayer * textLayer = [CATextLayer layer];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    CGFloat Nwidth = frame.size.width + 4;
    frame.size.width = Nwidth;
    textLayer.frame = frame;
    // 字体颜色
    textLayer.foregroundColor = color.CGColor;
    // 字体名称、大小
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    textLayer.string = string;
    [self.layer addSublayer:textLayer];
}

// 调整表格尺寸
- (void)correctorFrame{
    self.heightOfRowArray       = [[NSMutableArray alloc] init];
    self.widthOfColumnArray     = [[NSMutableArray alloc] init];
    self.centreXOfColumnArray   = [[NSMutableArray alloc] init];
    self.rowNumber              = [self.dataSource numberOfRowsInPanelView:self];
    self.columnNumber           = [self.dataSource numberOfColumnsInPanelView:self];
}

// 字体颜色
-(UIColor *)textColor{
    return ZCHexColor(@"#A29E9A");
}

// 分隔线颜色
-(UIColor *)lineColor{
    return ZCHexColor(@"#D7D6D2");
}

// 颜色值数组
-(NSArray<NSString *> *)differenceColors{
    if (_differenceColors.count > 0){
        return _differenceColors;
    }
    return @[@"#FFFFFF",@"#F3F3EA"];
}



-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}



@end
