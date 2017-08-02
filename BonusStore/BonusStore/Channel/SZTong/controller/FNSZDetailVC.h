//
//  FNSZDetailVC.h
//  BonusStore
//
//  Created by cindy on 2017/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBPeripheral;

#import "FNHeader.h"

@interface FNSZDetailVC : UIViewController

@property (nonatomic,assign)FNSZRechargeState rechargeState; // 充值状态

@property (nonatomic, copy) NSString *orderno;

@property (nonatomic , strong) CBPeripheral *model;

@property(nonatomic,assign)FNSZStateEntry stateEntry; //入口是余额查询还是充值

@property (nonatomic,assign)BOOL overRecharge;
@end
