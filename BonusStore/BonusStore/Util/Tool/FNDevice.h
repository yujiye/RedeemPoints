//
//  YXDevice.h
//  YueXin
//
//  Created by feinno on 15/8/31.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNDevice : NSObject

@end

@interface FNDevice (Accessor)

+ (CGFloat) version;

+ (NSString *) machineCode;

+ (void) saveToken:(NSString *)token;

+ (NSString *)idfa;

+ (NSString *) machineModel;

@end
