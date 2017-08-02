//
//  FNCartVC.m
//  BonusStore
//  Created by Nemo on 16/4/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCartVC.h"
#import "FNHeader.h"
#import "UIView+Toast.h"
#import "FNCartBO.h"
#import "FNMyBO.h"
#import "FNAddressModel.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "FNMainBO.h"
#import "FNVirfulOrderVC.h"
#import "FNDetailVC.h"
#import "FNConfirmGetGoodsVC.h"

static CGFloat kMarginTopX = 10;
static CGFloat kSelecteWidth = 16;

@interface FNCartVC() <UITableViewDelegate,UITableViewDataSource,FNShoppingCartCellDelegate,FNShoppingCartViewDelegate,UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,FNTextFieldDelegate,UITextFieldDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate>
{
    CGFloat  _allPrice;
    NSInteger _allScore;
    NSInteger _allNumber;
    BOOL _isHideTabBar;
    NSIndexPath *_deleteIndexpath;
    UIButton *_topBut;
    BOOL _isEditing; // 是否正在编辑产品数量
    FNNoDataView *_noData;
    FNProductArgs *_product;
    
}

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cartShoppingData;// 购物车数据
@property (nonatomic, strong) NSMutableArray *collectionData;
@property (nonatomic, strong) NSIndexPath *currentEditCellIndexPath;// 当前被编辑的cell
@property (nonatomic, strong) UIButton *allSelecteBtn;//全选按钮
@property (nonatomic, weak) UILabel *numLab;// 总价格
@property (nonatomic, weak) UILabel *scoreLab;// 总积分
@property (nonatomic, weak) UILabel * goToPayLabel;// 去结算
@property (nonatomic, strong) FNShoppingCartView *shoppingCartView;// 记录
@property (nonatomic, weak) UIView *settleView;
@property (nonatomic, weak) UIImageView * selectImage;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, assign) BOOL btnSelected;
@property (nonatomic,weak) UIView *needView;

@end

@implementation FNCartVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavMessageItem];
    
    self.navigationController.tabBarController.tabBar.hidden = _isHideTabBar;
    
    [self refreshData];
}

-(void)refreshData
{
    [FNLoadingView showInView:self.view];
    [self.cartShoppingData removeAllObjects];
    [self.tableView reloadData];
    [self.collectionData removeAllObjects];
    [self.collectionView reloadData];
    self.tableView.hidden = YES;
    self.settleView.hidden = YES;
    self.collectionView.hidden = YES;
    self.needView.hidden = YES;
    [_noData removeFromSuperview];
    __weak __typeof(self) weakSelf = self;
    
    [[FNCartBO port02] getCartListWithBlock:^(id result) {
        if([result[@"code"] integerValue] != 200 || result == nil)
        {
            [FNLoadingView hideFromView:self.view];
            
            if (!_noData)
            {
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth ,kScreenHeight)];
            }
            _noData.hidden = NO;
            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            [_noData setTypeWithResult:result];
            
            [_noData setActionBlock:^(id sender) {
                
                [weakSelf refreshData];
            }];
            [self.view addSubview:_noData];
            return ;
        }
        
        _noData.hidden = YES;
        [_noData removeFromSuperview];
        
        [self.cartShoppingData removeAllObjects];
        
        for ( NSDictionary * dict in result[@"cartList"] )
        {
            [ self.cartShoppingData  addObject:[FNCartGroupModel mj_objectWithKeyValues:dict ]];
        }
        for(FNCartGroupModel * model in self.cartShoppingData)
        {
            for (FNCartItemModel * cart in model.productList) {
                cart.isSelecte = NO;
            }
        }
        if(self.cartShoppingData.count > 0)
        {
            [FNLoadingView hideFromView:self.view];
            _topBut.hidden = YES;
            self.tableView.hidden = NO;
            self.settleView.hidden = NO;
            self.collectionView.hidden = YES;
            self.needView.hidden = YES;
            self.btnSelected = NO;
            [self totalPriceWithBool:YES];
            [[FNCartBO port02]getCartCountWithBlock:nil];
            [self.tableView reloadData];
            
        }
        else
        {
            _topBut.hidden = NO;
            self.collectionView.hidden = YES;
            [[FNMainBO port01]getProductListWithPage: 1 sort:FNSortTypeClickDesc block:^(id result) {
                [FNLoadingView hideFromView:self.view];
                [self.navigationController.tabBarController.viewControllers[2] tabBarItem].badgeValue = nil;
                self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                if (![result isKindOfClass:[NSArray class]] || result == nil)
                {
                    if (!_noData)
                    {
                        _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth ,kScreenHeight)];
                    }
                    _noData.hidden = NO;
                    _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                    [_noData setTypeWithResult:result];
                    
                    [_noData setActionBlock:^(id sender) {
                        
                        [weakSelf refreshData];
                    }];
                    [self.view addSubview:_noData];
                    return;
                }
                
                self.collectionData = (NSMutableArray *)result;
                self.needView.hidden = NO;
                self.tableView.hidden = YES;
                self.settleView.hidden = YES;
                self.collectionView.hidden = NO;
                [self.collectionView reloadData];
            }];
            
        }
        
    }];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (self.isComeFromCartImage) {
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-64-56);
        self.settleView.frame = CGRectMake(0, kScreenHeight-64-56, kScreenWidth, 56);
        self.collectionView.frame = CGRectMake(0,0 ,kScreenWidth , kScreenHeight-64-44+48);
        _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-56, 44, 44);
        
        
    }else{
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-64 -48-56);
        self.settleView.frame = CGRectMake(0, kScreenHeight-64-48-56, kScreenWidth, 56);
        self.collectionView.frame = CGRectMake(0,0 ,kScreenWidth , kScreenHeight-64-44);
        _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 44, 44);
        
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self showCartShopping];
    [self showCartNoShopping];
    self.title = @"购物车";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.cartShoppingData = [NSMutableArray array];
    self.collectionData = [NSMutableArray array];
}

