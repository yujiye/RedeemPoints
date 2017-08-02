 //
//  FNOrderVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/10/10.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderVC.h"
#import "FNHeader.h"
#import "FNOrderCenterView.h"
#import "FNCartBO.h"
static NSString *identifier = @"FNOrderCell";
@interface FNOrderVC ()<FNOrderCenterViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _page;
    NSMutableArray *_array;
    NSMutableArray *_afterSaleTypeList;
    NSInteger _maxPage;
    UIButton *_topBut;
    NSMutableArray *_sellerNameList;
    UIView *_sectionView;
    UILabel *_sectionLabel;
    UILabel *_orderStateLabel;
    
    FNOrderArgs *_order;
    
    FNTitleType _typeOfTableView;
    
    NSInteger _type;
    
    FNNoDataView *_noData;
    
    FNNoOrderView *_noOrderView;
    
    MJRefreshAutoNormalFooter *_refreshFooter;
    
}
@property(nonatomic,strong)FNOrderCenterView * titleView;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic, assign) FNOrderState state;
@end

@implementation FNOrderVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _page = 1;
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)self.stateTag];
    
    if ([str isEqualToString:@"0"])
    {
        _state = FNOrderStateAll;
        [self loadDataWithType:FNTitleTypeOrderStateAll refresh:YES];
    }
    else
    {
        [self.titleView clickButton:self.titleView.buttons[self.stateTag]];
    }
    self.tabBarController.tabBar.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    self.title = @"所有订单";
    _dataSource = [NSMutableArray array];
    [self setNavigaitionMoreItem];
    [self setNavigaitionBackItem];
    [self createTitleView];
    [self scrollView];
    
    _array = [NSMutableArray array];
    _sellerNameList = [NSMutableArray array];
    _afterSaleTypeList = [NSMutableArray array];
    
    _refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    _refreshFooter.automaticallyRefresh = YES;
    [_refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle] ;
    [_refreshFooter setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
    [_refreshFooter setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
 
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(refreshReceivingOrders:) name:@"clickGetGoods" object:nil];

}
- (void)refreshReceivingOrders:(id)sender
{
    NSDictionary * dict = [sender userInfo];
    _typeOfTableView = [[dict objectForKey:@"getGoodsState"] integerValue];
    [self refreshTableView];
}

