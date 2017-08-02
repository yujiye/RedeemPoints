//
//  ChargeReq.h
//  ChargeDemo_GD
//
//  Created by szt on 16/8/10.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *订单类型（充值、消费）
 */
typedef enum{
    charge,
    consume,
    
}orderType;

#pragma mark - OrderReq
@interface OrderReq : NSObject

/*
 *订单金额（以分为单位）
 */
@property (nonatomic,copy) NSString *orderMoney;

/*
 *订单号
 */
@property (nonatomic,copy) NSString *orderNo;


/*
 *订单类型
 */
@property (nonatomic,assign) orderType orderType;

/*
 *手机号码
 */
@property (nonatomic,copy) NSString *phoneNo;

/*
 *token
 */
@property (nonatomic,copy) NSString *token;

/*
 *openId
 */
@property (nonatomic,copy) NSString *openId;

/*
 *优惠券id
 */
@property (nonatomic,copy) NSString *voucherId;

/*
 *优惠券
 */
@property (nonatomic,copy) NSString *voucherMoney;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,copy)   NSString   *row;
@property (nonatomic,copy)   NSString   *type;
@end

#pragma mark - RequestResult
@interface RequestResult : NSObject

/*
 *状态
 */
@property(nonatomic,assign)NSInteger status;

/*
 *返回代码
 */
@property(nonatomic,strong)NSString *code;

/*
 *返回消息
 */
@property(nonatomic,strong)NSString *message;

/*
 *返回结果数组
 */
@property(nonatomic,strong)NSArray *results;

/*
 *返回结果字典
 */
@property(nonatomic,strong)NSDictionary *resultInfo;

/*
 *返回结果字符串
 */
@property(nonatomic,strong)NSString *resultString;

/*
 *时间戳标示
 */
@property(nonatomic,strong)NSString *timestamp;

/*
 *token
 */
@property(nonatomic,strong)NSString *token;

@end



