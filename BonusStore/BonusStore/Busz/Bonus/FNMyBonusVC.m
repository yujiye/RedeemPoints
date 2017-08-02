//
//  FNMyBonusVC.m
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMyBonusVC.h"
#import "FNMyBO.h"
#import "FNBonusBO.h"

@interface FNMyBonusVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _page;
    
    NSArray *_array;
    
    NSInteger _bonus;
    
    FNSymmetryView *upView;
    
    FNNoDataView *_noDataView;
    
    BOOL _isSinglePageGo;     //防止点击多次，多次跳转页面
}

@property (nonatomic, strong) NSMutableArray * ableBonus;

@property (nonatomic, strong) NSMutableArray * dataSources;

@end

@implementation FNMyBonusVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的积分";
    
    self.tableViewDelegate = self;
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    _array = [FNBonusArgs getAll];
    
    _ableBonus = [NSMutableArray array];
    
    _dataSources = [NSMutableArray array];
    
    [self.tableView reloadData];
    
    [self autoFitInsets];
    
    _page = 1;
    
    [self initUp];
    
    [[FNBonusBO port02] getBonusWithBlock:^(id result) {
        
        if ([result[@"code"] integerValue] != 200)
        {
            return ;
        }
        
        _bonus = [result[@"amount"] integerValue];
        
        NSString * left = [NSString stringWithFormat:@"当前可用积分 %ld",_bonus];
        
        NSString *right = [NSString stringWithFormat:@"可抵扣 ¥%.02f",_bonus/100.0];

         upView.leftLabel.attributedText = [left setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fzltWithSize:15]} range:NSMakeRange(6, left.length-6)];
         upView.rightLabel.attributedText = [right setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fzltWithSize:15]} range:NSMakeRange(3, right.length-3)];
        
    }];
    
    [self initHeader];
    
    [self refresh];
    
    self.tableView.frame = CGRectMake(0, 250, kWindowWidth, kWindowHeight-250-64);
}

- (void)refresh
{
    [FNLoadingView showInView:self.view];
    
    __weak __typeof(self) weakSelf = self;
    
    [[FNBonusBO port02] getBonusListWithPage:_page time:FNBonusTimeAll type:FNBonusTypeAll block:^(id result) {
        
        [FNLoadingView hideFromView:self.view];
        
        if ([result isKindOfClass:[NSArray class]] && [(NSArray *)result count])
        {
            [_dataSources addObjectsFromArray:result];
            
            self.tableView.scrollEnabled = YES;
            
            [self initFooter];

            [self.tableView reloadData];
        }
        else
        {
            self.tableView.scrollEnabled = NO;
            
            self.tableView.tableFooterView = nil;
            
            if (!_noDataView)
            {
                _noDataView = [[FNNoDataView alloc] initWithFrame:CGRectMake(0, self.tableView.y+self.tableView.tableHeaderView.height, kWindowWidth, kWindowHeight-self.tableView.y + (IS_IPHONE_4_OR_LESS ? 50 : 0))];
            }
            
            [_noDataView setTypeWithResult:result];

            [_noDataView setActionBlock:^(id sender) {
                
                _page = 1;
                
                [weakSelf refresh];
                
            }];
            
            [self.view addSubview:_noDataView];
        }
    }];
}

