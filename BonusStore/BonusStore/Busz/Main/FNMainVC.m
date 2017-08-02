//
//  FNMainVC.m
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainVC.h"
#import "FNMainBO.h"
#import "FNCartBO.h"
#import "FNLoginBO.h"
#import "FNMyBO.h"
#import "FNBonusBO.h"
#import "FNDetailVC.h"
#import "FNMainConfigHeaderView.h"
#import "FNHeader.h"
#import "FNQCoinRechargeVC.h"
@interface FNMainVC ()<UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    FNFocusView *_focusView;
    
    UIButton *_topBut;
    
    NSMutableArray *_productArray;
    
    NSInteger _page;
    
    NSInteger _advertId;
    
    NSMutableArray *_focusItem;
    
    UICollectionView *_collectionView;
    
    MJRefreshAutoNormalFooter *_footer;
 
    UILabel *_searchLab;
    
    UIView *_navigationBarView;
    
    UIImageView *_scanImage;
    
    UILabel *_scanLabel;
    
    UIImageView *_msgImg;
    
    UIImageView *_searchImg;
    
    UILabel *_msgLab;
    
    UIView *_msgView;
    
    NSMutableArray *_advertOfProductArray;
    
    NSMutableArray *_advertOfImageArray;
    
    NSMutableArray *_advertOfCashArray;
    
    NSMutableArray *_focusArray;
    BOOL _isRefresh;
    
    BOOL _isMsg;
    
    UIImage *_img;
    
    UIImageView *_bigImg;
    
    UILabel * _sepLab;
    
    BOOL _clickBtnShow;
    
}

@end

