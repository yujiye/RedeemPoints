//
//  XMMessageNoti.m
//  PandaFinancial
//
//  Created by Nemo on 16/2/20.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "FNMessageNoti.h"

static BOOL FN_MESSAGE_IS_NEW   = NO;

static NSString *FN_MESSAGE_NOTI = @"FN_MESSAGE_NOTI";

static NSString *FN_MESSAGE_IS_TOUCH = @"FN_MESSAGE_IS_TOUCH";

//积分
static NSString *FN_MESSAGE_IS_TOUCH_BONUS = @"FN_MESSAGE_IS_TOUCH_BONUS";
static NSString *FN_MESSAGE_NOTI_BONUS = @"FN_MESSAGE_NOTI_BONUS";
//订单

static NSString *FN_MESSAGE_IS_TOUCH_ORDER = @"FN_MESSAGE_IS_TOUCH_ORDER";
static NSString *FN_MESSAGE_NOTI_ORDER = @"FN_MESSAGE_NOTI_ORDER";

@implementation FNMessageNoti

+ (BOOL)isNew
{
    if (![FNConfigManager valueForKey:FN_MESSAGE_IS_TOUCH] || [[FNConfigManager valueForKey:FN_MESSAGE_IS_TOUCH] boolValue])
    {
        return NO;
    }
    
    return FN_MESSAGE_IS_NEW;
}


+ (BOOL)isNewWithMessageID:(NSNumber *)messageID
{
    NSNumber *old = [FNConfigManager valueForKey:FN_MESSAGE_NOTI];

    if (old)
    {
        if ([messageID integerValue] > [old integerValue])
        {
            [FNConfigManager configKey:FN_MESSAGE_NOTI value:messageID];

            return YES;
        }
        
        return NO;
    }
    else
    {
        [FNConfigManager configKey:FN_MESSAGE_NOTI value:messageID];
    }
    
    return YES;
}

+ (void)saveLatestMessageID:(NSNumber *)messageID
{
    FN_MESSAGE_IS_NEW = [self isNewWithMessageID:messageID];

    [FNConfigManager configKey:FN_MESSAGE_NOTI value:messageID];
}

/**
 *  当点击后隐藏小红点，＋1显示更大
 */
+ (void)touchOff
{
    [FNConfigManager configKey:FN_MESSAGE_IS_TOUCH value:@(YES)];
}

//积分消息
+ (BOOL)isNewBonusMsg
{
    return [[FNConfigManager valueForKey:FN_MESSAGE_NOTI_BONUS] boolValue];
}

+ (void)saveBonusMessage:(BOOL)isBonusMsg
{
    [FNConfigManager configKey:FN_MESSAGE_NOTI_BONUS value:[NSNumber numberWithBool:isBonusMsg]];
     
}

+ (void)touchOffBonus
{
    [FNConfigManager configKey:FN_MESSAGE_NOTI_BONUS value:@(NO)];
}

//订单消息
+ (BOOL)isNewOrderMsg
{
    return [[FNConfigManager valueForKey:FN_MESSAGE_NOTI_ORDER] boolValue];
}

+ (void)saveOrderMessage:(BOOL)isOrderMsg
{
    [FNConfigManager configKey:FN_MESSAGE_NOTI_ORDER value:[NSNumber numberWithBool:isOrderMsg]];
}

+ (void)touchOffOrder
{
    [FNConfigManager configKey:FN_MESSAGE_NOTI_ORDER value:@(NO)];
}

@end
