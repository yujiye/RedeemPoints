//
//  FNSZBLRechargeVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZBLRechargeVC.h"
#import "CardAPI.h"
#import "FNHeader.h"
#import "UIImage+GIF.h"

@interface FNSZBLRechargeVC ()
{
    UIView *_rechargeView;
    
    UIView *_unRechargeView;
    
    UIView *_failedChargeView;
    
    UILabel * _percentLabel;
    
    UILabel *_tipLabel;
}

@end

@implementation FNSZBLRechargeVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BluetoothAPI sharedManager] disConnectDevice:_model];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"贴卡";
    [self setNavigaitionBackItem];
    [self unRecharging];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)goBack
{
    if(self.stateEntry == FNSZStateEntryBalance)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(self.stateEntry == FNSZStateEntryRecharge||self.stateEntry == FNSZStateEntryDetail ||self.stateEntry == FNSZStateEntryCheckCard )
    {
      FNSZDetailVC * detailVC = [[FNSZDetailVC alloc]init];
      detailVC.stateEntry = self.stateEntry;
      detailVC.orderno = self.orderno;
     [self.navigationController pushViewController:detailVC animated:YES];
    }
   
}

- (void)unRecharging
{
    _unRechargeView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_unRechargeView];
    
    UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(30,  52, kWindowWidth-60, 12)];
    
    [tipLab clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWith0xRGB(0x333333)];
    
    [tipLab setText:@"请将深圳通卡置于蓝牙盒子上" align:NSTextAlignmentCenter];
    
    [_unRechargeView addSubview:tipLab];
    
    UIImageView *bluetoothSignalView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 173) / 2, tipLab.bottom + 20, 173, 229)];
    
    bluetoothSignalView.image = [UIImage imageNamed:@"szt_bluetooth_book"];
    
    bluetoothSignalView.contentMode = UIViewContentModeCenter;
    
    [_unRechargeView addSubview:bluetoothSignalView];
    
    [bluetoothSignalView setHorizonCenterWithSuperView:_unRechargeView];
    
    [[BluetoothAPI sharedManager] didConnectDevice:_model];
    
    [self beginCheck];
    
}

