//
//  ZCLotteryConst.h
//  YTFrame
//
//  Created by yang on 2017/4/10.
//  Copyright © 2017年 yang. All rights reserved.
//
//  常量、宏 配置项
#import <UIKit/UIKit.h>

// ---------------------------------------- 空检测 ----------------------------------------

//空检测
#define isEmpty(a) ((a) == nil || [(a) isEqual:@""] || [(a) isEqual:@" "]||[(a) isKindOfClass:[NSNull class]] || [(a) isEqual:@"<null>"])
/**
 字符串防空判断
 */
#define isStrEmpty(string) (string == nil || string == NULL || (![string isKindOfClass:[NSString class]]) || ([string isEqual:@""]) || [string isEqualToString:@""] || [string isEqualToString:@" "] || ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) || ([string respondsToSelector:@selector(length)] && [(NSData *)string length] == 0) || [string isEqualToString:@"(null)"] )
/**
 数组防空判断
 */
#define isArrEmpty(array) (array == nil || array == NULL || (![array isKindOfClass:[NSArray class]]) || array.count == 0)
/**
 字典防空判断
 */
#define isDictEmpty(dict) (dict == nil || dict == NULL || (![dict isKindOfClass:[NSDictionary class]]) || dict.count == 0)
/**
 NSURL防空判断，只判断url是不是空，
 不检测是不是合法，不检测能不能正常发起请求
 */
#define isUrlEmpty(url) (url == nil || url == NULL || [url isEqual:[NSNull null]] || (![url isKindOfClass:[NSURL class]]) || url.absoluteString.length == 0)


// ---------------------------------------- 字体设置 ----------------------------------------
#define kFontSizeWith(value) [UIFont systemFontOfSize:[UIFont ZC_FontSize:value]] // 字体大小设置
#define kFontblodSizeWith(value) [UIFont boldSystemFontOfSize:[UIFont ZC_FontSize:value]] // 加粗字体设置

// ---------------------------------------- 颜色设置 ----------------------------------------
#define ZCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define ZCColorAlpha(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define ZCRandColor ZCColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
/** 十六进制颜色值 */
#define ZCHexColor(strValue) [UIColor colorWithHexString:(strValue)]

#define LotteryName @"LotteryName"
#define kRedColor kRedColorAlpha(1.0) // 全局按钮颜色：现在为红色
#define kRedColorAlpha(value) [UIColor colorWithHexString:@"#dd3048" alpha:value] // 全局按钮颜色：现在为红色


// ---------------------------------------- 调试设置 ----------------------------------------
/** 打印函数*/
#define ZCLogFunc ZCLog(@"%s",__func__)

#ifdef DEBUG
#define ZCLog(format, ...) printf(">>> Class: < %s:(%d) > \n>>> Method: %s\n %s\n>>>LogEnd~~~~~~\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define ZCLog(format, ...)
#endif


#define WeakSelf(type)  __weak typeof(type) weakSelf = type;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

// ----------------------------------------- 屏幕尺寸设置 ------------------------------------

#define ZC_Screen_W [UIScreen mainScreen].bounds.size.width
#define ZC_Screen_H [UIScreen mainScreen].bounds.size.height

#define ZC_iPhone_4x      ZC_Screen_W == 320 && ZC_Screen_H == 480
#define ZC_iPhone_5x      ZC_Screen_W == 320 && ZC_Screen_H == 568
#define ZC_iPhone_6x      ZC_Screen_W == 375 && ZC_Screen_H == 667
#define ZC_iPhone_6x_plus ZC_Screen_W == 414 && ZC_Screen_H == 736
#define ZC_iPhoneX        ZC_Screen_W == 375 && ZC_Screen_H == 812

#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define IOS9 [[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0
#define IOS10 [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0
#define IOS11 [[[UIDevice currentDevice]systemVersion] floatValue] >= 11.0

// 控件缩放比例
#define ZC_SCALE_WIDTH(w) (ZC_Screen_W/375.0*w)
#define ZC_SCALE_HEIGHT(h) (ZC_Screen_H/667.0*h)

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// ----------------------------------------- 导航栏和Tabbar ------------------------------------
// 导航栏高度
#define ZCNav_topH (ZC_iPhoneX ? 88 : 64)
// iPhone X 状态栏安全高度
#define ZCStatus_H  (ZC_iPhoneX ? 44 : 20)
// tabbar高度
#define ZCTab_H (ZC_iPhoneX ? 83 : 49)
// iPhone X tabbar安全高度
#define ZCTabMustAddSafe (ZC_iPhoneX ? 34: 0)

// ----------------------------------------- 其它设置 ------------------------------------
/** 弹框统一提示文本 */
/** 访问网络错误 */
#define kNetworkingRequetFail @"网络开小差了"
/** 访问网络超时 */
#define kNetworkingRequetTimeOut @"请求超时,请稍后重试"
/** 访问服务器错误 */
#define kNetworkingRequetErrorl @"请求失败,请稍后重试"


#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}




















