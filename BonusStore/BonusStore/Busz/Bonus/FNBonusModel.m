//
//  FNBonusModel.m
//  BonusStore
//
//  Created by sugarwhi on 16/5/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusModel.h"

@implementation FNBonusModel

@end


@implementation FNBonusDetailedModel

- (NSString *)getBonusType
{
    return [self getBonusTypeDescWithType:_type.integerValue];
}

- (NSString *)getBonusTypeDescWithType:(FNBonusType)type
{
    switch (type)
    {
        case FNBonusTypeToApp:
            return @"电信积分兑入";
        case FNBonusTypeToTele:
            return @"兑换电信积分";
        case FNBonusTypeOffLine:
            return @"消费抵扣";
        case FNBonusTypeOnLine:
            return @"消费抵扣";
        case FNBonusTypeConsumptionSend:
            return @"消费赠送";
        case FNBonusTypeActivitySend:
            return @"活动赠送";
        case FNBonusTypePay:
            return @"返还支付积分";
        case FNBonusTypeMinus:
            return @"扣减赠送积分";
        case FNBonusTypeRecharge:
            return @"积分卡充值";
        case FNBonusTypeRedGift:
            return @"积分红包活动";
        case FNBonusTypeRegisteredGift:
            return @"第三方注册赠送";
        case FNBonusTypeTrirdSend:
            return @"第三方消费抵扣";
        case FNBonusTypeAutoReturn:
            return @"自动返还第三方抵扣积分";
        case FNBonusTypeManualReturn:
            return @"手动返还第三方抵扣积分";
          case FNBonusTypeAfterReturn:
            return @"订单售后退积分";

        default:
            break;
    }
    
    return @"";
}

@end

@implementation FNBounsRechargeListModel


@end
