//
//  FNFillOrderVC.m
//  BonusStore
//
//  Created by qingPing on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNFillOrderVC.h"
#import "FNManageAddressVC.h"
#import "UIView+Toast.h"
#import "FNCartBO.h"
#import "FNMyBO.h"
#import "FNAddNewAddressVC.h"
#import "FNSkuPriceAndStock.h"
#import "FNPostageModel.h"
#import "NSString+Cate.h"
static CGFloat kMarginTopX = 15;

@interface FNFillOrderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FNTextFieldDelegate>
{
    NSString * _allPostage;
    NSInteger  _allNumber;
    CGFloat    _allPrice;
    FNNoDataView *_noData;

//    NSInteger _allFreight;
    
//    BOOL _isVirtual;
}
@property (nonatomic, weak) UITableView * fillTabelView;
@property (nonatomic, weak) UIView *headView;

@property (nonatomic, strong) NSIndexPath *currentEditCellIndexPath;// 当前被编辑的cell
@property (nonatomic, strong) FNAddressModel * addressModel;

//@property (nonatomic, assign) NSInteger allNeedPrice;

@property (nonatomic, strong) NSMutableArray * addressArr;

@property (nonatomic, strong) NSMutableArray *skuStoreArr; // 库存数组
@property (nonatomic, strong) NSMutableArray *postageArr; //运费数组
@property (nonatomic,weak)UILabel * totalNumLabel; // 总件数和总价格
@property (nonatomic,weak)UILabel *priceLabel;  // 商品价格
@property (nonatomic,weak) UILabel * usdLabel; //运费
@property (nonatomic,weak) UIButton *settlementBtn;

@end

@implementation FNFillOrderVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.skuStoreArr = [NSMutableArray array];
    
    [self setNavigaitionBackItem];
    self.title = @" 填写订单";
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *fillTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-48 -74-64) style:UITableViewStyleGrouped];
    self.fillTabelView = fillTabelView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.fillTabelView addGestureRecognizer:tap];
    self.fillTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.fillTabelView.delegate = self;
    self.fillTabelView.dataSource = self;
    self.fillTabelView.showsVerticalScrollIndicator = NO;
    self.fillTabelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fillTabelView];
    self.addressArr = [NSMutableArray array];
    [self refresePriceAndGoodNumber];
    UIView *footView = [self creatFootView];
    footView.frame = CGRectMake(0, kScreenHeight -48 -64, kScreenWidth, 48);
    [self.view addSubview:footView];
    
    UIView * selectPay = [self selectePaymentView];
    selectPay.frame = CGRectMake(0, kScreenHeight - 74 -48-64 , kScreenWidth, 74);
    [self.view addSubview:selectPay];
    [self fillOrderReloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickAddress:) name:@"clickAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fillAddFirstAddress:) name:@"addFirstAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editAddressIsDefault:) name:@"editAddressIsDefault" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editAddress:) name:@"editAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteAddress:) name:@"deleteAddress" object:nil];
}


