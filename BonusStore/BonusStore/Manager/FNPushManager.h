//
//  FNPushService.h
//  BonusStore
//
//  Created by Nemo on 16/3/30.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNPushManager : NSObject

+ (void)setupOptionWithCategory:(NSSet *)category delegate:(id)delegate options:(NSDictionary *)options;

+ (void)resignAPNS;

+ (BOOL)isRegistered;

+ (void)registerDeviceToken:(NSData *)token;

+ (void)handleRemoteNotification:(NSDictionary *)userInfo;

+ (void)handleRemoteError:(NSError *)error;

+ (void)setBadge:(NSInteger)badge;

+ (void)enableDebug:(BOOL)debug;

/**
 *  设置JPush的Alias(别名)，用于指定用户推送消息，如
 *
 *  @param alias 需要识别用户客户端的别名
 */
+ (void)setAlias:(NSString *)alias,...;

@end
