//
//  FNQCoinRechargeVC.m
//  BonusStore
//
//  Created by cindy on 2016/11/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "FNQCoinRechargeVC.h"
#import "FNButton.h"
#import "FNTextField.h"
#import "FNRechargeBO.h"
#import "FNLoginBO.h"

@interface FNQCoinRechargeVC ()<UITextFieldDelegate,FNTextFieldDelegate>

{
    NSString *_totalPrice;
}
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, assign) BOOL payBtnEnable;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) FNQCoinBtn *selectedBtn;
@property (nonatomic, weak) FNTextField *textField;

@end

@implementation FNQCoinRechargeVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigaitionBackItem];
    self.title = @"Q币充值";
    self.btnArr = [NSMutableArray array];
    [self addTextfeild];
    
    NSArray * titleArr = @[@"10",@"30",@"50",@"100",@"150",@"200",@"300",@"500"];
    UILabel * lineLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth, 1)];
    lineLabel.backgroundColor = UIColorWithRGB(222, 222, 222);
    [self.view addSubview:lineLabel];
    
    CGFloat marginX =  (kScreenWidth - 3*100)*0.25;
    for(int i =0; i<titleArr.count;i++)
    {
        FNQCoinBtn *coinBtn = [FNQCoinBtn buttonWithType:UIButtonTypeCustom];
        coinBtn.frame = CGRectMake(marginX+(marginX+100)*(i%3), 20+(60+20)*(i/3)+90, 100 ,60);
        coinBtn.layer.cornerRadius = 4;
        coinBtn.layer.masksToBounds = YES;
        coinBtn.btnSelected = NO;
        coinBtn.enabled = NO;
        coinBtn.layer.borderColor = UIColorWithRGB(180.0, 180.0, 180.0).CGColor;
        coinBtn.layer.borderWidth = 1;
        [coinBtn setTitle:[NSString stringWithFormat:@"%@Q币",titleArr[i]] forState:UIControlStateNormal];
        [coinBtn setTitleColor:UIColorWithRGB(51.0, 51.0, 51.0) forState:UIControlStateNormal];
        [coinBtn addTarget:self action:@selector(coinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        coinBtn.titleLabel.font = [UIFont fzltWithSize:14];
        [self.btnArr addObject:coinBtn];
        [self.view addSubview:coinBtn];
    }
   
    [self addPaybtn];
}

- (void)setPayBtnEnable:(BOOL)payBtnEnable
{
    _payBtnEnable = payBtnEnable;
    if (_payBtnEnable == YES)
    {
        _payBtn.enabled = YES;
        _payBtn.backgroundColor = [UIColor redColor];

    }else
    {
        _payBtn.enabled = NO;
        _payBtn.backgroundColor = UIColorWithRGB(212, 212, 212);

    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.btnArr enumerateObjectsUsingBlock:^(FNQCoinBtn * obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
        obj.btnSelected = NO;
    }];
    _payBtn.enabled = NO;
    _payBtn.backgroundColor = UIColorWithRGB(212, 212, 212);
    _moneyLab.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 查询QQ号是否合法，查询价格
    if(![self isValidNumber:textField.text])
    {
        [self.view makeToast:@"请输入5-20位的QQ号"];
        return;
    }
 
    [self.btnArr enumerateObjectsUsingBlock:^(FNQCoinBtn * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = YES;
        if(idx == 0)
        {
            obj.btnSelected = YES;

            _selectedBtn = obj;
            [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            
        }else
        {
            obj.btnSelected = NO;
            [obj setTitleColor:UIColorWithRGB(51.0, 51.0, 51.0) forState:UIControlStateNormal];

        }
        
    }];
    NSString * mo = [_selectedBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"Q币" withString:@""];
    _totalPrice = mo;
    NSString *moneyStr2 = [NSString stringWithFormat:@"总额: ¥ %@",mo];
    NSMutableAttributedString *money = [moneyStr2 makeStr:mo withColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] andFont:[UIFont systemFontOfSize:15]];
    _moneyLab.attributedText = money;
    _moneyLab.hidden = NO;
    self.payBtnEnable = YES;
}

- (void)coinBtnClick:(FNQCoinBtn *)btn
{
    btn.btnSelected = !btn.btnSelected;
    for (FNQCoinBtn * button in self.btnArr)
    {
        if ([button isEqual:btn])
        {
            button.btnSelected = btn.btnSelected;
            _selectedBtn = btn;
            if(button.btnSelected == NO)
            {
                [button setTitleColor:UIColorWithRGB(51.0, 51.0, 51.0) forState:UIControlStateNormal];

            }else
            {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            }
        }else
        {
            button.btnSelected = NO;
            [button setTitleColor:UIColorWithRGB(51.0, 51.0, 51.0) forState:UIControlStateNormal];

        }
    }
    
    NSString * mo = [_selectedBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"Q币" withString:@""];
    _totalPrice = mo;
    NSString *moneyStr2 = [NSString stringWithFormat:@"总额: ¥ %@",mo];
    NSMutableAttributedString * money = [moneyStr2 makeStr:mo withColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] andFont:[UIFont systemFontOfSize:15]];
    _moneyLab.attributedText = money;
    _moneyLab.hidden = NO;
    self.payBtnEnable = YES;
}

