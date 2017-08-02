//
//  FNVirfulOrderVC.m
//  BonusStore
//
//  Created by feinno on 16/5/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNVirfulOrderVC.h"
#import "FNHeader.h"
#import "FNVirfulViewCell.h"
#import "FNCartBO.h"

static CGFloat kMarginTopX = 15;

@interface FNVirfulOrderVC ()<UITextFieldDelegate,FNVirfulViewCellDelegate,UITableViewDelegate,UITableViewDataSource,FNTextFieldDelegate>
{
    CGFloat _allPrice;
    NSInteger _allNumber;
    NSString * _mobelNo;
}
@property (nonatomic, strong) NSIndexPath *currentEditCellIndexPath;// 当前被编辑的cell
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, weak)UIButton *settlementBtn;
@property (nonatomic,weak)UILabel *priceLabel;  // 商品价格
@property (nonatomic,weak)UILabel * totalNumLabel; // 总件数和总价格


@end

@implementation FNVirfulOrderVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @" 填写订单";
    [self setNavigaitionBackItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-48 -74-64) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerDone:)];
    [self.tableView addGestureRecognizer:tap];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self refreshPriceAndGoodNumber];
    UIView *footView = [self creatFootView];
    footView.frame = CGRectMake(0, kScreenHeight -48 -64, kScreenWidth, 48);
    [self.view addSubview:footView];
    
    UIView * selectPay = [self selectePaymentView];
    selectPay.frame = CGRectMake(0, kScreenHeight - 74 -48-64 , kScreenWidth, 74);
    [self.view addSubview:selectPay];
    
    self.settlementBtn.enabled = NO;
    self.settlementBtn.backgroundColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShowIn:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHideOn:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.tabBarController.tabBar.hidden = YES;
    
    FNTextField * textFeild = nil ;
    FNCartGroupModel * group = self.fillOrderDataSource.firstObject;
    FNCartItemModel *item = group.productList.firstObject;
    item.mobleNo = nil;
    for(FNVirfulViewCell *cell in self.tableView.visibleCells)
    {
        for (UIView *view in cell.subviews)
        {
            for(UIView * subView  in view.subviews){
                
                
                if(subView.tag == kTextFieldTagMobileNo)
                {
                    textFeild = (FNTextField *)subView;
                    textFeild.text = nil;
                }
            }
        }
    }
    _mobelNo = nil;
    [self.tableView reloadData];

}


- (void)tapGestureRecognizerDone:(UITapGestureRecognizer *)tapGesture
{
    [self.view endEditing:YES];
}
- (void)keyBoardWillShowIn:(NSNotification *)notoINfo
{
    NSDictionary *dict = notoINfo.userInfo;
    CGRect keyBoardFram = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyBoardFram.size.height - 64 );
    [self.tableView scrollToRowAtIndexPath:self.currentEditCellIndexPath
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)keyBoardWillHideOn:(NSNotification*)notoINfo
{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -74 - 48 -64);
    [self.tableView scrollToRowAtIndexPath:self.currentEditCellIndexPath
                          atScrollPosition:UITableViewScrollPositionNone animated:YES];
}


#pragma mark - tableViewDelegate and tableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FNCartGroupModel * group = self.fillOrderDataSource.firstObject;
    return group.productList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNCartGroupModel * group = self.fillOrderDataSource.firstObject;
    FNCartItemModel *item = group.productList[indexPath.row];
    FNVirfulViewCell  *cell = [FNVirfulViewCell virfulViewCellWithTableView:tableView];
    cell.cartItemModel = item;
    cell.phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    cell.phoneNumField.inputAccessoryView = [self keyToolbar];
    cell.delegate = self;
    cell.phoneNumField.delegate = self;
    return cell;
}


