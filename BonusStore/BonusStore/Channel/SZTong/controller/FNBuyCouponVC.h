//
//  FNBuyCouponVC.h
//  BonusStore
//
//  Created by cindy on 2017/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNQCoinRechargeVC.h"

@interface FNBuyCouponVC : UIViewController

@end

@interface FNSZCouponModel : NSObject

@property(nonatomic, copy) NSString * code;
@property(nonatomic, copy) NSString * desc;
@property(nonatomic, copy) NSString * price;

@end
