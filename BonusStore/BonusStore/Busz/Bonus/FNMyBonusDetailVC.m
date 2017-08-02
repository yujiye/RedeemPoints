//
//  FNMyBonusDetailVC.m
//  BonusStore
//
//  Created by Nemo on 16/4/19.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMyBonusDetailVC.h"

#import "FNSegListBar.h"

#import "FNMyBO.h"

#import "FNBonusBO.h"

@interface FNMyBonusDetailVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSMutableArray *_array;
    
    FNSegBar *_bar;
    
    UIView *_header;
    
    FNSegListBar *_listBar;
    
    NSArray *_segListTypeArray;
    
    NSInteger _page;
    
    NSInteger _bonus;
    
    FNNoDataView *_noData;
    
    FNBonusType _bonusType;
    
    FNBonusTime _timeType;
}
@property (nonatomic, strong) NSMutableArray * dataSources;

@property (nonatomic, strong) NSMutableArray * ableBonus;

@end

@implementation FNMyBonusDetailVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_listBar deallocMask];

    self.navigationController.tabBarController.tabBar .hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar .hidden = YES;


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"积分明细";
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    
    _page = 1;
    
    _dataSources = [NSMutableArray array];
    
    _ableBonus = [NSMutableArray array];


    _segListTypeArray = @[@(FNBonusTypeAll),@(FNBonusTypeToApp),@(FNBonusTypeToTele),@(FNBonusTypeConsumptionDeduction),@(FNBonusTypeConsumptionSend),@(FNBonusTypeActivitySend),@(FNBonusTypePay),@(FNBonusTypeMinus),@(FNBonusTypeRecharge),@(FNBonusTypeRedGift),@(FNBonusTypeRegisteredGift),@(FNBonusTypeTrirdSend),@(FNBonusTypeAutoReturn),@(FNBonusTypeManualReturn),@(FNBonusTypeAfterReturn)];
    
    self.tableViewDelegate = self;    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        
        [self getData];
        
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    footer.automaticallyRefresh = YES;
    [footer setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_footer = footer;

    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    [self autoFitInsets];
    
    [[FNBonusBO port02] getBonusWithBlock:^(id result) {
        
        if ([result[@"code"] integerValue] != 200)
        {
            if(result)
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
            
        }
        
        _bonus = [result[@"amount"] integerValue];
        
        [self initHeader];
        [self.tableView reloadData];
    }];

    [self getData];
}

- (void)getData
{
    [FNLoadingView showInView:self.view];
    
    [_noData removeFromSuperview];
    
    _noData = nil;
    
    __weak __typeof(self) weakSelf = self;

    [[FNBonusBO port02] getBonusListWithPage:_page time:_timeType type:[_segListTypeArray[_bonusType] integerValue] block:^(id result) {
        
        [FNLoadingView hideFromView:self.view];
        
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView.mj_header endRefreshing];
        
        if (_page == 1)
        {
            [_dataSources removeAllObjects];
        }
        
        if ((![result isKindOfClass:[NSArray class]] && [result[@"code"] integerValue] != 200) || result == nil)
        {
            if (!_noData)
            {
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,self.tableView.tableHeaderView.height , kWindowWidth, kWindowHeight-self.tableView.tableHeaderView.height+1)];
            }
            [_noData setTypeWithResult:result];
            
            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            
            [_noData setActionBlock:^(id sender) {
                [weakSelf getData];
            }];
            [self.tableView addSubview:_noData];
            
            return ;
        }

        if ([result isKindOfClass:[NSArray class]])
        {
            self.tableView.hidden = NO;

            [_dataSources addObjectsFromArray:result];
            
            _noData.hidden = YES;
            
            _page++;
            
            if ([_dataSources count] == 0)
            {
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,self.tableView.tableHeaderView.height , kWindowWidth, kWindowHeight-self.tableView.tableHeaderView.height)];
                }
                [_noData setTypeWithResult:result];
                
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                
                [_noData setActionBlock:^(id sender) {
                    [weakSelf getData];
                }];
                [self.tableView addSubview:_noData];
            }
            else if ([(NSArray *)result count] < MAIN_PER_PAGE)
            {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
            }
            
        }
        
        [self.tableView reloadData];
    }];
}

- (void)initHeader
{
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 120)];
        
    _header.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    FNSymmetryView *upView = [[FNSymmetryView alloc] initWithFrame:CGRectMake(0, 10, kWindowWidth, 50)];
    
    [_header addSubview:upView];
    
    NSString *left = [NSString stringWithFormat:@"当前可用积分 %ld",_bonus];
    
    NSString *right = [NSString stringWithFormat:@"可抵扣 ¥%.2f",_bonus/100.0];
    
    upView.leftLabel.attributedText = [left setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fzltWithSize:15]} range:NSMakeRange(6, left.length-6)];
    
    upView.rightLabel.attributedText = [right setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fzltWithSize:15]} range:NSMakeRange(3, right.length-3)];
    
    _listBar = [[FNSegListBar alloc] initWithFrame:CGRectMake(0, upView.y + upView.height+10, kWindowWidth, 50)];
    
    [_header addSubview:_listBar];
    
    [_listBar setItems:@[@[@"全部",@"最近一天",@"最近三天",@"最近一周",@"最近一个月",@"最近三个月"],
                         @[@"全部",@"电信积分兑入",@"兑换电信积分",@"消费抵扣",@"消费赠送",@"活动赠送",@"返还支付积分",@"扣减赠送积分",@"积分卡充值",@"积分红包活动 ",@"第三方注册赠送",@"第三方消费抵扣",@"自动返还第三方抵扣积分",@"手动返还第三方抵扣积分",@"订单售后退积分"]]];
    
    [_listBar initMaskWithPoint:CGPointMake(0, 120+NAVIGATION_BAR_HEIGHT)];
    
    [_listBar selectedColumnWithBlock:^(NSInteger index) {
        
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        
    }];
    
    [_listBar selectedItemWithBlock:^(NSArray *array) {
    
        _timeType = [(NSNumber *)array[0] integerValue];
        
        _bonusType = [(NSNumber *)array[1] integerValue];
        
        _page = 1;
        
        [self getData];
    }];
    
    
    [self.tableView setTableHeaderView:_header];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNMyBonusCell *  cell = [FNMyBonusCell dequeueWithTableView:tableView];
    
    FNBonusDetailedModel * model = _dataSources[indexPath.row];
    
    cell.desLabel.text = [model getBonusTypeDescWithType:[model.type integerValue]];
    
    cell.timeLabel.text = model.tradeTime;
    
    if (model.inOrOut.integerValue == FNBonusIncomeTypeIn)
    {
        cell.bonusLabel.textColor = MAIN_COLOR_RED_ALPHA;
        
        cell.bonusLabel.text = [NSString stringWithFormat:@"+%@",model.amount];
    }
    else 
    {
        cell.bonusLabel.textColor = [UIColor greenColor];
        
        cell.bonusLabel.text = [NSString stringWithFormat:@"-%@",model.amount];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)goBack
{
    [_listBar deallocMask];

    if (self.isFinish)
    {
        [self goTabIndex:3];
    }
    else
    {
        [super goBack];
    }
}

@end
