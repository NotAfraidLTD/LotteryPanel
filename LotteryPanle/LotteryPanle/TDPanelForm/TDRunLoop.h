//
//  TDRunLoop.h
//  ZCLottery
//
//  Created by 任义春 on 2018/10/25.
//  Copyright © 2018年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDRunLoop : NSObject

typedef BOOL(^RunloopBlock)(void);

+ (instancetype)shareTDRunLoop;

//最大任务加载数 默认18(这里主要看屏幕能显示最多少个图片来确定)
@property (nonatomic,assign) NSUInteger maxQueue;

//添加任务
- (void)addTask:(RunloopBlock)unit withId:(id)key;

//移除所有任务
- (void)removeAllTasks;

@end