- (void)showCartShopping
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64 -48-56) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * footView  = [self creatFootView];
    self.settleView = footView;
    self.settleView.hidden = YES;
    footView.backgroundColor = [UIColor whiteColor];
    footView.frame = CGRectMake(0, kScreenHeight-64-48-56, kScreenWidth, 56);
    [self.view addSubview:footView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
    
}

- (void) showCartNoShopping
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setHeaderReferenceSize:CGSizeMake(kScreenWidth, 330)];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0 ,kScreenWidth , kScreenHeight-64-44) collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    self.collectionView.hidden = YES;
    [self.collectionView registerClass:[FNMainItemCell class] forCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class])];
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.minimumLineSpacing = 5.0;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:nil];
    // 禁止自动加载
    footer.automaticallyRefresh = YES;
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    // 设置footer
    self.collectionView.mj_footer = footer;
    self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
    
    FNShoppingCartView *shoppingCartView = [[FNShoppingCartView alloc] init];
    self.shoppingCartView = shoppingCartView;
    self.shoppingCartView.delegate = self;
    UIView *needView = [shoppingCartView viewWithNoShopping];
    self.needView = needView;
    self.needView.hidden = YES;
    needView.frame = CGRectMake(0,0, kScreenWidth, 330) ;
    [self.collectionView addSubview: needView];
    [self.view addSubview:collectionView];
    self.collectionView.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.collectionView.showsVerticalScrollIndicator = NO;
    _topBut = [UIButton buttonWithType:UIButtonTypeCustom];
    __weak __typeof(self) weakSelf = self;
    _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 44, 44);
    _topBut.hidden = NO;
    [_topBut setBackgroundImage:[UIImage imageNamed:@"main_back_top"] forState:UIControlStateNormal];
    [_topBut addSuperView:self.view ActionBlock:^(id sender) {
        
        [weakSelf.collectionView scrollRectToVisible:CGRectMake(1, 1, 1, 1) animated:YES];
    }];
    
    _topBut.alpha = NO;
}



- (void)hideTabBar
{
    _isHideTabBar = YES;
}

