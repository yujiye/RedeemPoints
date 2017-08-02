//
//  FNCacheManager.h
//  BonusStore
//
//  Created by Nemo on 16/5/18.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FNCacheManager : NSObject

UIKIT_EXTERN    NSString *FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST;

UIKIT_EXTERN    NSString *FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST;

UIKIT_EXTERN    NSString *FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST;

UIKIT_EXTERN    NSString *FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST;

UIKIT_EXTERN    NSString *FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST;

+ (void)save:(id)data path:(NSString *)path;

+ (id)getInfoWithPath:(NSString *)path;

@end
