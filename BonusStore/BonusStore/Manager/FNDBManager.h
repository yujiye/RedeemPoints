//
//  FNDBManager.h
//  RcsIntegral
//
//  Created by Nemo on 16/3/25.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

FOUNDATION_EXTERN NSString *const FNSystemNotification;

FOUNDATION_EXTERN NSString *const FNCampaignNotification;

@interface FNDBManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *bc;

@property (nonatomic, strong) NSManagedObjectContext *fc;

+ (instancetype)shared;

+ (void)addNotificationWithObserver:(id)observer name:(NSString *)name sel:(SEL)sel;

+ (void)removeNotificationFromObserver:(id)observer;

+ (void)fetch;

/**
 *  暂时无删除功能
 */
+ (void)del;

@end
