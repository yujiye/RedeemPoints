//
//  FNBaseBO.m
//  BonusStore
//
//  Created by Nemo on 16/4/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseBO.h"

@implementation FNBaseBO

+ (Class)port01
{
    [[FNNetManager shared]setPort:18001];
    
    return self;
}

+ (Class)port02
{
    [[FNNetManager shared]setPort:18002];
    
    return self;
}

+ (Class)port03
{
    [[FNNetManager shared]setPort:18003];
    
    return self;
}

+ (Class)port04
{
    [[FNNetManager shared]setPort:18004];
    return self;
}

+ (Class)port30
{
    [[FNNetManager shared]setPort:3000];
    
    return self;
}


+ (Class)withOutUserInfo
{
    [[FNNetManager shared] setUserInfo:NO];  //    FNUserAccountInfo = nil;  意义相同需统一
    
    return self;
}

+ (Class)isWX
{
    [[FNNetManager shared] setUrlIsWX:YES]; //设置此选项，则使用wx url
    
    return self;
}

@end