- (void)tapGestureRecognizer: (UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
- (void)fillOrderReloadDataNotWithAddress
{
    for(FNCartGroupModel * cart in self.fillOrderDataSource)
    {
        for(FNCartItemModel * model in cart.productList)
        {
            model.isOver = YES;
        }
    }
    // 批量获取库存和sku价格
    [[FNCartBO port01] getQuerystoreBatchWithProvinceId:[NSString stringWithFormat:@"%zd",self.addressModel.provinceId] orderList:self.fillOrderDataSource block:^(id result) {
        if([result[@"code"] integerValue] != 200)
        {
            self.settlementBtn .enabled = NO;
            self.settlementBtn.backgroundColor = [UIColor grayColor];
            
            [self.fillTabelView reloadData];
            if(result)
            {
                [self.view makeToast:result[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }

            return ;
        }
        if ([result[@"code"] integerValue] == 200)
        {
            [self.skuStoreArr removeAllObjects];
            
            for (NSDictionary *dict in result[@"skuPriceAndStockList"])
            {
                [self.skuStoreArr addObject:[FNSkuPriceAndStock makeEntityWithJSON:dict]];
            }
        }
        
        NSInteger storeHourseIdEmptyCount = 0; //storehourseid is 0 then count++;
        NSInteger storeHourseProductCount = 0; //storehourse product count;
        for (FNCartGroupModel *cartGroup in self.fillOrderDataSource)
        {
            for(FNCartItemModel * cartItem in cartGroup.productList)
            {
                NSString * productId = cartItem.productId;
                NSString * skuNum = cartItem.sku.skuNum;
                __block FNSkuPriceAndStock * skuPrice = nil;
                [self.skuStoreArr enumerateObjectsUsingBlock:^(FNSkuPriceAndStock * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.productId isEqualToString:productId] && [obj.skuNum isEqualToString:skuNum] )
                    {
                        skuPrice = obj;
                        *stop =YES;
                    }
                }];
                // 判断库存和当前价格 ,storehouseid, sku
                if(![NSString isEmptyString:skuPrice.curPrice])
                {
                    cartItem.curPrice = skuPrice.curPrice;
                }
                if (skuPrice.storehouseId == 0)
                {
                    storeHourseIdEmptyCount++;
                    
                    skuPrice.count = 0;
                }
                
                cartItem.storehouseId = [NSString stringWithFormat:@"%zd",skuPrice.storehouseId];
                
                if (skuPrice.count == 0)    //0库存
                {
                    cartItem.isOver = NO;
                    cartItem.skuCount = skuPrice.count;
                    self.settlementBtn .enabled = NO;
                    self.settlementBtn.backgroundColor = [UIColor grayColor];
                    storeHourseIdEmptyCount++;
                }
                else if (skuPrice.count <  cartItem.count && skuPrice.count>0)//库存小于填写的
                {
                    cartItem.isOver = NO;
                    cartItem.skuCount = skuPrice.count;
                    self.settlementBtn .enabled = NO;
                    self.settlementBtn.backgroundColor = [UIColor grayColor];
                    
                    storeHourseProductCount++;
                }
                else        //normal
                {
                    cartItem.isOver = YES;
                    self.settlementBtn.enabled =YES;
                    self.settlementBtn.backgroundColor = [UIColor redColor];
                }
            }
            
            if (storeHourseProductCount)
            {
                [UIAlertView alertViewWithMessage:@"当前城市下您的订单中有商品库存不足，请查看"];
            }
            else if (storeHourseIdEmptyCount)
            {
                [UIAlertView alertViewWithMessage:@"当前城市下您的订单中有商品已售罄，请查看"];
            }
        }
        [self.fillTabelView reloadData];
        // 获得运费
        [[FNCartBO port01] getShipWithProvinceId:
         [NSString stringWithFormat:@"%zd",self.addressModel.provinceId] orderList:self.fillOrderDataSource block:^(id result) {
             self.postageArr = [NSMutableArray array];
             if([result[@"code"] intValue] != 200)
             {
                 self.settlementBtn .enabled = NO;
                 self.settlementBtn.backgroundColor =[UIColor grayColor];
                 [self.view makeToast:@"商品暂时不支持该收货地址"];
                 return ;
             }
             
             _allPostage = result[@"totalPostage"];
             
             //返回各商家的运费和总运费
             [self.postageArr removeAllObjects];
             for (NSDictionary *dict in result[@"sellerPostageReturnList"])
             {
                 [self.postageArr addObject:[FNPostageModel makeEntityWithJSON:dict]];
             }
             
             // 先遍历self.fillorderDataSource
             for (FNCartGroupModel *cartGroup in self.fillOrderDataSource)
             {
                 int sellerId = cartGroup.sellerId;
                 __block FNPostageModel* postageModel = nil;
                 [self.postageArr enumerateObjectsUsingBlock:^(FNPostageModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if (obj.sellerId == sellerId)
                     {
                         postageModel = obj;
                         *stop =YES;
                     }
                 }];
                 cartGroup.postage = postageModel.postage;
             }
             
             NSInteger overNumber =0;
             for (FNCartGroupModel *cartGroup in self.fillOrderDataSource)
             {
                 for (FNCartItemModel *item  in cartGroup.productList) {
                     if(item.isOver == NO)
                     {
                         overNumber = overNumber +1;
                     }
                 }
             }
             if(overNumber >1 || overNumber ==1)
             {
                 // 做个标志
                 self.settlementBtn .enabled = NO;
                 self.settlementBtn.backgroundColor = [UIColor grayColor];
             }else
             {
                 self.settlementBtn.enabled = YES;
                 self.settlementBtn.backgroundColor = [UIColor redColor];
                 
             }
             
             [self refresePriceAndGoodNumber];
             
             NSString * str1 = [NSString stringWithFormat:@"总 %zd 件,", _allNumber];
             NSMutableAttributedString *needStr = [str1 makeStr:[NSString stringWithFormat:@"%zd",_allNumber] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
             CGFloat totalPostage = [_allPostage floatValue];
             NSString *str2 = [NSString stringWithFormat:@"共计:¥%.2f", _allPrice + totalPostage];
             [needStr appendAttributedString:[str2  makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice + totalPostage] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
             self.totalNumLabel.attributedText = needStr;
             
             self.priceLabel.text =  [NSString stringWithFormat:@"商品金额: ¥%.2f ",_allPrice];
             
             NSMutableAttributedString *needString = [self.priceLabel.text makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
             self. priceLabel.attributedText = needString;
             CGFloat allPostag =  [_allPostage floatValue];
             self. usdLabel.text = [NSString stringWithFormat:@"运费:  ¥%.2lf",allPostag];
             NSMutableAttributedString *needStr1 = [self.usdLabel.text makeStr:[NSString stringWithFormat:@"¥%.2lf",allPostag] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
             self.usdLabel.attributedText = needStr1;
             [self.fillTabelView reloadData];
             
             
             
         }];
        
    }];
}



-(void )fillOrderReloadData
{
    // 获得地址列表
    [FNLoadingView showInView:self.view];
    [self.addressArr removeAllObjects];
    __weak __typeof(self) weakSelf = self;

    
    [[FNMyBO port02] getAddrListWithBlock:^(id result) {
        [FNLoadingView hideFromView:self.view];
        
        if([result[@"code"] integerValue] != 200 || result ==nil)
        {
            _noData.hidden = NO;
            if (!_noData)
            {
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,0 ,kScreenWidth ,kScreenHeight)];
            }
            
            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            [_noData setTypeWithResult:result];

            [_noData setActionBlock:^(id sender) {
                
                [weakSelf fillOrderReloadData];
                
            }];
            [self.view addSubview:_noData];
            return ;
        }
        
        if ([result[@"code"] integerValue] == 200)
        {
            for ( NSDictionary * dict in result[@"addressInfoList"] )
            {
                [self.addressArr addObject:[FNAddressModel mj_objectWithKeyValues:dict]];
            }
        }
        if(self.addressArr.count !=0)
        {
        
            for(FNAddressModel * model in self.addressArr)
            {
                if (model.isDefault == 1)
                {
                    self.addressModel = model;
                }
                
            }
            if(self.addressModel == nil)
            {
                self.addressModel = self.addressArr.firstObject;
            }
            [self tableHeadView:YES];
            for(FNCartGroupModel * cart in self.fillOrderDataSource)
            {
                for(FNCartItemModel * model in cart.productList)
                {
                    model.isOver = YES;
                }
            }
            // 批量获取库存和sku价格
            [[FNCartBO port01] getQuerystoreBatchWithProvinceId:[NSString stringWithFormat:@"%zd",self.addressModel.provinceId] orderList:self.fillOrderDataSource block:^(id result) {
                if([result[@"code"] integerValue] != 200)
                {
                    self.settlementBtn .enabled = NO;
                    self.settlementBtn.backgroundColor = [UIColor grayColor];
                    
                    [self.fillTabelView reloadData];
                    if(result)
                    {
                        [self.view makeToast:result[@"desc"]];
                    }else
                    {
                        [self.view makeToast:@"加载失败,请重试"];
                    }
                    return ;
                }
                if ([result[@"code"] integerValue] == 200)
                {
                    [self.skuStoreArr removeAllObjects];
                    
                    for (NSDictionary *dict in result[@"skuPriceAndStockList"])
                    {
                        [self.skuStoreArr addObject:[FNSkuPriceAndStock makeEntityWithJSON:dict]];
                    }
                }
                NSInteger storeHourseIdEmptyCount = 0; //storehourseid is 0 then count++;
                NSInteger storeHourseProductCount = 0; //storehourse product count;
                for (FNCartGroupModel *cartGroup in self.fillOrderDataSource)
                {
                    for(FNCartItemModel * cartItem in cartGroup.productList)
                    {
                        NSString * productId = cartItem.productId;
                        NSString * skuNum = cartItem.sku.skuNum;
                        __block FNSkuPriceAndStock * skuPrice = nil;
                        
                        [self.skuStoreArr enumerateObjectsUsingBlock:^(FNSkuPriceAndStock * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if(obj.skuNum != nil)
                            {
                                if([obj.productId isEqualToString:productId] && [obj.skuNum isEqualToString:skuNum] )
                                {
                                    skuPrice = obj;
                                    *stop = YES;
                                }
                            }else
                            {
                                if([obj.productId isEqualToString:productId])
                                {
                                    skuPrice = obj;
                                    *stop = YES;

                                }
                            }
                           
                        }];
                        // 判断库存和当前价格 ,storehouseid, sku
                        if(![NSString isEmptyString:skuPrice.curPrice])
                        {
                            cartItem.curPrice = skuPrice.curPrice;
                        }
                        if (skuPrice.storehouseId == 0)
                        {
                            storeHourseIdEmptyCount++;
                            
                            skuPrice.count = 0;
                        }
                        
                        cartItem.storehouseId = [NSString stringWithFormat:@"%zd",skuPrice.storehouseId];
                        
                        if (skuPrice.count == 0)    //0库存
                        {
                            cartItem.isOver = NO;
                            cartItem.skuCount = skuPrice.count;
                            self.settlementBtn .enabled = NO;
                            self.settlementBtn.backgroundColor = [UIColor grayColor];
                            storeHourseIdEmptyCount++;
                        }
                        else if (skuPrice.count <  cartItem.count && skuPrice.count>0)//库存小于填写的
                        {
                            cartItem.isOver = NO;
                            cartItem.skuCount = skuPrice.count;
                            self.settlementBtn .enabled = NO;
                            self.settlementBtn.backgroundColor = [UIColor grayColor];
                            
                            storeHourseProductCount++;
                        }
                        else        //normal
                        {
                            cartItem.isOver = YES;
                            self.settlementBtn.enabled =YES;
                            self.settlementBtn.backgroundColor = [UIColor redColor];
                        }
                    }
                    
                    if (storeHourseProductCount)
                    {
                        [UIAlertView alertViewWithMessage:@"当前城市下您的订单中有商品库存不足，请查看"];
                    }
                    else if (storeHourseIdEmptyCount)
                    {
                        [UIAlertView alertViewWithMessage:@"当前城市下您的订单中有商品已售罄，请查看"];
                    }

                }
                [self.fillTabelView reloadData];
                // 获得运费
                [[FNCartBO port01] getShipWithProvinceId:
                 [NSString stringWithFormat:@"%zd",self.addressModel.provinceId] orderList:self.fillOrderDataSource block:^(id result) {
                     [FNLoadingView hideFromView:self.view];
                     self.postageArr = [NSMutableArray array];
                     if([result[@"code"] intValue] != 200)
                     {
                         self.settlementBtn .enabled = NO;
                         self.settlementBtn.backgroundColor = [UIColor grayColor];
                         [self.view makeToast:@"商品暂时不支持该收货地址"];
                         return ;
                     }
                     
                         _allPostage = result[@"totalPostage"];
                         
                         //返回各商家的运费和总运费
                         [self.postageArr removeAllObjects];
                         for (NSDictionary *dict in result[@"sellerPostageReturnList"])
                         {
                             [self.postageArr addObject:[FNPostageModel makeEntityWithJSON:dict]];
                         }
                         
                         // 先遍历self.fillorderDataSource
                         for (FNCartGroupModel *cartGroup in self.fillOrderDataSource)
                         {
                             int sellerId = cartGroup.sellerId;
                             __block FNPostageModel* postageModel = nil;
                             [self.postageArr enumerateObjectsUsingBlock:^(FNPostageModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 if (obj.sellerId == sellerId)
                                 {
                                     postageModel = obj;
                                     *stop =YES;
                                 }
                             }];
                             cartGroup.postage = postageModel.postage;
                         }
                         
                         NSInteger overNumber = 0;
                         for (FNCartGroupModel *cartGroup in self.fillOrderDataSource)
                         {
                             for (FNCartItemModel *item  in cartGroup.productList) {
                                 if(item.isOver == NO)
                                 {
                                     overNumber = overNumber +1;
                                 }
                             }
                         }
                         if(overNumber >1 || overNumber ==1)
                         {
                             // 做个标志
                             self.settlementBtn.enabled = NO;
                             self.settlementBtn.backgroundColor = [UIColor grayColor];
                         }else
                         {
                             self.settlementBtn.enabled =YES;
                             self.settlementBtn.backgroundColor = [UIColor redColor];
                             
                         }
                         
                         [self refresePriceAndGoodNumber];
                         
                         NSString * str1 = [NSString stringWithFormat:@"总 %zd 件,", _allNumber];
                         NSMutableAttributedString *needStr = [str1 makeStr:[NSString stringWithFormat:@"%zd",_allNumber] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
                         CGFloat totalPostage = [_allPostage floatValue];
                         NSString *str2 = [NSString stringWithFormat:@"共计:¥%.2f", _allPrice + totalPostage];
                         [needStr appendAttributedString:[str2  makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice + totalPostage] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
                         self.totalNumLabel.attributedText = needStr;
                         
                         self.priceLabel.text =  [NSString stringWithFormat:@"商品金额: ¥%.2f ",_allPrice];
                         
                         NSMutableAttributedString *needString = [self.priceLabel.text makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
                         self. priceLabel.attributedText = needString;
                         CGFloat allPostag =  [_allPostage floatValue];
                         self. usdLabel.text = [NSString stringWithFormat:@"运费:  ¥%.2lf",allPostag];
                         NSMutableAttributedString *needStr1 = [self.usdLabel.text makeStr:[NSString stringWithFormat:@"¥%.2lf",allPostag] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
                         self.usdLabel.attributedText = needStr1;
                         [self.fillTabelView reloadData];
                         
                     
                     
                 }];
                
            }];
        
        
        }else
        {
            [self tableHeadView:NO];
        }
    }];
    

}



// 通知
- (void)deleteAddress:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"deleteAddress"];

    if(add.id == self.addressModel.id)
    {
         [self fillOrderReloadData];
    }

   
}


- (void)clickAddress:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"clickAddress"];
    self.addressModel = add;
    [self tableHeadView:YES];
    [self fillOrderReloadDataNotWithAddress];
}
- (void)fillAddFirstAddress:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"addFirstAddress"];
    self.addressModel = add;
    [self tableHeadView:YES];

    [self fillOrderReloadDataNotWithAddress];
}
 -(void)editAddressIsDefault:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"editAddressIsDefault"];
    if(self.addressModel.id == add.id)
    {
       self.addressModel = add;
        [self tableHeadView:YES];
        [self fillOrderReloadDataNotWithAddress];
    }
    
}

