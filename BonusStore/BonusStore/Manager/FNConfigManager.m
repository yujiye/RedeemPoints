//
//  FNConfigManager.m
//  YellowPage
//
//  Created by feinno on 15/2/3.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "FNConfigManager.h"

@implementation FNConfigManager

+ (void)configKey:(NSString *)key value:(id)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)valueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)removeKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end


static NSString *FNFirstLaunch      =   @"FNFirstLaunch";

@implementation FNSystemConfig

+ (BOOL)isFirstLaunch
{
    if (![FNConfigManager valueForKey:FNFirstLaunch])
    {
        [FNConfigManager configKey:FNFirstLaunch value:@(YES)];
        
        return YES;
    }
    
    [FNConfigManager configKey:FNFirstLaunch value:@(NO)];
    
    return NO;
}

@end

static NSString *const FNNewMsgNoficationBadge      =   @"FNNewMsgNoficationBadge";

static NSString *const FNSystemNoficationBadge      =   @"FNSystemNoficationBadge";

static NSString *const FNCampaignNoficationBadge    =   @"FNCampaignNoficationBadge";

@implementation FNNotificationConfig

+ (BOOL)isNewMsg
{
    if ([[FNConfigManager valueForKey:FNSystemNoficationBadge] integerValue])
    {
        return YES;
    }
    
    return NO;
}

+ (void)setNewMsgBadge:(NSInteger)badge
{
    [FNConfigManager configKey:FNSystemNoficationBadge value:@(badge)];
}

+ (NSInteger)systemBadge
{
    return [[FNConfigManager valueForKey:FNSystemNoficationBadge] integerValue];
}

+ (NSInteger)campaignBadge
{
    return [[FNConfigManager valueForKey:FNCampaignNoficationBadge] integerValue];
}

+ (void)setSystemBadge:(NSInteger)badge
{
    [FNConfigManager configKey:FNSystemNoficationBadge value:@(badge)];
}

+ (void)setCampaignBadge:(NSInteger)badge
{
    [FNConfigManager configKey:FNCampaignNoficationBadge value:@(badge)];
}

@end