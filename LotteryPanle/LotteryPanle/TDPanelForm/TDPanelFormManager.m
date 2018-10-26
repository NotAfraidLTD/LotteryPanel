//
//  TDPanelFormManager.m
//  ZCLottery
//
//  Created by 任义春 on 2018/10/9.
//  Copyright © 2018年 yang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TDPanelFormManager.h"

@implementation TDPanelFormManager

/**
 过滤字符串数组获取最长字符串

 @param array 过滤数组
 @return      最长字符
 */
+ (NSString *)getLongestStringWithArray:(NSArray<NSString *> *)array{
    NSString * longestStr = [[NSString alloc] init];
    for (NSString * string in array) {
        if(string.length > longestStr.length){
            longestStr = string;
        }
    }
    return longestStr;
}

/**
 计算字符内容的格式尺寸

 @param text 文字内容
 @return 计算好的尺寸
 */
+ (CGSize)calculationTextSizeWithString:(NSString *)text{
    NSDictionary * attributeDict =@{ NSFontAttributeName : [TDPanelFormManager formFont] };
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, [TDPanelFormManager formHeight]) options:(NSStringDrawingUsesFontLeading) attributes:attributeDict context:nil ].size;
    return contentSize;
}

/**
 计算字符内容的格式尺寸

 @param text 文字内容
 @param font 文字大小
 @return 计算好的尺寸
 */
+ (CGSize)calculationTextSizeWithString:(NSString *)text formFont:(UIFont *)font{
    NSDictionary * attributeDict =@{ NSFontAttributeName : font};
    CGSize contentSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, [TDPanelFormManager formHeight]) options:(NSStringDrawingUsesFontLeading) attributes:attributeDict context:nil ].size;
    return contentSize;
}

// 表格高度
+ (CGFloat)formHeight{
    return ZC_SCALE_WIDTH(30);
}

// 表格内圆半径
+ (CGFloat)formRadius{
    return ZC_SCALE_WIDTH(30-10)/2;
}

// 表格内矩形 文字边距
+ (CGFloat)formInternal{
    return ZC_SCALE_WIDTH(4.5);
}


// 文字左边距
+ (CGFloat)insetleft{
    return ZC_SCALE_WIDTH(14);
}

// 字体大小
+ (UIFont *)formFont{
    return kFontSizeWith(13);
}

// 排序图标宽度
+ (CGFloat)formOrderWidth{
    return ZC_SCALE_WIDTH(10);
}

// 排序图标高度
+ (CGFloat)formOrderHeight{
    return ZC_SCALE_WIDTH(5.88);
}

// 排序图标和标题间隔
+ (CGFloat)formOrderInterval{
    return ZC_SCALE_WIDTH(3);
}

// 角标字体大小
+ (UIFont *)badgeFont{
    return kFontSizeWith(8);
}


@end
