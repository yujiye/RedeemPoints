//
//  FNBuyCouponVC.m
//  BonusStore
//
//  Created by cindy on 2017/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNBuyCouponVC.h"
#import "FNHeader.h"
#import "FNLoginBO.h"
#import "FNSZTongBO.h"
#import "Mask.h"
#import "FNHeader.h"

@interface FNBuyCouponVC ()

@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, assign) BOOL payBtnEnable;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) FNQCoinBtn *selectedBtn;
@property (nonatomic, strong) UILabel * intrLab;

@end

@implementation FNBuyCouponVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购买充值券";
    
    [self setNavigaitionBackItem];
    [self setNavigaitionSZTHelpItem];
    CGFloat marginX =  (kScreenWidth - 3*105)*0.25;
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(marginX, 0, kScreenWidth- 2*marginX, 64)];
    tipLabel.text = @"购买充值券";
    tipLabel.textColor = [UIColor blackColor];
    [self.view addSubview:tipLabel];
    [self addPaybtn];
    self.btnArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];

    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
    [[[FNSZTongBO port01] withOutUserInfo]getCouponListBlock:^(id result) {
        [Mask HUDHideInView:self.view];

        if ([result[@"code"] integerValue]==200)
        {
            if (![result[@"cardList"] isKindOfClass:[NSNull class]])
            {
             for ( NSDictionary * dict in result[@"cardList"])
             {
                [self.titleArr addObject:[FNSZCouponModel mj_objectWithKeyValues:dict]];
                 
             }
                for(int i =0; i<self.titleArr.count;i++)
                {
                    FNSZCouponModel * model =  self.titleArr[i];
                    FNQCoinBtn *coinBtn = [FNQCoinBtn buttonWithType:UIButtonTypeCustom];
                    coinBtn.frame = CGRectMake(marginX+(marginX+105)*(i%3), 20+(50+20)*(i/3)+44, 105 ,50);
                    coinBtn.layer.cornerRadius = 4;
                    coinBtn.layer.masksToBounds = YES;
                    coinBtn.tag = i ;
                    coinBtn.layer.borderColor = UIColorWithRGB(180.0, 180.0, 180.0).CGColor;
                    coinBtn.layer.borderWidth = 1;
                    [coinBtn setTitle:[NSString stringWithFormat:@"%@元券",model.price] forState:UIControlStateNormal];
                    [coinBtn setTitleColor:UIColorWith0xRGB(0x4A4A4A) forState:UIControlStateNormal];
                    [coinBtn addTarget:self action:@selector(coinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    coinBtn.titleLabel.font = [UIFont fzltWithSize:14];
                    if(i == 0)
                    {
                        coinBtn.btnSelected = YES;
                        coinBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buyCoupon_sz"]];
                        coinBtn.layer.borderColor = [UIColor clearColor].CGColor;
                        [coinBtn setTitleColor:UIColorWith0xRGB(0xEF3030) forState:UIControlStateNormal];
                        NSString *moneyStr2 = [NSString stringWithFormat:@"总额: ¥ %@",model.price];
                        NSMutableAttributedString * moneyAtt = [moneyStr2 makeStr:model.price withColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] andFont:[UIFont systemFontOfSize:15]];
                        _moneyLab.attributedText = moneyAtt;
                    }else
                    {
                        coinBtn.btnSelected = NO;
                    }
                    
                    [self.btnArr addObject:coinBtn];
                    [self.view addSubview:coinBtn];
                }
                
            }
            if (![result[@"descList"] isKindOfClass:[NSNull class]])
            {
                NSArray * arr = result[@"descList"];
                NSMutableString * stringM  =[NSMutableString string];
                for (int i =0;i <arr.count ;i++)
                {
                    [stringM appendString:[NSString stringWithFormat:@"%@\n",arr[i]]];
                }
                self.intrLab.text = stringM;
            }
            
        }else
        {
            self.payBtnEnable = NO;
            NSString * toast = @"获取卡券列表失败";
            if (![NSString isEmptyString:result[@"desc"]])
            {
                toast = result[@"desc"];
            }
            [self.view makeToast:toast];
        }
    }];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

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

- (void)addPaybtn
{
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.enabled = YES;
    _payBtn.backgroundColor = UIColorWith0xRGB(0xEF3030);
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    _payBtn.frame = CGRectMake(15, kScreenHeight - 40-64 - 200, kScreenWidth -30, 40);
    [_payBtn addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _payBtn.titleLabel.font = [UIFont fzltWithSize:18];
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    [self.view addSubview:_payBtn];
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _payBtn.y-10-25, kScreenWidth, 25)];
    _moneyLab.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    _moneyLab.font = [UIFont systemFontOfSize:12];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyLab];
    
    UIButton * goUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goUseBtn setTitleColor:UIColorWith0xRGB(0xEF3030) forState:UIControlStateNormal];
    [goUseBtn setTitle:@"已有券，去使用" forState:UIControlStateNormal];
    goUseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [goUseBtn addTarget:self action:@selector(gouseClick) forControlEvents:UIControlEventTouchUpInside];
    goUseBtn.frame = CGRectMake(kScreenWidth -15-110, CGRectGetMaxY(_payBtn.frame),110 , 44);
    [self.view addSubview:goUseBtn];
    
    _intrLab =[[UILabel alloc]initWithFrame:CGRectMake(15, kScreenHeight-85-10-64, kScreenWidth -30, 85)];
    _intrLab.numberOfLines = 0;
    _intrLab.textColor = UIColorWith0xRGB(0x999999);
    if (IS_IPHONE_5)
    {
        _intrLab.font = [UIFont systemFontOfSize:11.9];
 
    }else
    {
        _intrLab.font = [UIFont systemFontOfSize:12];

    }
    [self.view addSubview:_intrLab];
    
}

