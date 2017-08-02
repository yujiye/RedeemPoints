//
//  FNProvinceModel.h
//  BonusStore
//
//  Created by feinno on 16/5/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

@interface FNProvinceModel : NSObject

@property (nonatomic, strong) NSArray* cityList;
@property (nonatomic, copy)   NSString * name;
@property (nonatomic,copy) NSString *shortName;
@property (nonatomic, assign) int id;

- (instancetype) initWithDict:(NSDictionary *) dict;
+ (instancetype)provinceWithDict:(NSDictionary*)dict;

+ (NSArray *) provinceArray;

@end
