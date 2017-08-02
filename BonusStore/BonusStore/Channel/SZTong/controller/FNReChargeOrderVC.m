//
//  FNReChargeOrderVC.m
//  BonusStore
//
//  Created by cindy on 2017/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNReChargeOrderVC.h"
#import "FNHeader.h"
#import "Mask.h"

@interface FNReChargeOrderVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSArray *  _buttonTitleArray;
    NSMutableArray * _buttonArr;
    UILabel * _lineLabel;
    NSInteger _currPage;
    UIView *_bgView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentSel;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) BOOL isLoad;


@end

@implementation FNReChargeOrderVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    _currPage = 1;
    self.currentSel = 0;
    UIButton * btn = _buttonArr.firstObject;
    [_lineLabel removeFromSuperview];
    [btn addSubview:_lineLabel];
    self.tableView.hidden = YES;
    [self loadDataMore];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"充值订单";
    [self setNavigaitionBackItem];
    self.dataSource = [NSMutableArray array];
    _buttonArr = [NSMutableArray array];
    _buttonTitleArray = @[@"全部",@"未完成"];
    [self setTypeTitle];
    UILabel * HLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 -2.0, 7, 2, 30)];
    HLabel.backgroundColor = UIColorWith0xRGB(0xDCDADA);
    [self.view addSubview:HLabel];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tableView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView)
    {
        int index = (int)scrollView.contentOffset.x / (int)SCREEN_WIDTH;
        
        if (index < 0)
        {
            index = 0;
        }
        if (index >1)
        {
            index = 1;
        }
        self.currentSel = index;
        _currPage = 1;
        [_buttonArr enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == index)
            {
                [_lineLabel removeFromSuperview];
                [obj addSubview:_lineLabel];
                *stop = YES;
                
            }
        }];
        UIReframeWithX(self.tableView, kScreenWidth *_currentSel);
        [self loadDataMore];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //去详情
    FNMyOrderModel *myOrder = self.dataSource[indexPath.row];
     if (![NSString isEmptyString:myOrder.orderNo])
     {
      FNSZDetailVC * detailVC = [[FNSZDetailVC alloc]init];
         detailVC.stateEntry = FNSZStateEntryDetail;
      detailVC.orderno = myOrder.orderNo;
      [self.navigationController pushViewController:detailVC animated:YES];
     }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNMyOrderCell *myOrderCell  = [FNMyOrderCell myOrderCellWithTableView:tableView];
    myOrderCell.myOrderModel = self.dataSource[indexPath.row];
    return myOrderCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)clickTypeTitle:(UIButton *)btn
{
    [_lineLabel removeFromSuperview];
    [btn addSubview:_lineLabel];
    _currPage = 1;
    self.currentSel = btn.tag;
    [self loadDataMore];
}

#pragma mark scrollview
- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        UIScrollView  *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, kScreenHeight -44 - 64 )];
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, scrollView.height);
        scrollView.scrollEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        self.scrollView = scrollView;
    }
    return  _scrollView;
}

- (UITableView *)tableView
{
    if (_tableView ==nil)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44 -64) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc]init];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currPage = 1;
            [self loadDataMore];
        }];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataMore)];
        footer.automaticallyRefresh = YES;
        [footer setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
        tableView.mj_footer = footer;
        [footer setTitle:@"没有更多内容啦" forState:MJRefreshStateNoMoreData];
        self.tableView = tableView;
    }
    return _tableView;
}

