//
//  FNPayWayArgs.h
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

@interface FNPayWayArgs : FNBaseArgs

@property (nonatomic, strong) NSString *icon;

@property (nonatomic, strong) NSString *des;

+ (NSMutableArray *)initData ;


@end
