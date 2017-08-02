//
//  FNPushService.m
//  BonusStore
//
//  Created by Nemo on 16/3/30.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPushManager.h"

@implementation FNPushManager

+ (void)setupOptionWithCategory:(NSSet *)category delegate:(id)delegate options:(NSDictionary *)options
{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    if (IOS_VERSION_GREATER_THAN_10)
    {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:delegate];
    }
    else if (IOS_VERSION_GREATER_THAN_8)
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:category];
    }
    else
    {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PushConfig" ofType:@"plist"];
    
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];

    [JPUSHService setupWithOption:options
                           appKey:info[@"APP_KEY"]
                          channel:info[@"CHANNEL"]
                 apsForProduction:FN_JPUSH_DIS
            advertisingIdentifier:idfa];
}

+ (void)resignAPNS
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

+(BOOL)isRegistered
{
    return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
}

+ (void)registerDeviceToken:(NSData *)token
{
    [JPUSHService registerDeviceToken:token];
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
}

+ (void)handleRemoteError:(NSError *)error
{
    NSLog(@"%s\n%s\n%@",__FILE__,__FUNCTION__,error.description);
}

+ (void)setBadge:(NSInteger)badge
{
    if (!badge)
    {
        [JPUSHService setBadge:badge];
    }
    else
    {
        [JPUSHService resetBadge];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
}

+ (void)enableDebug:(BOOL)debug
{
    if (debug)
    {
        [JPUSHService setDebugMode];
        
        [JPUSHService crashLogON];
    }
    else
    {
        [JPUSHService setLogOFF];
    }
}

+ (void)setAlias:(NSString *)alias,...
{
    if (alias)
    {
        alias = [FNTools md5FromHash:[NSString stringWithFormat:@"%@",alias]];
        
        [JPUSHService setTags:nil alias:alias callbackSelector:nil object:nil];
    }
}

@end
