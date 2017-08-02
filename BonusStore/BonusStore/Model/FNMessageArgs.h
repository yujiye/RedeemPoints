//
//  FNMessageArgs.h
//  BonusStore
//
//  Created by Nemo on 16/5/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

@interface FNMessageArgs : FNBaseArgs

@property (nonatomic, strong) NSNumber *id;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *beginDate;

@property (nonatomic, strong) NSString *endDate;

@property (nonatomic, strong) NSString *createTime;

@end
