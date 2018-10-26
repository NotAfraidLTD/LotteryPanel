//
//  YMSegmentedControl.m
//  ZCLottery
//
//  Created by 胡月明 on 2018/9/29.
//  Copyright © 2018年 yang. All rights reserved.
//

#import "YMSegmentedControl.h"
@interface YMSegmentedControl()
@property(nonatomic,strong)NSArray * titleArray;
//type : 1 2 3 分别为 大图  中图  小图  0代表没有。
@property (nonatomic, strong)NSArray *typeArray;

@property(nonatomic,strong)NSMutableArray * btnArray;
@property(nonatomic,strong)UIView * bottomLineV;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,assign)CGFloat buttonWidth;
@end

@implementation YMSegmentedControl
- (void)updateSegmentControlUIWithlotteryName:(nonnull NSString *)lotteryName gamePlay:(nonnull NSString *)gamePlay
{
    _titleArray = [NSArray array];
    _typeArray = [NSArray array];
    _btnArray = [NSMutableArray arrayWithCapacity:0];
    if ([lotteryName rangeOfString:@"fast_three"].location != NSNotFound) {
        if ([gamePlay rangeOfString:@"三同号"].location != NSNotFound) {
            _titleArray = @[@"开奖",@"基本走势",@"形态走势"];
            _typeArray = @[@"3",@"2",@"0"];
        }else if ([gamePlay rangeOfString:@"三不同号"].location != NSNotFound || [gamePlay rangeOfString:@"三连号"].location != NSNotFound) {
            _titleArray = @[@"开奖",@"基本走势",@"形态走势"];
            _typeArray = @[@"3",@"2",@"2"];
        }else if ([gamePlay isEqualToString:@"和值"]){
            _titleArray = @[@"开奖",@"基本走势",@"和值走势"];
            _typeArray = @[@"3",@"2",@"1"];
        }else if ([gamePlay rangeOfString:@"二同号"].location != NSNotFound){
            _titleArray = @[@"开奖",@"基本走势",@"号码分布"];
            _typeArray = @[@"3",@"2",@"2"];
        }else if ([gamePlay rangeOfString:@"二不同号"].location != NSNotFound) {
            _titleArray = @[@"开奖",@"基本走势",@"号码分布"];
            _typeArray = @[@"3",@"2",@"2"];
        }
    }else if ([lotteryName rangeOfString:@"eleven_five"].location != NSNotFound) {
        if ([gamePlay isEqualToString:@"任选二"] || [gamePlay isEqualToString:@"任选三"] || [gamePlay isEqualToString:@"任选四"] || [gamePlay isEqualToString:@"任选五"] || [gamePlay isEqualToString:@"任选六"] || [gamePlay isEqualToString:@"任选七"] || [gamePlay isEqualToString:@"任选八"] || [gamePlay isEqualToString:@"前一直选"] || [gamePlay isEqualToString:@"前二组选"] || [gamePlay isEqualToString:@"前三组选"] || [gamePlay isEqualToString:@"任选二胆拖"] || [gamePlay isEqualToString:@"任选三胆拖"] || [gamePlay isEqualToString:@"任选四胆拖"] || [gamePlay isEqualToString:@"任选五胆拖"] || [gamePlay isEqualToString:@"任选六胆拖"] || [gamePlay isEqualToString:@"任选七胆拖"] || [gamePlay isEqualToString:@"任选八胆拖"] || [gamePlay isEqualToString:@"前二组选胆拖"] || [gamePlay isEqualToString:@"前三组选胆拖"]) {
            _titleArray = @[@"开奖",@"走势",@"形态"];
            _typeArray = @[@"3",@"2",@"3"];
        }else if ([gamePlay isEqualToString:@"前二直选"]) {
            _titleArray = @[@"开奖",@"万位走势",@"千位走势"];
            _typeArray = @[@"3",@"1",@"1"];
        }else if ([gamePlay isEqualToString:@"前三直选"]) {
            _titleArray = @[@"开奖",@"万位走势",@"千位走势",@"百位走势"];
            _typeArray = @[@"3",@"1",@"1",@"1"];
        }
    }else if ([lotteryName rangeOfString:@"chongqing_tick_tick"].location != NSNotFound) {
        if ([gamePlay isEqualToString:@"五星通选"] || [gamePlay isEqualToString:@"五星直选"]) {
            _titleArray = @[@"开奖",@"万位走势",@"千位走势",@"百位走势",@"十位走势",@"个位走势"];
            _typeArray = @[@"3",@"1",@"1",@"1",@"1",@"1"];
        }else if ([gamePlay isEqualToString:@"三星直选"]) {
            _titleArray = @[@"开奖",@"百位走势",@"十位走势",@"个位走势"];
            _typeArray = @[@"3",@"1",@"1",@"1"];
        }else if ([gamePlay isEqualToString:@"三星组三"] || [gamePlay isEqualToString:@"三星组六"] || [gamePlay isEqualToString:@"二星组选"]) {
            _titleArray = @[@"开奖",@"走势",@"跨度"];
            _typeArray = @[@"3",@"2",@"1"];
        }else if ([gamePlay isEqualToString:@"二星直选"]) {
            _titleArray = @[@"开奖",@"十位走势",@"个位走势"];
            _typeArray = @[@"3",@"1",@"1"];
        }else if ([gamePlay isEqualToString:@"一星直选"]) {
            _titleArray = @[@"开奖",@"个位走势",@"个位振幅"];
            _typeArray = @[@"3",@"1",@"1"];
        }else if ([gamePlay isEqualToString:@"大小单双"]) {
            _titleArray = @[@"开奖",@"形态走势"];
            _typeArray = @[@"3",@"1"];
        }
    }
    [self configUI];
    
    if (_btnArray.count > 0) {
        if (self.segmentDefaultType == SegmentDefaultTypeRecent) {
            [self pressButton:_btnArray[0]];
//            self.segmentDefaultType = SegmentDefaultTypeNull;
        }else if (self.segmentDefaultType == SegmentDefaultTypeTrend) {
            if ([_titleArray containsObject:@"和值走势"]) {
                [self pressButton:_btnArray[2]];
            }else{
                [self pressButton:_btnArray[1]];
            }
//            self.segmentDefaultType = SegmentDefaultTypeNull;
        }
    }

}

