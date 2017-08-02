//
//  FNBonusRechargeRecordVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusRechargeRecordVC.h"
#import "FNBonusBO.h"
@interface FNBonusRechargeRecordVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    CGFloat  _cellHeight;
    FNNoDataView *_noData;
}

@property (nonatomic, strong) UITableView *rechargeTableView;

@property (nonatomic, strong) UIButton *topBtn;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FNBonusRechargeRecordVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值记录";
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    [self setNavigaitionBackItem];
    [self setNavigaitionMoreItem];
    [self rechargeTableView];
    _page = 1;
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor redColor];
    
    [_rechargeTableView setTableFooterView:view];
    
    _dataSource = [NSMutableArray array];
    
    _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _topBtn.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 44, 44);
    
    [_topBtn setBackgroundImage:[UIImage imageNamed:@"main_back_top"] forState:UIControlStateNormal];
    
    [_topBtn addSuperView:self.view ActionBlock:^(id sender) {
        
        [_rechargeTableView scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:YES];
        
    }];
//    [self loadMore];
    _page = 1;
    
    [self loadMore];
    _topBtn.alpha = NO;
    _rechargeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadMore];
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    footer.automaticallyRefresh = YES;
    [footer setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
    _rechargeTableView.mj_footer = footer;
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];

}

- (void)loadMore
{
     __weak __typeof(self) weakSelf = self;
    [FNLoadingView showInView:self.view];
    [_noData removeFromSuperview];
    _noData = nil;
    [FNBonusBO getRechargeBonusListWithPreCount:10 curPage:_page block:^(id result) {
        
        [_rechargeTableView.mj_footer endRefreshing];
        [_rechargeTableView.mj_header endRefreshing];
        if ([result[@"code"] integerValue] == 200)
        {
            [FNLoadingView hide];
            _rechargeTableView.hidden = NO;
            if (_page == 1)
            {
                [_dataSource removeAllObjects];
            }
            
            for (NSDictionary *dict in result[@"rechargeCardRecordList"])
            {
                [_dataSource addObject:[FNBounsRechargeListModel makeEntityWithJSON:dict ]];
            }
            if ([(NSArray *)result[@"rechargeCardRecordList"]count] >=10)
            {
                _page ++;
            }
            else
            {
                _rechargeTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }
        else
        {
            if (![result isKindOfClass:[NSArray class]] || result == nil)
            {
                [FNLoadingView hide];
                _rechargeTableView.hidden = YES;
                
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0 ,0 , kWindowWidth, kWindowHeight)];
                }
                [_noData setTypeWithResult:result];
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                [_noData setActionBlock:^(id sender) {
                    [weakSelf loadMore];
                }];
                [self.view addSubview:_noData];
                self.rechargeTableView.mj_footer.state = MJRefreshStateNoMoreData;
            }
        }
        [_rechargeTableView reloadData];
    }];
}

- (UITableView *)rechargeTableView
{
    if (_rechargeTableView == nil)
    {
        _rechargeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _rechargeTableView.showsVerticalScrollIndicator = NO;
        _rechargeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_rechargeTableView registerClass:[FNBonusRechargeRecordCell class] forCellReuseIdentifier:NSStringFromClass([FNBonusRechargeRecordCell class])];
        _rechargeTableView.delegate = self;
        _rechargeTableView.dataSource = self;
        
        [self.view addSubview:_rechargeTableView];
    }
    return _rechargeTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNBonusRechargeRecordCell *cell = [FNBonusRechargeRecordCell bonusRechargeRecordCell:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FNBounsRechargeListModel *rechargeModel = _dataSource[indexPath.section];
    cell.rechargeNumLab.text =[NSString stringWithFormat:@"%@", rechargeModel.pieceValue];
    cell.rechargePassLab.text = [NSString stringWithFormat:@"%@",rechargeModel.cardName];
    cell.rechargeTimeLab.text = rechargeModel.rechargeTime;
    switch ([rechargeModel.rechargeType integerValue]) {
        case 0:
            cell.rechargeTypeLab.text = @"手动充值";
            break;
        case 1:
            cell.rechargeTypeLab.text = @"自动充值";
            break;
        default:
            break;
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else
    {
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _topBtn.alpha = 1- (100 - offsetY)/100;
    
    CGFloat sectionHeaderHeight = 0;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
