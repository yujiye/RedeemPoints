//
//  FNSearchResultVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/27.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSearchResultVC.h"
#import "FNMainBO.h"
@interface FNSearchResultVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UILabel *_searchLab;
    FNSearchResultView *_resultView;
    UIButton *_topBut;
    NSInteger _page;
    BOOL _isUp;
    MJRefreshAutoNormalFooter *_footer;
    FNNoDataView *_noData;
    UIImageView *_searchImg;
    NSInteger _searchType;
    UIView *_navigationView;
    UIButton *_searchBtn;
    UIView *_backBtnView;
}

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *productArray;
@end

@implementation FNSearchResultVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    [self setNavigaitionBackItem];
    [self initSearchNavg];
    [self initCollectionView];
    _searchType = FNSearchSortTypeClickDesc;
    _productArray = [NSMutableArray array];
    _topBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 44, 44);
    
    [_topBut setBackgroundImage:[UIImage imageNamed:@"main_back_top"] forState:UIControlStateNormal];
    
    [_topBut addSuperView:self.view ActionBlock:^(id sender) {
        
        [_collectionView scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:YES];
        
    }];
    _page = 1;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _resultView.userInteractionEnabled = NO;
        _page = 1;
        
        [self getData];
        
    }];
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    
    _footer.automaticallyRefresh = YES;
    [_footer setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
    
    [_footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    
    _collectionView.mj_footer = _footer;
    
    _topBut.alpha = NO;
    
    [self getData];
    
    _isUp = YES;
}
- (void)getData
{
    __weak __typeof(self) weakSelf = self;

    [FNLoadingView showInView:self.view];
    _resultView.userInteractionEnabled = NO;
    [[FNMainBO port01] getSearchProductListWithPage:_page descType:_searchType perCount:20 keyword:self.searchStr block:^(id result) {
        [FNLoadingView hide];
        _resultView.userInteractionEnabled = YES;
        [_collectionView.mj_footer endRefreshing];
        
        [_collectionView.mj_header endRefreshing];
        
        [FNLoadingView hideFromView:self.view];
        _resultView.userInteractionEnabled = YES;
        if (![result isKindOfClass:[NSArray class]] || result == nil)
        {
            _collectionView.hidden = YES;
            _resultView.hidden = NO;
            if (!_noData)
            {
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0 ,_resultView.height +_resultView.y, kWindowWidth, kWindowHeight)];
            }
            
            [_noData setTypeWithResult:result];
            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            
            [_noData setActionBlock:^(id sender) {
                [weakSelf getData];
            }];
            [self.view addSubview:_noData];
            
            _collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
        
        if ([result isKindOfClass:[NSArray class]] )
        {
            if (_page == 1)
            {
                [_productArray removeAllObjects];
            }
            
            [FNLoadingView hideFromView:self.view];
            
            [_productArray addObjectsFromArray:result];
            
            if ([(NSArray *)result count] >= 10)
            {
                _page ++;
            }
            else
            {
                _collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            [_collectionView reloadData];

            if (_productArray.count == 0)
            {
                _collectionView.hidden = YES;
                _resultView.hidden = NO;
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0 ,_resultView.y+_resultView.height , kWindowWidth, kWindowHeight)];
                }
                
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                [_noData setTypeWithResult:result];
                
                [_noData setActionBlock:^(id sender) {
                    [weakSelf getData];
                }];
                [self.view addSubview:_noData];
                [_collectionView reloadData];

            }
            else
            {
                _collectionView.hidden = NO;
                [_collectionView reloadData];
            }
        }
    }];
}

- (void)initSearchNavg
{
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navigationView.backgroundColor = MAIN_COLOR_WHITE;
    [self.view addSubview:_navigationView];
    _backBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15+30, 64)];
    [_backBtnView addTarget:self action:@selector(goBack)];
    [_navigationView addSubview:_backBtnView];
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(15,30 , 10, 20);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_nor"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_backBtnView addSubview:_backBtn];
    
    _searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(60,25, kScreenWidth-120,33 )];
    _searchImg.backgroundColor = MAIN_BACKGROUND_COLOR;
    _searchImg.layer.masksToBounds = YES;
    _searchImg.layer.cornerRadius = 16;
    [_searchImg addTarget:self action:@selector(goSearchVC)];

    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(15,7 ,18 ,18 )];
    leftImg.image = [UIImage imageNamed:@"search_bg"];
    [_searchImg addSubview:leftImg];
    [self.view addSubview:_searchImg];
    
    _searchLab = [[UILabel alloc]initWithFrame:CGRectMake(35,5 , _searchImg.width - 35,23 )];
    _searchLab.font = [UIFont fzltWithSize:12];
    _searchLab.text = self.searchStr;
    [_searchImg addSubview:_searchLab];
    
    _searchBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(kScreenWidth - 10 - 40, _searchImg.y , 40, 30);
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = [UIFont fzltWithSize:18];
    [_navigationView addSubview:_searchBtn];
    [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:_searchBtn];
    
}

