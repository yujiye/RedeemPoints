//
//  FNSZTongBO.m
//  BonusStore
//
//  Created by Nemo on 17/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZTongBO.h"

@implementation FNSZTongBO

+(void)getCouponListBlock:(FNNetFinish)block
{
    [[FNNetManager shared]postURL:@"product/sztcardList" paras:nil  finish:^(id  _Nonnull result)
     {
         block(result);
         
     } fail:^(NSError * _Nonnull error) {
         block(nil);
         
     }];
}


+(void)rechargeMoneyWithTotalSum:(NSString *)totalSum flowno:(NSString *)flowno block:(FNNetFinish)block
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setValue:FNUserAccountInfo[@"userId"] forKey:@"userId"];
    [paras setValue:FNUserAccountInfo[@"userName"] forKey:@"userName"];
    [paras setValue:totalSum forKey:@"totalSum"];
    [paras setValue:FNUserAccountInfo[@"loginName"] forKey:@"receiverMobile"];
    [paras setValue:@"3" forKey:@"fromSource"];
    [paras setValue:@"Z8007" forKey:@"tradeCode"];
    [paras setValue:flowno forKey:@"flowno"];
    [paras setValue:[NSString stringWithFormat:@"深圳通充值券%@元",totalSum] forKey:@"sellerComment"];
    NSMutableArray *sellerDetailList = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"1" forKey:@"sellerId"];
    [dict setValue:@"聚分享旗舰店" forKey:@"sellerName"];
    [sellerDetailList addObject:dict];
    [paras setObject:sellerDetailList forKey:@"sellerDetailList"];
    [[FNNetManager shared]postURL:@"order/payOrderCreates" paras:paras finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        block(nil);
    }];
}

+(void)getSZTCardImgListBlock:(FNNetFinish)block
{
    [[FNNetManager shared]postURL:@"product/sztcardImg" paras:nil  finish:^(id  _Nonnull result){
         block(result);
         
     } fail:^(NSError * _Nonnull error) {
         block(nil);
         
     }];
}

@end
