//
//  Mask.h
//  AlaSoft
//
//  Created by 郑凯 on 15/9/16.
//  Copyright (c) 2015年 郑凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Mask : NSObject

#pragma mark 显示遮罩
/**
 * 显示遮罩
 */
+ (void)HUDShowInView:(UIView *)view
        AndController:(id)controller
          AndHUDColor:(UIColor *)hudColor
         AndLabelText:(NSString *)labelText
  AndDetailsLabelText:(NSString *)detailsLabelText
     AndDimBackground:(BOOL)isDim;

#pragma mark 显示可以自动隐藏的遮罩
/**
 * 显示可以自动隐藏的遮罩
 */
+ (void)HUDShowInView:(UIView *)view
        AndController:(id)controller
          AndHUDColor:(UIColor *)hudColor
         AndLabelText:(NSString *)labelText
  AndDetailsLabelText:(NSString *)detailsLabelText
     AndDimBackground:(BOOL)isDim
    AndHideAfterDelay:(NSTimeInterval)delay;

#pragma mark 隐藏遮罩
/**
 * 隐藏遮罩
 */
+ (void)HUDHideInView:(UIView *)view;

#pragma mark 显示可以自动隐藏的文字遮罩
/**
 * 显示可以自动隐藏的文字遮罩
 */
+ (void)HUDShowTextInView:(UIView *)view
              AndHUDColor:(UIColor *)hudColor
             AndLabelText:(NSString *)labelText
        AndHideAfterDelay:(NSTimeInterval)delay;

#pragma mark 显示可以自动隐藏的自定义图片遮罩
/**
 * 显示可以自动隐藏的自定义图片遮罩
 */
+ (void)HUDImageShowInView:(UIView *)view
              AndLabelText:(NSString *)labelText
       AndDetailsLabelText:(NSString *)detailsLabelText
                  AndImage:(NSString *)icon
         AndHideAfterDelay:(NSTimeInterval)delay;


@end


