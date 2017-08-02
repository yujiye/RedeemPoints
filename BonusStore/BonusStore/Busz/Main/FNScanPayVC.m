//
//  FNScanPayVC.m
//  BonusStore
//
//  Created by Nemo on 16/5/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNScanPayVC.h"

#import "UIView+Toast.h"

#import "FNMyBO.h"

#import "FNMainBO.h"

#import "FNLoginBO.h"

BOOL FNLoginIsScan;     //为了跟正常的登录进行区分，扫描登录多了一句话

@interface FNScanPayVC ()<FNTextFieldDelegate,UITextFieldDelegate>
{
    UIView *shopView;
    
    UILabel *nameLabel;
    
    UILabel *shopName;
    
    UIView *orderMoneyView;
    
    UILabel *orderLabel;
    
    UILabel *moneyLabel;
    
    FNTextField *moneyText;
    NSMutableArray * array;
  
}
@property (nonatomic, strong) FNPersonalModel * personalModel;

@property (nonatomic, strong) NSMutableArray * data;

@end


@implementation FNScanPayVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [moneyText becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (FNUserAccountInfo && moneyText.text.length)
    {
        [self.view endEditing:YES];
        
        [self payButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    
    _personalModel = [[FNPersonalModel alloc]init];
    
    _data = [NSMutableArray array];
    
    array = [NSMutableArray array];
    
    [self setNavigaitionBackItem];
    
    [self initView];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [self createButton];
    
}
- (void)createButton
{
    FNButton * payBtn = [FNButton buttonWithType:FNButtonTypePlain title:@"确认支付"];
    
    payBtn.frame = CGRectMake(52, 138,kScreenWidth - 104 , 48);
    
    payBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:17];
    
    [payBtn addTarget:self action:@selector(payButton) forControlEvents:UIControlEventTouchUpInside];
    
    [payBtn setCorner:5];
    
    [self.view addSubview:payBtn];
    
}

- (void)initView
{
    shopView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 48)];
    
    shopView.backgroundColor = MAIN_COLOR_WHITE;
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,15 , 79, 18)];
    
    nameLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
    
    nameLabel.text = @"店铺名称:";
    
    shopName = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.x+nameLabel.width, 15, kScreenWidth - 30 - nameLabel.width, 18)];
    
    for (NSDictionary *dic in _sellerDetailList)
    {
        shopName.text =  dic[@"sellerName"];
    }

    shopName.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
    
    shopName.textAlignment = NSTextAlignmentRight;
    
    [shopView addSubview:nameLabel];
    
    [shopView addSubview:shopName];

    [self.view addSubview:shopView];
    
    orderMoneyView = [[UIView alloc]initWithFrame:CGRectMake(0, 78, kScreenWidth, 48)];
    
    orderMoneyView.backgroundColor = MAIN_COLOR_WHITE;
    
    orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 79, 18)];
    
    orderLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
    
    orderLabel.text = @"订单金额:";
    
    [orderMoneyView addSubview:orderLabel];
    
    [self.view addSubview:orderMoneyView];

    moneyText = [[FNTextField alloc]initWithFrame:CGRectMake(kScreenWidth - 95,9, 90, 30)];
    
    moneyText.borderStyle = UITextBorderStyleNone;
    
    moneyText.textFieldDelegate = self;
    
    moneyText.delegate = self;
    
    moneyText.textAlignment = NSTextAlignmentLeft;
    
    moneyText.textColor = MAIN_COLOR_RED_ALPHA;
    
    moneyText.placeholder = @"0.00";
    moneyText.placeholderFont = 15;
    moneyText.isSanPayVC = YES;
    
    moneyText.font = [UIFont fontWithName:FONT_NAME_LTH size:15];
    
    moneyText.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [orderMoneyView addSubview:moneyText];

    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 ,0 , 10, 18)];
    
    moneyLabel.text = @"¥";
    
    moneyText.leftView = moneyLabel;
    
    moneyText.leftViewMode = UITextFieldViewModeAlways;

}

