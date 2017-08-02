//
//  UIViewController+Extension.m
//  BonusStore
//
//  Created by Nemo on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "FNLoginBO.h"

@interface UIViewController ()
{
}

@end

@implementation UIViewController (Extension)

- (void)setNavMessageItem
{
    UIImage *msgImage = nil;
    if ([FNMessageNoti isNewBonusMsg] || [FNMessageNoti isNewOrderMsg] || [FNMessageNoti isNew])
    {
        msgImage= [UIImage imageNamed:@"main_nav_msg_new"];
    }
    else
    {
        msgImage = [UIImage imageNamed:@"main_nav_msg"];
    }
    
    
    UIButton *msgBut = [FNNavigationBarItem setCustomItemWithOriginal:CGPointMake(kImage_W(msgImage)+8, 0) image:msgImage target:self action:@selector(goMessage)];
    
    msgBut.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    
    UILabel *msgLabel = [UILabel labelWithFrame:CGRectMake(0, 12, kImage_W(msgImage), kImage_H(msgImage))];
    
    [msgLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    msgLabel.text = @"消息";
    
    [msgBut addSubview:msgLabel];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:msgBut];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)goMessage
{
    if (![FNLoginBO isLogin])
    {
        return;
    }
    
    [FNMessageNoti touchOff];
    
    FNMessageCenterVC *vc = [[FNMessageCenterVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)captureWith
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
