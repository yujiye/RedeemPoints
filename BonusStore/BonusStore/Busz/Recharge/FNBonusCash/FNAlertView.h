//
//  FNAlertView.h
//  BonusStore
//
//  Created by cindy on 2017/1/10.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FNAlertBlock)();

@interface FNAlertView : UIView
// 设置alertView背景色
@property (nonatomic, copy) UIColor *alertBackgroundColor;
// 设置确定按钮背景色
@property (nonatomic, copy) UIColor *btnConfirmBackgroundColor;

//设置message字体颜色
@property (nonatomic, copy) UIColor *messageColor;

//内容颜色
@property (nonatomic,copy)UIColor *contentColor;

// 弹出alertView以及点击确定回调的block
+(instancetype)alertViewControllerWithMessage:(NSString *)message content:(NSString *)content block:(FNAlertBlock) block;

@end
