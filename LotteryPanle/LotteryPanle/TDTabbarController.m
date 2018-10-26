//
//  TDTabbarController.m
//  LotteryPanle
//
//  Created by *** on 2018/10/26.
//  Copyright © 2018年 LTD. All rights reserved.
//

#import "TDTabbarController.h"
#import "TDLineViewController.h"
#import "TDDifferenceViewController.h"

@interface TDTabbarController ()

@end

@implementation TDTabbarController

+(void)initialize{
    // 通过appearance统一设置所有UITabBarItem的文字属性 -
    NSMutableDictionary *atts = [NSMutableDictionary dictionary];
    atts[NSFontAttributeName] = kFontSizeWith(10);
    atts[NSForegroundColorAttributeName] = ZCHexColor(@"444444");

    NSMutableDictionary *SelectedAtts = [NSMutableDictionary dictionary];
    SelectedAtts[NSFontAttributeName] = atts[NSFontAttributeName];
    SelectedAtts[NSForegroundColorAttributeName] =ZCHexColor(@"E7A008");

    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:atts forState:UIControlStateNormal];
    [item setTitleTextAttributes:SelectedAtts forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildVC:[[TDLineViewController alloc] init] title:@"快三" image:@"tabbar_nomal" selectedImage:@"tabbar"];
    [self setupChildVC:[[TDDifferenceViewController alloc] init] title:@"选五" image:@"tabbar_nomal" selectedImage:@"tabbar"];
}

/**
 *  初始化子控制器
 */
- (void)setupChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {

    // 设置文字和图片
    vc.navigationItem.title =  title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];

    // 包装一个导航控制器，添加导航控制器为tabBarControler的子控制器
    UINavigationController * navigationVC = [[UINavigationController alloc] initWithRootViewController:vc];

    // 添加子控制器
    [self addChildViewController:navigationVC];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
