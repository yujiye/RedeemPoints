//
//  FNProvinceModel.m
//  BonusStore
//
//  Created by feinno on 16/5/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNProvinceModel.h"
#import "FNCityModel.h"
@implementation FNProvinceModel


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        _id  =  [dict[@"id"] intValue];
        _name   = dict[@"name"];
        NSArray *array = dict[@"cityList"];
        _cityList  = [FNCityModel cityListWithDicts:array];
        
    }
    return self;
}
+ (instancetype)provinceWithDict:(NSDictionary*)dict
{
    return [[self alloc]initWithDict:dict];
}

+ (NSArray *)provinceArray
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
    //    3.2 遍历字典数组
    for (NSDictionary *dict in array) {
        FNProvinceModel *provinceModel = [self provinceWithDict:dict];
        [arrayM addObject:provinceModel];
    }
    
    return arrayM;
}

@end
