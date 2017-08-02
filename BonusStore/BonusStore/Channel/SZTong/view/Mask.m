//
//  Mask.m
//  AlaSoft
//
//  Created by 郑凯 on 15/9/16.
//  Copyright (c) 2015年 郑凯. All rights reserved.
//

#import "Mask.h"

@interface Mask ()

@end

@implementation Mask

#pragma mark - 显示遮罩
#pragma mark 显示遮罩
+ (void)HUDShowInView:(UIView *)view
        AndController:(id)controller
          AndHUDColor:(UIColor *)hudColor
         AndLabelText:(NSString *)labelText
  AndDetailsLabelText:(NSString *)detailsLabelText
     AndDimBackground:(BOOL)isDim
{

    //方式1.直接在View上show
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.delegate = controller;
    
    //常用的设置
    //小矩形的背景色
    HUD.color = [hudColor colorWithAlphaComponent:0.9f];
    //显示的文字
    HUD.labelText = labelText;
    
    HUD.activityIndicatorColor = [UIColor whiteColor];
    
    HUD.labelColor = [UIColor whiteColor];
    //细节文字
    HUD.detailsLabelText = detailsLabelText;
    //是否有庶罩
    HUD.dimBackground = isDim;
}

#pragma mark 显示可以自动隐藏的遮罩
+ (void)HUDShowInView:(UIView *)view
        AndController:(id)controller
          AndHUDColor:(UIColor *)hudColor
         AndLabelText:(NSString *)labelText
  AndDetailsLabelText:(NSString *)detailsLabelText
     AndDimBackground:(BOOL)isDim
    AndHideAfterDelay:(NSTimeInterval)delay
{
    //方式1.直接在View上show
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.delegate = controller;
    
    //常用的设置
    //小矩形的背景色
    HUD.color = [hudColor colorWithAlphaComponent:0.9f];
    //显示的文字
    HUD.labelText = labelText;
    
    HUD.labelColor = [UIColor whiteColor];
    //细节文字
    HUD.detailsLabelText = detailsLabelText;
    //是否有庶罩
    HUD.dimBackground = isDim;
    [HUD hide:YES afterDelay:delay];
}

#pragma mark 隐藏遮罩
+ (void)HUDHideInView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

#pragma mark 显示可以自动隐藏的文字遮罩
+ (void)HUDShowTextInView:(UIView *)view
              AndHUDColor:(UIColor *)hudColor
             AndLabelText:(NSString *)labelText
        AndHideAfterDelay:(NSTimeInterval)delay
{
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.color = [hudColor colorWithAlphaComponent:0.9f];
    hud.labelText = labelText;
    hud.dimBackground = YES;
    hud.margin = 10.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

#pragma mark 显示可以自动隐藏的自定义图片遮罩
+ (void)HUDImageShowInView:(UIView *)view
              AndLabelText:(NSString *)labelText
       AndDetailsLabelText:(NSString *)detailsLabelText
                  AndImage:(NSString *)icon
         AndHideAfterDelay:(NSTimeInterval)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //显示的文字
    hud.labelText = labelText;
    //最小尺寸
    hud.minSize = CGSizeMake(140, 120);
    //细节文字
    hud.detailsLabelText = detailsLabelText;
    //遮罩颜色
    hud.color=[[UIColor darkGrayColor] colorWithAlphaComponent:0.9f];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:delay];
}

@end


