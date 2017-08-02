//
//  FNUserAccount.m
//  BonusStore
//
//  Created by Nemo on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNUserAccountArgs.h"
#import "FNConfigManager.h"

static NSString *const FNUserAccountKey = @"FNUserAccountKey";

static NSString *const FNUserAccountInfoKey = @"FNUserAccountInfoKey";

static NSString *const FNUserWechatAccountInfoKey = @"FNUserWechatAccountInfoKey";

NSString *FNTokenRefreshLastTimeKey = @"FNTokenRefreshLastTimeKey";

NSDictionary *FNUserAccountInfo;

NSDictionary *FNUserWechatAccountInfo;

BOOL isWechatLogin;

NSString *FNTokenRefreshFPS;

@implementation FNUserAccountArgs

+ (void)setUserAccount:(NSDictionary *)account
{
    if (account[@"mobile"])
    {
        isWechatLogin = NO;
    }
    else if(account[@"openId"])
    {
        isWechatLogin = YES;
    }
    
    [FNConfigManager configKey:FNUserAccountKey value:account];
}

+ (NSDictionary *)getUserAccount
{
    NSDictionary *account = [FNConfigManager valueForKey:FNUserAccountKey];
    
    if (account[@"mobile"])
    {
        isWechatLogin = NO;
    }
    else if(account[@"openId"])
    {
        isWechatLogin = YES;
    }
    
    [FNUserAccountArgs getUserAccountInfo];     //获取用户账号内容的时候，同时获取用户登陆信息

    return account;
}

+ (void)removeUserAccount
{
    isWechatLogin = NO;
    
    [FNConfigManager removeKey:FNUserAccountKey];
}

+ (void)setUserAccountInfo:(NSDictionary *)info
{
    [FNConfigManager configKey:FNUserAccountInfoKey value:info];
    
    if (info[@"logoutTime"])
    {
        FNTokenRefreshFPS = info[@"logoutTime"];
    }
    
    [FNPushManager setAlias:info[@"userId"]];

    [FNUserAccountArgs getUserAccountInfo];
}

+ (void)insertValue:(NSString *)value key:(NSString *)key
{
    [FNUserAccountArgs getUserAccountInfo];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:FNUserAccountInfo];
    
    [dict setValue:value forKey:key];
    
    [FNUserAccountArgs getUserAccountInfo];
}

+ (void)getUserAccountInfo
{
    FNUserAccountInfo = [FNConfigManager valueForKey:FNUserAccountInfoKey];
    
    if (FNUserAccountInfo[@"logoutTime"])
    {
        FNTokenRefreshFPS = FNUserAccountInfo[@"logoutTime"];
    }
}

+ (void)removeUserAccountInfo
{
    [FNPushManager setAlias:nil];
    
    [FNConfigManager removeKey:FNUserAccountInfoKey];
    
    FNUserAccountInfo = nil;
    
    [FNTokenFetcher cancel];
}

+ (BOOL)isUserAccountInfoAvailable
{
    [FNUserAccountArgs getUserAccountInfo];

    double duration = [FNTokenRefreshFPS doubleValue];
    
    double lastTime = [FNUserAccountInfo[@"curTime"] doubleValue] / 1000.0;
    
    double now = [[NSDate date] timeIntervalSince1970];
    
    if (now - lastTime <= duration *  0.9 && now - lastTime > 0)
    {
        return YES;
    }
    
    return NO;
}

+ (void)setUserWechatAccountInfo:(id)info
{
    [FNUserAccountArgs removeUserWechatAccountInfo];
    
    [FNConfigManager configKey:FNUserWechatAccountInfoKey value:info];
    
    [FNUserAccountArgs getUserWechatAccountInfo];
}

+ (void)getUserWechatAccountInfo
{
    FNUserWechatAccountInfo = [FNConfigManager valueForKey:FNUserWechatAccountInfoKey];
}

+ (void)removeUserWechatAccountInfo
{
    [FNConfigManager removeKey:FNUserWechatAccountInfoKey];
    
    [FNUserAccountArgs getUserWechatAccountInfo];

}

@end
