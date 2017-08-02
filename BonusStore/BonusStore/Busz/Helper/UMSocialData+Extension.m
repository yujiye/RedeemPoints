//
//  UMSocialData+Extension.m
//  BonusStore
//
//  Created by Nemo on 16/3/31.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "UMSocialData+Extension.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import <UMMobClick/MobClick.h>
#import "FNLoginBO.h"

NSObject *FN_SNS_Account;

@implementation UMSocialData (Extension)

+ (void)configAll
{
    [UMSocialData setAppKey:FN_UMENG_KEY];
    
    [UMSocialData openLog:YES];
    
    [UMAnalyticsConfig sharedInstance].appKey = FN_UMENG_KEY;
    
    [UMAnalyticsConfig sharedInstance].ePolicy = REALTIME;
    
    [UMAnalyticsConfig sharedInstance].channelId = FN_CHANNEL_ID;
    
    [MobClick startWithConfigure:[UMAnalyticsConfig sharedInstance]];
    
    [MobClick setAppVersion:APP_ARGUS_RELEASE_VERSION];
    
    [MobClick setLogEnabled:YES];

    [UMSocialWechatHandler setWXAppId:FN_WECHAT_ID appSecret:FN_WECHAT_SECRET url:@"http://www.umeng.com/social"];
    
}

@end
