//
//  FNRechargeBO.m
//  BonusStore
//
//  Created by sugarwhi on 16/10/16.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNRechargeBO.h"

@implementation FNRechargeBO

+(void)rechargeMoneyWithTotalSum:(NSString *)totalSum flowno:(NSString *)flowno company:(NSString *)company provinceName:(NSString *)provinceName receiverMobile:(NSString *)receiverMobile block:(FNNetFinish)block
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    
    [paras setValue:FNUserAccountInfo[@"userId"] forKey:@"userId"];
    [paras setValue:FNUserAccountInfo[@"userName"] forKey:@"userName"];
    [paras setValue:totalSum forKey:@"totalSum"];
    [paras setValue:receiverMobile forKey:@"receiverMobile"];
    [paras setValue:@"3" forKey:@"fromSource"];
    if([NSString isEmptyString:company])
    {
        //Q币
        [paras setValue:provinceName forKey:@"provinceName"];
        [paras setValue:@"Z8005" forKey:@"tradeCode"];

    }else
    {
        if([NSString isEmptyString:flowno])
        {
            //话费
            [paras setValue:company forKey:@"company"];

            [paras setValue:@"Z8003" forKey:@"tradeCode"];
            
        }else
        {
            //流量
            [paras setValue:company forKey:@"company"];
            [paras setValue:@"Z8004" forKey:@"tradeCode"];
            [paras setValue:flowno forKey:@"flowno"];
        }
    }
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

+(void)payOrderCreatesWithTotalSum:(NSString *)totalSum flowno:(NSString *)flowno company:(NSString *)company receiverMobile:(NSString *)receiverMobile sellerComment:(NSString *)sellerComment provinceName:(NSString *)provinceName  block:(FNNetFinish)block
{
    
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    
    [paras setValue:FNUserAccountInfo[@"userId"] forKey:@"userId"];
    [paras setValue:FNUserAccountInfo[@"userName"] forKey:@"userName"];
    [paras setValue:totalSum forKey:@"totalSum"];
    [paras setValue:receiverMobile forKey:@"receiverMobile"];
    [paras setValue:@"3" forKey:@"fromSource"];
    [paras setValue:@"Z8006" forKey:@"tradeCode"];
    [paras setValue:flowno forKey:@"flowno"];
    [paras setValue:company forKey:@"company"];
    [paras setValue:sellerComment forKey:@"sellerComment"];
    [paras setValue:provinceName forKey:@"provinceName"];

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

+ (void)mobileInfoWithMobile:(NSString *)mobile block:(FNNetFinish)block
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    [paras setValue:mobile forKey:@"mobile"];
    
    [[FNNetManager shared]getURL:@"active/queryMobileInfo" paras:paras finish:^(id result) {
        block(result);
    } fail:^(NSError *error) {
        block(nil);
    }];
}


+(void)getGameNameWithFirstpy:(NSString *)py name:(NSString *)name thirdGameId:(NSString *)thirdGameId block:(FNNetFinish)block
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if(![NSString isEmptyString:py])
    {
        [paras setValue:py forKey:@"firstpy"];
 
    }
    if(![NSString isEmptyString:name])
    {
        [paras setValue:name forKey:@"name"];

    }
    if(![NSString isEmptyString:thirdGameId])
    {
        [paras setValue:thirdGameId forKey:@"thirdGameId"];
    }
    
[[FNNetManager shared]postURL:@"fileCard/queryGames" paras:paras finish:^(id  _Nonnull result) {
    block(result);

} fail:^(NSError * _Nonnull error) {
    block(nil);

}];
    
}

+(void)getAreaListAndSeaverListWith:(NSString *)gameId block:(FNNetFinish)block
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    if(![NSString isEmptyString:gameId])
    {
        [paras setValue:gameId forKey:@"gameId"];
        
    }
    
    [[FNNetManager shared]postURL:@"fileCard/queryAreas" paras:paras finish:^(id  _Nonnull result) {
        block(result);
        
    } fail:^(NSError * _Nonnull error) {
        block(nil);
        
    }];
}


@end
