//
//  FNConfigManager.h
//  YellowPage
//
//  Created by feinno on 15/2/3.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNConfigManager : NSObject

+ (void)configKey:(NSString *)key value:(id)value;

+ (id)valueForKey:(NSString *)key;

+ (void)removeKey:(NSString *)key;

@end

/**
 *  是否第一次登录
 */

@interface FNSystemConfig : NSObject

+ (BOOL)isFirstLaunch;

@end

/**
 *  消息中心Badge
 */

@interface FNNotificationConfig : NSObject

+ (BOOL)isNewMsg;

+ (void)setNewMsgBadge:(NSInteger)badge;

+ (NSInteger)systemBadge;

+ (NSInteger)campaignBadge;

+ (void)setSystemBadge:(NSInteger)badge;

+ (void)setCampaignBadge:(NSInteger)badge;

@end
