//
//  UIWindow+Extension.m
//  LotteryPanle
//
//  Created by *** on 2018/10/26.
//  Copyright © 2018年 LTD. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "TDTabbarController.h"

@implementation UIWindow (Extension)

- (void)createRootViewController{

    self.rootViewController = [[TDTabbarController alloc] init];

}

@end