@implementation FNMainVC

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _productArray = [[NSMutableArray alloc] init];
        _page = 1;
        _advertId = 1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    [_navigationBarView removeFromSuperview];
    
    if ([FNMessageNoti isNewBonusMsg] || [FNMessageNoti isNewOrderMsg] || [FNMessageNoti isNew])
    {
        _isMsg = YES;
        _img = [UIImage imageNamed:@"main_msg_msg"];
    }
    else
    {
        _isMsg = NO;
        _img = [UIImage imageNamed:@"main_msg"];
    }
    
    [self initNavigationHeader];
    
    [[FNMainBO port01] getHotSearchListWithModuleId:@"6" block:^(id result) {
        
        if ([result isKindOfClass:[NSArray class]])
        {
            NSMutableArray *defaultArray = [NSMutableArray array];
            NSString *defaultStr ;
            for (FNHotSearchModel *model in result)
            {
                if ([model.relaSort isEqualToString:@"1"])
                {
                    [defaultArray addObject:model.relaImgkey];
                    defaultStr = model.relaImgkey;
                }
            }
            if (defaultArray.count == 0)
            {
                _searchLab.text = @"购物返积分,积分当钱花";
            }
            else
            {
                _searchLab.text = defaultStr;
            }
        }
        else
        {
            if (result)
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];
            }
            _searchLab.text = @"购物返积分,积分当钱花";
        }
        [_searchImg addSubview:_searchLab];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initFlash];

    _advertOfCashArray = [NSMutableArray array];
    
    _advertOfImageArray = [NSMutableArray array];
    
    _advertOfProductArray = [NSMutableArray array];
    
    _focusArray = [NSMutableArray array];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5.0;
    layout.minimumLineSpacing = 5.0;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc]initWithFrame: CGRectMake(0, 0, kScreenWidth, self.view.height - self.navigationController.tabBarController.tabBar.height) collectionViewLayout:layout];
    
    _collectionView.delegate = self;
    
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = MAIN_BACKGROUND_COLOR;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[FNMainItemCell class] forCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class])];
    
    [_collectionView registerClass:[FNMainItemTableCell class] forCellWithReuseIdentifier:NSStringFromClass([FNMainItemTableCell class])];
    
    [_collectionView registerClass:[FNMainHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_collectionView registerClass:[FNMainReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    [_collectionView registerClass:[FNMainReusableViewTwo class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footertwo"];

    [self.view addSubview:_collectionView];

    _isRefresh = YES;
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 1;
        _advertId = 1;
        [self getData];
        _isRefresh = YES;

    }];

    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];

    _footer.automaticallyRefresh = YES;
    [_footer setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
    
    [_footer setTitle:@"" forState:MJRefreshStateNoMoreData];

    _collectionView.mj_footer = _footer;

    _topBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-44, 44, 44);
    
    [_topBut setBackgroundImage:[UIImage imageNamed:@"main_back_top"] forState:UIControlStateNormal];
    
    [_topBut addSuperView:self.view ActionBlock:^(id sender) {
        
        [_collectionView scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:YES];
        
    }];
    
    _topBut.alpha = NO;
    
    [self getData];
    
    [self updateVersion];
}

- (void)initNavigationHeader
{
    _navigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navigationBarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navigationBarView];
    
    UIView *scanView = [[UIView alloc]initWithFrame:CGRectMake(0, 23, 36, 34)];
    scanView.backgroundColor = [UIColor clearColor];
    [_navigationBarView addSubview:scanView];
    [scanView addTarget:self action:@selector(goScan)];
    
    _scanImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 18, 18)];
    _scanImage.image = [UIImage  imageNamed:@"main_scan"];
    _scanImage.contentMode = UIViewContentModeScaleAspectFit;
    [scanView addSubview:_scanImage];
    _scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scanImage.frame)+4,36 , 10)];
    [_scanLabel addTarget:self action:@selector(goScan)];
    _scanLabel.font = [UIFont systemFontOfSize:10];
    _scanLabel.textColor = [UIColor whiteColor];
    _scanLabel.textAlignment = NSTextAlignmentRight;
    _scanLabel.text = @"付款";
    [scanView addSubview:_scanLabel];
    
    _msgView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 36, scanView.y, 36, 34)];
    _msgView.backgroundColor = [UIColor clearColor];
    [_navigationBarView addSubview:_msgView];
    [_msgView addTarget:self action:@selector(goMessage)];
    _msgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    _msgImg.contentMode = UIViewContentModeScaleAspectFit;
    _msgImg.image =_img;
    [_msgView addSubview:_msgImg];
    _msgLab = [[UILabel alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(_scanImage.frame)+4,36 ,10)];
    [_msgLab addTarget:self action:@selector(goMessage)];
    _msgLab.font = [UIFont systemFontOfSize:10];
    _msgLab.textColor = [UIColor whiteColor];
    _msgLab.textAlignment = NSTextAlignmentLeft;
    _msgLab.text = @"消息";
    [_msgView addSubview:_msgLab];
    
    CGFloat searchHeight = 30;
    CGFloat font = 11;
    _searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(_scanImage.x+_scanImage.width + 15, scanView.y, kScreenWidth -60-_scanImage.width-_msgImg.width, searchHeight)];
    _searchImg.image = [UIImage imageNamed:@"main_search"];
  
    [_searchImg addTarget:self action:@selector(goSearchVC)];
    [_navigationBarView addSubview:_searchImg];
    
    _bigImg = [[UIImageView alloc]initWithFrame:CGRectMake(searchHeight*0.5, (searchHeight -18)*0.5, 18, 18)];
    _bigImg.image = [UIImage imageNamed:@"main_big"];
    [_searchImg addSubview:_bigImg];
    
    _searchLab = [[UILabel alloc]initWithFrame:CGRectMake(36,0 , _searchImg.width - 35,searchHeight)];
    _searchLab.textColor = [UIColor whiteColor];
    _sepLab.backgroundColor = [UIColor clearColor];
    _searchLab.font = [UIFont systemFontOfSize:font];
    
    _sepLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, kScreenWidth, 1)];
    _sepLab.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
    _sepLab.hidden = YES;
    [_navigationBarView addSubview:_sepLab];

}

