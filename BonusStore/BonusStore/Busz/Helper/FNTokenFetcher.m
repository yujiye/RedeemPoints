//
//  FNTokenFetcher.m
//  BonusStore
//
//  Created by Nemo on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNTokenFetcher.h"
#import "FNLoginBO.h"

@implementation FNTokenFetcher

static FNTokenFetcher *_fetcher;

static dispatch_source_t _timer;

static dispatch_queue_t _token_fetcher_queue()
{
    static dispatch_queue_t fetcher_queue;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
    
#if TARGET_DEV
        fetcher_queue = dispatch_queue_create("com.jfshare.bonusDev.token.fetcher.queue", DISPATCH_QUEUE_CONCURRENT);
#else
        fetcher_queue = dispatch_queue_create("com.jfshare.bonus.token.fetcher.queue", DISPATCH_QUEUE_CONCURRENT);
#endif
        
        
    });
    
    return fetcher_queue;
}

+ (instancetype)start
{
    [[FNTokenFetcherLock shared].lock lock];
    
    if (!_fetcher)
    {
        _fetcher = [[FNTokenFetcher alloc] init];
    }
    
    if (_timer)
    {
        return _fetcher;
    }
    
    uint64_t interval = [FNTokenRefreshFPS integerValue] * NSEC_PER_SEC;       //Refresh token in 60m.
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _token_fetcher_queue());
    
    dispatch_source_set_timer(_timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * interval), interval, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        [_fetcher after];
        
    });
    
    dispatch_resume(_timer);
    
    [[FNTokenFetcherLock shared].lock unlock];
    
    return _fetcher;
}

/**
 *  You should clearly recognize this:
 *  start function invoke immediately after function when timer began,
 *  after function will do it self after FNTokenRefreshFPS second,
 *  
 *  start function do it first, after do FNTokenRefreshFPS second,
 *  it means start function is last time, after function is now.
 */
- (void)after
{
    uint64_t interval = [FNTokenRefreshFPS integerValue] * NSEC_PER_SEC;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)interval), _token_fetcher_queue(), ^(void){

        [_fetcher fetchToken];
    });
}

- (void)resume
{
    [[FNTokenFetcherLock shared].lock lock];
    
    if (_timer)
    {
        dispatch_resume(_timer);
    }
    
    [[FNTokenFetcherLock shared].lock unlock];
}

+ (void)cancel
{
    [[FNTokenFetcherLock shared].lock lock];
    
    if (_timer)
    {        
        dispatch_source_cancel(_timer);
        
        _timer = nil;
    }
    
    [[FNTokenFetcherLock shared].lock unlock];
}

+ (void)fetchToken
{
    [_fetcher fetchToken];
}

- (void)fetchToken
{
    [[FNLoginBO port02] getAuthInfoWithBlock:^(id result) {
        
        [[FNTokenFetcherLock shared].lock lock];

        if ([result[@"code"] integerValue] == 200)
        {
            [FNUserAccountArgs getUserAccountInfo];
            
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:FNUserAccountInfo];
            
            [info setObject:result[@"token"] forKey:@"token"];
            [info setObject:result[@"ppInfo"] forKey:@"ppInfo"];
            [info setObject:result[@"curTime"] forKey:@"curTime"];
                                                                                                                                                                       
            [FNUserAccountArgs setUserAccountInfo:info];
        }
        else
        {
            [FNTokenFetcher cancel];
            
            [FNUserAccountArgs removeUserAccountInfo];
            
            [FNLoginBO loginAuthFail];
        }
        
        [[FNTokenFetcherLock shared].lock unlock];

    }];
}

@end

@implementation FNTokenFetcherLock

+ (instancetype)shared
{
    static FNTokenFetcherLock *_fetcherLock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _fetcherLock = [[FNTokenFetcherLock alloc] init];
        _fetcherLock.lock = [[NSRecursiveLock alloc] init];

    });
    return _fetcherLock;
}

@end
