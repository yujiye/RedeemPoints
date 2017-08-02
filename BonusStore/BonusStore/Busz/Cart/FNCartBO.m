//
//  FNCarBO.m
//  BonusStore
//
//  Created by Nemo on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCartBO.h"
#import "FNUserAccountArgs.h"
#import "FNCartGroupModel.h"
#import "MJExtension.h"
#import "FNCartItemModel.h"
#import "FNAddressModel.h"
#import "FNSkuPriceAndStock.h"
#import "FNTabBarVC.h"

@implementation FNCartBO

+ (void)cancelOrder:(FNOrderArgs *)orderArgs block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(1) forKey:@"userType"];
    [para setObject:orderArgs.orderId forKey:@"orderId"];
    [[FNNetManager shared] postURL:@"order/cancelOrder" paras:para finish:^(id result) {
        block(result);
    } fail:^(NSError *error) {
        
        block(nil);
    }];
}

// 批量获取库存和sku价格
+ (void)getQuerystoreBatchWithProvinceId:(NSString *)provinceId orderList:(NSMutableArray *)orderList block:(FNNetFinish)block
{
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    NSMutableArray * arrM = [NSMutableArray array];
    for (FNCartGroupModel * cartGroup in orderList)
    {
        int  sellerId = cartGroup.sellerId;
        for(FNCartItemModel *item in cartGroup.productList)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:@(sellerId) forKey:@"sellerId"];
            [dict setValue:item.productId forKey:@"productId"];
            [dict setValue:item.sku.skuNum forKey:@"skuNum"];
           
            [dict setValue:item.storehouseIds  forKey:@"storehouseIds"];
            [dict setValue:provinceId forKey:@"provinceId"];
            [arrM addObject:dict];
        }
    }
    [para setObject:arrM forKey:@"sellerList"];
    
    
    [[FNNetManager shared] postURL:@"product/querystoreBatch" paras:para finish:^(id result) {
        
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
    }];
}



// 单个获取库存和sku价格   从商品详情中跳入填写订单使用
+ (void)getOneQuerystoreBatchWithProvinceId:(int )provinceId sellerId:(int)sellerId skuNum:(NSString *)skuNum productId:(NSString *)productId block:(FNNetFinish)block
{
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    [para setValue:@(sellerId) forKey:@"sellerId"];
    [para setValue:productId forKey:@"productId"];
    
    if (skuNum)
    {
        [para setValue:skuNum forKey:@"skuNum"];
    }
    if (productId)
    {
        
        [para setValue:@(provinceId) forKey:@"provinceId"];
    }
    [[FNNetManager shared]postURL:@"product/querystore" paras:para finish:^(id result) {
        

        block(result);
    } fail:^(NSError *error) {
        block(nil);
    }];
    
    
}
+ (void)getOrderListWithPage:(NSInteger)page status:(FNOrderState)status block:(FNNetFinish)block
{
    NSString *url = @"order/afterSaleList";
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"perCount":@(MAIN_PER_PAGE),
                                                                                @"curPage":@(page),
                                                                                @"userType":@(FNUserTypeBuyer)}];
    
    if (status != FNOrderStateAfterSale)
    {
        url = @"order/list";
        
        //2个状态一样 5 ＝ 50，51； 6 ＝ 60，61 ,62
        
        if (status == FNOrderStateFinish || status == FNOrderStateFinishCommenting)
        {
            status = 5;
        }
        
        if (status == FNOrderStateAutoClosed || status == FNOrderStateCanceled ||status ==FNOrderStateManageCanceled )
        {
            status = 6;
        }
        
        if (status != FNOrderStateAll)
        {
            [para setObject:@(status) forKey:@"orderState"];
        }
    }
    
    [[FNNetManager shared] postURL:url paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getOrderCountListWithBlock:(FNNetFinish)block
{
    NSDictionary *para = @{@"userType":@(FNUserTypeBuyer)};
    
    [[FNNetManager shared] postURL:@"order/count" paras:para finish:^(id result) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        if ([result[@"code"] integerValue] == 200)
        {
            [array addObject:[FNOrderCountArgs makeEntityWithJSON:result[@"orderCountList"][3]]];
            [array addObject:[FNOrderCountArgs makeEntityWithJSON:result[@"orderCountList"][5]]];
            [array addObject:[FNOrderCountArgs makeEntityWithJSON:result[@"orderCountList"][2]]];
            [array addObject:[FNOrderCountArgs makeEntityWithJSON:result[@"orderCountList"][4]]];
            [array addObject:[FNOrderCountArgs makeEntityWithJSON:result[@"orderCountList"][1]]];
            [array addObject:[FNOrderCountArgs makeEntityWithJSON:result[@"orderCountList"][0]]];
            
            block(array);
            
            return ;
        }
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}
// 获得运费
+ (void) getShipWithProvinceId:(NSString *)provinceId orderList:(NSMutableArray *)order block:(FNNetFinish)block
{
    NSMutableArray * arrM = [NSMutableArray array];
    for (FNCartGroupModel * cartGroup in order)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@(cartGroup.sellerId) forKey:@"sellerId"];
        NSMutableArray * arra = [NSMutableArray array];
        for(FNCartItemModel *item in cartGroup.productList)
        {
            NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
            [dict2 setValue:item.productId forKey:@"productId"];
            [dict2 setValue:@(item.postageId) forKey:@"postageId"];
            [dict2 setValue:@(item.count) forKey:@"count"];
            double weight = [item.sku.weight doubleValue];
            [dict2 setValue:@(weight)  forKey:@"weight"];
            CGFloat amount = item.count *1.0 *[item.cartPrice floatValue];
            [dict2 setValue:[NSString stringWithFormat:@"%.2f",amount] forKey:@"amount"];
            [arra addObject:dict2];
        }
        [dict setObject:arra forKey:@"productPostageList"];
        [arrM addObject:dict];
    }
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    [para setValue:provinceId forKey:@"provinceId"];
    [para setObject:arrM forKey:@"sellerPostageList"];
    [[FNNetManager shared]postURL:@"product/freight" paras:para  finish:^(id result)
     {
         block(result);
     } fail:^(NSError *error) {
         block(nil);
     }];
    
}


