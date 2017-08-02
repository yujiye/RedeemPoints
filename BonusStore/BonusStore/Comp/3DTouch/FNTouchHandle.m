//
//  FNTouchHandle.m
//  BonusStore
//
//  Created by cindy on 2017/2/10.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNTouchHandle.h"
#import "FNTouchShow.h"
#import "FNTouchArgs.h"
#import <Social/Social.h>
#import "FNHeader.h"
#import "FNLoginBO.h"
#import "FNScanVC.h"
@implementation FNTouchHandle

+(void)creatShortcutItem
{
    NSMutableArray * arrM = [NSMutableArray array];
    FNTouchArgs * touchargs1 = [[FNTouchArgs alloc]init];
    touchargs1.imageName = @"touch_ship";
    touchargs1.title = @"待收货";
    touchargs1.type = @"waitShip";
    [arrM addObject:touchargs1];
    
    FNTouchArgs * touchargs2 = [[FNTouchArgs alloc]init];
    touchargs2.imageName = @"touch_cart";
    touchargs2.title = @"购物车";
    touchargs2.type = @"shopCart";
    [arrM addObject:touchargs2];
    
    FNTouchArgs * touchargs3 = [[FNTouchArgs alloc]init];
    touchargs3.imageName = @"touch_scan";
    touchargs3.title = @"扫一扫";
    touchargs3.type = @"scanQRcode";
    [arrM addObject:touchargs3];
    
    FNTouchArgs * touchargs4 = [[FNTouchArgs alloc]init];
    touchargs4.imageName = @"touch_share";
    touchargs4.title = @"分享\"聚分享\"";
    touchargs4.type = @"shareIcon";
    [arrM addObject:touchargs4];
    [FNTouchShow creatShortcutItemWithArr:arrM.copy];
    
}

+ (void)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    FNTabBarVC * tabBarVC  = (FNTabBarVC *)window.rootViewController;
    [tabBarVC dismissViewControllerAnimated:YES completion:nil];
    FNNavigationVC *nav = (FNNavigationVC *)[tabBarVC  selectedViewController];
    if (shortcutItem) {
        //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        if([shortcutItem.type isEqualToString:@"waitShip"]){ //待发货
            if (![FNLoginBO isLogin])
            {
                return;
            }
            FNOrderVC *orderVC = [[FNOrderVC alloc]init];
            orderVC.stateTag = FNTitleTypeOrderStateReceiving;
            orderVC.isNoti = YES;
            [nav pushViewController:orderVC animated:YES];
        } else if ([shortcutItem.type isEqualToString:@"shopCart"]) {//购物车
            if (![FNLoginBO isLogin])
            {
                return;
            }
            tabBarVC.selectedIndex = 2;
            
        } else if ([shortcutItem.type isEqualToString:@"scanQRcode"]) {//扫一扫
            FNScanVC * scanvc = [[FNScanVC alloc]init];
            
            tabBarVC.selectedIndex = 0;
            
            FNNavigationVC * navVC  = (FNNavigationVC *) [[tabBarVC viewControllers]firstObject];
            [navVC pushViewController:scanvc animated:YES];
        }else if ([shortcutItem.type isEqualToString:@"shareIcon"]){ //分享
            // 设置分享内容
            
            NSString *text = @"中国电信战略合作伙伴--“移动互联网通用积分服务平台”，支持多渠道积分整合，并提供线上线下多场景积分消费服务。积分可以当钱花，快来查查你的积分吧！";
            UIImage *image = [UIImage imageNamed:@"logo180.png"];
            NSURL *url = [NSURL URLWithString:APP_ARGUS_URL_SHARE];
            NSArray *activityItems = @[text, image, url];
            
            // 服务类型控制器
            UIActivityViewController *activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop,UIActivityTypeOpenInIBooks];
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            
            FNNavigationVC *nav = (FNNavigationVC *)[(FNTabBarVC *)window.rootViewController selectedViewController];
            
            [nav presentViewController:activityViewController animated:YES completion:nil];
            
            // 选中分享类型
            [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
                
                // 显示选中的分享类型
                NSLog(@"act type %@",activityType);
                
                if (completed) {
                    NSLog(@"ok");
                }else {
                    NSLog(@"no ok");
                }
                
            }];
        }
    }
    
}



@end
