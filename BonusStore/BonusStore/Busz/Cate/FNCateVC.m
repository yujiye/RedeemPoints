//
//  FNCateVC.m
//  BonusStore
//
//  Created by Nemo on 16/4/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCateVC.h"

#import "FNCateHotCell.h"

#import "FNCateHeadReusableView.h"

#import "FNCateBO.h"

#import "FNLoginBO.h"

#import "FNMainBO.h"

#import "FNDetailVC.h"

static CGFloat TableWidth     = 100;

static CGFloat TableHeight    = 48;

static CGFloat TableMargin    = 5;

static CGFloat HeadHeght      = 48;

@interface FNCateVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _page;
    
    MJRefreshAutoNormalFooter *footer;
    
    UIImageView *_imageV;
    
    UIImageView *_bgView;
    
    UILabel *_tipLabel;
    
    BOOL _isMsg;
    
    FNNoDataView *_noData;
}

@property (nonatomic, strong) FNCateParentModel * currentSelected;

@property (nonatomic, strong) UICollectionView * myCollectionView;

@property (nonatomic, strong) UITableView * myTableView;

@property (nonatomic, strong) NSMutableArray * dataSources;

@property (nonatomic, assign) BOOL isReturnLastOffset;

@property (nonatomic, assign) BOOL isKeepScrollState;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray * array;

@property (nonatomic, copy) NSString * pid;

@end

@implementation FNCateVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavMessageItem];
  
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        
        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0, 18,0 ,17)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"分类";
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.dataSources = [[NSMutableArray alloc]init];//右边
    
    self.array = [[NSMutableArray alloc]init];
    
    self.isReturnLastOffset = YES;
    
    self.isKeepScrollState = YES;
    
    _selectIndex = 0;
    
    _page = 1;
    
    [self myTableView];
    
    [self myCollectionView];
    
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(_myTableView.x + _myTableView.width, 0, kScreenWidth - _myTableView.width, kScreenHeight)];
    
    _bgView.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(_myTableView.x + _myTableView.width + (kScreenWidth - _bgView.x - 60) /2,kScreenHeight/2-15-72, 60, 72)];
    
    _imageV.image = [UIImage imageNamed:@"no_data_logo"];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(_myTableView.x + _myTableView.width, kScreenHeight/2-15,kScreenWidth - _myTableView.width , 30)];
    
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    
    _tipLabel.text = @"加载失败点击屏幕重试";
    
    _tipLabel.font = [UIFont systemFontOfSize:12];
    
    _tipLabel.textColor = UIColorWithRGB(52.0, 52.0, 52.0);
    
    footer.automaticallyRefresh = YES;
    
    [footer setTitle:@"加载更多....." forState:MJRefreshStateRefreshing];
    
    [footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];

    if (_selectIndex == 0)
    {
        self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            _page = 1;
            
            [self.myCollectionView.mj_header endRefreshing];
            
        }];
        
    }
    [self refresh];
}
- (void)refresh
{
    __weak __typeof(self) weakSelf = self;
    
    if (![_array count])
    {
        [_noData removeFromSuperview];
        [FNLoadingView showInView:self.view];
        
        [[FNCateBO port01] getCateListWithParentID:0 block:^(id result) {
            [FNLoadingView hideFromView:self.view];

            if ([result isKindOfClass:[NSArray class]])
            {
                [_array addObjectsFromArray:result];
                
                self.currentSelected = _array[0];
                
                self.selectIndex = 0;
                
                [self.myTableView reloadData];
                
                _myTableView.hidden = NO;
                _myCollectionView.hidden = NO;
                
                if (![_dataSources count])
                {
                    [FNLoadingView showInView:self.view];
                    [_noData removeFromSuperview];
                    
                    [[FNMainBO port01] getProductListWithPage:1 sort:FNSortTypeTimeDesc perCount:20 block:^(id result) {
                    
                        [self.myCollectionView.mj_header endRefreshing];
                        
                        if (![result isKindOfClass:[NSArray class]] || result == nil || [(NSArray *)result count] == 0)
                        {
                            if (!_noData)
                            {
                                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(_myTableView.x + _myTableView.width,0 , kWindowWidth-_myTableView.width, kWindowHeight)];
                            }
                            [_noData setTypeWithResult:result];

                            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                            
                            [_noData setActionBlock:^(id sender) {
                                [weakSelf refreshProductList];
                            }];
                            [self.view addSubview:_noData];
                            
                            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                            return;
                        }
                        
                        [FNLoadingView hideFromView:self.view];
                        
                        if (_page == 1)
                        {
                            [_dataSources removeAllObjects];
                        }
                        
                        self.myCollectionView.hidden = NO;
                        [_dataSources removeAllObjects];
                        [_dataSources addObjectsFromArray:result];
                        [self.myCollectionView reloadData];
                        
                        
                    }];
                }
            }
            else
            {
                _myTableView.hidden = YES;
                _myCollectionView.hidden = YES;
                
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
                }
                [_noData setTypeWithResult:result];

                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                
                [_noData setActionBlock:^(id sender) {
                    [weakSelf refresh];
                }];
                [self.view addSubview:_noData];
            }
            
        }];
    }
}

