//
//  FNItemModel.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNBaseArgs.h"
#import "FNCommon.h"

@interface FNItemModel : FNBaseArgs

@property (nonatomic, strong) NSString * imageName;

@property (nonatomic, strong) NSString * title;

@property (nonatomic, strong) NSString * money;

@property (nonatomic, strong) NSString * integration;

@property (nonatomic, strong) NSString * subjectId;

@property (nonatomic, strong) NSString * productId;

@property (nonatomic, strong) NSString * productName;

@property (nonatomic, strong) NSString * viceName;

@property (nonatomic, strong) NSString *curPrice;

@property (nonatomic, strong) NSNumber *orgPrice;

@property (nonatomic, strong) NSString * imgUrl;

@property (nonatomic, assign) FNProductType type;

@end
