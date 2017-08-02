//
//  ChargeAPI.h
//  ChargeDemo_GD
//
//  Created by szt on 16/8/10.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "OrderReq.h"
#import "CentralManager.h"
#import "CommonObject.h"
typedef enum{
    Searching,
    ReceiveRfm,
    TimeOut,
    Processing,
    Success,
    Failed,
    Unknown,
    OverCharge,
}OperationStatus;


#pragma mark - CardAPI
@interface CardAPI : NSObject


+ (CardAPI *)sharedManager;

//卡充值
- (void)startCharge:(OrderReq*)req
            success:(void (^)(RequestResult *requestResult))success
            failure:(void (^)(RequestResult *requestResult))failure
             unkown:(void (^)(RequestResult *requestResult))unkown;
//卡消费
- (void)startConsume:(OrderReq*)req
             success:(void (^)(RequestResult *requestResult))success
             failure:(void (^)(RequestResult *requestResult))failure
              unkown:(void (^)(RequestResult *requestResult))unkown;
//余额与消费记录查询
- (void)startoffLineChecking:(OrderReq*)req
                     success:(void (^)(RequestResult *requestResult))success
                     failure:(void (^)(RequestResult *requestResult))failure;
//异常验卡
- (void)startonLineChecking:(OrderReq *)req
                    success:(void (^)(RequestResult *))success
                    failure:(void (^)(RequestResult *))failure
                     unkown:(void (^)(RequestResult *))unkown;
@end

#pragma mark - OrderAPI
@interface OrderAPI : NSObject


+ (OrderAPI *)sharedManager;

//查询充值券
- (void)getVoucherList:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success failure:(void (^)(RequestResult *requestResult))failure;

//查询充值券数量
- (void)getVoucherCount:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success failure:(void (^)(RequestResult *requestResult))failure;

//创建充值订单
- (void)getChargeOrder:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success failure:(void (^)(RequestResult *requestResult))failure;

//创建消费订单
- (void)getConsumeOrder:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success failure:(void (^)(RequestResult *requestResult))failure;

//支付订单
- (void)toPayOrder:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success failure:(void (^)(RequestResult *requestResult))failure;

//创建取消订单
- (void)requestCancelOrder:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success;

//申请退款
- (void)requestRefundOrder:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success;
//订单列表
- (void)requestOrderList:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success failure:(void (^)(RequestResult *requestResult))failure;
//订单详情
- (void)requestOrderDetail:(OrderReq *)req success:(void (^)(RequestResult *requestResult))success failure:(void (^)(RequestResult *requestResult))failure;
@end


#pragma mark - BluetoothAPI
@interface BluetoothAPI : NSObject

@property (nonatomic,assign) CBPeripheralState state;

+ (BluetoothAPI *)sharedManager;

- (void)startScan:(void (^)(RequestResult *))success;

- (void)didConnectDevice:(CBPeripheral *)peripheral;

- (void)disConnectDevice:(CBPeripheral *)peripheral;
@end

