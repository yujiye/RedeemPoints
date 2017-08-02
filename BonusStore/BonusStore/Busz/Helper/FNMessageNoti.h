//
//  XMMessageNoti.h
//  PandaFinancial
//
//  Created by Nemo on 16/2/20.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNMessageNoti : NSObject

+ (BOOL)isNew;

+ (void)touchOff;

+ (BOOL)isNewWithMessageID:(NSNumber *)messageID;

+ (void)saveLatestMessageID:(NSNumber *)messageID;

//积分消息
+ (BOOL)isNewBonusMsg;

+ (void)saveBonusMessage:(BOOL)isBonusMsg;

+ (void)touchOffBonus;

//订单消息
+ (BOOL)isNewOrderMsg;

+ (void)saveOrderMessage:(BOOL)isOrderMsg;

+ (void)touchOffOrder;

@end
