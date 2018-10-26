//
//  TDTrendMissStatisRightView.h
//  ZCLottery
//
//  Created by 任义春 on 2018/10/9.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "TDPanelView.h"

@interface TDTrendMissStatisRightView : TDPanelView

/** 隐藏遗漏 */
@property (nonatomic, assign) BOOL hideMiss;

/** 隐藏折线 */
@property (nonatomic, assign) BOOL hideLine;

/** 是否为空 */
@property (nonatomic, assign) BOOL isEmpty;

/** 绘制起始行数 */
@property (nonatomic, assign) int startRow;

/** 可展示行数 */
@property (nonatomic, assign) int showRow;

/** 绘制行数 */
@property (nonatomic, assign) int drawRow;

@end
