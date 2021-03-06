//
//  UIColor+Extension.h
//  YTFrame
//
//  Created by yang on 2017/4/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)



/**
 *  根据十六进制得到颜色
 *
 *  @param hexString 十六进制字符串：@"#e85352"
 */
+ (instancetype)colorWithHexString:(NSString *)hexString;
+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+(NSMutableAttributedString *)buttonOneColor:(UIColor *)color twoColor:(UIColor *)twoColor title:(NSString *)title second:(NSString *)second;

+(NSMutableAttributedString *)buttonOneColor:(UIColor *)color title:(NSString*)title;

@end
