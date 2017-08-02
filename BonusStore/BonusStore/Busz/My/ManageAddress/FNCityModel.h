//
//  FNCityModel.h
//  BonusStore
//
//  Created by feinno on 16/5/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNCityModel : NSObject


@property (nonatomic, assign) int id;
@property (nonatomic,copy) NSString * shortName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *countyList;

+ (instancetype)cityWithDict:(NSDictionary*)dict;

+ (NSArray *) cityListWithDicts:(NSArray *) arr;

@end