- (void)pressButton:(UIButton *)btn
{
    for (UIView * view  in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    btn.selected = !btn.selected;
    NSInteger tag = btn.tag - 100000;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomLineV.left = self.buttonWidth*tag;
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.segmentedControlPressBtnBlock) {
        self.segmentedControlPressBtnBlock(tag,_titleArray[tag],_typeArray[tag]);
    }
}

- (void)configUI
{
    for (UIView * view  in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger strMaxL = 0;
    for (NSString * str in _titleArray) {
        if (str.length > strMaxL) {
            strMaxL = str.length;
        }
    }
    
    self.buttonWidth = strMaxL*20;
    if (ZC_Screen_W > self.buttonWidth*_titleArray.count) {
        self.buttonWidth = ZC_Screen_W/_titleArray.count*1.0;
        self.scrollView.contentSize = CGSizeMake(ZC_Screen_W, self.height);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.buttonWidth*_titleArray.count, self.height);
    }
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*self.buttonWidth, 0, self.buttonWidth, self.height);
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:ZCHexColor(@"504f58") forState:UIControlStateNormal];
        [button setTitleColor:kRedColor forState:UIControlStateSelected];
        button.titleLabel.font = kFontSizeWith(14);
        button.tag = i+100000;
        [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        [_btnArray addObject:button];

    }
    
    _bottomLineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.height - ZC_SCALE_WIDTH(2), self.buttonWidth, ZC_SCALE_WIDTH(2))];
    _bottomLineV.backgroundColor = kRedColor;
    [self.scrollView addSubview:_bottomLineV];
    
    UIView * seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-ZC_SCALE_WIDTH(1), ZC_Screen_W, ZC_SCALE_WIDTH(1))];
    seperatorLine.backgroundColor = ZCHexColor(@"d7d6d2");
    [self addSubview:seperatorLine];
    
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-ZC_SCALE_WIDTH(1))];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
