//
//  FNSZWelcomeVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/18.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZWelcomeVC.h"
#import "FNSZTongBO.h"
#import "FNLoginBO.h"
#import "UIImage+GIF.h"

@interface FNSZWelcomeVC ()

@end

@implementation FNSZWelcomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWith0xRGB(0xf3f3f3);
    
    self.title = @"深圳通";
    
    [self setNavigaitionSZTHelpItem];
    
    [self setNavigaitionBackItem];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HeightScale_IOS6(180))];
    
    logo.image = [UIImage imageNamed:@"szt_top_default_icon"];
    
    [self.view addSubview:logo];
    
    [logo setHorizonCenterWithSuperView:self.view];
    
    [[FNSZTongBO port01]getSZTCardImgListBlock:^(id result) {
        NSString *path = [result valueForKey:@"img"];
        NSURL *url = IMAGE_ID(path);
           [logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"szt_top_default_icon"]];
    }];
    
    
    UIImageView *processView = [[UIImageView alloc] initWithFrame:CGRectMake(0, logo.bottom + HeightScale_IOS6(20), kWindowWidth, HeightScale_IOS6(44))];
    
    processView.image = [UIImage imageNamed:@"szt_process"];
    
    [self.view addSubview:processView];
    
    [processView setHorizonCenterWithSuperView:self.view];
    
    UIView *buyBg = [[UIView alloc] initWithFrame:CGRectMake(15, processView.bottom+HeightScale_IOS6(20), kWindowWidth-30, HeightScale_IOS6(118))];
    
    buyBg.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:buyBg];
    
    [buyBg setCorner:6.0f];
    
    UILabel *buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  HeightScale_IOS6(25), buyBg.width, 12)];
    
    [buyLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    [buyLabel setText:@"先购券，再充值" align:NSTextAlignmentCenter];
    
    buyLabel.textColor = UIColorWith0xRGB(0x666666);
    
    buyLabel.font = [UIFont systemFontOfSize:12.0];
    
    [buyBg addSubview:buyLabel];

    UIButton *buyBut = [FNButton buttonWithType:FNButtonTypePlain title:@"购买充值券"];
    
    buyBut.backgroundColor = UIColorWith0xRGB(0xEF3030);
    
    buyBut.frame = CGRectMake(7.5, buyLabel.bottom + HeightScale_IOS6(25), buyBg.width-15, HeightScale_IOS6(36));
    
    [buyBut setCorner:3];
    
    buyBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
    
    [buyBut addSuperView:buyBg ActionBlock:^(id sender) {

        FNBuyCouponVC *buyCoponVC = [[FNBuyCouponVC alloc]init];
        [self.navigationController pushViewController:buyCoponVC animated:YES];
    }];
    
    UIView *rechargeBg = [[UIView alloc] initWithFrame:CGRectMake(15, buyBg.bottom+HeightScale_IOS6(15), kWindowWidth-30, HeightScale_IOS6(144))];
    
    rechargeBg.backgroundColor = [UIColor whiteColor];
    
    [rechargeBg setCorner:6.0f];
    
    [self.view addSubview:rechargeBg];
    
    UILabel *rechargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  HeightScale_IOS6(25), rechargeBg.width-60, 12)];
    
    [rechargeLabel clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    [rechargeLabel setText:@"已有券，直接充值" align:NSTextAlignmentCenter];
    
    rechargeLabel.textColor = UIColorWith0xRGB(0x666666);
    
    rechargeLabel.font = [UIFont systemFontOfSize:12.0];
    
    [rechargeBg addSubview:rechargeLabel];
    
    UIButton *rechargeBut = [FNButton buttonWithType:FNButtonTypePlain title:@"我的深圳通"];
    
    rechargeBut.frame = CGRectMake(15, buyLabel.bottom+HeightScale_IOS6(25), rechargeBg.width-30, HeightScale_IOS6(36));
    
    [rechargeBut setCorner:3];
    
    rechargeBut.backgroundColor = UIColorWith0xRGB(0xEF3030);
    
    rechargeBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
    
    [rechargeBut addSuperView:rechargeBg ActionBlock:^(id sender) {
        if (![FNLoginBO isLogin])
        {
            
            return ;
        }        
        FNShowCouponVC *VC = [[FNShowCouponVC alloc]init];
        
        [self.navigationController pushViewController:VC animated:YES];
        
    }];
    
    NSArray *tips = @[@"深圳通充值",@"余额查询",@"消费明细查询"];
    
    for (NSInteger i = 0; i < tips.count; i++) {
        
        NSString *title = tips[i];
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(i * rechargeBg.width / 3,  rechargeBut.bottom+HeightScale_IOS6(15), rechargeBg.width/3.0, 12)];
        
        [tip clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        tip.textColor = UIColorWith0xRGB(0x666666);
        
        [tip setText:title align:NSTextAlignmentCenter];
        
        [rechargeBg addSubview:tip];
        
        float width = [title boundingRectWithSize:CGSizeMake(kScreenWidth / 3, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size.width;
        
        UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectMake((tip.width - width) / 2 - 5, 4, 4, 4)];
        
        [dotLabel setCorner:2.0];
        
        dotLabel.backgroundColor = UIColorWith0xRGB(0x9B9B9B);
        
        [tip addSubview:dotLabel];
        
    }

    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(15,  rechargeBg.bottom + HeightScale_IOS6(15), kWindowWidth-30, 12)];
    
    [tip clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:UIColorWith0xRGB(0x4A90E2)];

    [tip setText:@"温馨提示：需要连接蓝牙盒子" align:NSTextAlignmentLeft];
    
    [self.view addSubview:tip];

    

    
}

@end