- (void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    if (flag)
    {
        if (textField.text.length != 0)
        {
            NSString *subString = @".";
            NSArray *array = [textField.text componentsSeparatedByString:subString];
            NSInteger count = array.count - 1;
            NSString *str = [textField.text substringToIndex:1];
            
            NSString *regex =@"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
            
            NSPredicate *name = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([str isEqualToString:@"."]|| count>1 || [str isEqualToString:@"-"]|| ![name evaluateWithObject:textField.text])
            {
                textField.text = nil;
                textField.placeholder = @"0.00";
            }
        }
        else
        {
            [self.view makeToast:@"请输入金额"];
        }
       
    }
    else
    {
    }
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.view endEditing:YES])
    {
    }
    else
    {
        if (moneyText.text.length !=0 )
        {
            NSString *subString = @".";
            NSArray *array = [moneyText.text componentsSeparatedByString:subString];
            NSInteger count = array.count - 1;
            NSString *str = [moneyText.text substringToIndex:1];
            
            NSString *regex =@"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
            
            NSPredicate *name = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([str isEqualToString:@"."]|| count>1 || [str isEqualToString:@"-"]|| ![name evaluateWithObject:moneyText.text])
            {
                moneyText.text = nil;
                moneyText.placeholder = @"0.00";
            }
        }
        if ([moneyText.text floatValue] == 0|| moneyText.text.length == 0)
        {
            moneyText.text = nil;
            moneyText.placeholder = @"0.00";
            [self.view makeToast:@"请输入金额"];
        }
        
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == moneyText )
    {
        if ([textField.text floatValue]==0 || textField.text.length == 0)
        {
            moneyText.text = nil;
            moneyText.placeholder = @"0.00";
            [self.view makeToast:@"请输入金额"];
        }
    }
    return YES;
    
}

- (void)payButton
{
    if (moneyText.text.length == 0)
    {
        [self.view endEditing:YES];
        [self.view makeToast:@"请输入金额"];
        
        return;
    }
    
    FNLoginIsScan = YES;
    
    if (![FNLoginBO isLogin])
    {
        return;
    }
    
    if (moneyText.text.length == 0)
    {
        [self.view endEditing:YES];
        [self.view makeToast:@"请输入金额"];
    }
    else
    {
        [FNLoadingView showInView:self.view];
        
        [[FNMyBO port02] getUserInfoWithBlock:^(id result) {
            
            [FNLoadingView hideFromView:self.view];
            
            if ([result isKindOfClass:[NSArray class]])
            {
                [_data addObjectsFromArray:result];
                
                FNPersonalModel *person = _data.lastObject;
                
                _personalModel = person;
                
                [[FNMainBO port03] getOrderPayListWithUserName:_personalModel.userName sellerDetailList:_sellerDetailList totalSum:moneyText.text tradeCode:_tradeCode block:^(id result) {
                    
                    if ([result[@"code"] integerValue] == 200)
                    {
                        [array addObjectsFromArray:result[@"orderIdList"]];
                        
                        FNPayVC *pay = [[FNPayVC alloc]init];
                        pay.isSpecialType = YES;
                        pay.orderIds = array;
                        pay.allPrice = moneyText.text;
                        pay.order = [[FNOrderArgs alloc]init];
                        pay.order.orderType = 1;
                        
                        [self.navigationController pushViewController:pay animated:YES];
                        
                        return ;
                    }
                    
                    if(result)
                    {
                        [UIAlertView alertViewWithMessage:result[@"desc"]];
                    }else
                    {
                        [self.view makeToast:@"加载失败,请重试"];
                    }
                }];

            }
        }];
    }
}


- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:0];
    
    [paragraphStyle setHeadIndent:0];
    
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length + string.length;
    if (num >8 )
    {
        if ([NSString isEmptyString:string])
        {
            CGFloat x = textField.x + 10;
            
            textField.frame = CGRectMake(x ,9 ,textField.width - 10,30 );
        }
        else
        {
            CGFloat x = textField.x - 10;
                
            textField.frame = CGRectMake(x ,9 ,textField.width + 10,30 );
        }
        if (num >16)
        {
            textField.frame = CGRectMake(200,9,170, 30);
        }
    }
    else
    {
        textField.frame = CGRectMake(kScreenWidth - 95,9, 90, 30);
    }
    if (textField == moneyText && num >16)
    {
        return NO;
    }
    return YES;
}

@end