- (void)updateVersion
{

    [[[FNMyBO port01] withOutUserInfo] getUpdateWithBlock:^(id result) {
        
        if ([result[@"code"] integerValue] != 200)
        {
            if (![result isKindOfClass:[NSArray class]])
            {
                if(result)
                {
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                }
            }
            return ;
        }
        
        if (![FNMyUpdateInfo isKindOfClass:[NSDictionary class]] || ![[FNMyUpdateInfo allKeys] count])
        {
            return;
        }
        
        if (FNMyIsEnforceUpdate == 2)
        {
            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:FNMyUpdateInfo[@"upgradeDesc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                
                if (bIndex == 0)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FNMyUpdateInfo[@"url"]]];
                }
                
            } otherTitle:nil, nil];
        }
        else if (FNMyIsEnforceUpdate == 1)
        {
            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:FNMyUpdateInfo[@"upgradeDesc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                
                if (bIndex == 0)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FNMyUpdateInfo[@"url"]]];
                }
            } otherTitle:@"取消", nil];
        }
        else
        {
        }
        
    }];

}

- (void)getData
{
    
    //周佳那里有台测试机有问题，读取缓存，界面总是显示错乱，暂时先屏蔽掉
    //首先获取缓存数据
     //轮播图缓存
    //商品模块配置缓存
    _clickBtnShow = NO;

    id modelProdcutTemp = [FNCacheManager getInfoWithPath:FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST];
    
    if (modelProdcutTemp && _productArray.count == 0)
    {
        for (NSDictionary *dict in modelProdcutTemp[@"ModuleConfigDetailList"])
        {
            [_productArray addObject:[FNMainModelConfigOfProduct makeEntityWithJSON:dict]];
        }
    }
    //商品模块ModuleId＝4    6:搜索
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[FNMainBO port01] getModelConfigOfProductListWithModuleId:@"4" curPage:_page perCount:MAIN_PER_PAGE block:^(id result) {
            [FNLoadingView hideFromView:self.view];
            if (![FNReachability isReach])
           {
            [_footer setTitle:@"网络异常，请刷新重试" forState:MJRefreshStateIdle];
               [_collectionView.mj_footer endRefreshing];
               [_collectionView.mj_header endRefreshing];
               return ;
            }
            [_collectionView.mj_footer endRefreshing];
            [_collectionView.mj_header endRefreshing];
            
            if (_page == 1 && result)
            {
                [_productArray removeAllObjects];
                
                [_collectionView reloadData];
            }
            
            if ([(NSArray *)result count] < MAIN_PER_PAGE)
            {
                _collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                
                _collectionView.mj_footer.hidden = YES;
                
                _clickBtnShow = YES;

            }else
            {
                _clickBtnShow = NO;
                
                _collectionView.mj_footer.hidden = NO;

            }
            [_productArray addObjectsFromArray:result];
            
            _page ++;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_collectionView reloadData];
                
            });
        }];
        
        [[[FNMainBO port01] withOutUserInfo] getMessageListWithBlock:^(id result) {
            
            
        }];
        
    });
    
}

