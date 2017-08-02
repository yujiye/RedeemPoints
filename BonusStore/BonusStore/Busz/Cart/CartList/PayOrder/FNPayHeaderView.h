//
//  FNPayHeaderView.h
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNPayHeaderView : UIView

@property (nonatomic, strong) NSDecimalNumber *price;

@property (nonatomic, assign) NSInteger bonus;

@property (nonatomic, strong) UISwitch *switchBut;

@property (nonatomic, assign)BOOL isSpecialType;

- (void)switchStateBlock:(void (^) (UISwitch *sender))block;

@end
