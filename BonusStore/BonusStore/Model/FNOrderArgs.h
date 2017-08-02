//
//  FNOrderArgs.h
//  BonusStore
//
//  Created by Nemo on 16/4/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"
#import "FNCommon.h"

#import "FNProductArgs.h"

@interface FNOrderArgs : FNBaseArgs

@property (nonatomic, assign)int orderType; // orderType =1

@property (nonatomic,assign)NSInteger timeOutLimit; //待发货状态时的超时时长

@property (nonatomic, copy)NSString * expressId;// 物流商ID

@property (nonatomic, copy)NSString *expressNo; //物流单号

@property (nonatomic, assign) int afterOrderType;

@property (nonatomic, strong)NSString *payChannel; //支付方式

@property (nonatomic, strong)NSString *closingPrice;

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSString *orderPrice;

@property (nonatomic, strong) NSNumber *activeState;

@property (nonatomic, strong) NSString *postage;

@property (nonatomic, strong) NSString *sellerName;

@property (nonatomic, strong) NSString *sellerId;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *receiverName;

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *buyerComment;
@property (nonatomic, strong) NSString *comment;

@property (nonatomic, strong) NSString *deliverTime;

@property (nonatomic, strong) NSString *successTime;

@property (nonatomic, strong) NSNumber *curTime;

@property (nonatomic, strong) NSString *exchangeCash;

@property (nonatomic, strong) NSString *exchangeScore;

@property (nonatomic, strong) NSNumber *orderState;

@property (nonatomic, strong) NSString *sellerComment;

@property (nonatomic, strong) NSString *productPrice;

@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic,strong) NSString * tradeCode;

@property (nonatomic, strong) NSString *userComment;//买家备注退货原因

@property (nonatomic, strong) NSString *reason;//申请原因

@property (nonatomic, assign) NSInteger type;//申请类型

@property (nonatomic, strong) NSString *createTime;//创建时间

@property (nonatomic, strong) NSString *skuNum;

@property (nonatomic, strong) NSString *productId;

@property (nonatomic, strong) FNProductArgs *productLists;

@property (nonatomic, strong) NSArray *afterSaleList;          //售后

@property (nonatomic,strong)NSNumber *virRechargeState; // 话费流量，Q币状态


@end

@interface FNOrderCountArgs : FNBaseArgs

@property (nonatomic, strong) NSNumber *orderState;

@property (nonatomic, strong) NSNumber *count;

@end


@interface FNSellerName : FNBaseArgs

@property (nonatomic, assign)int sellerId;

@property (nonatomic,copy)NSString * sellerName;


@end


@interface FNAfterSaleModel : FNBaseArgs

@property(nonatomic,assign) int sellerId;

@property (nonatomic,copy)NSString *orderId;

@property (nonatomic,copy)NSString * productId;

@property (nonatomic,copy)NSString * skuNum;

@property (nonatomic,assign)int type;

@end

@interface FNPayOrderList : NSObject

@property (nonatomic,copy)NSString * sellerId;

@property (nonatomic,copy)NSString * sellerName;

@property (nonatomic,copy)NSString * tradeCode;

@property (nonatomic,strong)NSArray *sellerDetailList;

@property (nonatomic, copy)NSString * extend;

@property (nonatomic,strong)NSArray * orderIdList;

@end

