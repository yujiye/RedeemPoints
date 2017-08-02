//
//  FNSZSuccessVC.h
//  BonusStore
//
//  Created by cindy on 2017/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBPeripheral;

@interface FNSZSuccessVC : UIViewController

@property (nonatomic,copy) NSString * orderNo; //订单号

@property (nonatomic,copy) NSString * moneyAmount; //充值金额

@property (nonatomic,copy) NSString * beforeRestMoney; //充值前金额

@property (nonatomic,copy) NSString * cardno; //卡号

@property (nonatomic , strong) CBPeripheral *model;

@end
