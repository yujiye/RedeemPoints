//
//  FNCacheManager.m
//  BonusStore
//
//  Created by Nemo on 16/5/18.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCacheManager.h"

NSString *FN_CACHE_PATH_MAIN_LIST = @"FN_CACHE_PATH_MAIN_LIST";

NSString *FN_CACHE_PATH_MAIN_LIST_CHART = @"FN_CACHE_PATH_MAIN_LIST_CHART";

NSString *FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST = @"FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST";
NSString *FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST = @"FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST";
NSString *FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST = @"FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST";
NSString *FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST = @"FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST";
NSString *FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST = @"FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST";

@implementation FNCacheManager

+ (void)save:(id)data path:(NSString *)path
{
    NSString *p = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    p = [p stringByAppendingPathComponent:@"cache"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [fm createDirectoryAtPath:p withIntermediateDirectories:NO attributes:nil error:nil];
    
    if (path == FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST)
    {
        [data writeToFile:[p stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST] atomically:YES];
    }
    if (path == FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST)
    {
        [data writeToFile:[p stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST] atomically:YES];
    }
    if (path == FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST)
    {
        [data writeToFile:[p stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST] atomically:YES];
    }
    if (path == FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST)
    {
        [data writeToFile:[p stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST] atomically:YES];
    }
    if (path == FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST)
    {
        [data writeToFile:[p stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST] atomically:YES];
    }
    
}

+ (id)getInfoWithPath:(NSString *)path
{
    NSString* paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    paths = [paths stringByAppendingPathComponent:@"cache"];
    
    if (path == FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST)
    {
        path = [paths stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST];
    }
    
    if (path == FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST)
    {
        path = [paths stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST];
    }
    if (path == FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST)
    {
        path = [paths stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST];
    }
    if (path == FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST)
    {
        path = [paths stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST];
    }
    if (path == FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST)
    {
        path = [paths stringByAppendingPathComponent:FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST];
    }
    //直接返回数组
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

@end
