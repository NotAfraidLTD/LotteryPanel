//
//  TDPanelModel.m
//  ZCLottery
//
//  Created by 任义春 on 2018/10/12.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "TDPanelModel.h"


@implementation TDPanelModel

- (UIColor *)badgeColor{
    return ZCHexColor(@"#FDDB0F");
}


+(NSArray *)modelArray:(NSArray *)array winArray:(NSArray *)winArray ballArr:(NSArray *)ballArr diffType:(TDPanelFormType)diffType isShowLine:(BOOL)isShowLine nodeIdentitys:(NSArray *)nodeIdentitys{
    return [TDPanelModel modelArray:array winArray:winArray ballArr:ballArr diffType:diffType isShowLine:isShowLine nodeIdentitys:nodeIdentitys badge:YES];
}


//中奖号码为圆
+(NSArray *)modelArray:(NSArray *)array winArray:(NSArray *)winArray ballArr:(NSArray *)ballArr isShowLine:(BOOL)isShowLine{
    return [TDPanelModel modelArray:array winArray:winArray ballArr:ballArr diffType:TDPanelFormRound isShowLine:isShowLine nodeIdentitys:nil];
}

+(NSArray *)modelArray:(NSArray *)array winArray:(NSArray *)winArray ballArr:(NSArray *)ballArr diffType:(TDPanelFormType)diffType isShowLine:(BOOL)isShowLine nodeIdentitys:(NSArray *)nodeIdentitys badge:(BOOL)isBadge{
    NSMutableArray * temp = [NSMutableArray array];
    
    for (int i = 0; i<array.count; i++) {
        
        NSString * ball = [NSString stringWithFormat:@"%@",array[i]];
        
        if (ball.integerValue <= 0) {//中奖号码
            
            NSString * ballStr = ballArr[i];
            
            TDPanelModel * model = [[TDPanelModel alloc]initWithContent:ballStr];
            
            model.diffType = diffType;
            model.contentColor = [UIColor whiteColor];
            
            if (isBadge) {
                NSInteger badgeNumber = 0;
                for (NSNumber * number in winArray) {
                    if ([ballStr isEqualToString:[NSString stringWithFormat:@"%@",number]]) {
                        badgeNumber++;
                    }
                }
                if (badgeNumber>1) {
                    model.badgeNumber = [NSString stringWithFormat:@"%ld",(long)badgeNumber];
                }
                model.badgeColor = ZCHexColor(@"#F1973A");
            }
            
            
            [temp addObject:model];
            
            if (isShowLine) {
                model.isNode = YES;
                
                if (nodeIdentitys&&nodeIdentitys.count>0) {
                    if (nodeIdentitys.count == ballArr.count) {
                        model.nodeIdentity = nodeIdentitys[i];
                        model.lineColor = ZCHexColor(nodeIdentitys[i]);
                        model.diffTypeColor = ZCHexColor(nodeIdentitys[i]);
                    }else{
                        model.nodeIdentity = nodeIdentitys[0];
                        model.lineColor = kRedColor;
                        model.contentColor = [UIColor whiteColor];
                    }
                }else{
                    model.nodeIdentity = @"nodeIdentity";
                    model.lineColor = kRedColor;
                }
            }
            model.isMiss = NO;
            
        }else{
            TDPanelModel * model = [[TDPanelModel alloc]initWithContent:ball];
            model.isMiss = YES;
            [temp addObject:model];
        }
        
    }
    
    return temp.copy;
}


- (instancetype)initWithContent:(NSString *)content 
{
    self = [super init];
    if (self) {
        if ([content isEqualToString:@"-1"]) {
            content = @"--";
        }
        self.content = [NSString stringWithFormat:@"%@",content];
    }
    return self;
}

@end