- (void)beginCheck
{
    
    if ([BluetoothAPI sharedManager].state == CBPeripheralStateConnected) {

        if(self.stateEntry == FNSZStateEntryCheckCard)
        {
            //验卡
            OrderReq *orderReq  = [OrderReq new];
            
            orderReq.orderMoney = _moneyAmount;
            
            NSDictionary * user = [FNUserAccountArgs getUserAccount];
            
            orderReq.orderNo = _orderno;
            
            orderReq.orderType = charge;
            
            orderReq.token = [NSString stringWithFormat:@"%@" , FNUserAccountInfo[@"token"]];
            
            orderReq.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
            
            orderReq.phoneNo =  [NSString stringWithFormat:@"%@" , [user valueForKey:@"mobile"]];

            [[CardAPI sharedManager]startonLineChecking:orderReq success:^(RequestResult *requestResult) {
                if (requestResult.status == Processing) {
                    
                    float progress = [requestResult.code integerValue] / 10.0;
                    UIReframeWithW(_percentLabel, (kScreenWidth - 106) * progress);

                }else if (requestResult.status == ReceiveRfm){// 贴卡成功
                    for (UIView *view1 in self.view.subviews)
                    {
                        [view1 removeFromSuperview];
                    }
                    [self recharging];

                }else if (requestResult.status == TimeOut){ // 未贴卡
                    
                }else{ // 验卡成功
                    UIReframeWithW(_percentLabel, kScreenWidth - 106);
                    FNSZDetailVC * detailVC = [[FNSZDetailVC alloc]init];
                    detailVC.stateEntry = self.stateEntry;
                    detailVC.orderno = self.orderno;
                    [self.navigationController pushViewController:detailVC animated:YES];
                   
                }
            } failure:^(RequestResult *requestResult) {
        
                FNSZDetailVC * detailVC = [[FNSZDetailVC alloc]init];
                detailVC.stateEntry = self.stateEntry;
                detailVC.orderno = self.orderno;
                [self.navigationController pushViewController:detailVC animated:YES];
                
            } unkown:^(RequestResult *requestResult) {
               
            }];
            
        }else
        {

            OrderReq *orderReq  = [OrderReq new];
            
            orderReq.orderMoney = _moneyAmount;
            
            NSDictionary * user = [FNUserAccountArgs getUserAccount];
            
            orderReq.orderNo = _orderno;
            
            orderReq.orderType = charge;
            
            orderReq.token = [NSString stringWithFormat:@"%@" , FNUserAccountInfo[@"token"]];
            
            orderReq.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
            
            orderReq.phoneNo =  [NSString stringWithFormat:@"%@" , [user valueForKey:@"mobile"]];
            
            [[CardAPI sharedManager] startCharge:orderReq success:^(RequestResult *requestResult) {
                
                if (requestResult.status == Processing)
                {
                    float progress = [requestResult.code integerValue] / 10.0;
                    UIReframeWithW(_percentLabel, (kScreenWidth - 106) * progress);
                }else if (requestResult.status == ReceiveRfm){// 贴卡成功
                    for (UIView *view1 in self.view.subviews)
                    {
                        [view1 removeFromSuperview];
                    }
                    if (!_path)
                    {
                        [self recharging];
                        
                    }else{
                        
                        FNMyOrderVC *VC = [[FNMyOrderVC alloc] init];
                        VC.model = _model;
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                }else if (requestResult.status == TimeOut){
                    // 未贴卡
                }else if (requestResult.status == OverCharge)
                {
                    FNSZDetailVC * detailVC = [[FNSZDetailVC alloc]init];
                    detailVC.stateEntry = self.stateEntry;
                    detailVC.overRecharge = YES;
                    detailVC.orderno = self.orderno;
                    [self.navigationController pushViewController:detailVC animated:YES];
                    
                }else{ // 充值成功
                    UIReframeWithW(_percentLabel, kScreenWidth - 106);
                    NSString *cardNo = [requestResult.resultInfo objectForKey:@"cardNo"]; //卡号
                     NSString *overMoney = [requestResult.resultInfo objectForKey:@"overMoney"]; //充值前余额
                    FNSZSuccessVC *VC = [[FNSZSuccessVC alloc] init];
                    VC.moneyAmount = self.moneyAmount;
                    VC.orderNo = self.orderno;
                    VC.model = self.model;
                    VC.cardno = cardNo;
                    VC.beforeRestMoney = overMoney;
                    [self.navigationController pushViewController:VC animated:YES];
            
                }
            } failure:^(RequestResult *requestResult) { // 充值失败
                if(self.stateEntry == FNSZStateEntryBalance)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                if(self.stateEntry == FNSZStateEntryRecharge||self.stateEntry==FNSZStateEntryDetail)
                {
                    
                    FNSZDetailVC * detailVC = [[FNSZDetailVC alloc]init];
                    
                    detailVC.stateEntry = self.stateEntry;
                    if (requestResult.status == OverCharge) //一个卡超过三次
                    {
                        detailVC.overRecharge = YES;
                    }else
                    {
                        detailVC.overRecharge = NO;
                        
                    }
                    detailVC.orderno = self.orderno;
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
                
            } unkown:^(RequestResult *requestResult) { // 未知状态
               
            }];
        }

    }
    

}
    
- (void)recharging
{
    
    _rechargeView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_rechargeView];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    
    logoView.image = [UIImage sd_animatedGIFNamed:@"szt_charging_icon"];
    
    logoView.frame = CGRectMake((kScreenWidth - logoView.image.size.width) / 2, 60, logoView.image.size.width, logoView.image.size.height);
    
    [self.view addSubview:logoView];
    
    [_rechargeView addSubview:logoView];

    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  logoView.bottom, kWindowWidth, 50)];
    
    if (self.stateEntry ==FNSZStateEntryCheckCard)
    {
        [_tipLabel setText:@"小淘正在拼命验卡中，请保持贴卡，切勿移动哦。" align:NSTextAlignmentCenter];

    }else
    {
        [_tipLabel setText:@"小淘正在拼命充值中，请保持贴卡，切勿移动哦。" align:NSTextAlignmentCenter];

    }
    [_tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWith0xRGB(0x333333)];
    
    [_rechargeView addSubview:_tipLabel];
    
    UILabel *pregressLabel = [[UILabel alloc]initWithFrame:CGRectMake(53,  _tipLabel.bottom+30, kWindowWidth-106, 14)];
    
    pregressLabel.layer.masksToBounds = YES;
    
    pregressLabel.layer.borderWidth = 0.5;
    
    pregressLabel.backgroundColor = [UIColor clearColor];
    
    pregressLabel.layer.borderColor = [UIColorWith0xRGB(0x5DA0EC) CGColor];
    
    [pregressLabel setCorner:6.0];
    
    [_rechargeView addSubview:pregressLabel];
    
    _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(53,  _tipLabel.bottom+30, kWindowWidth-106, 14)];
    
    [_percentLabel setCorner:6.0];
    
    UIReframeWithW(_percentLabel, 0);
    
    _percentLabel.backgroundColor = UIColorWith0xRGB(0x5DA0EC);
    
    [_rechargeView addSubview:_percentLabel];
    
}

- (void)reCharge
{
    _failedChargeView.hidden = YES;
    [self beginCheck];
}
@end
