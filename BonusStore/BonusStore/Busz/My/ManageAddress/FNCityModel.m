//
//  FNCityModel.m
//  BonusStore
//
//  Created by feinno on 16/5/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCityModel.h"
#import "FNCountyModel.h"
@implementation FNCityModel


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        _id  = [dict[@"id"] intValue];
        _name = dict[@"name"];
        _shortName = dict[@"shortName"];
        NSArray * array = dict[@"New item"];
        
        _countyList = [FNCountyModel countyListWithDicts:array];
    }
    return self;
}

+ (instancetype)cityWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}

+ (NSArray *) cityListWithDicts:(NSArray *) arr
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:arr .count];
    for (NSDictionary *dict in arr ) {
        FNCityModel *city = [self cityWithDict:dict];
        [arrayM addObject:city];
    }
    return arrayM;
}

@end