- (void)createTitleView
{
    FNOrderCenterView *titleView = [[FNOrderCenterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    titleView.titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成",@"售后"];
    titleView.delegate = self;
    _titleView = titleView;
    [self.view addSubview:titleView];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width*6, _scrollView.frame.size.height);
        [self createTableView];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)createTableView
{
    for (int i = 0; i < 6; i ++) {
        NSMutableArray * models = [NSMutableArray array];
        [self.dataSource addObject:models];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width,kScreenHeight - 44 - NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.tag = i + 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.hidden = YES;
        UIView *view = [[UIView alloc]init];
        [_tableView setTableFooterView:view];
        [_tableView registerClass:[FNOrderCell class] forCellReuseIdentifier:identifier];
        [self.scrollView addSubview:_tableView];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FNOrderCell *cell = (FNOrderCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return [cell autoFitHeight];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray *arr = _dataSource[tableView.tag - 50];
    
    return arr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FNOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell =  [[FNOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSMutableArray *arr = _dataSource[tableView.tag - 50];
    
   if (![arr isKindOfClass:[NSNull class]] && arr.count != 0)
   {
           
    FNOrderArgs *order = self.dataSource[tableView.tag - 50][indexPath.row];
    
    cell.order = order;
   
    FNProductArgs *product = order.productList.firstObject;
    
    __weak __typeof(self) weakSelf = self;
    
    if (_state == FNOrderStateAfterSale)
    {
        cell.state = FNOrderStateAfterSale;
    }
    else
    {
        if ([order.orderState integerValue] == FNOrderStateFinish || [order.orderState integerValue] == FNOrderStateFinishCommenting)
        {
            //如果是已完成，则是售后的显示已完成，如果是全部，则显示售后
         
            if (order.afterOrderType == 0)
            {
                cell.state = [order.orderState integerValue];
            }
            else
            {
                cell.state = order.afterOrderType;
            }
        }
        else
        {
            cell.state = [order.orderState integerValue];
        }
    }
        cell.shopLabel.text = ![order.sellerName isKindOfClass:[NSNull class]] ? order.sellerName : @"商家名称";
       if([NSString isEmptyString:product.productName])
       {
            product.productName = @"聚分享产品";
       }
        cell.nameLabel.text = product.productName;

    cell.indexPath = indexPath;
       
    if(![NSString isEmptyString:product.skuName])
    {
        cell.attributeLabel.text = [NSString stringWithFormat:@"%@ x% d",product.skuName,[product.count intValue]];
    }else
    {
        cell.attributeLabel.text = [NSString stringWithFormat:@"x% d",[product.count intValue]];
    }
    
    [cell setActionWithPay:^(FNOrderState state, NSIndexPath *selectedIndexPath, FNOrderCell *selectedCell) {
        
        _order = order;
        
        if (state == FNOrderStateReceiving)
        {
            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"确认收货" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                
                if (bIndex == 0)
                {
                    
                    [FNLoadingView showInView:self.view];
                    [[FNCartBO port02] confirmWithOrderID:_order.orderId block:^(id result){
                        [FNLoadingView hideFromView:self.view];
                        
                        if ([result[@"code"] integerValue] == 200)
                        {
                            _typeOfTableView  = FNTitleTypeOrderStateReceiving;
                            [self refreshTableView];
                            FNConfirmGetGoodsVC * confirmVC = [[FNConfirmGetGoodsVC  alloc]init];
                            confirmVC.state = 1;
                            confirmVC.orderID = _order.orderId;
                            [self.navigationController pushViewController:confirmVC animated:YES];
                       }
                        else
                        {
                            [UIAlertView alertViewWithMessage:result[@"desc"]];
                        }
                    }];
                }
                
            } otherTitle:@"取消", nil];
        }
        else if (state == FNOrderStatePaying)
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date = [df dateFromString:selectedCell.order.createTime];
            
            NSDate * curDate = [NSDate date];
            
            NSTimeInterval inter = [curDate timeIntervalSinceDate:date];
            
            NSTimeInterval interval = selectedCell.order.timeOutLimit * 60 - inter;
            if(interval <= 0)
            {
                 [UIAlertView alertWithTitle:nil message:@"该订单已关闭" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                     
                     [self refreshTableView];
                 } otherTitle: nil];
            }else
            {
            
            FNPayVC *vc = [[FNPayVC alloc] init];
            vc.order = order;
                vc.tradeCode = _order.tradeCode;
            vc.orderIds = @[order.orderId];
           vc.allPrice = [NSString stringWithFormat:@"%@",order.closingPrice];
           vc.curBonus = [order.exchangeScore integerValue];
           if([_order.tradeCode isEqualToString:@"Z8003"] ||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"]||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
            {
                vc.isSpecialType = YES;
            }else
          {
               vc.isSpecialType = NO;
            }
           
            vc.createTime = order.createTime;
           
           [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
        
    } ship:^(id sender) {
        
        FNShipInfoVC *vc = [[FNShipInfoVC alloc] init];
        vc.orderArgs = order;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    if(_state == FNOrderStatePaying || _state ==FNOrderStateAll)
    {
     [cell cancelPay:^(FNOrderArgs *orderArgs) {
         
         NSDateFormatter *df = [[NSDateFormatter alloc] init];
         
         [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         
         NSDate *date = [df dateFromString:orderArgs.createTime];
         
         NSDate * curDate = [NSDate date];
         
         NSTimeInterval inter = [curDate timeIntervalSinceDate:date];
         
         NSTimeInterval interval = orderArgs.timeOutLimit * 60 - inter;
         if(interval <=0)
         {
             [UIAlertView alertWithTitle:nil message:@"该订单已关闭" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                 [self refreshTableView];

             } otherTitle: nil];
         }else{
         
        [UIAlertView alertWithTitle:nil message:@"你是否确定取消订单" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
            if(bIndex == 0 )
            {
                [FNLoadingView showInView:self.view];
                
                [[FNCartBO port02] cancelOrder:orderArgs block:^(id result) {
                    [FNLoadingView hideFromView:self.view];
                    if([result[@"code"] integerValue]==200)
                    {
                        [self refreshTableView];
                        FNConfirmGetGoodsVC *cancelVC = [[FNConfirmGetGoodsVC alloc]init];
                        cancelVC.orderID = order.orderId;
                        cancelVC.state = 2;
                        [self.navigationController pushViewController:cancelVC animated:YES];
                        
                    }else
                    {
                        [self.view makeToast:result[@"desc"]];
                    }
                }];
            }
        } otherTitle:@"取消", nil];
         }
    
     }];
    }
   }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNOrderDetailVC *vc = [[FNOrderDetailVC alloc] initWithState:_state];
    FNOrderArgs *order = nil;
    
    NSArray *models = self.dataSource[tableView.tag - 50];
    if (models.count != 0 )
    {
        order = models[indexPath.row];
    }
    _type = order.type ;
    
    vc.orderID = [order orderId];
    
    if (_type == 3)
    {
        vc.isVirtualGoods = YES;
    }
    else
    {
        vc.isVirtualGoods = NO;
    }
    vc.titleState = _typeOfTableView;
    vc.state = [[order orderState] integerValue];
    self.stateTag = _typeOfTableView;
    vc.timeOutLimit = order.timeOutLimit;
    [self.navigationController pushViewController:vc animated:YES];
}


-(UITableView  *)tableViewWithType:(FNTitleType)type
{
    
    return [self.scrollView viewWithTag:type+50];
    
}
#pragma mark titledelegate

-(void)titleView:(FNOrderCenterView *)view selectIndex:(NSInteger)index
{
    _topBut.alpha = 0;
    _page = 1;
    if (index == 6)
    {
        //跳转其它页

        return;
    }
    self.stateTag = index;

    [_scrollView setContentOffset:CGPointMake(index*kScreenWidth, 0) animated:YES];
    [[self tableViewWithType:index]  setContentOffset:CGPointMake(0,0) animated:NO];
    [self loadDataWithType:(FNTitleType)index refresh:YES];
}

-(void)loadDataWithType:(FNTitleType)type refresh:(BOOL)isRefresh
{
    [self tableViewWithType:type].scrollEnabled = YES;
    
    _typeOfTableView = type;
    
    [self tableViewWithType:type].mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self refreshTableView];
    }];
    [self tableViewWithType:type].mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshTableView)];
    
    
    _topBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 44, 44);
    
    [_topBut setBackgroundImage:[UIImage imageNamed:@"main_back_top"] forState:UIControlStateNormal];
    
    [_topBut addSuperView:self.view ActionBlock:^(id sender) {
        
        [[self tableViewWithType:type] scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:YES];
        
    }];
    
    _topBut.alpha = 0;
    __weak __typeof(self) weakSelf = self;
    switch (type) {
        case 0:
            _state = FNOrderStateAll;
            
            break;
        case 1:
            _state = FNOrderStatePaying;
            break;
        case 2:
            _state = FNOrderStateShipping;
            break;
        case 3:
            _state = FNOrderStateReceiving;
            break;
        case 4:
            _state = FNOrderStateFinish;
            break;
        case 5:
            _state = FNOrderStateAfterSale;
            break;
        default:
            break;
    }
   
    [FNLoadingView showInView:self.view];
    _scrollView.scrollEnabled = NO;
    _titleView.userInteractionEnabled = NO;
    [self tableViewWithType:type].hidden = YES;
    [[FNCartBO port02] getOrderListWithPage:_page status:_state block:^(id result) {
        [[self tableViewWithType:type].mj_footer endRefreshing];
        
        [[self tableViewWithType:type].mj_header endRefreshing];
        
        if (result && [result[@"code"] integerValue] == 200)
        {
            if (_page == 1)
            {
                [_array removeAllObjects];
                [self.dataSource[type] removeAllObjects];
                
            }
            [_afterSaleTypeList removeAllObjects];
            for (NSDictionary *dict in result[@"orderList"])
            {
                FNOrderArgs *args = [FNOrderArgs makeEntityWithJSON:dict];
                
                args.curTime = [NSNumber numberWithDouble:[result[@"curTime"] doubleValue]];
                
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSDictionary *d in dict[@"productList"])
                {
                    FNProductArgs *p = [FNProductArgs makeEntityWithJSON:d];
                    
                    [array addObject:p];
                }
                
                args.productList = array;
                [_array addObject:args];
            }
            if (result[@"afterSaleList"] && [result[@"afterSaleList"] isKindOfClass:[NSArray class]])
            {
                [self tableViewWithType:type].hidden = NO;
                for(NSDictionary * dict in result[@"afterSaleList"])
                {
                    [_afterSaleTypeList addObject:[FNAfterSaleModel makeEntityWithJSON:dict]];
                }
            }
            //匹配状态
            for(FNOrderArgs *order  in _array)
            {
                __block FNAfterSaleModel *afterSale =nil;
                
                [_afterSaleTypeList enumerateObjectsUsingBlock:^(FNAfterSaleModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.orderId isEqualToString: order.orderId]  )
                    {
                        afterSale = obj;
                        afterSale.type = FNOrderStateAfterSale;
                        *stop = YES;
                    }
                }];
                
                order.afterOrderType = afterSale.type;
            }
            
            // 匹配名称
            for (NSDictionary * dict in result[@"sellerList"])
            {
                [_sellerNameList addObject:[FNSellerName makeEntityWithJSON:dict]];
            }
            for (FNOrderArgs * orderArgs in _array)
            {
                __block FNSellerName * sellerName = nil;
                [_sellerNameList enumerateObjectsUsingBlock:^(FNSellerName* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.sellerId == [orderArgs.sellerId intValue] )
                    {
                        sellerName = obj;
                        *stop = YES;
                    }
                }];
                orderArgs.sellerName = sellerName.sellerName;
            }
            [_dataSource[type] addObjectsFromArray:_array];
            
            if ([(NSArray *)result[@"orderList"] count] >= MAIN_PER_PAGE )
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                [self tableViewWithType:type].hidden = NO;
                _page ++;
                
                [self tableViewWithType:type].mj_footer.state = MJRefreshStateIdle;
            }
            else
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                [self tableViewWithType:type].hidden = NO;
                [self tableViewWithType:type].mj_footer = _refreshFooter;
                [self tableViewWithType:type].mj_footer.state = MJRefreshStateNoMoreData;
                [[self tableViewWithType:type] reloadData];
                
            }
            if (![_array count])
            {
                _noOrderView = [[FNNoOrderView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
                [_noOrderView setActionBlock:^(id sender) {
                    [weakSelf goMain];
                }];
                [FNLoadingView hide];
                [self tableViewWithType:type].scrollEnabled = NO;
                _titleView.userInteractionEnabled = YES;
                _scrollView.scrollEnabled = YES;
                [self tableViewWithType:type].hidden = NO;
                UITableView *tableView = [self tableViewWithType:type];
                tableView.scrollEnabled = NO;
                tableView.tableHeaderView = _noOrderView;
                tableView.mj_header.hidden = YES;
                tableView.mj_footer.hidden = YES;
                
            }
            else
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                [self tableViewWithType:type].hidden = NO;
                [_noData removeFromSuperview];

                [self tableViewWithType:_typeOfTableView].tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
                [self tableViewWithType:_typeOfTableView].mj_footer.hidden = NO;
                [self tableViewWithType:_typeOfTableView].mj_header.hidden = NO;
                [[self tableViewWithType:type] reloadData];
            }
        }
        else
        {
            if (_page == 1)
            {
            
                [_array removeAllObjects];
                [self.dataSource[type] removeAllObjects];
                [_afterSaleTypeList removeAllObjects];
                [self.dataSource[_typeOfTableView] removeAllObjects];
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                [_noData setTypeWithResult:result];
                [_noData setActionBlock:^(id sender) {
                    _page = 1;
                    [weakSelf refreshTableView];
                }];
                [self tableViewWithType:type].hidden = NO;
                [self tableViewWithType:type].tableHeaderView = _noData;
                [self tableViewWithType:type].mj_footer.hidden = YES;
                [self tableViewWithType:type].mj_header.hidden = YES;
                [[self tableViewWithType:type] reloadData];

                return;
            }
            if(result)
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                
                [self tableViewWithType:type].hidden = NO;
                [self.view makeToast:result[@"desc"]];
            }
            else
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                [self tableViewWithType:type].hidden = NO;
                [self.view makeToast:@"加载失败,请重试"];
            }
            
            return ;
        }
        [[self tableViewWithType:type] reloadData];
    }];
    
}
- (void)refreshTableView
{
    __weak __typeof(self) weakSelf = self;
    switch (_typeOfTableView) {
        case 0:
            _state = FNOrderStateAll;
            _typeOfTableView =  FNTitleTypeOrderStateAll;
            break;
        case 1:
            _state = FNOrderStatePaying;
            _typeOfTableView = FNTitleTypeOrderStatePaying;
            break;
        case 2:
            _state = FNOrderStateShipping;
            _typeOfTableView = FNTitleTypeOrderStateShipping;
            break;
        case 3:
            _state = FNOrderStateReceiving;
            _typeOfTableView = FNTitleTypeOrderStateReceiving;
            break;
        case 4:
            _state = FNOrderStateFinish;
            _typeOfTableView =FNTitleTypeOrderStateFinish;
            break;
        case 5:
            _state = FNOrderStateAfterSale;
            _typeOfTableView = FNTitleTypeOrderStateAfterSale;
            break;
        default:
            break;
    }
    
    [FNLoadingView showInView:self.view];
    _scrollView.scrollEnabled = NO;
    _titleView.userInteractionEnabled = NO;
    [[FNCartBO port02] getOrderListWithPage:_page status:_state block:^(id result) {
        [[self tableViewWithType:_typeOfTableView].mj_footer endRefreshing];
        
        [[self tableViewWithType:_typeOfTableView].mj_header endRefreshing];
      
        if (result && [result[@"code"] integerValue] == 200)
        {

            if ( _page == 1)
            {
                [_array removeAllObjects];
                [_afterSaleTypeList removeAllObjects];
            }
            [self.dataSource[_typeOfTableView] removeAllObjects];
            
            for (NSDictionary *dict in result[@"orderList"])
            {
                FNOrderArgs *args = [FNOrderArgs makeEntityWithJSON:dict];
                
                args.curTime = [NSNumber numberWithDouble:[result[@"curTime"] doubleValue]];
                
                NSMutableArray *array = [NSMutableArray array];
                
                for (NSDictionary *d in dict[@"productList"])
                {
                    FNProductArgs *p = [FNProductArgs makeEntityWithJSON:d];
                    
                    [array addObject:p];
                }
                
                args.productList = array;
                [_array addObject:args];
            }

            if (result[@"afterSaleList"] && [result[@"afterSaleList"] isKindOfClass:[NSArray class]])
            {
                [self tableViewWithType:_typeOfTableView].hidden = NO;
                for(NSDictionary * dict in result[@"afterSaleList"])
                {
                    [_afterSaleTypeList addObject:[FNAfterSaleModel makeEntityWithJSON:dict]];
                }
            }
            //匹配状态
            for(FNOrderArgs *order  in _array)
            {
                __block FNAfterSaleModel *afterSale =nil;
                
                [_afterSaleTypeList enumerateObjectsUsingBlock:^(FNAfterSaleModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.orderId isEqualToString: order.orderId]  )
                    {
                        afterSale = obj;
                        afterSale.type = FNOrderStateAfterSale;
                        *stop = YES;
                    }
                }];
                order.afterOrderType = afterSale.type;
            }
            // 匹配名称
            for (NSDictionary * dict in result[@"sellerList"])
            {
                [_sellerNameList addObject:[FNSellerName makeEntityWithJSON:dict]];
            }
            for (FNOrderArgs * orderArgs in _array)
            {
                __block FNSellerName * sellerName = nil;
                [_sellerNameList enumerateObjectsUsingBlock:^(FNSellerName* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.sellerId == [orderArgs.sellerId intValue] )
                    {
                        sellerName = obj;
                        *stop = YES;
                    }
                }];
                orderArgs.sellerName = sellerName.sellerName;
            }
            [_dataSource[_typeOfTableView] addObjectsFromArray:_array];
            [[self tableViewWithType:_typeOfTableView ] reloadData];
            
            if ([(NSArray *)result[@"orderList"] count] >= MAIN_PER_PAGE )
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                [self tableViewWithType:_typeOfTableView].hidden = NO;
                _page ++;
                [self tableViewWithType:_typeOfTableView].mj_footer.state = MJRefreshStateIdle;

          }
            else
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                [self tableViewWithType:_typeOfTableView].hidden = NO;
                [self tableViewWithType:_typeOfTableView].mj_footer = _refreshFooter;
                [self tableViewWithType:_typeOfTableView].mj_footer.state = MJRefreshStateNoMoreData;
                [[self tableViewWithType:_typeOfTableView] reloadData];
                
            }
            if (![_array count])
            {
                _noOrderView = [[FNNoOrderView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
                [_noOrderView setActionBlock:^(id sender) {
                    [weakSelf goMain];
                }];
                [FNLoadingView hide];
                [self tableViewWithType:_typeOfTableView].hidden = NO;
                UITableView *tableView =  [self tableViewWithType:_typeOfTableView];
                tableView.tableHeaderView = _noOrderView;
                tableView.mj_footer.hidden = YES;
                tableView.mj_header.hidden = YES;
                _scrollView.scrollEnabled = NO;
                _titleView.userInteractionEnabled = YES;
            }
            else
            {
                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                [_noData removeFromSuperview];

                [self tableViewWithType:_typeOfTableView].hidden = NO;
                [self tableViewWithType:_typeOfTableView].tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
                [self tableViewWithType:_typeOfTableView].mj_footer.hidden = NO;
                [self tableViewWithType:_typeOfTableView].mj_header.hidden = NO;
                [[self tableViewWithType:_typeOfTableView] reloadData];
            }
        }
        else
        {
            if (_page == 1)
            {
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
                }
                _noData.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
                [_array removeAllObjects];
                [_afterSaleTypeList removeAllObjects];
                [self.dataSource[_typeOfTableView] removeAllObjects];

                [FNLoadingView hide];
                _scrollView.scrollEnabled = YES;
                _titleView.userInteractionEnabled = YES;
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                [_noData setTypeWithResult:result];
                
                [_noData setActionBlock:^(id sender) {
                    
                    _page = 1;
                    [weakSelf refreshTableView];

                }];
                [self tableViewWithType:_typeOfTableView].hidden = NO;

                [self tableViewWithType:_typeOfTableView].tableHeaderView = _noData;
                [self tableViewWithType:_typeOfTableView].mj_footer.hidden = YES;
                [self tableViewWithType:_typeOfTableView].mj_header.hidden = YES;
                [[self tableViewWithType:_typeOfTableView] reloadData];
                
                return;
            }
            
            _scrollView.scrollEnabled = YES;
            _titleView.userInteractionEnabled = YES;
            [FNLoadingView hide];
            [self tableViewWithType:_typeOfTableView].hidden = NO;
            if(result)
            {
                [self.view makeToast:result[@"desc"]];
            }
            else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
            return ;
        }
        [[self tableViewWithType:_typeOfTableView] reloadData];
    }];
    
}

#pragma mark scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (self.scrollView == scrollView)
    {
        _page = 1;
        NSInteger index = self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
        self.stateTag = index;
        [self.titleView clickButton:self.titleView.buttons[index]];
    }
}

- (void)goBack
{
    // 从通知过来
    if (self.isNoti)
    {
        [super goBack];
        
        return;
    }
    
    //从支付和我的过来
    if (_isPayFinish == YES)
    {
        [self goTabIndex:3];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        CGFloat offsetY = scrollView.contentOffset.y;
        
        CGFloat offY =  1- (100 - offsetY)/100;
        if (offY < 0 )
        {
            offY = 0;
        }else if ( offY>1)
        {
            offY = 1;
        }
        
        _topBut.alpha = offY;
    }
    else
    {
        _topBut.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"clickGetGoods" object:nil];

}

@end
