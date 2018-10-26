//
//  UIColor+Extension.m
//  LotteryPanle
//
//  Created by 任义春 on 2018/10/25.
//  Copyright © 2018年 LTD. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)
/**
 *  根据十六进制得到颜色
 *
 *  @param hexString 十六进制字符串：@"#e85352"
 */
+ (instancetype)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0];
}

+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha{

    // 转换成标准16进制数  @"#38722c"
    NSString *string =  [hexString stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
    // 16进制字符串转换成整形
    long colorLong = strtoul([string cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);

    return [UIColor colorWithRed:((float)((colorLong & 0xFF0000) >> 16))/255.0 green:((float)((colorLong & 0xFF00) >> 8))/255.0 blue:((float)(colorLong & 0xFF))/255.0 alpha:alpha];
}


+(NSMutableAttributedString *)buttonOneColor:(UIColor *)color twoColor:(UIColor *)twoColor title:(NSString *)title second:(NSString *)second{

    NSDictionary *attrTitleDict0 = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName: color};
    NSDictionary *attrTitleDict1 = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:10],NSForegroundColorAttributeName:twoColor};

    NSAttributedString *attrStr0 = [[NSAttributedString alloc] initWithString: [title substringWithRange: NSMakeRange(0, title.length)] attributes: attrTitleDict0];
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: [second substringWithRange: NSMakeRange(0, second.length)] attributes: attrTitleDict1];

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr0];
    [attributedStr appendAttributedString:attrStr1];
    return attributedStr;
}

+(NSMutableAttributedString *)buttonOneColor:(UIColor *)color title:(NSString*)title{
    NSDictionary *attrTitleDict0 = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName: color};
    NSAttributedString *attrStr0 = [[NSAttributedString alloc] initWithString: [title substringWithRange: NSMakeRange(0, title.length)] attributes: attrTitleDict0];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr0];

    return attributedStr;

}

@end
