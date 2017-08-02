//
//  FNSZBLRechargeIntroVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZBLRechargeIntroVC.h"

@interface FNSZBLRechargeIntroVC ()

@end

@implementation FNSZBLRechargeIntroVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"使用说明";
    
    [self setNavigaitionBackItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16,  30, kWindowWidth-32, 14)];
    
    [titleLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWith0xRGB(0x333333)];
    
    [titleLabel setText:@"iOS系统用户" align:NSTextAlignmentLeft];
    
    [self.view addSubview:titleLabel];
    
    UILabel *tip1 = [[UILabel alloc]initWithFrame:CGRectMake(16,  titleLabel.bottom+10, kWindowWidth-32, 70)];
    
    [tip1 clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWith0xRGB(0x666666)];
    
    [tip1 setText:@"1.打开蓝牙盒子开关，并开启蓝牙功能。\n2.选择充值券并确定。无充值券时需先进行购买。\n3.点击下图【搜索蓝牙设备】按钮，系统将自动搜索蓝牙盒子" align:NSTextAlignmentLeft];
    
    [tip1 setNumberOfLines:0];
    
    [self.view addSubview:tip1];
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(16, tip1.bottom+10, WidthScale_IOS6(150), 238)];
    
    leftView.image = [UIImage imageNamed:@"szt_blconnectingeg_icon"];
    
    [self.view addSubview:leftView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(leftView.right + WidthScale_IOS6(25), leftView.y, leftView.width, 238)];
    
    rightView.image = [UIImage imageNamed:@"szt_blconnecteg_icon"];
    
    [self.view addSubview:rightView];
    
    
    UILabel *tip4 = [[UILabel alloc]initWithFrame:CGRectMake(16,  leftView.bottom+20, kWindowWidth-32, 34)];
    
    tip4.numberOfLines = 0;
    
    [tip4 clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWith0xRGB(0x666666)];
    
    [tip4 setText:@"4.贴卡充值。搜索成功后出现贴卡界面，将需充值的深圳通卡放在蓝牙盒子上面即可。" align:NSTextAlignmentLeft];
    
    [self.view addSubview:tip4];
    
    
}



@end
