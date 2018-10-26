//
//  TDPanelModel.h
//  ZCLottery
//
//  Created by 任义春 on 2018/10/12.
//  Copyright © 2018年 yang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TDRunLoop.h"

// 表格内部展示的样式
typedef enum : NSUInteger {

    TDPanelFormRound = 1,           // 圆
    TDPanelFormRectangle = 2,       // 矩形

} TDPanelFormType;

@interface TDPanelModel : NSObject

/** 特殊表格样式 */
@property (nonatomic, assign) TDPanelFormType diffType;

/** 特殊样式背景 */
@property (nonatomic, strong) UIColor * diffTypeColor;

/** 是否遗漏 */
@property (nonatomic, assign) BOOL isMiss;

/** 展示内容 */
@property (nonatomic, copy) NSString * content;

/** 文字颜色 */
@property (nonatomic, strong) UIColor * contentColor;

/** 特殊处理字符 */
@property (nonatomic, copy) NSString * attributeContent;

/** 特殊处理属性 */
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> * attributeDict;

/** 角标颜色 */
@property (nonatomic, strong) UIColor * badgeColor;

/** 角标数字 */
@property (nonatomic, copy) NSString * badgeNumber;

/** 是否连线 */
@property (nonatomic, assign) BOOL isNode;

/** 节点分组 */
@property (nonatomic, copy) NSString * nodeIdentity;

/** 节点连线色 */
@property (nonatomic, strong) UIColor * lineColor;

/** 节点坐标 */
@property (nonatomic, assign) NSInteger row;

/** 节点坐标 */
@property (nonatomic, assign) NSInteger colmn;

/** 宽度 */
@property (nonatomic, assign) CGFloat customWidth;

/** 排序样式 0不排序 1升 2降 */
@property (nonatomic, copy) NSString * order;


+(NSArray *)modelArray:(NSArray *)array winArray:(NSArray *)winArray ballArr:(NSArray *)ballArr isShowLine:(BOOL)isShowLine;

- (instancetype)initWithContent:(NSString *)content;

+(NSArray *)modelArray:(NSArray *)array winArray:(NSArray *)winArray ballArr:(NSArray *)ballArr diffType:(TDPanelFormType)diffType isShowLine:(BOOL)isShowLine nodeIdentitys:(NSArray *)nodeIdentitys;

+(NSArray *)modelArray:(NSArray *)array winArray:(NSArray *)winArray ballArr:(NSArray *)ballArr diffType:(TDPanelFormType)diffType isShowLine:(BOOL)isShowLine nodeIdentitys:(NSArray *)nodeIdentitys badge:(BOOL)isBadge;

@end