- (UITableView *)myTableView
{
    if (_myTableView == nil)
    {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TableWidth, kScreenHeight - 49-64) style:UITableViewStylePlain];
        
        _myTableView.showsVerticalScrollIndicator = NO;
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.tableFooterView = [[UIView alloc]init];
        
        [_myTableView registerClass:[FNLeftTableCell class] forCellReuseIdentifier:NSStringFromClass([FNLeftTableCell class])];
        
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (UICollectionView *)myCollectionView
{
    
    if (!_myCollectionView)
    {
        UICollectionViewFlowLayout * flowLayOut1 = [[UICollectionViewFlowLayout alloc]init];
        
        flowLayOut1.minimumInteritemSpacing = 5;
        
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TableWidth + TableMargin, 0, kWindowWidth - TableWidth - 10  , kScreenHeight - 49-64) collectionViewLayout:flowLayOut1];
        
        self.myCollectionView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        self.myCollectionView.showsHorizontalScrollIndicator = NO;
        
        self.myCollectionView.showsVerticalScrollIndicator = NO;
        
        [self.myCollectionView registerClass:[FNCateHotCell class] forCellWithReuseIdentifier:NSStringFromClass([FNCateHotCell class])];
        
        [self.myCollectionView registerClass:[FNRightCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FNRightCollectionCell class])];
        
        [self.myCollectionView registerClass:[FNCateHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        self.myCollectionView.dataSource=self;
        
        self.myCollectionView.delegate=self;
        [self.view addSubview:self.myCollectionView];
    }
    return _myCollectionView;
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNLeftTableCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FNLeftTableCell class]) forIndexPath:indexPath];
    
    cell.curLeftTagModel = _array[indexPath.section];
    
    cell.hasBeenSelected = (cell.curLeftTagModel == self.currentSelected);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TableHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectIndex = indexPath.section;
    
    [_dataSources removeAllObjects];
    
    [_myCollectionView reloadData];
    
    [_noData removeFromSuperview];
    
    if (indexPath.section == 0)
    {
        self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            _page = 1;
            
            [self.myCollectionView.mj_header endRefreshing];
            
        }];
    }
    else
    {
        self.myCollectionView.mj_header = nil;
    }

    FNCateParentModel * parentModel = _array[indexPath.section];
    
    _pid = parentModel.subjectId   ;

    if ([_pid integerValue] == 1000)
    {
        [self refreshProductList];

        self.currentSelected = [_array objectAtIndex:indexPath.section];
    }
    
    if ([_pid integerValue] != 1000 )
    {
        [self refreshProductList];
        
        self.currentSelected = [_array objectAtIndex:indexPath.section];
    }
    [self.myTableView reloadData];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    self.isReturnLastOffset = NO;
}