- (void)loadDataMore
{
    OrderReq *orderReq  = [OrderReq new];
    orderReq.token = FNUserAccountInfo[@"token"];
    orderReq.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
    NSDictionary * user = [FNUserAccountArgs getUserAccount];
    orderReq.phoneNo =  [NSString stringWithFormat:@"%@", [user valueForKey:@"mobile"]];
    orderReq.row = @"20";
    orderReq.currentPage = _currPage;
    if (self.currentSel==0)
    {
        //全部
        orderReq.type = @"3";

    }else if (self.currentSel==1)
    {
        //未完成
        orderReq.type = @"1";
    }
    self.tableView.userInteractionEnabled = NO;
    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];

    [[OrderAPI sharedManager]requestOrderList:orderReq success:^(RequestResult *requestResult) {

        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.hidden = NO;
            self.tableView.userInteractionEnabled = YES;
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_header.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            if (requestResult.status == 0)
            {
                //成功
                NSMutableArray * arrM = [NSMutableArray array];
                if(![requestResult.resultInfo isKindOfClass:[NSNull class]])
                {
                    NSMutableArray * rows = [requestResult.resultInfo objectForKey:@"rows"];
                    if (rows.count !=0)
                    {
                        for (NSDictionary * dict in rows)
                        {
                            FNMyOrderModel *myOrder = [FNMyOrderModel mj_objectWithKeyValues:dict];
                            
                            myOrder.szType = FNSZConsumeTypeNone;
                            
                            if (self.currentSel == 0)
                            {
                                myOrder.showIcon = YES;
                            }
                            [arrM addObject:myOrder];
                        }
                    }
                    //总页数
                    int pageNumCount = [[requestResult.resultInfo objectForKey:@"totalPages"] intValue];
                    
                    if (_currPage == 1)
                    {
                        [self.dataSource removeAllObjects];
                        self.dataSource = arrM;
                        //还需要判断总页数
                        if (pageNumCount <= 1)
                        {
                            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
                        }else
                        {
                            _tableView.mj_footer.state = MJRefreshStateIdle;
                            _currPage ++;
                        }
                        
                    }else
                    {
                        // 加载更多
                        for (FNMyOrderModel * orderModle in arrM)
                        {
                            [self.dataSource addObject:orderModle];
                        }
                        if (pageNumCount >_currPage)
                        {
                            _tableView.mj_footer.state = MJRefreshStateIdle;
                            _currPage ++;
                            
                        }else
                        {
                            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
                        }
                    }
                    [_bgView removeFromSuperview];
                    [Mask HUDHideInView:self.view];
                    [self.tableView reloadData];
                    
                }
            }else
            {
                [_bgView removeFromSuperview];
                [Mask HUDHideInView:self.view];
                [self.dataSource removeAllObjects];
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
            
        });
        
    } failure:^(RequestResult *requestResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tableView.userInteractionEnabled = YES;
            [Mask HUDHideInView:self.view];
            [_bgView removeFromSuperview];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
            [self.view makeToast:@"订单获取失败"];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            
        });
    }];

}

- (void)setTypeTitle
{
    for (NSInteger i = 0 ; i < 2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 43);
        [btn setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [btn setTitleColor:UIColorWith0xRGB(0x4A4A4A) forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [_buttonArr addObject:btn];
        [btn addTarget:self action:@selector(clickTypeTitle:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * lineLa = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.height - 2.5,  btn.width, 2)];
        lineLa.backgroundColor = UIColorWith0xRGB(0xDCDADA);
        [btn addSubview:lineLa];

        if (i == 0) {
            _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.height - 2.5, btn.width, 2.5)];
            _lineLabel.backgroundColor = UIColorWith0xRGB(0xEF3030);
            [btn addSubview:_lineLabel];
    
        }
        [self.view addSubview:btn];
    }
}

- (UIView *)loadingView
{
     _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.alpha = 0.1;
    return _bgView;
}

- (void)goBack
{
    for (NSInteger i = 0; i <self.navigationController.viewControllers.count; i++) {
        
        UIViewController *VC = self.navigationController.viewControllers[i];
        
     if ([VC isKindOfClass:[FNShowCouponVC class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KRemoveTestPIc" object:nil userInfo:@{@"position":@(i)}];
            [self.navigationController popToViewController:VC animated:NO];
            return;
        }
    }
    
}

@end

