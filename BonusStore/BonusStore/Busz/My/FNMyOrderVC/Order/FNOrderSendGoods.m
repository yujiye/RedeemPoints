//
//  FNOrderSendGoods.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderSendGoods.h"

@implementation FNOrderSendGoods


+ (NSMutableArray *)goods
{
    NSMutableArray * goodsArray = [NSMutableArray array];
    
    FNOrderSendGoods * goods = [[FNOrderSendGoods alloc]init];
    goods.title = @"*********专营店";
    goods.status = @"待发货";
    goods.image = @"cart_goodsPic";
    goods.num = @"共 3 件";

    
    [goodsArray addObject:goods];
    
    return goodsArray;

}

@end
