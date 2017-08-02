//
//  FNStraddleService.m
//  BonusStore
//
//  Created by Nemo on 16/4/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNStraddleService.h"

FNStraddleType FNStraddleServiceType;

@implementation FNStraddleService

+ (void)setStraddleType:(FNStraddleType)type
{
    FNStraddleServiceType = type;
}

@end
