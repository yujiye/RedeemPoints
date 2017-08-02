//
//  FNMessageCenterVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

@interface FNMessageCenterVC : UIViewController

@property (nonatomic, assign) BOOL isNoti;

@property (nonatomic, assign) BOOL isMsg;

@property (nonatomic, assign) BOOL isOrderMsg;

@property (nonatomic, assign) BOOL isBonusMsg;

+ (void)setBonusMsg:(BOOL)bonusMsg;


@end
