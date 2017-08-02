//
//  FNPayVC.h
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNOrderArgs.h"

UIKIT_EXTERN NSMutableDictionary *FNPayInfo;        //支付订单ID：orderId

UIKIT_EXTERN UIViewController *FNPayVCExtern;       //支付跳转VC

@interface FNPayVC : FNBaseVC
@property (nonatomic, copy) NSArray * orderIds; // 订单ID
@property (nonatomic,copy) NSString * thirdScore;
@property (nonatomic,copy)NSString * cancelTime; 
@property (nonatomic,copy)NSString * createTime; //创建时间
@property (nonatomic, copy) NSString * allPrice; // 总价格
@property (nonatomic, assign) NSInteger curBonus; // 需要花费bonus

@property (nonatomic, strong) FNOrderArgs *order;


@property (nonatomic, assign) BOOL isVirtualGoods;

@property (nonatomic, assign)BOOL isAuthFail;       //是否鉴权失败

@property (nonatomic, assign)BOOL isSpecialType ;  //是否是不送积分产品

@property (nonatomic,copy)NSString * tradeCode; //


@end
