//
//  FNSZPayFinishVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/18.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZPayFinishVC.h"

@interface FNSZPayFinishVC ()

@end

@implementation FNSZPayFinishVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"支付成功";
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self setNavigaitionSZTHelpItem];
    
    [self setNavigaitionBackItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *finishLogo = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 109) / 2, 30, 109, 109)];
    
    finishLogo.image = [UIImage imageNamed:@"szt_charge_success"];
    
    [self.view addSubview:finishLogo];
    
    [finishLogo setHorizonCenterWithSuperView:self.view];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  finishLogo.bottom + 13, kWindowWidth, 42)];

    tipLabel.textColor = UIColorWith0xRGB(0x4A4A4A);
    
    tipLabel.font = [UIFont systemFontOfSize:14.0];
    
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    tipLabel.numberOfLines = 0;
    
    tipLabel.text = @"恭喜您，购券成功\n请前往进行深圳通充值";
    
    [self.view addSubview:tipLabel];
    
    UIButton *rechargeBut = [FNButton buttonWithType:FNButtonTypePlain title:@"立即充值"];
    
    rechargeBut.frame = CGRectMake(15, tipLabel.bottom+30, kWindowWidth-30, 45);
    
    [rechargeBut setCorner:4.0f];
    
    rechargeBut.backgroundColor = UIColorWith0xRGB(0xEF3030);
    
    rechargeBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
    
    [rechargeBut addTarget:self action:@selector(goCharge) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:rechargeBut];
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(tipLabel.x, rechargeBut.bottom+25, tipLabel.width, 14)];
    
    [detailLabel addTarget:self action:@selector(goDetail)];
    
    [detailLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    detailLabel.textColor = UIColorWith0xRGB(0xEF3030);
    
    detailLabel.textAlignment = NSTextAlignmentCenter;
    
    detailLabel.text = @"查看购券详情";
    
    [self.view addSubview:detailLabel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

// 查看券详情
- (void)goDetail
{
    FNOrderVC *orderVC = [[FNOrderVC alloc]init];
    orderVC.stateTag = FNTitleTypeOrderStateShipping;
    orderVC.isPayFinish = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)goBack
{
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *VC = self.navigationController.viewControllers[i];
        
        if ([VC isKindOfClass:[FNBuyCouponVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KRemoveTestPIc" object:nil userInfo:@{@"position":@(i)}];
            [self.navigationController popToViewController:VC animated:NO];
            return;
        }
        
        if ([VC isKindOfClass:[FNOrderVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KRemoveTestPIc" object:nil userInfo:@{@"position":@(i)}];
            // 通知页面刷新
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@(((FNOrderVC*)VC).stateTag) forKey:@"getGoodsState"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clickGetGoods" object:nil userInfo:dic];
            
            [self.navigationController popToViewController:VC animated:NO];
            return;
        }
       
    }
}
// 去充值 先创建充值订单
- (void)goCharge
{
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
        UIViewController *VC = self.navigationController.viewControllers[i];

        
        if ([VC isKindOfClass:[FNOrderVC class]]) {
            // 通知页面刷新
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@(((FNOrderVC*)VC).stateTag) forKey:@"getGoodsState"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"clickGetGoods" object:nil userInfo:dic];
    }
        
    }
    FNShowCouponVC * showVC  = [[FNShowCouponVC alloc]init];
    [self.navigationController pushViewController:showVC animated:YES];
}

@end