- (void)initUp
{
    upView = [[FNSymmetryView alloc] initWithFrame:CGRectMake(0, 10, kWindowWidth, 50)];
    
    [self.view addSubview:upView];

    NSString * left = [NSString stringWithFormat:@"当前可用积分 %ld",_bonus];
    
    NSString *right = [NSString stringWithFormat:@"可抵扣 ¥%.02f",_bonus/100.0];
    
    upView.leftLabel.attributedText = [left setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fzltWithSize:15]} range:NSMakeRange(6, left.length-6)];
    
    upView.rightLabel.attributedText = [right setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fzltWithSize:15]} range:NSMakeRange(3, right.length-3)];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, upView.y + upView.height + 10, kWindowWidth, 170)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    UIImageView *downExchangeView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, kWindowWidth-30, 70)];
    
    downExchangeView.image = [UIImage imageNamed:@"my_bonus_exchange"];
    
    [view addSubview:downExchangeView];

    
    [downExchangeView addTarget:self action:@selector(goExchange:)];
    
    UIImageView *downSpendView = [[UIImageView alloc]initWithFrame:CGRectMake(15, downExchangeView.y + downExchangeView.height + 10, kWindowWidth-30, 70)];
    
    downSpendView.image = [UIImage imageNamed:@"my_bonus_shopping"];
    
    [view addSubview:downSpendView];
    
    [downSpendView addTarget:self action:@selector(goSpend)];
}

- (void)initHeader
{
    FNSymmetryView *header = [[FNSymmetryView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 48)];
    
    [header addTarget:self action:@selector(goDetail)];
    
    header.leftLabel.text = @"积分明细";
    
    header.rightLabel.text = @"查看全部";
    
    header.rightLabel.textAlignment = NSTextAlignmentRight;
    
    header.rightLabel.textColor = MAIN_COLOR_GRAY_ALPHA;
    
    UIReframeWithW(header.rightLabel, header.rightLabel.width-15);
    
    UIImageView *indicator = [[UIImageView alloc]initWithFrame:CGRectMake(header.rightLabel.x + header.rightLabel.width + 8, header.rightLabel.y + 3, 6.5, 12)];
    
    indicator.image = [UIImage imageNamed:@"main_rank_more"];
    
    [header addSubview:indicator];
    
    CALayer *line = [CALayer layerWithFrame:CGRectMake(0, header.height-0.5, kWindowWidth, 0.5)];
    
    [header.layer addSublayer:line];

    self.tableView.tableHeaderView = header;
}

- (void)initFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 48)];
    
    [footer addTarget:self action:@selector(goDetail)];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    
    [moreLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_GRAY_ALPHA];
    
    [moreLabel setVerticalCenterWithSuperView:footer];
    
    [moreLabel setHorizonCenterWithSuperView:footer];
    
    [footer addSubview:moreLabel];
    
    moreLabel.text = @"查看全部";
    
    UIImageView *indicator = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.x + moreLabel.width + 8, moreLabel.y + 3, 6.5, 12)];
    
    indicator.image = [UIImage imageNamed:@"main_rank_more"];
    
    [footer addSubview:indicator];
    
    self.tableView.tableFooterView = footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSources.count>=10)
    {
        return 10;
    }
    
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNMyBonusCell *cell = [FNMyBonusCell dequeueWithTableView:tableView];
    
    FNBonusDetailedModel * model = _dataSources[indexPath.row];
    
    cell.desLabel.text = [model getBonusType];
    
    cell.timeLabel.text = model.tradeTime;
    
    if (model.inOrOut.integerValue == FNBonusIncomeTypeIn)
    {
        cell.bonusLabel.textColor = [UIColor redColor];
        
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

- (void)goDetail
{
    [self pushToVC:[FNMyBonusDetailVC class] animated:YES];
}

- (void)goExchange:(UIGestureRecognizer *)sender
{
    __weak __typeof(self) weakSelf = self;
    sender.view.userInteractionEnabled = NO;
    [[[FNBonusBO port01] withOutUserInfo] teleInWithBlock:^(id result) {
        sender.view.userInteractionEnabled = YES;

        if ([result[@"code"] integerValue] == 200)
        {
            
            FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:result[@"url"]]];
            
            vc.isMoreItem = YES;
            
            vc.title = @"电信积分";
            
            vc.isPop = YES;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            NSString *url = @"http://active.jfshare.com/android/comesoon.html";
            
            FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:url]];
            
            vc.isMoreItem = YES;
            
            vc.title = @"电信积分";
            
            vc.isPop = YES;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
        _isSinglePageGo = YES;
    }];
}

- (void)goSpend
{
    [self goMain];
}






@end
