//
//  FNRunTime.h
//  CardPacket
//
//  Created by feinno on 15/3/18.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNRunTime : NSObject

/**
 *  给对象的属性赋值
 *
 *  @param class  要赋值的对象的类
 *  @param data   所需要的数据
 *
 *  @return 赋好值的对象
 */
+(NSObject *)equipmentEntityWithClass:(Class)cl data:(NSDictionary *)data;

@end

/**
 *  Hook and swizzling with origin and dest method.
 *  You can use this method to exchange method in runtime.
 */

@interface FNRunTime (Hook)

+ (void)swizzlingWithClass:(Class)cls originalSel:(SEL)ori destSel:(SEL)dest;

@end