- (void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (BOOL) isValidNumber:(NSString*)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    const char *cvalue = [value UTF8String];
    unsigned long len = strlen(cvalue);
    if(len<5 ||len>20)
    {
        return NO;
    }
    for (int i = 0; i < len; i++) {
        if(! isnumber(cvalue[i])){
            return NO;
        }
    }
    return YES;
}

- (void)payButtonClick:(UIButton *)btn
{
    if (![FNLoginBO isLogin])
    {
        
        return ;
    }
    [FNLoadingView showInView:self.view];
    [[FNRechargeBO port02] rechargeMoneyWithTotalSum:_totalPrice flowno:nil company:nil provinceName:[self getIPAddress] receiverMobile:self.textField.text block:^(id result)
    {
        [FNLoadingView hide];
        
        if ([result[@"code"] integerValue] == 200)
        {
            FNPayVC *payVC = [[FNPayVC alloc]init];
            payVC.isSpecialType = YES;
            payVC.tradeCode = @"Z8005";
            payVC.orderIds = result[@"orderIdList"];
            payVC.allPrice = _totalPrice;
            [self.navigationController pushViewController:payVC animated:YES];
        }
        else if([result [@"code"] integerValue ] == 500 ||[result [@"code"] integerValue ] == 400 )
        {
            [UIAlertView alertViewWithMessage:result[@"desc"]];
        }
        else
        {
            [self.view makeToast:@"加载失败,请重试"];
        }
    }];
    
}

- (void)addTextfeild
{
    FNTextField *textField = [[FNTextField alloc]initWithFrame:CGRectMake(15, 25, kScreenWidth-30, 44)];
    textField.layer.cornerRadius = 4;
    textField.layer.masksToBounds = YES;
    textField.backgroundColor = UIColorWithRGB(222, 222, 222);
    textField.placeholder = @"请输入您的QQ号码";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField setValue:UIColorWithRGB(176, 176, 176) forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont fzltWithSize:16] forKeyPath:@"_placeholderLabel.font"];
    textField.delegate = self;
    textField.textFieldDelegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField = textField;
    [self.view addSubview:textField];

}

- (void)addPaybtn
{
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.enabled = NO;
    _payBtn.backgroundColor = UIColorWithRGB(212, 212, 212);
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    _payBtn.frame = CGRectMake(15, kScreenHeight - 40-10-64, kScreenWidth -30, 40);
    [_payBtn addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _payBtn.titleLabel.font = [UIFont fzltWithSize:18];
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    [self.view addSubview:_payBtn];
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _payBtn.y-10-25, kScreenWidth, 25)];
    _moneyLab.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    _moneyLab.font = [UIFont systemFontOfSize:12];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.hidden = YES;
    [self.view addSubview:_moneyLab];
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

@end



@implementation FNQCoinBtn

- (void)setBtnSelected:(BOOL)btnSelected
{
    _btnSelected = btnSelected;
    if(_btnSelected == YES)
    {
       self.backgroundColor = [UIColor redColor];
    }else
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
}

@end