- (void)setBtnSelected:(BOOL)btnSelected
{
    _btnSelected = btnSelected;
    if(btnSelected ==YES)
    {
        [self.selectImage setImage:[UIImage imageNamed:@"cart_choose_press"]];
    }else
    {
        [self.selectImage setImage:[UIImage imageNamed:@"cart_choose_normal"]];
        
    }
}
// 添加购物车的通知事件
- (void)addCartProduct:(NSNotification *)noti
{
    FNCartGroupModel * cartGroupModel = noti.userInfo[@"addressIsDefault"];
    FNCartItemModel * cartItem = cartGroupModel.productList.firstObject;
    FNCartGroupModel * model = nil;
    for(FNCartGroupModel * cartGroup in self.cartShoppingData)
    {
        if(cartGroupModel.sellerId == cartGroup.sellerId)
        {
            model = cartGroup;
        }
    }
    if(model != nil)
    {
        [model.productList addObject:cartItem];
        
    }else
    {
        [self.cartShoppingData addObject:cartGroupModel];
    }
    
    
    [[FNCartBO  port02] getCartCountWithBlock:nil];
    [self.tableView reloadData];
    
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
    return self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNMainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNMainItemCell class]) forIndexPath:indexPath];
    
    
    if (self.collectionData.count != 0)
    {
        _product = self.collectionData[indexPath.row];
        
        [cell.iconView sd_setImageWithURL:IMAGE_ID(_product.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
        
        cell.titleLabel.text = _product.productName;
        
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",_product.curPrice.floatValue];
        
        cell.bonusLabel.text = [NSString stringWithFormat:@"%.0f积分   ",[_product.curPrice floatValue] * 100];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionData.count == 0)
    {
        return;
    }
    FNProductArgs *product = self.collectionData[indexPath.row];
    
    FNDetailVC *vc = [[FNDetailVC alloc] init];
    
    vc.productName = product.productName;
    
    vc.productId = product.productId;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma  mark - tableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cartShoppingData.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FNCartGroupModel *shoppingCart = self.cartShoppingData[section];
    
    return shoppingCart.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FNCartGroupModel *shoppingCart = self.cartShoppingData[indexPath.section];
    FNCartItemModel  *cartItemDetail = shoppingCart.productList[indexPath.row];
    FNShoppingCartCell *cell = [FNShoppingCartCell shoppingCartCellWithTableView:tableView];
    cell.cartItem = cartItemDetail;
    cell.cellIndexPath = indexPath;
    cell.delegate = self;
    cell.numberField.textFieldDelegate = self;
    cell.numberField.delegate = self;
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FNShoppingCartView *shoppingCartView = [FNShoppingCartView groupHeaderViewWithTableView:tableView];
    shoppingCartView.delegate = self;
    shoppingCartView.cartGroup = self.cartShoppingData[section];
    return shoppingCartView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 59;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}


#pragma  mark - tableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _deleteIndexpath = indexPath;
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"是否从购物车删除该商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if(buttonIndex ==1)
    {
        FNCartGroupModel * shopCart = self.cartShoppingData[_deleteIndexpath.section];
        FNCartItemModel * itemModel = shopCart.productList[_deleteIndexpath.row];
        [FNLoadingView showInView:self.view];
        [[FNCartBO port02] delCartWithProduct:itemModel block:^(id result) {
            if ([result[@"code"] integerValue] == 200)
            {
                if(self.cartShoppingData.count == 1 && shopCart.productList.count== 1)
                {
                    [self.cartShoppingData removeAllObjects];
                    [FNLoadingView showInView:self.view];
                    self.collectionView.hidden = YES;
                    [[FNMainBO port01]getProductListWithPage: 1 sort:FNSortTypeClickDesc block:^(id result) {
                        [FNLoadingView hideFromView:self.view];
                        [self.collectionData addObjectsFromArray:result];
                        [self.navigationController.tabBarController.viewControllers[2] tabBarItem].badgeValue = nil;
                        if (![result isKindOfClass:[NSArray class]] || result == nil)
                        {
                            if (!_noData)
                            {
                                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth ,kScreenHeight)];
                            }
                            _noData.hidden = NO;
                            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
                            [_noData setTypeWithResult:result];
                            
                            [_noData setActionBlock:^(id sender) {
                                
                                [self refreshData];
                            }];
                            [self.view addSubview:_noData];
                            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
                            return;
                        }
                        
                        self.collectionView.hidden = NO;
                        _topBut.hidden = NO;
                        self.needView.hidden = NO;
                        self.tableView.hidden = YES;
                        self.settleView.hidden = YES;
                        [self.collectionView reloadData];
                    }];
                    
                }else
                {
                    if(shopCart.productList.count == 1)
                    {
                        [self.cartShoppingData removeObject:shopCart];
                        
                    }else
                    {
                        [shopCart.productList removeObject:itemModel];
                    }
                    
                    [[FNCartBO port02] getCartCountWithBlock:nil];
                    [self totalPriceWithBool:YES];
                    [self.tableView reloadData];
                }
                
            }else
            {
                [self.view makeToast:@"删除商品失败"];
            }
        }];
        
    }
    
}


#pragma mark -textdeild代理 获得键盘显示与隐藏并让当前的cell滚动到键盘上边

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    FNShoppingCartCell *cell = (FNShoppingCartCell *)[[[textField superview] superview] superview];
    
    self.currentEditCellIndexPath  = [self.tableView indexPathForCell:cell];
    
}

