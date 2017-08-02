//
//  FNRunTime.m
//  CardPacket
//
//  Created by feinno on 15/3/18.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "FNRunTime.h"

@implementation FNRunTime

+(NSObject *)equipmentEntityWithClass:(Class)class data:(NSDictionary *)data{
    
    NSObject *entity = [[class alloc]init];
    
    unsigned int outCount;
    
    objc_property_t *properties = class_copyPropertyList(class, &outCount);

    for (int i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
        NSString *value = nil;
        
        if ([propertyName isEqualToString:@"ID"])
        {
            value = [data valueForKey:@"id"];
        }
        else if ([propertyName isEqualToString:@"des"])
        {
            value = [data valueForKey:@"description"];
        }
        else
        {
            value = [data valueForKey:propertyName];
        }
        
        //设置属性值 并返回entity
        
        SEL selector = NSSelectorFromString(propertyName);
        
        if ([entity respondsToSelector:selector] && value)
        {
            [entity setValue:value forKeyPath:propertyName];
        }
    }
    return entity;
}

@end

@implementation FNRunTime (Hook)

+ (void)swizzlingWithClass:(Class)cls originalSel:(SEL)ori destSel:(SEL)dest
{
    Class class = cls;
    Method oriMethod = class_getInstanceMethod(class, ori);
    Method destMethod = class_getInstanceMethod(class, dest);
    
    BOOL didAdd = class_addMethod(class, ori, method_getImplementation(oriMethod), method_getTypeEncoding(destMethod));
    if (didAdd)
    {
        class_replaceMethod(class, dest, method_getImplementation(oriMethod), method_getTypeEncoding(destMethod));
    }
    else
    {
        method_exchangeImplementations(oriMethod, destMethod);
    }
}

@end