-(void)editAddress:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"editAddress"];
    if(self.addressModel.id == add.id)
    {
        self.addressModel = add;
        [self tableHeadView:YES];
        [self fillOrderReloadDataNotWithAddress];
    }
    
}


- (void)keyBoardWillShow:(NSNotification *)notoINfo
{
    NSDictionary *dict = notoINfo.userInfo;
    CGRect keyBoardFram = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.fillTabelView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyBoardFram.size.height - 64 );
    [self.fillTabelView scrollToRowAtIndexPath:self.currentEditCellIndexPath
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyBoardWillHide:(NSNotification*)notoINfo
{
    self.fillTabelView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -74 - 48 -64);
    [self.fillTabelView scrollToRowAtIndexPath:self.currentEditCellIndexPath
                              atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



#pragma mark - tableViewDelegate and tableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fillOrderDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FNCartGroupModel *fillOrderGroup = self.fillOrderDataSource[section];
    return fillOrderGroup.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNCartGroupModel * group = self.fillOrderDataSource[indexPath.section];
    FNCartItemModel *item = group.productList[indexPath.row];
    FNFillOrderCell *cell = [FNFillOrderCell fillOrderCellWithTableView:tableView];
    cell.fillOrderItem = item;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FNCartGroupModel * group = self.fillOrderDataSource[section];
    FNFillOrderHeaderView * fillOrderHeaderView = [FNFillOrderHeaderView fillOrderHeaderViewWithTableView:tableView];
    fillOrderHeaderView.cartGroup = group;
    return fillOrderHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    FNCartGroupModel * group = self.fillOrderDataSource[section];
    FNFillOrderFooterView *fillOrderFooterView = [FNFillOrderFooterView fillOrderFooterViewWithTableView:tableView];
    fillOrderFooterView.isVirful = NO;
    fillOrderFooterView.commentsField.delegate = self;
    fillOrderFooterView.commentsField.textFieldDelegate =self;
    fillOrderFooterView.cartGroup = group;
    return fillOrderFooterView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 82;
}

// 提交订单
- (void)goToOrder
{
    self.settlementBtn.enabled = NO;
    CGFloat totalPosta = [_allPostage floatValue];
    [FNLoadingView showInView:self.view];
    [[FNCartBO port02] submitOrderWithOrder:self.fillOrderDataSource totalSum:[NSString stringWithFormat:@"%.2lf",totalPosta+_allPrice] addressDesc:self.addressModel tradeCode:FNtradeCodeEntity batch:YES mobile:nil Block:^(id result) {
        self.settlementBtn.enabled = YES;
        [FNLoadingView hide];
        
        if([result[@"code"] integerValue]==200)
        {
            //返回应答码，订单ID，订单的价格和时间
            FNPayVC *payVC = [[FNPayVC alloc]init];
            payVC.orderIds = result[@"orderIdList"];
            payVC.tradeCode = @"Z0003";
//            if (payVC.orderIds.count > 1)
//            {
                payVC.allPrice = [NSString stringWithFormat:@"%.2f",_allPrice + [_allPostage floatValue]];
//                payVC.allPrice = result[@"extend"][@"price"];
//                payVC.thirdScore = result[@"extend"][@"thirdScore"];
//                payVC.cancelTime = result[@"extend"][@"cancelTime"];
//                payVC.createTime =result[@"extend"][@"createTime"];
//            }
            [self.navigationController pushViewController:payVC animated:YES];
        }else
        {
            if(result)
            {
                [self.view makeToast:result[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
        }
    }];
}

- (void)tableHeadView:(BOOL)haveDefault
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    self.headView = view;
    [self.headView addTarget:self action:@selector(goToAddress)];
    UILabel * grayline = [[UILabel alloc]init];
    grayline.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    grayline.frame = CGRectMake(0, 0, kScreenWidth, 10);
    [view addSubview:grayline];
    if (haveDefault == NO)
    {
        UILabel * tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"您还没有地址，请尽快添加吧~";
        [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
        CGSize tipLabelSize = [tipLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        tipLabel.frame = CGRectMake(15, 10, tipLabelSize.width, 44);
        [view addSubview:tipLabel];
        
        // 箭头
        UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_order"]];
        image1.frame = CGRectMake(kScreenWidth - 15-image1.frame.size.width, 32-image1.frame.size.height *0.5, image1.frame.size.width, image1.frame.size.height);
        [view addSubview:image1];
        view.frame = CGRectMake(0,0, kScreenWidth,54 );
        self.fillTabelView.tableHeaderView = view;
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil  message:@"请设置收货地址"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alertView show];
    }else
    {
        
        UILabel * nameLabel = [[UILabel alloc]init];
        nameLabel.text  = [NSString stringWithFormat:@"%@  %@",self.addressModel.receiverName, self.addressModel.mobile];
        [nameLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
        CGSize nameLabelSize = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        nameLabel.frame = CGRectMake(15, 10+18, nameLabelSize.width, nameLabelSize.height);
        [view addSubview:nameLabel];
        
        // 箭头
        UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_order"]];
        image1.frame = CGRectMake(kScreenWidth - 15-image1.frame.size.width, 48, image1.frame.size.width, image1.frame.size.height);
        [view addSubview:image1];
        
        CGFloat addressY = CGRectGetMaxY(nameLabel.frame);
        CGFloat addressX = CGRectGetMinX(image1.frame);
        UILabel *addressLabel = [[UILabel alloc]init];
        NSString * addreStr = [NSString stringWithFormat:@"%@%@%@%@",self.addressModel.provinceName,self.addressModel.cityName,self.addressModel.countyName,self.addressModel.address];
        
        addressLabel.text = addreStr;
        addressLabel.backgroundColor =[UIColor redColor];
        [addressLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
        addressLabel.numberOfLines = 0;
        CGSize addreSize = [self sizeWithMaxSize: addressX-50 andFont:[UIFont systemFontOfSize:14] WithString:addreStr];
        addressLabel.frame = CGRectMake(15, addressY +15, addreSize.width, addreSize.height );
        [view addSubview:addressLabel];
        
        view.frame = CGRectMake(0,64, kScreenWidth, CGRectGetMaxY(addressLabel.frame)+18);
        self.fillTabelView.tableHeaderView = view;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==0)
    {
        
    }else
    {
        FNAddNewAddressVC * addNewAddree = [[FNAddNewAddressVC alloc]init];
        addNewAddree.isEdit = NO;
        addNewAddree.isFirstAddress = YES;
        [self.navigationController pushViewController:addNewAddree animated:YES];
    }
}
// 设置换行的label 的size
- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

-(void)goToAddress
{
    FNManageAddressVC * manageAddress = [[FNManageAddressVC alloc]init];
    manageAddress.fromFillOrder = YES;
    [self.navigationController pushViewController:manageAddress animated:YES];
    
}

#pragma mark -- 计算价格和个数

- (void)refresePriceAndGoodNumber
{
    NSInteger currentNum = 0;
    CGFloat totalPrice = 0;
    for(FNCartGroupModel * sh in self.fillOrderDataSource)
    {
        for(FNCartItemModel *detail in sh.productList)
        {
            currentNum = currentNum +  detail.count;
            if ([NSString isEmptyString:detail.curPrice])
            {
                totalPrice = totalPrice +[detail.cartPrice doubleValue] *1.0 * detail.count;

            }else
            {
            totalPrice = totalPrice +[detail.curPrice doubleValue] *1.0 * detail.count;
            }
        }
    }
    _allNumber = currentNum;
    _allPrice = totalPrice;
}

- (UIView *)selectePaymentView
{
    NSArray * arr = @[@"cart_pay_1",@"cart_pay_2",@"cart_pay_3",@"cart_pay_4"];
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lineLabel1 = [[UILabel alloc]init];
    lineLabel1.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    lineLabel1.frame = CGRectMake(0, 0, kScreenWidth, 1);
    [view addSubview:lineLabel1];
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"可选择的支付方式: ";
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [nameLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
    CGFloat nameLabelH = [UIFont systemFontOfSize:14].lineHeight;
    nameLabel.frame = CGRectMake(15, 5, kScreenWidth *0.5-30, nameLabelH);
    [view addSubview:nameLabel];
    
    CGFloat btnY = CGRectGetMaxY(nameLabel.frame)+10;
    CGFloat btnW = 34;
    CGFloat btnMargin = (kScreenWidth*0.5 -30 - 4*34)*0.33;
    for(int i = 0;i<4;i++)
    {
        UIImageView * image = [[UIImageView alloc]init];
        
        image.frame = CGRectMake((btnW+btnMargin)*i+10, btnY, btnW, btnW);
        image.image = [UIImage imageNamed:arr[i]];
        [view addSubview:image];
    }
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.frame = CGRectMake(kScreenWidth *0.5, 5, 1, 64);
    [view addSubview:lineLabel];
    
    UILabel *priceLabel = [[UILabel alloc]init];
    self.priceLabel = priceLabel;
    [view addSubview:priceLabel];
    priceLabel.text =  [NSString stringWithFormat:@"商品金额: ¥%.2f  ",_allPrice];
    [priceLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
    
    CGSize priceLabelSize = [priceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    priceLabel.frame = CGRectMake(kScreenWidth *0.5 + 12, 5, kScreenWidth *0.5- 27 , priceLabelSize.height);
    NSMutableAttributedString *needStr = [priceLabel.text makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    priceLabel.attributedText = needStr;
    
    UILabel * usdLabel =[[UILabel alloc]init];
    self.usdLabel = usdLabel;
    [usdLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
    [view addSubview:self.usdLabel];
    CGFloat usdY = 65 - [UIFont systemFontOfSize:14].lineHeight;
    usdLabel.frame = CGRectMake(kScreenWidth *0.5+12, usdY, kScreenWidth *0.5- 27, [UIFont systemFontOfSize:14].lineHeight);
    CGFloat allPostag = [_allPostage floatValue];
    usdLabel.text = [NSString stringWithFormat:@"运费:¥%.2lf",allPostag];
    NSMutableAttributedString *needStr1 = [usdLabel.text makeStr:[NSString stringWithFormat:@"¥%.2lf",allPostag] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    usdLabel.attributedText = needStr1;
    
    return view;
}

- (UIView *)creatFootView
{
 //结算
    UIView * view  =[[UIView alloc]init];
    view.backgroundColor =[UIColor whiteColor];
    UIButton *settlementBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.settlementBtn =settlementBtn;
    NSString * str = @" 提交订单 ";
    [settlementBtn addTarget:self action:@selector(goToOrder) forControlEvents:UIControlEventTouchUpInside];
    settlementBtn.titleLabel.font = [UIFont systemFontOfSize:24];
    [settlementBtn setTitle:str  forState:UIControlStateNormal];
    [settlementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGSize settlementSize =  [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]}];
    settlementBtn.frame = CGRectMake(kScreenWidth - settlementSize.width-20, 0, settlementSize.width+20,48);
    settlementBtn.backgroundColor = [UIColor grayColor];
    settlementBtn.enabled = NO;
    [view addSubview:settlementBtn];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    lineLabel.frame = CGRectMake(0, 0, kScreenWidth, 1);
    [view addSubview: lineLabel];

    UILabel *numLab = [[UILabel alloc]init];
    self.totalNumLabel = numLab;
    [numLab clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
    NSString * str1 = [NSString stringWithFormat:@"总 %zd 件,",_allNumber];
    NSMutableAttributedString *needStr = [str1 makeStr:[NSString stringWithFormat:@"%zd",_allNumber] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    CGFloat totalPostage = [_allPostage floatValue];
    NSString *str2 = [NSString stringWithFormat:@"共计:¥%.2f",(_allPrice + totalPostage)];
    [needStr appendAttributedString:[str2  makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice +totalPostage] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
    numLab.attributedText = needStr;
    
    CGFloat numLabX = CGRectGetMinX(settlementBtn.frame) ;
    CGSize numLabSize = [needStr.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    numLab.frame = CGRectMake(kMarginTopX, (48 -numLabSize.height)*0.5, numLabX, numLabSize.height);
    [view addSubview:numLab];
    
    return view ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    FNFillOrderFooterView *footerView = (FNFillOrderFooterView *)[[textField superview] superview];
    footerView.cartGroup.buyerComment = textField.text;
    if (textField.text.length >60)
    {
        [self.view makeToast:@"留言不能超过60个字噢"];
        textField.text = [textField.text substringToIndex:60];
        footerView.cartGroup.buyerComment = [textField.text substringToIndex:60];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    FNFillOrderFooterView *footerView = (FNFillOrderFooterView *)[[textField superview] superview];
    footerView.cartGroup.buyerComment = textField.text;
    if (textField.text.length >60)
    {
        [self.view makeToast:@"留言不能超过60个字噢"];
        
      textField.text = [textField.text substringToIndex:60];
        footerView.cartGroup.buyerComment = [textField.text substringToIndex:60];
    }
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length + string.length;
    if(num > 60)
    {
        [self.view makeToast:@"留言不能超过60个字噢"];
        [textField resignFirstResponder];
        
        return NO;
    }
    return YES;
}


/**
 *  根据tableView的类型设置让组头跟着滚动滚动
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
}



@end