- (void)keyBoardWillShow:(NSNotification *)notoINfo
{
    NSDictionary *dict = notoINfo.userInfo;
    CGRect keyBoardFram = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyBoardFram.size.height - 64);
    [self.tableView scrollToRowAtIndexPath:self.currentEditCellIndexPath
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (void)keyBoardWillHide:(NSNotification*)notoINfo
{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44 -56);
    [self.tableView scrollToRowAtIndexPath:self.currentEditCellIndexPath
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
- (void)keyBoardDidShow:(NSNotification *)notoINfo
{
    _isEditing = YES;
}

-(void)keyBoardDidHide:(NSNotification *)notoINfo
{
   _isEditing = NO;
    
}


/**
 *  键盘完成或者取消点击的代理事件
 *
 *  @param textField 当点点击的textField
 *  @param flag   flag=0 取消 flag=1 完成
 */
- (void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    
    FNShoppingCartCell *cell = (FNShoppingCartCell *)[[[textField superview]superview]superview];
    if (flag)
    {
        [textField endEditing:YES];
        
        if ([textField.text integerValue] == 0 || [NSString isEmptyString:textField.text])
        {
            cell.cartItem.count = 1;
            [self.view makeToast:@"请输入正确的购买数量"];
            
        }else
        {
            
            cell.cartItem.count = [textField.text intValue];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.frame = CGRectMake(SCREEN_WIDTH *0.5-37, SCREEN_HEIGHT*0.5-37, 37, 37);
            hud.color = [UIColor whiteColor];
            hud.activityIndicatorColor = [UIColor blackColor];
            if (cell.cartItem.skuCount > cell.cartItem.count)
            {
                [FNCartBO  updateCartWithProduct:cell.cartItem count:cell.cartItem.count block:^(id result)
                 {
                     [hud removeFromSuperview];
                     
                     if ([result[@"code"] integerValue] !=200)
                     {
                         if(result)
                         {
                             [self.view makeToast:result[@"desc"]];
                         }else
                         {
                             [self.view makeToast:@"加载失败,请重试"];
                         }
                         return ;
                     }
                     if([result[@"code"] integerValue] == 200)
                     {
                         
                         [[FNCartBO port02]getCartCountWithBlock:nil];
                     }
                     
                 }];
            }else
            {
                cell.cartItem.count = cell.cartItem.skuCount;
                cell.numberField.text = [NSString stringWithFormat:@"%zd",cell.cartItem.count];
                [FNCartBO  updateCartWithProduct:cell.cartItem count:cell.cartItem.count block:^(id result) {
                    [hud removeFromSuperview];
                    
                    if ([result[@"code"] integerValue] !=200)
                    {
                        if(result)
                        {
                            [self.view makeToast:result[@"desc"]];
                        }else
                        {
                            [self.view makeToast:@"加载失败,请重试"];
                        }
                        
                        return ;
                    }
                    if([result[@"code"] integerValue] == 200)
                    {
                        
                        [[FNCartBO port02]getCartCountWithBlock:nil];
                        [self.tableView reloadData];
                        
                    }
                    
                }];
                
            }
            [self.tableView reloadData];
            
        }
    }
    else
    {
        cell.numberField.text = [NSString stringWithFormat:@"%zd", cell.cartItem.count];
        [textField  endEditing:YES];
        
    }
    
    [self totalPriceWithBool:YES];
    [self.tableView reloadData];
    
}

#pragma mark - FNShoppingCartCellDelegate加减号代理方法的实现

/**
 *  每种商品数量加减号的代理事件
 *
 *  @param cell 当前的点击cell
 *  @param flag 加减号的标识
 */
- (void)shoppingCartCellBtnClick:(FNShoppingCartCell *)cell flag:(NSInteger)flag
{
    NSIndexPath *index  = [self.tableView indexPathForCell:cell];
    FNCartGroupModel *shoppingCart = self.cartShoppingData[index.section];
    FNCartItemModel  *cartItemDetail = shoppingCart.productList[index.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(SCREEN_WIDTH*0.5-37, SCREEN_HEIGHT*0.5-37, 37, 37);
    hud.color = [UIColor whiteColor];
    hud.activityIndicatorColor = [UIColor blackColor];
    switch (flag) {
        case kNumberBtnTypeMinus:
        {
            if(cartItemDetail.count > 1)
            {
                cartItemDetail.count = cartItemDetail.count - 1;
            }else
            {
                [hud removeFromSuperview];
            }
            int curSkuCount =  cartItemDetail.skuCount;
            
            if (cartItemDetail.count > curSkuCount)
            {
                cartItemDetail.count = curSkuCount;
            }

            [FNCartBO updateCartWithProduct:cartItemDetail count:cartItemDetail.count block:^(id result)
             {
                 [hud removeFromSuperview];
                 
                 if ([result[@"code"] integerValue] !=200)
                 {
                     if(result)
                     {
                         [self.view makeToast:result[@"desc"]];
                     }else
                     {
                         [self.view makeToast:@"加载失败,请重试"];
                     }
                     
                     return ;
                 }
                 if([result[@"code"] integerValue] == 200)
                 {
                     [self totalPriceWithBool:YES];
                     
                     [[FNCartBO port02]getCartCountWithBlock:nil];
                 }
                 
             }];
            
        }
            break;
        case kNumberBtnTypeAdd:
        {
            
            if(cartItemDetail.count < 99)
            {
                if (cartItemDetail.skuCount > cartItemDetail.count)
                {
                    cartItemDetail.count = cartItemDetail.count + 1;
                    
                    [FNCartBO updateCartWithProduct:cartItemDetail  count:cartItemDetail.count block:^(id result) {
                        [hud removeFromSuperview];
                    
                        if ([result[@"code"] integerValue] !=200)
                        {
                            if(result)
                            {
                                [self.view makeToast:result[@"desc"]];
                            }else
                            {
                                [self.view makeToast:@"加载失败,请重试"];
                            }
                            return ;
                        }
                        if([result[@"code"] integerValue] == 200)
                        {
                            [self totalPriceWithBool:YES];

                            [[FNCartBO port02]getCartCountWithBlock:nil];
                        }
                        
                    }];
                }else
                {
                    cartItemDetail.count = cartItemDetail.skuCount;
                    
                    [self.view makeToast: [NSString stringWithFormat:@"库存仅剩%d件",cartItemDetail.skuCount]];
                    [FNCartBO updateCartWithProduct:cartItemDetail  count:cartItemDetail.count block:^(id result) {
                        [hud removeFromSuperview];
                        
                        
                        if ([result[@"code"] integerValue] !=200)
                        {
                            if(result)
                            {
                                [self.view makeToast:result[@"desc"]];
                            }else
                            {
                                [self.view makeToast:@"加载失败,请重试"];
                            }
                            return ;
                        }
                        if([result[@"code"] integerValue] == 200)
                        {
                            
                            [self totalPriceWithBool:YES];
                            [[FNCartBO port02]getCartCountWithBlock:nil];
                        }
                        
                    }];
                }
            }else{
                [hud removeFromSuperview];

                [self.view makeToast:@"最多只能购买99件喔"];
                
            }
            
        }
            break;
        default:
            break;
    }
    
    
    [self.tableView reloadData];
}

/**
 *  商家选择按钮点击的代理事件
 *
 *  @param headerView 点击的是哪一个商家的view
 */
- (void)groupHeaderViewDidTouched:(FNShoppingCartView *)headerView
{
    FNCartGroupModel * shoppingCart = headerView.cartGroup;
    FNCartGroupModel * needShoppingCar = nil ;
    for(FNCartGroupModel * sh in self.cartShoppingData)
    {
        if(shoppingCart.sellerId == sh.sellerId)
        {
            needShoppingCar = sh;
        }
    }
    if (needShoppingCar.selecteStatus ==  kSelecteBtnNoSelect)
    {
        for(FNCartItemModel *detail in needShoppingCar.productList)
        {
            detail.isSelecte = NO;
        }
        self.btnSelected = NO;
        
    }else if(needShoppingCar.selecteStatus ==  kSelecteBtnAllSelect)
    {
        for(FNCartItemModel *detail in needShoppingCar.productList)
        {
            detail.isSelecte = YES;
        }
    }
    NSMutableArray * tempArr = [NSMutableArray array];
    for (FNCartGroupModel * model in self.cartShoppingData)
    {
        if(model.selecteStatus == kSelecteBtnAllSelect)
        {
            [tempArr addObject:model];
        }
    }
    if(tempArr.count == self.cartShoppingData.count)
    {
        self.btnSelected = YES;
    }
    [self totalPriceWithBool:YES];
    
    [self.tableView reloadData];
}

/**
 *  商家整个头的点击的代理事件
 *
 *  @param shoppingCartView 点击的是哪一种商品的view
 */
- (void)goToMerchantListControllerClick:(FNShoppingCartView *)shoppingCartView
{
    NSLog(@"跳转到商家列表");
 
    FNSellerVC * sellerVC = [[FNSellerVC alloc]init];
    sellerVC.sellerId =  [NSString stringWithFormat:@"%d",shoppingCartView.cartGroup.sellerId];
    sellerVC.sellerName = shoppingCartView.cartGroup.sellerName;
    [self.navigationController pushViewController:sellerVC animated:YES];

    
}

/**
 *  每种商品选择按钮点击的代理事件
 *
 *  @param shoppingCartCell 点击的是哪一种商品的view
 */
- (void)shoppingCartCellTouched:(FNShoppingCartCell *)shoppingCartCell
{
    FNCartItemModel  *cartItemDetail = shoppingCartCell.cartItem;
    FNCartGroupModel *shopcart = nil ;
    for (FNCartGroupModel *shop in self.cartShoppingData)
    {
        for (FNCartItemModel *cartItemDetail1 in shop.productList)
        {
            if([cartItemDetail1.productId isEqual:cartItemDetail.productId]&& cartItemDetail1.sku.skuNum == cartItemDetail.sku.skuNum )
            {
                shopcart = shop;
            }
        }
    }
    NSMutableArray * arrM = [NSMutableArray array];
    for (FNCartItemModel *cartItemDetail2 in shopcart.productList)
    {
        BOOL selecte  = cartItemDetail2.isSelecte;
        
        [arrM addObject:[NSNumber numberWithBool:selecte]];
    }
    // 判断该商家下商品的选择状态来判断该商家的选择状态
    NSInteger num = 0;
    if(arrM.count ==1)
    {
        num = 0;
    }else
    {
        for(int i = 0; i< arrM.count -1 ; i++)
        {
            if (arrM[i] == arrM[i+1])
            {
                num += 1;
            }
        }
    }
    
    if(num == arrM.count -1)
    {
        if(cartItemDetail.isSelecte == YES)
        {
            shopcart.selecteStatus = kSelecteBtnAllSelect;
        }else
        {
            shopcart.selecteStatus = kSelecteBtnNoSelect;
            self.btnSelected = NO;
        }
        
    }else
    {
        shopcart.selecteStatus = kSelecteBtnHalfSelect;
        self.btnSelected = NO;
        
    }
    NSMutableArray * tempArr =[NSMutableArray array];
    for (FNCartGroupModel * model in self.cartShoppingData)
    {
        if(model.selecteStatus == kSelecteBtnAllSelect)
        {
            [tempArr addObject:model];
        }
    }
    if(tempArr.count == self.cartShoppingData.count)
    {
        self.btnSelected = YES;
    }
    [self totalPriceWithBool:YES];
    [self.tableView reloadData];
}


/**
 *  全选按钮的点击事件
 *
 *  @param sender  全选按钮的选择状态
 */
- (void)allSelectBtnClick:(UIButton *)sender
{
    self.btnSelected = !self.btnSelected;
    if (self.btnSelected == YES)
    {
        for(FNCartGroupModel * sh in self.cartShoppingData)
        {
            sh.selecteStatus = kSelecteBtnAllSelect;
            for(FNCartItemModel *detail in sh.productList)
            {
                detail.isSelecte = self.btnSelected;
            }
        }
        [self totalPriceWithBool:YES];
        
    }else{
        for(FNCartGroupModel * sh in self.cartShoppingData)
        {
            sh.selecteStatus = kSelecteBtnNoSelect;
            for(FNCartItemModel *detail in sh.productList)
            {
                detail.isSelecte = self.btnSelected;
            }
        }
        [self totalPriceWithBool:YES];
        
    }
    [self.tableView reloadData];
}


/**
 *  textField  数量值的改变事件
 *
 *  @param cell  当前textField 所在cell
 *  @param    textField
 */
- (void)shoppingCartCell:(FNShoppingCartCell *)cell numberChangeWithTextField:(UITextField*)textField
{
    
    if ([textField.text integerValue] < 0) {
        cell.numberField.text = @"1";
        
    }else if([textField.text integerValue]>99)
    {
        [self.view makeToast:@"最多能购买99件"];
        cell.numberField.text = @"99";
    }
    
}


#pragma mark - 去逛逛代理方法的实现 跳转到首页

- (void)goToHomeViewControllerClick:(FNShoppingCartView *)headerView
{
    
    [self goMain];
}

#pragma mark -- 计算价格和个数和积分

- (void)refreshPriceAndGoodNumber
{
    _allScore = 0;
    _allNumber = 0;
    _allPrice = 0;
    if (self.cartShoppingData == nil )
    {
        return;
    }
    for(FNCartGroupModel * sh in self.cartShoppingData)
    {
        if(sh.productList == nil)
        {
            return;
        }
        
        for(FNCartItemModel *detail in sh.productList)
        {
            if (detail.isSelecte)
            {
                _allScore += [[NSDecimalNumber decimalWithString:detail.cartPrice] multiplyingBy:100].floatValue * detail.count;
                _allNumber += detail.count;
                _allPrice += [[NSDecimalNumber decimalWithString:detail.cartPrice] floatValue] * detail.count;
            }
        }
    }
}

-(void)totalPriceWithBool:(BOOL)isSelecte
{
    [self refreshPriceAndGoodNumber];
    if (isSelecte)
    {
        self.numLab.text = [NSString stringWithFormat:@"商品金额:¥%.2lf    ",_allPrice];
        NSMutableAttributedString *needStr = [self.numLab.text makeStr:[NSString stringWithFormat:@"¥%.2lf",_allPrice] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
        self.numLab.attributedText = needStr;
        CGSize numLabSize = [self.numLab.attributedText.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        CGFloat numLabX = CGRectGetMaxX(self.detailLabel.frame)+8 ;
        self.numLab.frame = CGRectMake(numLabX, 8, kScreenWidth - 114 - numLabX-10, numLabSize.height);
        
        self.scoreLab.text = [NSString stringWithFormat:@"总积分:%zd",_allScore];
        NSMutableAttributedString *needStr1 = [self.scoreLab.text makeStr:[NSString stringWithFormat:@"%zd积分",_allScore] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
        
        self.scoreLab.attributedText = needStr1;
        CGSize scoreSize = [self.scoreLab.attributedText.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.scoreLab.frame = CGRectMake(numLabX, 56- scoreSize.height -8, kScreenWidth - 114 - numLabX-10, scoreSize.height);
        self.goToPayLabel.text = [NSString stringWithFormat:@"去结算 (%zd)",_allNumber];
    }
}
/**
 *  去填写订单按钮的点击事件
 */
-(void)goToWriteOrder
{
    NSMutableArray * arr = [NSMutableArray array];
    
    for (FNCartGroupModel * cartGroup in self.cartShoppingData)
    {
        if(cartGroup.selecteStatus ==kSelecteBtnHalfSelect ||cartGroup.selecteStatus ==kSelecteBtnAllSelect )
        {
            FNCartGroupModel *tempGroup = [[FNCartGroupModel alloc]init];
            tempGroup.sellerId = cartGroup.sellerId;
            tempGroup.sellerName = cartGroup.sellerName;
            tempGroup.remark = cartGroup.remark;
            tempGroup.selecteStatus = cartGroup.selecteStatus;
            NSMutableArray * arrM = [NSMutableArray array];
            for(FNCartItemModel *cartItem in cartGroup.productList)
            {
                if(cartItem.isSelecte == YES)
                {
                    [arrM addObject:cartItem];
                }
            }
            tempGroup.productList = arrM;
            [arr addObject:tempGroup];
        }
        
    }
    
    if(arr.count == 0)
    {
        [self.view makeToast:@"您还没有选择商品哦"];
    }else
    {
        FNFillOrderVC *vc = [[FNFillOrderVC alloc]init];
        vc.fillOrderDataSource = arr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

/**
 *  消息按钮的点击事件
 */
- (void)message
{
    FNMessageCenterVC  *vc = [[FNMessageCenterVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *   当前页面的总计和结算view
 *
 *  @return
 */
- (UIView *)creatFootView
{
    UIView * view  = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    lineLabel.frame = CGRectMake(0, 0, kScreenWidth, 1);
    [view addSubview:lineLabel];
    
    // 添加一个全选文本框按钮
    self.allSelecteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.allSelecteBtn.frame = CGRectMake(0, (56-38)*0.5, 38, 38);
    [self.allSelecteBtn addTarget:self action:@selector(allSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.allSelecteBtn];
    
    UIImageView *selecteImage = [[UIImageView alloc]init];
    selecteImage.frame = CGRectMake(kMarginTopX, (56-kSelecteWidth)*0.5, kSelecteWidth, kSelecteWidth);
    self.selectImage = selecteImage;
    [view addSubview:self.selectImage];
    self.btnSelected = NO;
    
    // 添加一个全选文本框标签
    UILabel *lab = [[UILabel alloc]init];
    self.detailLabel = lab;
    lab.text =  @"全选";
    [lab clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWithRGB(0.0, 0.0, 0.0)];
    CGFloat labX = CGRectGetMaxX(self.selectImage.frame) + 12;
    CGSize labSize = [lab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    lab.frame = CGRectMake(labX, (56- labSize.height) * 0.5, labSize.width, labSize.height);
    [view addSubview:lab];
    
    UILabel *goToPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 114 , 0, 114,56)];
    goToPayLabel.backgroundColor = [UIColor redColor];
    goToPayLabel.textColor = [UIColor whiteColor];
    goToPayLabel.textAlignment = NSTextAlignmentCenter;
    goToPayLabel.font = [UIFont systemFontOfSize:18];
    [view addSubview:goToPayLabel];
    self.goToPayLabel = goToPayLabel;
    // 添加一个结算按钮
    UIButton *settlementBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [settlementBtn addTarget:self action:@selector(goToWriteOrder) forControlEvents:UIControlEventTouchUpInside];
    settlementBtn.alpha = 0.11;
    settlementBtn.frame = CGRectMake(kScreenWidth - 114 , 0, 114,56);
    [view addSubview:settlementBtn];
    
    UILabel *numLab = [[UILabel alloc]init];
    self.numLab = numLab;
    self.numLab.textAlignment = NSTextAlignmentRight;
    [numLab clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [view addSubview:numLab];
    
    //总积分
    UILabel *scoreLab = [[UILabel alloc]init];
    [scoreLab clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
    self.scoreLab = scoreLab;
    self.scoreLab.textAlignment = NSTextAlignmentRight;
    [self totalPriceWithBool:YES];
    [view addSubview:scoreLab];
    _allNumber = 0;
    return view ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    FNCartGroupModel * model = self.cartShoppingData[indexPath.section];
    FNCartItemModel * cartItem = model.productList[indexPath.row];
    FNDetailVC * detailVC = [[FNDetailVC alloc]init];
    detailVC.productId = cartItem.productId;
    detailVC.productName = cartItem.productName;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    FNShoppingCartCell *cell = (FNShoppingCartCell *)[[[textField superview] superview] superview];
    
    NSIndexPath * index =   [self.tableView indexPathForCell:cell];
    
    FNCartGroupModel *model = self.cartShoppingData[index.section];
    FNCartItemModel * item = model.productList[index.row];
    if ([cell.numberField.text intValue]==0)
    {
        cell.numberField.text = @"1";
        item.count =1;
    }else
    {
        item.count = [cell.numberField.text intValue];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.frame = CGRectMake(SCREEN_WIDTH *0.5-37, SCREEN_HEIGHT*0.5-37, 37, 37);
    hud.color = [UIColor whiteColor];
    hud.activityIndicatorColor = [UIColor blackColor];
    if (cell.cartItem.skuCount > item.count)
    {
        [FNCartBO  updateCartWithProduct:cell.cartItem count:item.count block:^(id result)
         {
             [hud removeFromSuperview];
             
             if ([result[@"code"] integerValue] !=200)
             {
                 [self.view makeToast:result[@"desc"]];
                 return ;
             }
             if([result[@"code"] integerValue] == 200)
             {
                 
                 [[FNCartBO port02]getCartCountWithBlock:nil];
             }
             
         }];
    }else
    {
        item.count = cell.cartItem.skuCount;
        cell.numberField.text = [NSString stringWithFormat:@"%zd",item.count];
        [self.view makeToast:[NSString stringWithFormat:@"库存仅剩%d件",item.count]];
        [FNCartBO  updateCartWithProduct:cell.cartItem count:item.count block:^(id result) {
            [hud removeFromSuperview];
            
            if ([result[@"code"] integerValue] !=200)
            {
                [self.view makeToast:result[@"desc"]];
                
                return ;
            }
            if([result[@"code"] integerValue] == 200)
            {
                
                [[FNCartBO port02]getCartCountWithBlock:nil];
                [self.tableView reloadData];
                
            }
            
        }];
        
        
    }
    [self.tableView reloadData];
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    _topBut.alpha = 1- (100 - offsetY)/100;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_isEditing )
    {
        [self.view endEditing:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

@end
