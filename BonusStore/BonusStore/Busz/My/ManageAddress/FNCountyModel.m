//
//  FNCountyModel.m
//  BonusStore
//
//  Created by feinno on 16/5/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCountyModel.h"

@implementation FNCountyModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _id = [dict[@"id"] intValue];
        _name = dict[@"name"];
        _shortName = dict[@"shortName"];
    }
    return self;
}

+ (instancetype)cityWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}

+ (NSArray *) countyListWithDicts:(NSArray *) dicts
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:dicts.count];
    for (NSDictionary *dict in dicts) {
        FNCountyModel *county = [self cityWithDict:dict];
        [arrayM addObject:county];
    }
    return arrayM;
}


@end
