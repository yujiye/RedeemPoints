//
//  FNBonusArgs.m
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusArgs.h"

@implementation FNBonusArgs

+ (NSArray *)getAll
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i<10; i++)
    {
        
        NSDictionary *d = @{@"des":@"消费积分",@"time":@"2015-5-5",@"bonus":@"＋200",};
        
        [array addObject:[FNBonusArgs makeEntityWithJSON:d]];
        
    }
    
    return array;
}

@end
