//
//  UIAlertView+Attributes.h
//  FNCardPacketMerchant
//
//  Created by feinno on 15/3/26.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"


typedef void (^UIAlertActionBlock) (NSInteger bIndex);

@interface UIAlertView (Cate)

+(void)alertViewWithMessage:(NSString *)message;

+(instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)canceltitle actionBlock:(UIAlertActionBlock)block otherTitle:(NSString *)otherTitle,... NS_REQUIRES_NIL_TERMINATION;


@end
