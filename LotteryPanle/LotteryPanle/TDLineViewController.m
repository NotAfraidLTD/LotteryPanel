//
//  TDLineViewController.m
//  LotteryPanle
//
//  Created by 任义春 on 2018/10/26.
//  Copyright © 2018年 LTD. All rights reserved.
//

#import "TDLineViewController.h"
#import "TDPanelHeaderView.h"
#import "TDTrendMissStatisRightView.h"

@interface TDLineViewController ()<UIScrollViewDelegate , TDPanelViewDelegate , TDPanelViewDataSource>

/** main */
@property (nonatomic, strong) UIScrollView * mainScrollView;

/** rightView */
@property (nonatomic, strong) TDTrendMissStatisRightView * rightView;

/** headerView */
@property (nonatomic, strong) TDPanelHeaderView * headerView;

@end

@implementation TDLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubview];
}

- (void)createSubview{
    [self.view addSubview:self.mainScrollView];

    self.rightView = [[TDTrendMissStatisRightView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    self.rightView.delegate = self;
    self.rightView.dataSource = self;
    [self.rightView correctorFrame];
    self.rightView.startRow = 180;
    [self.mainScrollView addSubview:_rightView];

    self.headerView = [[TDPanelHeaderView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.headerView.delegate = self;
    self.headerView.dataSource = self;
    [self.headerView correctorFrame];
    [self.mainScrollView addSubview:self.headerView];

    self.mainScrollView.contentSize = CGSizeMake(self.rightView.width, self.rightView.height + self.headerView.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView){
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}

/**
 表格有多少行

 @param panelView           当前表格
 @return                    行数
 */
- (NSInteger)numberOfRowsInPanelView:(TDPanelView *)panelView{
    if (panelView == self.headerView){
        return 1;
    }else{
        return 200;
    }
}

/**
 表格有多少列

 @param panelView           当前表格
 @return                    列数
 */
- (NSInteger)numberOfColumnsInPanelView:(TDPanelView *)panelView{
    return 15;
}


/**
 表格内容获取

 @param panelView           当前表格
 @param indexPath           添加内容的表格
 @return                    表格显示的文字
 */
- (TDPanelModel *)panelView:(TDPanelView *)panelView ContentForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (panelView == self.headerView){
        TDPanelModel * model = [[TDPanelModel alloc] initWithContent:[NSString stringWithFormat:@"第%ld列",(long)indexPath.row]];
        return model;
    }else{
        TDPanelModel * model = [[TDPanelModel alloc] initWithContent:[NSString stringWithFormat:@"%ld%ld",(long)indexPath.row,(long)indexPath.section]];
        if (indexPath.row % 3 == 1){
            model.diffType = TDPanelFormRound;
            model.diffTypeColor = UIColor.redColor;
        }
        return model;
    }
}


/**
 设置行高

 @param panelView           当前表格
 @param row                 指定的行
 @return                    行高
 */
- (CGFloat)panelView:(TDPanelView *)panelView heightForRow:(NSInteger)row{
    return [TDPanelFormManager formHeight];
}

/**
 设置列宽

 @param panelView           当前表格
 @param column              指定的列
 @return                    列宽
 */
- (CGFloat)panelView:(TDPanelView *)panelView widthForColumn:(NSInteger)column{
    return ZC_SCALE_WIDTH(50);
}



@end
