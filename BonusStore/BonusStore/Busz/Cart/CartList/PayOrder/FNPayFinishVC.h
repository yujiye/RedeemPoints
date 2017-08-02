//
//  FNPayFinishVC.h
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNPayFinishVC : FNBaseVC

@property (nonatomic, strong) NSString *bonus;

@property (nonatomic, copy)NSString *isVirtual;

@property (nonatomic, assign) BOOL isVirtualGoods;

@property (nonatomic, assign) BOOL isFinish;

@property (nonatomic,assign)BOOL isSpecialType;

@property (nonatomic, assign) int orderType;

@end
