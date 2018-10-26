//
//  TDPanelView.h
//  ZCLottery
//
//  Created by 任义春 on 2018/10/8.
//  Copyright © 2018年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDPanelModel.h"
#import "TDPanelFormManager.h"

@class TDPanelView;

@protocol TDPanelViewDataSource <NSObject>

@required

/**
 表格有多少行

 @param panelView           当前表格
 @return                    行数
 */
- (NSInteger)numberOfRowsInPanelView:(TDPanelView *)panelView;

/**
 表格有多少列

 @param panelView           当前表格
 @return                    列数
 */
- (NSInteger)numberOfColumnsInPanelView:(TDPanelView *)panelView;


/**
 表格内容获取

 @param panelView           当前表格
 @param indexPath           添加内容的表格
 @return                    表格显示的文字
 */
- (TDPanelModel *)panelView:(TDPanelView *)panelView ContentForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional


@end

@protocol TDPanelViewDelegate <NSObject>

@optional

/**
 设置行高

 @param panelView           当前表格
 @param row                 指定的行
 @return                    行高
 */
- (CGFloat)panelView:(TDPanelView *)panelView heightForRow:(NSInteger)row;

/**
 设置列宽

 @param panelView           当前表格
 @param column              指定的列
 @return                    列宽
 */
- (CGFloat)panelView:(TDPanelView *)panelView widthForColumn:(NSInteger)column;



/**
 点击表格

 @param panelView           表格
 @param indexPath           行列   section 行 row 列
 */
- (void)panelView:(TDPanelView *)panelView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_BEGIN

@interface TDPanelView : UIView

@property (nonatomic, weak) id<TDPanelViewDataSource> dataSource;

@property (nonatomic, weak) id<TDPanelViewDelegate> delegate;

/** 行数 */
@property (nonatomic, assign) NSInteger rowNumber;

/** 列数 */
@property (nonatomic, assign) NSInteger columnNumber;

/** 行高数组 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> * heightOfRowArray;

/** 列宽数组 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> * widthOfColumnArray;

/** X轴位置数组 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> * centreXOfColumnArray;

/** 分隔颜色数组 */
@property (nonatomic, strong) NSArray<NSString *> * differenceColors;

/**
 绘制表格中心圆

 @param superLayer      父视图layer
 @param center          圆的中心
 @param color           圆的填充色
 */
- (void)drawRound:(CALayer *)superLayer ArcCenter:(CGPoint)center fill:(UIColor *)color;


/**
 绘制分隔背景色

 @param superLayer          父视图layer
 @param row                 第几行
 @param startY              起始Y坐标
 */
- (void)drawSeparatebackgroundColor:(CALayer *)superLayer ForRow:(NSInteger)row withY:(CGFloat)startY;


/**
 绘制文字到固定区域

 @param frame               绘制区域
 @param color               绘制颜色
 @param font                字体大小
 @param string              文字内容
 */
- (void)drawTextLayerFrame:(CGRect)frame foregroundColor:(UIColor *)color font:(UIFont *)font content:(NSString *)string;


/**
 子类重写 调整表格尺寸 最后调用[self setNeedsDisplay];
 */
- (void)correctorFrame;

// 字体颜色
-(UIColor *)textColor;

// 分隔线颜色
-(UIColor *)lineColor;

-(UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
