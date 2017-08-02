//
//  FNBaseArgs.m
//  BonusStore
//
//  Created by Nemo on 16/3/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseArgs.h"
#import <objc/runtime.h>

@implementation FNBaseArgs

+ (__kindof NSObject *)makeEntityWithJSON:(NSDictionary *)json;
{
    Class cls = [self class];
    
    NSObject *entity = [[[self class] alloc] init];
    
    unsigned int cnt;
    
    objc_property_t *properties = class_copyPropertyList(cls, &cnt);
    
    for (int i = 0; i<cnt; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        NSString *value = nil;
        
        if ([name isEqualToString:@"ID"])
        {
            value = [json valueForKey:@"id"];
        }
        else if ([name isEqualToString:@"des"])
        {
            value = [json valueForKey:@"description"];
        }
        else
        {
            value = [json valueForKey:name];
        }
        
        SEL sel = NSSelectorFromString(name);
        
        if ([entity respondsToSelector:sel] && value)
        {
            [entity setValue:value forKey:name];
        }
    }
    
    free(properties);
    
    return entity;
}

@end
