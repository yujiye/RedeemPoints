
//
//  FNCountyModel.h
//  BonusStore
//
//  Created by feinno on 16/5/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface FNCountyModel : NSObject


@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * shortName;

+ (NSArray *) countyListWithDicts:(NSArray *) dicts;

@end
