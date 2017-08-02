//
//  FNPayWayArgs.m
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPayWayArgs.h"

@implementation FNPayWayArgs

+ (NSMutableArray *)initData
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    
    NSArray *images = @[@"pay_wechat",@"pay_alipay",@"pay_chinamobile",@"pay_cmb",@"pay_wing"];
    
    NSArray *deses = @[@"微信支付",@"支付宝支付",@"移动和包支付",@"一网通银行卡支付",@"翼支付"];
    
        NSInteger index = 0;
    
        for (NSString *d in deses)
        {
            FNPayWayArgs *arg = [[FNPayWayArgs alloc] init];
            
            arg.icon = images[index];
            
            arg.des = d;
            
            [array addObject:arg];
            
            index++;
        }
    return array;
}

@end
