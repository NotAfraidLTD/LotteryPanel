//
//  UIView+Extension.h
//  YTFrame
//
//  Created by yang on 2017/4/10.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIView (Extension)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/** LM 新增 */
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
/** HQC 新增 */
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;

/**
 *  加载xib
 */
+ (instancetype)viewFromXib;

/**
 *  判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;





@end
