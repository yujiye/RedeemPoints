//
//  FNCarBO.h
//  BonusStore
//
//  Created by Nemo on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FNBaseBO.h"
#import "FNProductArgs.h"
#import "FNSellerArgs.h"
#import "FNOrderArgs.h"
@interface FNCartBO : FNBaseBO

// 批量获取库存和sku价格
+ (void)getQuerystoreBatchWithProvinceId:(NSString *)provinceId orderList:(NSMutableArray *)orderList block:(FNNetFinish)block;;

// 获取库存和sku价格   从商品详情中跳入填写订单使用
+ (void)getOneQuerystoreBatchWithProvinceId:(int )provinceId sellerId:(int)sellerId skuNum:(NSString *)skuNum productId:(NSString *)productId block:(FNNetFinish)block;

//订单列表  （或者售后的订单列表）
+ (void)getOrderListWithPage:(NSInteger)page status:(FNOrderState)status block:(FNNetFinish)block;

//获取订单所有状态的数量
+ (void)getOrderCountListWithBlock:(FNNetFinish)block;

//  提交订单 实物和虚拟
+ (void)submitOrderWithOrder:(NSMutableArray *)order totalSum:(NSString *)totalSum addressDesc:(FNAddressModel *)addressDesc tradeCode:(FNTradeCode)code batch:(BOOL)batch mobile:(NSString *)mobile Block:(FNNetFinish)block;

//确认收货
+ (void)confirmWithOrderID:(NSString *)orderID block:(FNNetFinish)block;


//立即付款
+ (void)payWithOrderList:(NSArray *)list type:(FNPayType)type bonus:(NSInteger)bonus cash:(NSString *)cash block:(FNNetFinish)block;

//订单详情
+ (void)getOrderDetailWithOrderID:(NSString *)orderID block:(FNNetFinish)block;

//订单详情:virtual
+ (void)getVirtualOrderDetailWithOrderID:(NSString *)orderID block:(FNNetFinish)block;

//申请退货
+ (void)refundWithOrder:(FNOrderArgs *)order productId:(NSString *)productId skuNum:(NSString *)skuNum block:(FNNetFinish)block;

//获取运费
+ (void) getShipWithProvinceId:(NSString *)provinceId orderList:(NSMutableArray *)order block:(FNNetFinish)block;

//获取售后信息
+ (void)getRefundDescWithOrderID:(NSString *)orderID block:(FNNetFinish)block;

//订单支付
+ (void)payWithOrderID:(NSString *)orderID payType:(FNPayType)type code:(NSString *)code list:(NSDictionary *)list block:(FNNetFinish)block;

//查询支付状态
+ (void)getPayStateWithPayID:(NSString *)payID block:(FNNetFinish)block;

//删除购物车
+ (void)delCartWithProduct:(FNCartItemModel *)cartItem block:(FNNetFinish)block;

//购物车列表
+ (void)getCartListWithBlock:(FNNetFinish)block;

//获取购物车数量
+ (void)getCartCountWithBlock:(FNNetFinish)block;

//修改购物车中商品数量
+ (void)updateCartWithProduct:(FNCartItemModel *)cartItem count:(NSInteger)count block:(FNNetFinish)block;

// 加入购物
+ (void)addCartWithProduct:(FNCartItemModel *)cartItem skuNum:(NSString *)skuNum count:(int)count block:(FNNetFinish)block;

// 取消订单
+ (void)cancelOrder:(FNOrderArgs *)orderArgs block:(FNNetFinish)block;


@end

@interface FNCartBO (Extension)

+ (NSString *)getTradeCode:(FNTradeCode)code;

//获取cmbform表单,由于请求的是CMB，所以不用加端口
+ (void)getCMBFormWithURL:(NSString *)url para:(NSDictionary *)para block:(FNNetFinish)block;

@end
