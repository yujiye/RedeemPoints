//
//  FNTokenFetcher.h
//  BonusStore
//
//  Created by Nemo on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNTokenFetcher : NSObject

+ (instancetype)start;

+ (void)cancel;

+ (void)fetchToken;

- (void)fetchToken;

@end

@interface FNTokenFetcherLock : NSObject

@property (nonatomic, strong) NSRecursiveLock *lock;

+ (instancetype)shared;

@end