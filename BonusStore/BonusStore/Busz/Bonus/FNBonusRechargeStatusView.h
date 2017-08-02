//
//  FNBonusRechargeStatusView.h
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

@interface FNBonusRechargeStatusView : UIView

@property (nonatomic, strong) UIImageView *statusImg;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UILabel *successPromptLab;

@property (nonatomic, strong) UILabel *succSurplusLab;


@property (nonatomic, strong) UILabel *failLab;

@property (nonatomic, strong) UIButton *rechargeOrSpendBtn;

- (void)rechargeAction:(UIButtonActionBlock)block;


- (void)rechargeSuccess;

- (void)rechargeFail;

@end
