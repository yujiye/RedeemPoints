//
//  XMReachability.m
//  PandaFinancial
//
//  Created by Nemo on 16/2/21.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "FNReachability.h"

@implementation FNReachability

+ (BOOL)isReach
{
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
}

@end
