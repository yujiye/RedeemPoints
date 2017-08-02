//
//  FNUBSManager.m
//  BonusStore
//
//  Created by Nemo on 16/10/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNUBSManager.h"
#import "BaiduMobStat.h"

@implementation FNUBSManager

+ (void)configAll
{
    BaiduMobStat *tracker = [BaiduMobStat defaultStat];
    
    tracker.shortAppVersion = APP_ARGUS_RELEASE_VERSION;
    
    [tracker startWithAppId:FN_BAIDU_UBS_KEY];
        
}

+ (void)ubsEvent:(NSString *)event
{
    BaiduMobStat *tracker = [BaiduMobStat defaultStat];

    [tracker logEvent:event eventLabel:event];
}

+ (void)pageStart:(NSString *)page
{
    BaiduMobStat *tracker = [BaiduMobStat defaultStat];

    [tracker pageviewStartWithName:page];
}

+ (void)pageEnd:(NSString *)page
{
    BaiduMobStat *tracker = [BaiduMobStat defaultStat];

    [tracker pageviewEndWithName:page];
}

@end