#pragma mark - collectionview

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_selectIndex == 0)
    {
        if (_dataSources.count > 20)
        {
            return 20;
        }
        else
        {
            return _dataSources.count;
        }
    }
    else
    {
        return _dataSources.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == 0)
    {
        self.myCollectionView.backgroundColor = MAIN_COLOR_WHITE;
        
        FNCateHotCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNCateHotCell class]) forIndexPath:indexPath];
        
        if (_dataSources.count != 0 && [_dataSources[indexPath.row] isKindOfClass:[FNProductArgs class]])
        {
            FNProductArgs *_product = _dataSources[indexPath.row];

            cell.integral.text = [NSString stringWithFormat:@"%.0f 积分",_product.curPrice.floatValue*100];
            
            [cell.hotImage sd_setImageWithURL:IMAGE_ID(_product.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
            
            cell.title.text = _product.productName;
            
            cell.backgroundColor = MAIN_COLOR_WHITE;

        }
        return cell;
    }
    self.myCollectionView.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    FNRightCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNRightCollectionCell class]) forIndexPath:indexPath];
    
    if (_dataSources.count != 0 && [_dataSources[indexPath.row] isKindOfClass:[FNHeadRightModel class]])
    {
        FNHeadRightModel *_secCategory = _dataSources[indexPath.row];
        
        [cell.nameImageView sd_setImageWithURL:IMAGE_ID(_secCategory.img_key) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
        
        cell.nameLabel.text = _secCategory.subjectName;
        
        cell.backgroundColor = MAIN_COLOR_WHITE;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        
        FNCateHeadReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        header.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        if (_selectIndex == 0)
        {
            
            header.titleLable.text = @"积分兑换排行榜";
            
            header.checkBtn.hidden = NO;
            header.checkAllBtn.hidden = YES;
            header.hotCheckBtn.hidden = NO;
             [header.hotCheckBtn setTitle:@"查看全部商品 >" forState:UIControlStateNormal];
        
            [header.hotCheckBtn addTarget:self action:@selector(goToMainAllVC:) forControlEvents:UIControlEventTouchUpInside];
            [header.checkBtn removeTarget:self action:@selector(checkAll) forControlEvents:UIControlEventTouchUpInside];
            reusableView = header;
        }
        else
        {
            header.titleLable.text = @"全部分类";
            header.checkAllBtn.hidden = NO;
            header.checkBtn.hidden = NO;
            header.hotCheckBtn.hidden = YES;
            [header.hotCheckBtn removeTarget:self action:@selector(goToMainAllVC:) forControlEvents:UIControlEventTouchUpInside];
            [header.checkBtn addTarget:self action:@selector(checkAll) forControlEvents:UIControlEventTouchUpInside];
            [header.checkAllBtn addTarget:self action:@selector(checkAll) forControlEvents:UIControlEventTouchUpInside];
            
             [header.checkAllBtn setTitle:@"查看全部商品 >" forState:UIControlStateNormal];
            
            reusableView = header;
        }
    }
    return reusableView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.myCollectionView.bounds.size.width, HeadHeght);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_selectIndex == 0)
    {
        return CGSizeMake(kScreenWidth - TableWidth - 10, 108);
    }
    else
    {
        return CGSizeMake((kScreenWidth - 20 - TableWidth)/3, (kScreenWidth - 20 - TableWidth)/3+25);
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNCateProductListVC *vc = [[FNCateProductListVC alloc]init];
    
    if (_selectIndex == 0 && [_dataSources[indexPath.row] isKindOfClass:[FNProductArgs class]])
    {
        FNProductArgs *_product = _dataSources[indexPath.row];

        FNDetailVC * vc = [[FNDetailVC alloc]init];
        
        vc.title = _product.productName;
        
        vc.productId = _product.productId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if ([_dataSources[indexPath.row] isKindOfClass:[FNHeadRightModel class]])
        {
            vc.secCategory = _dataSources[indexPath.row];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma  mark - 记录滑动的坐标(把右边滚动的的y值记录在一个属性中)
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.myCollectionView])
    {
        self.isReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.myCollectionView])
    {
        if (_array.count != 0)
        {
            FNCateParentModel * item = _array[self.selectIndex];
            item.offset = scrollView.contentOffset.y;
            self.isReturnLastOffset = NO;
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.myCollectionView])
    {
        if (_array.count != 0)
        {
            FNCateParentModel * item = _array[self.selectIndex];
            
            item.offset = scrollView.contentOffset.y;
            
            self.isReturnLastOffset=NO;
        }

    }
}