- (void)initFlash
{
    __weak __typeof(self) weakSelf = self;
    
    if ([FNSystemConfig isFirstLaunch])
    {
        FNGuidanceView *guidance = [[FNGuidanceView alloc] initWithFrame:self.view.bounds];
        
        [[UIApplication sharedApplication].keyWindow addSubview:guidance];
        
        [guidance initLastBlock:^(id sender) {
            
            [guidance hide];
            
            switch ([(UIButton *)sender tag])
            {
                case 0:
                {
                    FNRegisterVC *vc = [[FNRegisterVC alloc] init];
                    vc.navigationController.tabBarController.tabBar.hidden = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    FNLoginVC *vc = [[FNLoginVC alloc] init];
                    vc.navigationController.tabBarController.tabBar.hidden = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        if (indexPath.section == 0)
        {
            FNMainHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
            header.backgroundColor = MAIN_BACKGROUND_COLOR;
            //配置兑换区  --缓存
            id cashTemp = [FNCacheManager getInfoWithPath:FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST];
            if (cashTemp && _advertOfCashArray.count == 0)
            {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in cashTemp[@"AdvertSlotImageList"])
                {
                    [array addObject:[FNAdvertOfConfig makeEntityWithJSON:dict]];
                }
                for (FNAdvertOfConfig *config in array)
                {
                    if (config.isOnline == 1)
                    {
                        [_advertOfCashArray addObject:config];
                        int i,j;
                        for (i = 0; i < _advertOfCashArray.count; i ++)
                        {
                            for (j = 0; j<_advertOfCashArray.count-i-1; j++)
                            {
                                FNAdvertOfConfig *config = _advertOfCashArray[j];
                                FNAdvertOfConfig *configJ = _advertOfCashArray[j+1];
                                if (config.sort >configJ.sort)
                                {
                                    [_advertOfCashArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                                }
                            }
                        }
                    }
                }
                [header.configView setCashDataWithCashArray:_advertOfCashArray];
            }
          
            if (_advertId == 1 && _isRefresh == YES )
            {
                //advertid:8 首页3个兑换区
                [[FNMainBO port04] getProductListWithAdvertId:FNMainModelOfAdvertIdTypeOfCash block:^(id result) {
                    _isRefresh = NO;
                    if ([result isKindOfClass:[NSArray class]])
                    {
                        [_advertOfCashArray removeAllObjects];

                        for (FNAdvertOfConfig *config in result)
                        {
                            if (config.isOnline == 1)
                            {
                                [_advertOfCashArray addObject:config];
                                int i,j;
                                for (i = 0; i < _advertOfCashArray.count; i ++)
                                {
                                    for (j = 0; j<_advertOfCashArray.count-i-1; j++)
                                    {
                                        FNAdvertOfConfig *config = _advertOfCashArray[j];
                                        FNAdvertOfConfig *configJ = _advertOfCashArray[j+1];
                                        if (config.sort >configJ.sort)
                                        {
                                            [_advertOfCashArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        if (result)
                        {
                            [UIAlertView alertViewWithMessage:result[@"desc"]];
                        }
                        else
                        {
                        }
                    }
                    [header.configView setCashDataWithCashArray:_advertOfCashArray];
                }];
                
            }
            
            //配置广告区－－广告商品配置缓存
            id advertTemp = [FNCacheManager getInfoWithPath:FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST];
            if (advertTemp && _advertOfImageArray.count == 0)
            {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in advertTemp[@"AdvertSlotImageList"])
                {
                    [array addObject:[FNAdvertOfConfig makeEntityWithJSON:dict]];
                }
                for (FNAdvertOfConfig *config in array)
                {
                    if (config.isOnline == 1)
                    {
                        [_advertOfImageArray addObject:config];
                    }
                }
               [header.productHeaderView setHeaderImg:_advertOfImageArray];
            }
            if(_advertId == 1 && _isRefresh == YES)
            {
                [[FNMainBO port04] getProductListWithAdvertId:FNMainModelOfAdvertIdTypeOfImage block:^(id result) {
                    _isRefresh = NO;
                    if ([result isKindOfClass:[NSArray class]])
                    {
                        [_advertOfImageArray removeAllObjects];
                        for (FNAdvertOfConfig *config in result)
                        {
                            if (config.isOnline == 1)
                            {
                                [_advertOfImageArray addObject:config];
                            }
                        }
                    }
                    else
                    {
                        if (result)
                        {
                            [UIAlertView alertViewWithMessage:result[@"desc"]];
                        }
                        else
                        {
                        }
                    }
                    [header.productHeaderView setHeaderImg:_advertOfImageArray];
            }];
            }
            id advertProductTemp = [FNCacheManager getInfoWithPath:FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST];
            
            if (advertProductTemp && _advertOfProductArray.count == 0)
            {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in advertProductTemp[@"AdvertSlotImageList"])
                {
                    [array addObject:[FNAdvertOfConfig makeEntityWithJSON:dict]];
                }
                for (FNAdvertOfConfig *config in array)
                {
                    if (config.isOnline == 1)
                    {
                        [_advertOfProductArray addObject:config];
                        int i,j;
                        for (i = 0; i < _advertOfProductArray.count; i ++)
                        {
                            for (j = 0; j<_advertOfProductArray.count-i-1; j++)
                            {
                                FNAdvertOfConfig *config = _advertOfProductArray[j];
                                FNAdvertOfConfig *configJ = _advertOfProductArray[j+1];
                                if (config.sort >configJ.sort)
                                {
                                    [_advertOfProductArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                                }
                            }
                        }
                    }
                }
                [header.productHeaderView setConfigForProductWithImgArray:_advertOfProductArray];
            }
            if (_advertId == 1 && _isRefresh == YES)
            {
                //配置商品区
                [[FNMainBO port04] getProductListWithAdvertId:FNMainModelOfAdvertIdTypeOfProduct block:^(id result) {
                    _isRefresh = NO;
                    if ([result isKindOfClass:[NSArray class]])
                    {
                        [_advertOfProductArray removeAllObjects];
                        for (FNAdvertOfConfig *config in result)
                        {
                            if (config.isOnline == 1)
                            {
                                
                                [_advertOfProductArray addObject:config];
                                int i,j;
                                for (i = 0; i < _advertOfProductArray.count; i ++)
                                {
                                    for (j = 0; j<_advertOfProductArray.count-i-1; j++)
                                    {
                                        FNAdvertOfConfig *config = _advertOfProductArray[j];
                                        FNAdvertOfConfig *configJ = _advertOfProductArray[j+1];
                                        if (config.sort >configJ.sort)
                                        {
                                            [_advertOfProductArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    [header.productHeaderView setConfigForProductWithImgArray:_advertOfProductArray];
                }];
            }
            
            //Because this delegate function is slower than '_page++', so here is '_page == 2', not '_page == 1'
            //It's the same even if you exchange reloadData function with '_page++';
            id focusTemp = [FNCacheManager getInfoWithPath:FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST];
            if (focusTemp && _focusArray.count == 0)
            {
                NSMutableArray *array = [NSMutableArray array];
                for (NSDictionary *dict in focusTemp[@"AdvertSlotImageList"])
                {
                    [array addObject:[FNAdvertOfConfig makeEntityWithJSON:dict]];
                }
                for (FNAdvertOfConfig *config in array)
                {
                    if (config.isOnline == 1)
                    {
                        [_focusArray addObject:config];
                        int i,j;
                        for (i = 0; i < _focusArray.count; i ++)
                        {
                            for (j = 0; j<_focusArray.count-i-1; j++)
                            {
                                FNAdvertOfConfig *config = _focusArray[j];
                                FNAdvertOfConfig *configJ = _focusArray[j+1];
                                if (config.sort >configJ.sort)
                                {
                                    [_focusArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                                }
                            }
                        }
                    }
                }
                [header.focusView setItems:_focusArray];
                [header.focusView setIsAutoLoop:YES];
            }
            if (_advertId == 1 && _isRefresh == YES )
            {
                [[FNMainBO port04] getProductListWithAdvertId:FNMainModelOfAdvertIdTypeOfFocus block:^(id result) {
                    _isRefresh = NO;
                    if ([result isKindOfClass:[NSArray class]])
                    {
                        [_focusArray removeAllObjects];
                        for (FNAdvertOfConfig *config in result)
                        {
                            if (config.isOnline == 1)
                            {
                                [_focusArray addObject:config];
                                int i,j;
                                for (i = 0; i < _focusArray.count; i ++)
                                {
                                    for (j = 0; j<_focusArray.count-i-1; j++)
                                    {
                                        FNAdvertOfConfig *config = _focusArray[j];
                                        FNAdvertOfConfig *configJ = _focusArray[j+1];
                                        if (config.sort >configJ.sort)
                                        {
                                            [_focusArray exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
                                        }
                                    }
                                }

                            }
                        }
                        if ([_focusArray count]>0)
                        {
                            [header.focusView setItems:_focusArray];
                            [header.focusView setIsAutoLoop:YES];
                            [FNCacheManager save:result path:FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST];

                            return ;
                        }
                        else if ([_focusArray count]==0)
                        {
                            //暂无轮播图
                        }
                        return;
                    }
                    else
                    {
                        if(result)
                        {
                            [self.view makeToast:result[@"desc"]];
                        }else
                        {
                            
                        }
                        
                        return;
                    }
            
                }];
            }
            
            __weak __typeof(self) weakSelf = self;
            
            [header.focusView focusDidSelectedIndex:^(NSInteger index, FNImageArgs *args) {
                
                //add http prefix.
                //'app=app' 是为了h5活动页显示分享按钮。正常的活动页需要加，但是积分活动页面不用，所以这里进行区分
                //商品详情（productId）、活动（active）、红包（encryActivityId）
                FNAdvertOfConfig *config = _focusArray[index];
                
                NSMutableString *j = [NSMutableString stringWithFormat:@"%@", config.jump];
                
                if ([j rangeOfString:@"data-detail"].length)
                {
                    NSString *productDes = [[j componentsSeparatedByString:@"?"] lastObject];
                    
                    NSString * productId  = [[productDes componentsSeparatedByString:@"="]lastObject];
                    
                    FNDetailVC *vc = [[FNDetailVC alloc] init];
                    
                    vc.productId = productId;
                    
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                }else if ([j rangeOfString:@"sztRecharge"].location!= NSNotFound ||[j rangeOfString:@"rechargeszt"].location!= NSNotFound)
                {
                    
                    FNSZWelcomeVC *buyCouponVC = [[FNSZWelcomeVC  alloc]init];
                    [buyCouponVC setHidesBottomBarWhenPushed:YES];

                    [self.navigationController pushViewController:buyCouponVC animated:YES];
                }
                else
                {
                    if ([j rangeOfString:@"?"].length)
                    {
                        [j appendString:@"&app=app"];
                    }
                    else
                    {
                        [j appendString:@"?app=app"];
                    }
                    
                    FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:j]];
                    
                    web.isPop = YES;
                    
                    web.title = @"聚分享活动";
                    
                    [weakSelf.navigationController pushViewController:web animated:YES];
                }
                
            }];
            
            [header goItemIndexBlock:^(NSInteger index) {
               
                switch (index)
                {
                    case 0:
                    {
                        FNHebaoIntroVC *vc = [[FNHebaoIntroVC alloc] init];
                        
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        if (![FNLoginBO isLogin])
                        {
                            return ;
                        }
                        
                        [[[FNBonusBO port01] withOutUserInfo] teleInWithBlock:^(id result) {
                           
                            if ([result[@"code"] integerValue] == 200)
                            {
                                FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:result[@"url"]]];
                                 
                                vc.title = @"电信积分";
                                
                                vc.isPop = YES;
                                
                                [weakSelf.navigationController pushViewController:vc animated:YES];
                            }
                            
                        }];
                    }
                        break;
                    case 2:
                    {
                        FNHopeVC *vc = [[FNHopeVC alloc] init];
                        
                        [weakSelf.navigationController pushViewController:vc animated:YES];

                    }
                        break;
                    case 3:
                    {
                        if (![FNLoginBO isLogin])
                        {
                            return ;
                        }
                        
                        FNMyBonusVC *vc = [[FNMyBonusVC alloc ] init];
                        
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
            
            reusableView = header;
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        
       if ( _clickBtnShow)
       {
          
           FNMainReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
           [footer.checkAllBtn addTarget:self action:@selector(checkAllBtnAction:) forControlEvents:UIControlEventTouchUpInside];
           reusableView = footer;

       }else
       {
           FNMainReusableViewTwo *footerTwo = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footertwo" forIndexPath:indexPath];
           reusableView = footerTwo;

       }
       
    }
    
    return reusableView;
}

- (void)checkAllBtnAction:(UIButton *)sender
{
    FNMainAllProductVC *mainAllProductVC = [[FNMainAllProductVC alloc]init];
    [self.navigationController pushViewController:mainAllProductVC animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_productArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNMainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class]) forIndexPath:indexPath];
    
    FNMainModelConfigOfProduct *product = _productArray[indexPath.row];
    
    [cell.iconView sd_setImageWithURL:IMAGE_ID(product.relaImgkey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
    
    cell.titleLabel.text = product.title;
    
    if ([NSString isEmptyString:[NSString stringWithFormat:@"%@",product.curPrice]])
    {
        cell.priceLabel.text = @"";
        cell.bonusLabel.text = @"";
    }
    else
    {
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",product.curPrice.floatValue ];
        cell.bonusLabel.text = [NSString stringWithFormat:@"%.0f积分",[product.curPrice floatValue]*100];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_productArray.count==0)
    {
        return;
    }
    FNDetailVC * detailVC = [[FNDetailVC alloc]init];
    
    FNMainModelConfigOfProduct *product = _productArray[indexPath.row];

    detailVC.productId = product.relaId;
    
    detailVC.productName = product.title;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 5)*0.5, (kScreenWidth - 5)*0.5 +62);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (_clickBtnShow)
    {
        return CGSizeMake(kScreenWidth, 64);

    }else
    {
        return CGSizeMake(kScreenWidth, 1);
    }
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat kscale;
    if (IS_IPHONE_6)
    {
        kscale = 1;
        
    }else if (IS_IPHONE_6P)
    {
        kscale = (CGFloat)(414.0/375.0);
    }else
    {
        kscale = (CGFloat)(320.0/375.0);
    }
    return CGSizeMake(kScreenWidth, (178+135+120+247)*kscale +161+20+40);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _topBut.alpha = 1- (100 - offsetY)/100;
    
    if (offsetY < 0)
    {
        [_navigationBarView removeFromSuperview];
        [_collectionView addSubview:_navigationBarView];
    }
    else
    {
        [_navigationBarView removeFromSuperview];
        [self.view addSubview:_navigationBarView];
        _navigationBarView.alpha = YES;
    }
    if (offsetY > 169)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _navigationBarView.backgroundColor = [UIColor whiteColor];
            
            _scanLabel.textColor = MAIN_COLOR_BLACK_ALPHA;
            _scanImage.image = [UIImage imageNamed:@"main_scan_nav"];
            _bigImg.image = [UIImage imageNamed:@"main_big_nav"];
            _searchImg.image = [UIImage imageNamed:@"main_search_nav"];
            _searchLab.textColor = MAIN_COLOR_BLACK_ALPHA;
            _sepLab.hidden = NO;
            UIImage *msgImage = nil;
            if (_isMsg == YES)
            {
                msgImage = [UIImage imageNamed:@"main_nav_msg_new"];
            }
            else
            {
                msgImage = [UIImage imageNamed:@"main_msg_nav"];
            }
            _msgImg.image = msgImage;
            
            _msgLab.textColor = MAIN_COLOR_BLACK_ALPHA;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            _navigationBarView.backgroundColor = [UIColor clearColor];
            _scanLabel.textColor = MAIN_COLOR_WHITE;
            _searchLab.textColor = [UIColor whiteColor];
            _scanImage.image = [UIImage imageNamed:@"main_scan"];
            _bigImg.image = [UIImage imageNamed:@"main_big"];
            _searchImg.image = [UIImage imageNamed:@"main_search"];
            _searchImg.backgroundColor =[UIColor clearColor];
            _sepLab.hidden = YES;
            UIImage *msgImage = nil;
            if (_isMsg == YES)
            {
                msgImage = [UIImage imageNamed:@"main_msg_msg"];
            }
            else
            {
                msgImage = [UIImage imageNamed:@"main_msg"];
            }
            _msgImg.image = msgImage;
        
            _msgLab.textColor = MAIN_COLOR_WHITE;;

        }];
    }
}

- (void)goMessage
{
    
    if (![FNLoginBO isLogin])
    {
        return;
    }
    
    FNMessageCenterVC *vc = [[FNMessageCenterVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goScan
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
    {
        [UIAlertView alertViewWithMessage:@"您的相机功能好像有点问题哦～\n去\"设置>隐私>相机\"开启一下"];
    }
    else if(status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined)
    {
        FNScanVC *vc = [[FNScanVC alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goSearchVC
{
    FNSearchVC *searchVC = [[FNSearchVC alloc]init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
