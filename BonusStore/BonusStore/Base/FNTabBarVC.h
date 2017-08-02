//
//  XMTabbarVC.h
//  BonusStore
//
//  Created by Nemo on 15/12/27.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNNavigationController.h"

UIKIT_EXTERN NSString *const FNCartBadgeUpdateNotification;

UIKIT_EXTERN NSString *const FNUserAccountIsLoginNotification;

UIKIT_EXTERN NSString * const FNUserAccountCancelNotification;

@interface FNTabBarVC : UITabBarController

@property (nonatomic, assign) NSUInteger tabSelectedIndex; //跳转到指定vc index

@end