//已有券，去使用
- (void)gouseClick
{
    if (![FNLoginBO isLogin])
    {
        
        return ;
    }
    FNShowCouponVC * showCouponVC  = [[FNShowCouponVC alloc]init];
    [self.navigationController pushViewController:showCouponVC animated:YES];
}

//点击购买充值券
- (void)payButtonClick:(UIButton *)btn
{
    if (![FNLoginBO isLogin])
    {
        return ;
    }
    NSInteger selInt  = _selectedBtn.tag;
    FNSZCouponModel * selModel  = self.titleArr[selInt];
    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
    [[FNSZTongBO port02]rechargeMoneyWithTotalSum:selModel.price flowno:selModel.code block:^(id result) {

        if ([result[@"code"] integerValue] == 200)
        {
            [Mask HUDHideInView:self.view];

            FNPayVC *payVC = [[FNPayVC alloc]init];
            payVC.tradeCode = @"Z8007";
            payVC.isSpecialType  = YES;
            payVC.orderIds = result[@"orderIdList"];
            payVC.allPrice = selModel.price;
            [self.navigationController pushViewController:payVC animated:YES];
        }else
        {
            [Mask HUDHideInView:self.view];

            NSString * toast = @"下单失败,请重试";
            
            if (![NSString isEmptyString:result[@"desc"]])
            {
                toast = result[@"desc"];
            }
            [self.view makeToast:toast];
        }
    }];

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
                [button setTitleColor:UIColorWith0xRGB(0x4A4A4A) forState:UIControlStateNormal];
                
            }else
            {
                [button setTitleColor:UIColorWith0xRGB(0xEF3030) forState:UIControlStateNormal];
            }
        }else
        {
            button.btnSelected = NO;
            [button setTitleColor:UIColorWith0xRGB(0x4A4A4A) forState:UIControlStateNormal];
        }
        button.layer.borderColor =UIColorWith0xRGB(0xDCDADA).CGColor;
    }
    _selectedBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buyCoupon_sz"]];
    _selectedBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [_selectedBtn setTitleColor:UIColorWith0xRGB(0xEF3030) forState:UIControlStateNormal];
    NSString * money = [_selectedBtn.titleLabel.text stringByReplacingOccurrencesOfString:@"元券" withString:@""];
    NSString *moneyStr2 = [NSString stringWithFormat:@"总额: ¥ %@",money];
    NSMutableAttributedString * moneyAtt = [moneyStr2 makeStr:money withColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] andFont:[UIFont systemFontOfSize:15]];
    _moneyLab.attributedText = moneyAtt;
    self.payBtnEnable = YES;
}


@end

@implementation FNSZCouponModel

@end
