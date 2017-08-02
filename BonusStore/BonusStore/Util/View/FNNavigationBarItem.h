//
//  FNNavigationBarItem.h
//  CardPacket
//
//  Created by feinno on 15/3/16.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"


typedef void (^FNNavigationBarItemBlock) ();

@interface FNNavigationBarItem : NSObject

+(UIBarButtonItem *)initItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action;

//Set item with image.
+(void)setNavgationBackItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action;
+(void)setNavgationLeftItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action;
+(void)setNavgationRightItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action;

//Set title.
+(void)setNavgationLeftItemWithTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action;
+(void)setNavgationRightItemWithTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action;

//Set item with custom image.
+(UIButton *)setCustomItemWithOriginal:(CGPoint)original image:(UIImage *)image target:(UIViewController *)target action:(SEL)action;
+(void)setNavgationCustomItem:(UIView *)item target:(UIViewController *)target;
+(void)setCustomBackWithTarget:(UIViewController *)target action:(SEL)action;
+(void)setCustomLeftWithTarget:(UIViewController *)target image:(UIImage *)image action:(SEL)action;
+(UIBarButtonItem *)setCustomRightWithTarget:(UIViewController *)target image:(UIImage *)image action:(SEL)action;

+(void)setCustomTitle:(NSString *)title target:(UIViewController *)target;
+(void)setCustomImage:(UIImage *)image target:(UIViewController *)target;

@end
