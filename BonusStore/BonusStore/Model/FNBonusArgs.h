//
//  FNBonusArgs.h
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

@interface FNBonusArgs : FNBaseArgs

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *bonus;

@property (nonatomic, assign) BOOL type;

+ (NSArray *)getAll;

@end