//  提交订单 实物和虚拟
+ (void)submitOrderWithOrder:(NSMutableArray *)order totalSum:(NSString *)totalSum addressDesc:(FNAddressModel *)addressDesc tradeCode:(FNTradeCode)code batch:(BOOL)batch mobile:(NSString *)mobile Block:(FNNetFinish)block
{
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
//    [para setValue:[FNCartBO getTradeCode:code] forKey:@"tradeCode"];
    [para setValue:@(FNSourceTypeiOS) forKey:@"fromSource"];
    [para setValue:(batch ? @"2" : @"1") forKey:@"fromBatch"];        //batch = yes from cart or buy it now
    [para setValue:totalSum forKey:@"totalSum"];
    
    NSMutableArray * arrM = [NSMutableArray array];
    for (FNCartGroupModel * cartGroup in order)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@(cartGroup.sellerId) forKey:@"sellerId"];
        [dict setValue:cartGroup.sellerName forKey:@"sellerName"];
        [dict setValue:cartGroup.remark forKey:@"remark"];
        [dict setValue:cartGroup.buyerComment forKey:@"buyerComment"];
        NSString * postage = cartGroup.postage;
        NSMutableArray * arra = [NSMutableArray array];
        for(FNCartItemModel *item in cartGroup.productList)
        {
            NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
            [dict2 setValue:item.productId forKey:@"productId"];
            [dict2 setValue:item.productName forKey:@"productName"];
            [dict2 setValue:item.sku.skuNum forKey:@"skuNum"];
            [dict2 setValue:item.sku.skuName forKey:@"skuName"];
            [dict2 setValue:@(item.count) forKey:@"count"];
            [dict2 setValue:item.curPrice forKey:@"curPrice"];
            [dict2 setValue:postage forKey:@"postage"];
            [dict2 setValue:item.imgKey forKey:@"imgUrl"];
            if(code == FNTradeCodeVirtualHuafei|| code ==FNTradeCodeVirtualCard||code ==FNTradeCodeVirtualSN)
            {
                [dict2 setValue:item.storehouseIds forKey:@"storehouseId"];
            }else
            {
                [dict2 setValue:item.storehouseId forKey:@"storehouseId"];
            }
            [arra addObject:dict2];
        }
        [dict setObject:arra forKey:@"productList"];
        
        [arrM addObject:dict];
    }
    
    [para setObject:arrM forKey:@"sellerDetailList"];
    
    NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
    if (!mobile)
    {
        [dictM setValue:@(addressDesc.id) forKey:@"id"];
        [dictM setValue:addressDesc.provinceName forKey:@"provinceName"];
        [dictM setValue:addressDesc.cityName forKey:@"cityName"];
        [dictM setValue:addressDesc.countyName forKey:@"countyName"];
        [dictM setValue:addressDesc.address forKey:@"address"];
        [para setObject:dictM forKey:@"addressDesc"];
        
    }
    else
    {
        [para setObject:mobile forKey:@"mobile"];
    }
    
    [[FNNetManager shared]postURL:@"order/submit" paras:para  finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
    
}


