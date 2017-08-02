//
//  FNBonusRechargeStatusVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusRechargeStatusVC.h"
#import "FNBonusBO.h"
@interface FNBonusRechargeStatusVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)FNBonusRechargeStatusView *bonusRechargeStatusView;

@end

@implementation FNBonusRechargeStatusVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    [self setNavigaitionMoreItem];
    
    self.title = @"积分充值";
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    [self tableView];
    [self initHeaderView];
}

- (void)initHeaderView
{
    _bonusRechargeStatusView = [[FNBonusRechargeStatusView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _tableView.tableHeaderView = _bonusRechargeStatusView;
    
    if (_isFail == NO)
    {
        [_bonusRechargeStatusView rechargeSuccess];
        _bonusRechargeStatusView.successPromptLab.text = [NSString stringWithFormat:@"成功充值 %@ 积分",_rechargeValue];
        NSInteger totalBonus = [_rechargeValue integerValue] + _bonusTotal;
        _bonusRechargeStatusView.succSurplusLab.text = [NSString stringWithFormat:@"积分余额 %ld 积分",(long)totalBonus];
        [_bonusRechargeStatusView rechargeAction:^(id sender) {
            [self goMain];
        }];
    }
    else
    {
        [_bonusRechargeStatusView rechargeFail];
        _bonusRechargeStatusView.failLab.text = _rechargeFailStr;

        __weak __typeof(self) weakSelf = self;
        
        [_bonusRechargeStatusView rechargeAction:^(id sender) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}


@end
