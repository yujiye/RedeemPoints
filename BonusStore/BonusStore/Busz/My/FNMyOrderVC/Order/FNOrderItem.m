//
//  FNOrderItem.m
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderItem.h"

@implementation FNOrderItem

+ (NSMutableArray *)orderItems
{
    NSMutableArray * arrM = [NSMutableArray array];
    for(int i= 0;i<4;i++)
    {
        FNOrderItem * fillOrderItem = [[FNOrderItem alloc]init];
        fillOrderItem.goodsPictureUrl = @"cart_goodsPic";
        fillOrderItem.goodsName = @"Kirkland柯克兰葡萄干巧克力";
        fillOrderItem.goodsDetail = @"牛奶味 150g";
        fillOrderItem.goodsPrice = @"220.00";
        fillOrderItem.usdPrice = @"10";
        fillOrderItem.commentsString = @"请尽快发货";
        
        [arrM addObject:fillOrderItem];
    }
    for(int i= 0;i<2;i++)
    {
        FNOrderItem * fillOrderItem = [[FNOrderItem alloc]init];
        fillOrderItem.goodsPictureUrl = @"cart_goodsPic";
        fillOrderItem.goodsName = @"变形金刚拉杆箱 万向登机箱";
        fillOrderItem.goodsDetail = @"土豪金色 24寸";
        fillOrderItem.goodsPrice = @"220.00";
        fillOrderItem.usdPrice = @"10";
        fillOrderItem.commentsString = @"请不要弄错颜色，颜色必须是土豪金";
        [arrM addObject:fillOrderItem];
    }
    
    return arrM;
}
@end
