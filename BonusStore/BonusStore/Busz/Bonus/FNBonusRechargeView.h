//
//  FNBonusRechargeView.h
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNBonusRechargeView : UIView

@property (nonatomic, strong) UITextField *cardNumText;

@property (nonatomic, strong) UITextField *cardPassText;

@property (nonatomic, strong) UIButton *rechargeRecord;

@property (nonatomic, strong) UIButton *rechargeBtn;

- (void)goRecargeRecordVC:(UIButtonActionBlock)block;

- (void)rechargeSuccessOrFaile:(UIButtonActionBlock)block;

@end
