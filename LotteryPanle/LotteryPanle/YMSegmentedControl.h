//
//  YMSegmentedControl.h
//  ZCLottery
//
//  Created by *** on 2018/9/29.
//  Copyright © 2018年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SegmentDefaultType) {
    SegmentDefaultTypeRecent,//开奖
    SegmentDefaultTypeTrend,//走势
//    SegmentDefaultTypeNull
};

/**
 type : 1 2 3 分别为 大图  中图  小图  0代表没有。
 */
typedef void(^SegmentedControlPressBtnBlock)(NSInteger tag,NSString * title,NSString * type);

@interface YMSegmentedControl : TrendBaseView

@property(nonatomic,copy)SegmentedControlPressBtnBlock segmentedControlPressBtnBlock;

@property(nonatomic,assign)SegmentDefaultType segmentDefaultType;

//更新样式
- (void)updateSegmentControlUIWithlotteryName:(nonnull NSString *)lotteryName gamePlay:(nonnull NSString *)gamePlay;

@end

NS_ASSUME_NONNULL_END