- (void)goSearchVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnAction:(UIButton *)sender
{
    _page = 1;
    [self getData];
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.minimumLineSpacing = 5.0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,_navigationView.y+_navigationView.height +46, kWindowWidth , kWindowHeight-NAVIGATION_BAR_HEIGHT) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[FNMainItemCell class] forCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = MAIN_BACKGROUND_COLOR;
    _collectionView.showsVerticalScrollIndicator = NO;
    _resultView = [[FNSearchResultView alloc]initWithFrame:CGRectMake(0, _navigationView.y+_navigationView.height+1, kScreenWidth, 44)];
    _resultView.backgroundColor = MAIN_COLOR_WHITE;
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.hotBtn addTarget:self action:@selector(hotBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_resultView.priceBtn addTarget:self action:@selector(priceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_resultView.updateBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resultView];
    [self.view addSubview:_collectionView];
}

- (void)hotBtnAction:(UIButton *)sender
{
    _collectionView.hidden = YES;
    _isUp = YES;
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.priceBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    [_resultView.updateBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    _resultView.priceImg.image = [UIImage imageNamed:@"price_default"];
    [_productArray removeAllObjects];
    _searchType = FNSearchSortTypeClickDesc;
    _page = 1;
    [self getData];
    
}

- (void)priceBtnAction:(UIButton *)sender
{
    _collectionView.hidden = YES;
    [_resultView.priceBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    [_resultView.updateBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    if (_isUp == YES)
    {
        _resultView.priceImg.image = [UIImage imageNamed:@"price_up"];
        [_productArray removeAllObjects];
        _searchType = FNSearchSortTypePriceAsc;
        _page = 1;
        [self getData];
    }
    else
    {
        _resultView.priceImg.image = [UIImage imageNamed:@"price_down"];
        [_productArray removeAllObjects];
        
        _searchType = FNSearchSortTypePriceDesc;
        _page = 1;
        [self getData];
    }
    _isUp = !_isUp;
}

- (void)updateBtnAction:(UIButton *)sender
{
    _collectionView.hidden = YES;
    _isUp = YES;
    _resultView.priceImg.image = [UIImage imageNamed:@"price_default"];
    [_resultView.updateBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.priceBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    _page = 1;
    _searchType = FNSearchSortTypeTimeDesc;
    [self getData];
}

#pragma mark - collectionView

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 5)*0.5, (kScreenWidth - 5)*0.5 +62);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
   return  _productArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNMainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class]) forIndexPath:indexPath];
    
    FNProductArgs *product = _productArray[indexPath.row];
    NSArray *imgArr = [NSArray array];
    if([product.imgUrl rangeOfString:@","].location !=NSNotFound)
    {
      imgArr = [product.imgUrl componentsSeparatedByString:@","];
    }
    else
    {
        imgArr  = @[product.imgUrl];

    }

    [cell.iconView sd_setImageWithURL:IMAGE_ID(imgArr.firstObject) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
    
    cell.titleLabel.text = product.productName;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[product.minCurPrice floatValue]];
    
    cell.bonusLabel.text = [NSString stringWithFormat:@"%.0f积分   ",[product.minCurPrice floatValue]*100];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNProductArgs *product = _productArray[indexPath.row];
    
    FNDetailVC *vc = [[FNDetailVC alloc] init];
    
    vc.productName = product.productName;
    
    vc.productId = product.productId;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _topBut.alpha = 1- (100 - offsetY)/100;
    
    if (offsetY > 46)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _resultView.hidden = YES;
            _collectionView.frame =CGRectMake(0, _navigationView.y+_navigationView.height+1, kWindowWidth , kWindowHeight-NAVIGATION_BAR_HEIGHT);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            _resultView.hidden = NO;
            _collectionView.frame =CGRectMake(0,_navigationView.y+_navigationView.height+ 46, kWindowWidth , kWindowHeight-NAVIGATION_BAR_HEIGHT);
        }];
    }
}

- (void)dealloc
{
}

- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
