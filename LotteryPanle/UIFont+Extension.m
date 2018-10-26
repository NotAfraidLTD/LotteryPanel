//
//  UIFont+Extension.m
//  LotteryPanle
//
//  Created by *** on 2018/10/25.
//  Copyright © 2018年 LTD. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

/** 根据不同设备返回字体大小 */
+ (CGFloat)ZC_FontSize:(CGFloat)size {
    if (ZC_iPhone_4x) {
        size *= 0.84;
    }
    if (ZC_iPhone_5x) {
        size *= 0.84;
    }
    if ((ZC_iPhone_6x)||(ZC_iPhoneX)) {
        size *= 1;
    }
    if (ZC_iPhone_6x_plus) {
        size *= 1.104;
    }
    return size;
}

@end
