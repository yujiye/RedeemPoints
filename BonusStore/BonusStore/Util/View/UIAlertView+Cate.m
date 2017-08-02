//
//  UIAlertView+Attributes.m
//  FNCardPacketMerchant
//
//  Created by feinno on 15/3/26.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "UIAlertView+Cate.h"

@implementation UIAlertView (Cate)

static char UIALERT_ACTION_KEY;

+(void)alertViewWithMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:APP_ARGUS_NAME message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

/**
 *  单利并初始化
 */
+(instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)canceltitle actionBlock:(UIAlertActionBlock)block otherTitle:(NSString *)otherTitle,... NS_REQUIRES_NIL_TERMINATION{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:canceltitle,otherTitle, nil];
    [alert setupAlertWithBlock:block];
    return alert;
}

/**
 *  设置关联和block回调
 */
-(void)setupAlertWithBlock:(UIAlertActionBlock)block{
    objc_removeAssociatedObjects(self);
    objc_setAssociatedObject(self, &UIALERT_ACTION_KEY, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.delegate = self;
    [self show];
}

/**
 *  代理并回调
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIAlertActionBlock block = objc_getAssociatedObject(self, &UIALERT_ACTION_KEY);
    block ? block(buttonIndex) : NSLog(@"no meesage to log");
}

@end