- (UIToolbar *)keyToolbar
{
    
    UIToolbar *keyToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    keyToolbar.barTintColor =  [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.5];
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
    
    UIBarButtonItem * doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClick)];
    
    UIBarButtonItem  *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    keyToolbar.items = [NSArray arrayWithObjects:cancleButton,spaceButtonItem,doneButtonItem,nil];
    
    return keyToolbar ;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FNCartGroupModel * group = self.fillOrderDataSource.firstObject;
    FNFillOrderHeaderView * fillOrderHeaderView = [FNFillOrderHeaderView fillOrderHeaderViewWithTableView:tableView];
    fillOrderHeaderView.cartGroup = group;
    return fillOrderHeaderView;
}



-(void)cancleButtonClick
{
    [self.view endEditing:YES];
}

-(void)doneButtonClick
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

// 提交订单
- (void)goToOrder
{
    self.settlementBtn.enabled = NO;
    [FNLoadingView showInView:self.view];
   [[FNCartBO  port02] submitOrderWithOrder:self.fillOrderDataSource totalSum:[NSString stringWithFormat:@"%.2lf",_allPrice] addressDesc:nil tradeCode:FNTradeCodeVirtualCard batch:NO mobile:_mobelNo Block:^(id result) {
       [FNLoadingView hide];
       if([result[@"code"] integerValue]==200)
       {
           //返回应答码，订单ID，订单的价格和时间
           FNPayVC *payVC = [[FNPayVC alloc]init];
           payVC.orderIds = result[@"orderIdList"];
//           if (payVC.orderIds.count > 1)
//           {
              payVC.tradeCode = @"Z8001";
               payVC.allPrice = [NSString stringWithFormat:@"%.2f",_allPrice];
//           payVC.isVirtualGoods = YES;
//               payVC.allPrice   = result[@"extend"][@"price"];
//               payVC.thirdScore = result[@"extend"][@"thirdScore"];
//               payVC.cancelTime = result[@"extend"][@"cancelTime"];
//               payVC.createTime =result[@"extend"][@"createTime"];
//           }
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == kTextFieldTagMobileNo)
    {
        FNVirfulViewCell *cell = (FNVirfulViewCell *)[[textField superview] superview];
        
        if ([textField.text isMobile])
        {
            cell.cartItemModel.mobleNo = textField.text;
            _mobelNo = textField.text;
            self.settlementBtn.enabled = YES;
            self.settlementBtn.backgroundColor =[UIColor redColor];
        }else
        {
            [self.view makeToast:@"输入正确的手机号"];
            self.settlementBtn.enabled = NO;
            self.settlementBtn.backgroundColor =[UIColor grayColor];
        }
        
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length+string.length;
    
    if (textField.tag == kTextFieldTagMobileNo && num >11)
    {
        [textField resignFirstResponder];
        return NO;
 
    }
    return YES;
}

- (void)refreshPriceAndGoodNumber
{
    NSInteger currentNum =0;
    CGFloat totalPrice = 0;
    for(FNCartGroupModel * sh in self.fillOrderDataSource)
    {
        for(FNCartItemModel *detail in sh.productList)
        {
            currentNum = currentNum + detail.count;
            totalPrice = totalPrice + [detail.curPrice floatValue] * 1.0 * detail.count;
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
    for(int i = 0; i<4;i++)
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
    priceLabel.frame = CGRectMake(kScreenWidth *0.5 + 12, (74 - priceLabelSize.height)*0.5, kScreenWidth *0.5- 27 , priceLabelSize.height);
    NSMutableAttributedString *needStr = [priceLabel.text makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    priceLabel.attributedText = needStr;
    
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
    settlementBtn.backgroundColor = [UIColor redColor];
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
    NSString *str2 = [NSString stringWithFormat:@"共计:¥%.2f",_allPrice ];
    [needStr appendAttributedString:[str2  makeStr:[NSString stringWithFormat:@"¥%.2f",_allPrice ] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
    numLab.attributedText = needStr;
    
    CGFloat numLabX = CGRectGetMinX(settlementBtn.frame) ;
    CGSize numLabSize = [needStr.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    numLab.frame = CGRectMake(kMarginTopX, (48 -numLabSize.height)*0.5, numLabX, numLabSize.height);
    [view addSubview:numLab];
    
    return view ;
}

@end


