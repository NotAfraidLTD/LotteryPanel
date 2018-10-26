//
//  TDRunLoop.m
//  ZCLottery
//
//  Created by 任义春 on 2018/10/25.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "TDRunLoop.h"
#import <objc/message.h>

@interface TDRunLoop ()
//定时器 这里定时器里面不要进行操作，否则可能会导致反优化（如果处理了耗时操作，电池电量也会加快）
@property (nonatomic,strong) NSTimer * timer;
//任务数组
@property (nonatomic,strong) NSMutableArray * tasks;

@end

@implementation TDRunLoop

static TDRunLoop * _instance = nil;

+ (instancetype)shareTDRunLoop{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[TDRunLoop alloc] init];
    });

    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化对象／基本信息
        self.maxQueue = 200;
        self.tasks = [NSMutableArray array];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 repeats:YES block:^(NSTimer * _Nonnull timer) { }];
        //添加Runloop观察者
        [self addRunloopObserver];
    }
    return self;
}

//删除所有任务
- (void)removeAllTasks{
    [self.tasks removeAllObjects];
}


//add task 添加任务
- (void)addTask:(RunloopBlock)unit withId:(id)key{
    //添加任务到数组
    [self.tasks addObject:unit];

    //为了保证加载到图片最大数是18所以要删除
    if (self.tasks.count > self.maxQueue) {
        [self.tasks removeObjectAtIndex:0];
    }
}

//这里处理耗时操作了
static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){

    //通过info桥接为当前的对象
    TDRunLoop * runloop = (__bridge TDRunLoop *)info;

    //如果没有任务，就直接返回
    if (runloop.tasks.count == 0) {
        return;
    }

    BOOL result = NO;
    while (result == NO && runloop.tasks.count) {

        //取出任务
        RunloopBlock unit = runloop.tasks.firstObject;

        //执行任务
        result = unit();

        //删除任务
        [runloop.tasks removeObjectAtIndex:0];
    }
}

//添加runloop监听者
- (void)addRunloopObserver{

    //    获取 当前的Runloop ref - 指针
    CFRunLoopRef current =  CFRunLoopGetCurrent();

    //定义一个RunloopObserver
    CFRunLoopObserverRef defaultModeObserver;

    //上下文
    /*
     typedef struct {
     CFIndex    version; //版本号 long
     void *    info;    //这里我们要填写对象（self或者传进来的对象）
     const void *(*retain)(const void *info);        //填写&CFRetain
     void    (*release)(const void *info);           //填写&CGFRelease
     CFStringRef    (*copyDescription)(const void *info); //NULL
     } CFRunLoopObserverContext;
     */
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };

    /*
     1 NULL空指针 nil空对象 这里填写NULL
     2 模式
     kCFRunLoopEntry = (1UL << 0),
     kCFRunLoopBeforeTimers = (1UL << 1),
     kCFRunLoopBeforeSources = (1UL << 2),
     kCFRunLoopBeforeWaiting = (1UL << 5),
     kCFRunLoopAfterWaiting = (1UL << 6),
     kCFRunLoopExit = (1UL << 7),
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     3 是否重复 - YES
     4 nil 或者 NSIntegerMax - 999
     5 回调
     6 上下文
     */
    //    创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL,
                                                  kCFRunLoopBeforeWaiting, YES,
                                                  NSIntegerMax - 999,
                                                  &Callback,
                                                  &context);

    //添加当前runloop的观察着
    CFRunLoopAddObserver(current, defaultModeObserver, kCFRunLoopDefaultMode);

    //释放
    CFRelease(defaultModeObserver);
}

@end