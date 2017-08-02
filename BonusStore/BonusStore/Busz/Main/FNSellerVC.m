//
//  FNSellerVC.m
//  BonusStore
//
//  Created by sugarkawhi on 16/9/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSellerVC.h"
#import "FNHeader.h"
#import "FNMainBO.h"
@interface FNSellerVC ()<UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _page;
    UIButton *_topBut;
    FNNoDataView *_noData;
    FNSortType _sortType;
    FNSearchResultView *_resultView;
    BOOL _isUp;
}
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSources;

@property (nonatomic,strong)UICollectionView *collectionView;

@end


@implementation FNSellerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sortType = FNSortTypeClickDesc;
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.title = self.sellerName;
    _dataSources = [NSMutableArray array];
    [self setNavigaitionBackItem];
    [self setNavigaitionMoreItem];
    [self initCollectionView];
    
    _topBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 44, 44);
    
    [_topBut setBackgroundImage:[UIImage imageNamed:@"main_back_top"] forState:UIControlStateNormal];
    
    [_topBut addSuperView:self.view ActionBlock:^(id sender) {
        
        [_collectionView scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:YES];
        
    }];
    _page = 1;
    [self loadMore];
    _topBut.alpha = NO;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadMore];
    }];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    footer.automaticallyRefresh = YES;
    
    [footer setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
    
    _collectionView.mj_footer = footer;
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
    _isUp = YES;
}

- (void)loadMore
{
    __weak __typeof(self) weakSelf = self;
    [FNLoadingView showInView: self.view];
    [_noData removeFromSuperview];
    _resultView.userInteractionEnabled = NO;
    [[[FNMainBO port01]withOutUserInfo] getProductListWithPage:_page sort:_sortType sellerID:[self.sellerId integerValue] block:^(id result) {
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
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0 ,_resultView.y+_resultView.height , kWindowWidth, kWindowHeight)];
            }
            [_noData setTypeWithResult:result];
            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            
            [_noData setActionBlock:^(id sender) {
                [weakSelf loadMore];
            }];
            [self.view addSubview:_noData];
            
            _collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            return;
        }
        
        if ([result isKindOfClass:[NSArray class]] )
        {
            if (_page == 1)
            {
                [_dataSources removeAllObjects];
            }
            
            [FNLoadingView hideFromView:self.view];
        
            [_dataSources addObjectsFromArray:result];
            
            if ([(NSArray *)result count] >= 10)
            {
                _page ++;
            }
            else
            {
                _collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            
            if (_dataSources.count == 0)
            {
                self.tableView.hidden = YES;
                _resultView.hidden = NO;
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0 ,_resultView.y+_resultView.height , kWindowWidth, kWindowHeight)];
                }
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                [_noData setTypeWithResult:result];
                
                [_noData setActionBlock:^(id sender) {
                    [weakSelf loadMore];
                }];
                [self.view addSubview:_noData];
            }
            else
            {
                _collectionView.hidden = NO;
                [_collectionView reloadData];
            }
        }
    }];
    
}

- (void)initCollectionView
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.minimumLineSpacing = 5.0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 46, kWindowWidth , kWindowHeight-NAVIGATION_BAR_HEIGHT) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[FNMainItemCell class] forCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = MAIN_BACKGROUND_COLOR;
    _collectionView.showsVerticalScrollIndicator =NO;
    _resultView = [[FNSearchResultView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _resultView.backgroundColor = MAIN_COLOR_WHITE;
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.hotBtn addTarget:self action:@selector(hotBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_resultView.priceBtn addTarget:self action:@selector(priceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_resultView.updateBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_collectionView];
    [self.view addSubview:_resultView];
}
- (void)hotBtnAction:(UIButton *)sender
{
    [_dataSources removeAllObjects];
    _collectionView.hidden = YES;
    _isUp = YES;
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.priceBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    [_resultView.updateBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    _resultView.priceImg.image = [UIImage imageNamed:@"price_default"];
    _sortType = FNSortTypeClickDesc;
    _page = 1;
    [self loadMore];
    
}

- (void)priceBtnAction:(UIButton *)sender
{
    [_dataSources removeAllObjects];
    _collectionView.hidden = YES;
    [_resultView.priceBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    [_resultView.updateBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    if (_isUp == YES)
    {
        _resultView.priceImg.image = [UIImage imageNamed:@"price_up"];
        _sortType = FNSortTypePriceAsc;
        _page = 1;
        [self loadMore];
    }
    else
    {
        _resultView.priceImg.image = [UIImage imageNamed:@"price_down"];
        [_dataSources removeAllObjects];
        _sortType = FNSortTypePriceDesc;
        _page = 1;
        [self loadMore];
    }
    _isUp = !_isUp;
}

- (void)updateBtnAction:(UIButton *)sender
{
    [_dataSources removeAllObjects];
    _collectionView.hidden = YES;
    _isUp = YES;
    _resultView.priceImg.image = [UIImage imageNamed:@"price_default"];
    [_resultView.updateBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_resultView.priceBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    [_resultView.hotBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    _page = 1;
    _sortType = FNSortTypeTimeDesc;
    [self loadMore];
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
    return  _dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNMainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class]) forIndexPath:indexPath];
        
    FNProductArgs *product = _dataSources[indexPath.row];
    
    [cell.iconView sd_setImageWithURL:IMAGE_ID(product.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
    
    cell.titleLabel.text = product.productName;
    
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",product.curPrice.floatValue];
    
    cell.bonusLabel.text = [NSString stringWithFormat:@"%.0f积分   ",[product.curPrice floatValue] * 100];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNProductArgs *product = _dataSources[indexPath.row];
    
    FNDetailVC *vc = [[FNDetailVC alloc] init];
    
    vc.productName = product.productName;
    
    vc.productId = product.productId;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    _topBut.alpha = 1- (100 - offsetY)/100;
    if (offsetY > 46)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _resultView.hidden = YES;
            _collectionView.frame =CGRectMake(0, 0, kWindowWidth , kWindowHeight-NAVIGATION_BAR_HEIGHT);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            _resultView.hidden = NO;
            _collectionView.frame =CGRectMake(0, 46, kWindowWidth , kWindowHeight-NAVIGATION_BAR_HEIGHT);
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
