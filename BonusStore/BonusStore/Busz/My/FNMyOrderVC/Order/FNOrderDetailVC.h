//
//  FNOrderViewController.h
//  BonusStore
//
//  Created by qingPing on 16/4/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNButton.h"

@interface FNOrderDetailVC : UIViewController

@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, assign) FNOrderState state;

@property (nonatomic, assign) BOOL isVirtualGoods;

@property (nonatomic, assign)FNTitleType titleState;

@property (nonatomic, assign)NSInteger timeOutLimit;

- (instancetype)initWithState:(FNOrderState)state;

@end
