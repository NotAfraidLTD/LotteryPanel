//
//  TDPanelFormManager.h
//  ZCLottery
//
//  Created by 任义春 on 2018/10/9.
//  Copyright © 2018年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDPanelFormManager : NSObject

/**
 过滤字符串数组获取最长字符串

 @param array 过滤数组
 @return      最长字符
 */
+ (NSString *)getLongestStringWithArray:(NSArray<NSString *> *)array;

/**
 计算字符内容的尺寸

 @param text 文字内容
 @return     计算好的尺寸
 */
+ (CGSize)calculationTextSizeWithString:(NSString *)text;

/**
 计算字符内容的格式尺寸

 @param text 文字内容
 @param font 文字大小
 @return 计算好的尺寸
 */
+ (CGSize)calculationTextSizeWithString:(NSString *)text formFont:(UIFont *)font;

// 表格高度
+ (CGFloat)formHeight;

// 表格内圆半径
+ (CGFloat)formRadius;

// 文字左边距
+ (CGFloat)insetleft;

// 字体大小
+ (UIFont *)formFont;

// 角标字体大小
+ (UIFont *)badgeFont;

// 表格内矩形 文字边距
+ (CGFloat)formInternal;

// 排序图标宽度
+ (CGFloat)formOrderWidth;

// 排序图标和标题间隔
+ (CGFloat)formOrderInterval;

// 排序图标高度
+ (CGFloat)formOrderHeight;

@end