+ (void)confirmWithOrderID:(NSString *)orderID block:(FNNetFinish)block
{
    NSDictionary *para = @{@"orderId":orderID,
                           @"userType":@(FNUserTypeBuyer)};
    
    [[FNNetManager shared] postURL:@"order/changeState" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)payWithOrderList:(NSArray *)list type:(FNPayType)type bonus:(NSInteger)bonus cash:(NSString *)cash block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"payChannel":@(type),
                                                                                @"orderIdList":list,
                                                                                @"exchangeScore":[NSString stringWithFormat:@"%ld",(long)bonus],
                                                                                @"exchangeCash":cash}];
    
    
    [[FNNetManager shared] postURL:@"order/pay" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getOrderDetailWithOrderID:(NSString *)orderID block:(FNNetFinish)block
{
    NSDictionary *para = @{@"orderId":orderID,
                           @"userType":@(FNUserTypeBuyer)};
    
    [[FNNetManager shared] postURL:@"order/info" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            FNOrderArgs *order = [FNOrderArgs makeEntityWithJSON:result];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dict in result[@"productList"])
            {
                [array addObject:[FNProductArgs makeEntityWithJSON:dict]];
            }
            
            order.productList = array;
            
            order.afterSaleList = result[@"afterSaleList"] ? result[@"afterSaleList"] : nil;
            
            block(order);
            
            return ;
        }
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getVirtualOrderDetailWithOrderID:(NSString *)orderID block:(FNNetFinish)block
{
    NSDictionary *para = nil;
    
    [[FNNetManager shared] postURL:@"order/info2" paras:para finish:^(id result) {
        
        FNProductDetailArgs *order = [FNProductDetailArgs makeEntityWithJSON:result];
        
        order.productList = [FNProductArgs makeEntityWithJSON:result[@"productList"]];
        
        block(order);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)refundWithOrder:(FNOrderArgs *)order productId:(NSString *)productId skuNum:(NSString *)skuNum block:(FNNetFinish)block
{
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    [para setValue:@(1) forKey:@"type"];
    [para setValue:order.createTime forKey:@"createTime"];
    [para setValue:order.orderId forKey:@"orderId"];
    [para setValue:order.userComment forKey:@"userComment"];
    [para setValue:order.reason forKey:@"reason"];
    [para setValue:order.sellerId forKey:@"sellerId"];
    [para setObject:productId forKey:@"productId"];
    [para setObject:skuNum forKey:@"skuNum"];
    
    [[FNNetManager shared] postURL:@"order/refund" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getRefundDescWithOrderID:(NSString *)orderID block:(FNNetFinish)block
{
    NSDictionary *para = nil;
    
    
    //userId: int, 	//用户id
    //productId: string //商品id
    //orderId: string, //订单id
    //token: string
    //ppInfo: string
    
    [[FNNetManager shared] postURL:@"order/refundDesc" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}


+ (void)payWithOrderID:(NSString *)orderID payType:(FNPayType)type code:(NSString *)code list:(NSDictionary *)list block:(FNNetFinish)block
{
    NSDictionary *para = @{@"userId":FNUserAccountInfo[@"userId"],
                           @"payChannel":@(type),
                           @"code":code,
                           @"ppInfo":FNUserAccountInfo[@"ppInfo"],
                           @"token":FNUserAccountInfo[@"token"],
                           @"browser":[FNDevice machineCode],
                           @"orderInfo":list};
    
    
    [[FNNetManager shared] postURL:@"order/pay" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getPayStateWithPayID:(NSString *)payID block:(FNNetFinish)block
{
    NSDictionary *para = @{@"payId":payID};
    
    [[FNNetManager shared] postURL:@"order/paystate" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)delCartWithProduct:(FNCartItemModel *)cartItem block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSMutableArray * arra = [NSMutableArray array];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:cartItem.productId forKey:@"productId"];
    [dict2 setObject:cartItem.sku.skuNum forKey:@"skuNum"];
    [arra addObject:dict2];
    [para setValue:@(2) forKey:@"source"];
    [para setObject:arra forKey:@"cartKey"];
    [[FNNetManager shared] postURL:@"cart/delete" paras:para   finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

// 获得购物车列表
+ (void)getCartListWithBlock:(FNNetFinish)block
{
    NSDictionary *para = @{ @"source":@(2)};
    [[FNNetManager shared] postURL:@"cart/list" paras:para finish:^(id result)
    {
        block(result);
    } fail:^(NSError *error) {
        
        block(nil);
    }];
}

// 获得购物车数量
+ (void)getCartCountWithBlock:(FNNetFinish)block
{
    [[FNNetManager shared] postURL:@"cart/count" paras:nil finish:^(id result)
     {
         if ([result[@"code"] integerValue] == 200)
         {
             NSObject *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
             
             if ([vc isKindOfClass:[FNTabBarVC class]])
             {
                 FNTabBarVC *tab = (FNTabBarVC *)vc;
                 
                 UINavigationController *vc = [tab viewControllers][2];
                 
                 if ([result[@"count"] integerValue] > 0)
                 {
                     if ([result[@"count"] integerValue] > 99)
                     {
                         vc.tabBarItem.badgeValue = @"99+";
                     }
                     else
                     {
                         vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@",result[@"count"]];
                     }
                 }
                 else
                 {
                     vc.tabBarItem.badgeValue = nil;
                 }
             }
         }
         
         if (block)
         {
             block (result);
         }
         
     } fail:^(NSError *error) {
         
         if (block)
         {
             block(nil);
         }
         
     }];
}
+ (void)updateCartWithProduct:(FNCartItemModel *)cartItem count:(NSInteger)count block:(FNNetFinish)block
{
    NSDictionary *para = @{
                           @"productId":cartItem.productId,
                           @"skuNum":cartItem.sku.skuNum,
                           @"count":@(count),
                           @"price":cartItem.cartPrice,
                           @"source":@(2),
//                            @"storehouseId":cartItem.storehouseId
                           };
    
    [[FNNetManager shared] postURL:@"cart/update" paras:para finish:^(id result) {
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}


// 加入购物
+ (void)addCartWithProduct:(FNCartItemModel *)cartItem skuNum:(NSString *)skuNum count:(int)count block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:cartItem.productId forKey:@"productId"];
    
    [para setObject:cartItem.curPrice forKey:@"price"];
    [para setObject:@(count) forKey:@"count"];
    [para setObject:@(2) forKey:@"source"];
    [para setObject:cartItem.storehouseId forKey:@"storehouseId"];
    
    if (skuNum)
    {
        [para setObject:skuNum forKey:@"skuNum"];
    }
    
    [[FNNetManager shared]postURL:@"cart/add" paras:para finish:^(id result) {
        
            block(result);

    } fail:^(NSError *error) {
        
        block(nil);
    }];
  
}



@end

@implementation FNCartBO (Extension)

+ (NSString *)getTradeCode:(FNTradeCode)code
{
    NSString *type = nil;
    
    switch (code)
    {
        case FNTradeCodeBonus:
            type = @"Z0001";
            break;
        case FNTradeCodeVirtualHuafei:
            type = @"Z0002";
            break;
        case FNtradeCodeEntity:
            type = @"Z0003";
            break;
        case FNTradeCodeCOD:
            type = @"Z0004";
            break;
        case FNTradeCodeBonusCash:
            type = @"Z0005";
            break;
        case FNTradeCodeRedEnvelope:
            type = @"Z0006";
            break;
        case FNTradeCodeWechatNewYear:
            type = @"Z0008";
            break;
        case FNTradeCodeOneRob:
            type = @"Z9001";
            break;
        case FNTradeCodeTimeRob:
            type = @"Z9002";
            break;
        case FNTradeCodeBuyMinus:
            type = @"Z9003";
            break;
        case FNTradeCodeVirtualCard:
            type = @"Z8001";
            break;
        case FNTradeCodeVirtualSN:
            type = @"Z8002";
            break;
            
        default:
            break;
    }
    
    return type;
}

+ (void)getCMBFormWithURL:(NSString *)url para:(NSDictionary *)para block:(FNNetFinish)block
{
    [[FNNetManager shared] setIsJSONSerializer:NO];
    
    [[FNNetManager shared] makePostURL:url paras:para success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        block(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        block(nil);

    }];
}
@end
