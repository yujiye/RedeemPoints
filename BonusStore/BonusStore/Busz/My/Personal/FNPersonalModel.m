//
//  FNPersonalModel.m
//  BonusStore
//
//  Created by sugarwhi on 16/5/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPersonalModel.h"

@implementation FNPersonalModel

- (NSString *)getGender
{
    return [self getGenderBySex:_sex];
}

- (NSString *)getGenderBySex:(NSInteger)sex
{
    switch (sex)
    {
        case 0:
            return @"保密";
        case 1:
            return @"男";
        case 2:
           return @"女";
    }
    return @"";
}

@end

