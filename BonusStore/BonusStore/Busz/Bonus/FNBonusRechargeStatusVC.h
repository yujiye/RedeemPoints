//
//  FNBonusRechargeStatusVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
@interface FNBonusRechargeStatusVC : UIViewController

@property (nonatomic, assign)FNBonusRechargeFailType failType;

@property (nonatomic, copy) NSString * rechargeFailStr;

@property (nonatomic, copy) NSString *successfulStr;

@property (nonatomic, copy) NSString *rechargeValue;

@property (nonatomic, assign) BOOL isFail;

@property (nonatomic, assign) NSInteger bonusTotal;


@end
