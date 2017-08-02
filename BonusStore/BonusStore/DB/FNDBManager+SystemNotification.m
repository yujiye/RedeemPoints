//
//  FNDBManager+SystemNotification.m
//  BonusStore
//
//  Created by Nemo on 16/4/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNDBManager+SystemNotification.h"

@implementation FNDBManager (SystemNotification)

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (void)fetch
{
    NSManagedObjectContext *context = [FNDBManager shared].bc;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FNSystemNotification object:array];
}

+ (void)del
{
    
}

#pragma clang diagnostic pop

@end