- (void)goMessage
{
    
    if (![FNLoginBO isLogin])
    {
        return;
    }
    
    [FNMessageNoti touchOff];
    
    FNMessageCenterVC *vc = [[FNMessageCenterVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.myCollectionView] && self.isReturnLastOffset)
    {
        if (_array.count !=0)
        {
            FNCateParentModel * item = _array[self.selectIndex];
            
            item.offset = scrollView.contentOffset.y;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - other

- (void)checkAll
{
    FNCateProductListVC *vc = [[FNCateProductListVC alloc]init];
    
    vc.secCategory = _array[_selectIndex];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshProductList
{
    [_dataSources removeAllObjects];
    [FNLoadingView showInView:self.view];
    [_noData removeFromSuperview];
    _noData = nil;      //两个小哭脸的大小不一样，上一个全屏的没有消除，现在需要显示半屏的，结果全盖上了
    __weak __typeof(self) weakSelf = self;
    
    if ([_pid integerValue] == 1000)
    {
        [FNLoadingView showInView:self.view];
        [_noData removeFromSuperview];
        _noData = nil;
        [[FNMainBO port01] getProductListWithPage:1 sort:FNSortTypeTimeDesc perCount:20 block:^(id result) {
            [FNLoadingView hideFromView:self.view];
            
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView.mj_header endRefreshing];
            
            self.myCollectionView.hidden = NO;
            
            if (![result isKindOfClass:[NSArray class]] || result == nil || [(NSArray *)result count] == 0)
            {
                self.myCollectionView.hidden = YES;
                
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(_myTableView.x + _myTableView.width,0 , kWindowWidth-_myTableView.width, kWindowHeight)];
                }
                [_noData setTypeWithResult:result];
                
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                
                [_noData setActionBlock:^(id sender) {
                    [weakSelf refreshProductList];
                }];
                [self.view addSubview:_noData];
                
                return ;
            }
            
            if (_selectIndex != 0)
            {
                return ;
            }
            if (!result)
            {
                return ;
            }
            [_dataSources removeAllObjects];
            
            [_dataSources addObjectsFromArray:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.myCollectionView reloadData];
            });
        }];

    }
    else
    {
    
        [[FNCateBO port01] getProductListWithCateID:[_pid  integerValue] page:0 block:^(id result) {
            [FNLoadingView hideFromView:self.view];
            
            self.myCollectionView.hidden = NO;

            if ([result[@"code"] integerValue] != 200 || result == nil)
            {
                self.myCollectionView.hidden = YES;
                
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(_myTableView.x + _myTableView.width,0 , kWindowWidth-_myTableView.width, kWindowHeight)];
                }
                [_noData setTypeWithResult:result];
                
                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                
                [_noData setActionBlock:^(id sender) {
                    [weakSelf refreshProductList];
                }];
                [self.view addSubview:_noData];
                
                return ;
            }
            
            [_noData removeFromSuperview];
            
            [_dataSources removeAllObjects];
            
            for (NSDictionary * dict in result[@"classList"])
            {
                [_dataSources addObject:[FNHeadRightModel makeEntityWithJSON:dict]];
            }
            
            if (_dataSources.count == 0 )
            {
                self.myCollectionView.hidden = YES;
                
                if (!_noData)
                {
                    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(_myTableView.x + _myTableView.width,0 , kWindowWidth-_myTableView.width, kWindowHeight)];
                }
                [_noData setTypeWithResult:result];

                _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                
                [_noData setActionBlock:^(id sender) {
                    [weakSelf refreshProductList];
                }];
                [self.view addSubview:_noData];
            }
            else
            {
                self.myCollectionView.hidden = NO;
                
                [self.myCollectionView reloadData];
            }
            
        }];
        
    }
}
- (void)goToMainAllVC:(UIButton *)sender
{
    FNMainAllProductVC *mainAllVC = [[FNMainAllProductVC alloc]init];
    [self.navigationController pushViewController:mainAllVC animated:YES];
}

@end
