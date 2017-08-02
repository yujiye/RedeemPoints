//
//  FNSysteModel.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNBaseArgs.h"

@interface FNSysteModel : FNBaseArgs

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSNumber *pushTarget;

@property (nonatomic, copy) NSNumber *status;

@property (nonatomic, copy) NSNumber *id;

@end
