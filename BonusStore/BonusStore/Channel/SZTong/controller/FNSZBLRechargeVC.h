//
//  FNSZBLRechargeVC.h
//  BonusStore
//
//  Created by Nemo on 17/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "FNCommon.h"

@class CBPeripheral;

@interface FNSZBLRechargeVC : UIViewController

@property (nonatomic , strong) CBPeripheral *model;

@property (nonatomic,copy) NSString * orderno;

@property (nonatomic,copy) NSString * moneyAmount;

@property (nonatomic , strong) NSString *path;

@property(nonatomic, assign)FNSZStateEntry stateEntry; //入口是余额查询还是充值

@end
