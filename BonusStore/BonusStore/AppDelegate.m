//  --
//  AppDelegate.m
//  BonusStore
//
//  Created by Nemo on 16/3/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "AppDelegate.h"
#import "FNHeader.h"
#import "FNLoginBO.h"
#import "FNMyBO.h"
#import "FNCartBO.h"
#import "FNScanVC.h"
#import <Social/Social.h>
#import "FNTouchShow.h"
#import "FNTouchArgs.h"
#import "FNTouchHandle.h"
#import "FNSpotlight.h"
#import "FNMainBO.h"


@class WXApiObject;



@interface AppDelegate ()<WXApiDelegate>
{
    NSDictionary *_remoteNoti;
    
    BOOL _isOfficialBack;
    
    BOOL _isActive;     //支付回来，会走走willinter和goback，所以需要判断
}


@end

@implementation AppDelegate

#if TARGET_DEV

#else
//处理3DTouch事件
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    
    [FNTouchHandle handleShortcutItem:shortcutItem];
    if (completionHandler) {
        completionHandler(YES);
    }
    
}

#endif


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _remoteNoti = [[NSDictionary alloc] init];
    
    [FNPushManager setupOptionWithCategory:nil delegate:self options:launchOptions];
    
    
    [FNUBSManager configAll];
#if TARGET_DEV
    
#else
    [UMSocialData configAll];
    #endif
    [FNPayManager configAll];
    
    [self netStatus];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _window.backgroundColor = [UIColor whiteColor];
    
    FNMainVC *main = [[FNMainVC alloc] init];
    
    FNNavigationVC *mainNav = [[FNNavigationVC alloc] initWithRootViewController:main];
    
    FNCateVC *cate = [[FNCateVC alloc] init];
    
    FNNavigationVC *cateNav = [[FNNavigationVC alloc] initWithRootViewController:cate];
    
    FNCartVC *cart =[[FNCartVC alloc]init];
    
    FNNavigationVC *cartNav = [[FNNavigationVC alloc] initWithRootViewController:cart];
    
    FNMyVC *my = [[FNMyVC alloc] init];
    
    FNNavigationVC *myNav = [[FNNavigationVC alloc] initWithRootViewController:my];
    
    FNTabBarVC *tab = [[FNTabBarVC alloc] init];
    
    tab.viewControllers = @[mainNav, cateNav, cartNav, myNav];
    
    _window.rootViewController = tab;
    
    
    [_window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
#if TARGET_DEV

#else
    [FNTouchHandle creatShortcutItem];
#endif
    
    // 设置spotlight暂时屏蔽
    [[FNMainBO port01] getHotSearchListWithModuleId:@"6" block:^(id result) {
        // 热门搜索
        [FNSpotlight setSpotlights];
        
    }];
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType])
    {
        NSString *uniqueIdentifier = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
        if ([uniqueIdentifier hasPrefix:@"search"])
        {
            FNNavigationVC *nav = (FNNavigationVC *)[(FNTabBarVC *)self.window.rootViewController selectedViewController];
            NSString * searchContent = [[uniqueIdentifier componentsSeparatedByString:@"="]lastObject];
            FNSearchResultVC *resultVC = [[FNSearchResultVC alloc]init];
            resultVC.searchStr = searchContent;
            [nav pushViewController:resultVC animated:YES];
            
        } else if([uniqueIdentifier hasPrefix:@"main"])
        {
            FNMainConfigType index = (FNMainConfigType )[[[uniqueIdentifier componentsSeparatedByString:@"="]lastObject]integerValue];
            [self goDiffientVC:index];
            
        }
        
    }
    return YES;
}
- (void)netStatus
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        FNNoNetBar *no = [FNNoNetBar shared];
        
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            [FNLoadingView hide];
            
            [[UIApplication sharedApplication].keyWindow addSubview:no];
        }
        else
        {
            [no removeFromSuperview];
        }
        
    }];
}

#pragma mark - Remote Notification

- (void)receMessage:(NSNotification *)noti
{
    _remoteNoti = [noti userInfo];
    
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [FNPushManager handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [FNPushManager handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

//iOS 8-10
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [FNPushManager registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [FNPushManager handleRemoteError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    _remoteNoti = userInfo[@"aps"];
    
    [self setRemoteNoti];
    
    [FNPushManager handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    _remoteNoti = userInfo;
    
    [self setRemoteNoti];
    
    [FNPushManager handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)setRemoteNoti
{
    
    if (![_remoteNoti isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    NSDictionary *json = _remoteNoti;
    
    if ([json[@"obj_type"] isEqualToString:@"message"])
    {
        FNMessageCenterVC *vc = [[FNMessageCenterVC alloc] init];
        vc.isMsg = YES;
        vc.isNoti = YES;
        FNNavigationVC *nav = (FNNavigationVC *)[(FNTabBarVC *)self.window.rootViewController selectedViewController];
        [nav pushViewController:vc animated:YES];
        
    }
    else if ([json[@"obj_type"] isEqualToString:@"order"])
    {
        if ([json[@"order_type"] integerValue] == FNOrderStatePaying ||
            [json[@"order_type"] integerValue] == FNOrderStateShipping ||
            [json[@"order_type"] integerValue] == FNOrderStateReceiving ||
            [json[@"order_type"] integerValue] == FNOrderStateFinish ||
            [json[@"order_type"] integerValue] == FNOrderStateAfterSale)
        {
            FNOrderVC *orderVC = [[FNOrderVC alloc]init];
            switch ([json[@"order_type"] integerValue])
            {
                case FNOrderStatePaying:
                    orderVC.stateTag = FNTitleTypeOrderStatePaying;
                    break;
                case FNOrderStateShipping:
                    orderVC.stateTag = FNTitleTypeOrderStateShipping;
                    break;
                case FNOrderStateReceiving:
                    orderVC.stateTag = FNTitleTypeOrderStateReceiving;
                    break;
                case FNOrderStateFinish:
                    orderVC.stateTag = FNTitleTypeOrderStateFinish;
                    break;
                case FNOrderStateAfterSale:
                    orderVC.stateTag = FNTitleTypeOrderStateAfterSale;
                    break;
                    
                default:
                    break;
            }
            [FNMessageNoti saveOrderMessage:YES];
            orderVC.isNoti = YES;
            
            [self.window.rootViewController goTabIndex:3];
            
            FNNavigationVC *nav = (FNNavigationVC *)[(FNTabBarVC *)self.window.rootViewController selectedViewController];
            
            [nav pushViewController:orderVC animated:YES];
        }
        else if ([json[@"order_type"] integerValue] == FNOrderStateBonus)
        {
            [FNMessageNoti saveBonusMessage:YES];
            FNMyBonusDetailVC *bonusDetailVC = [[FNMyBonusDetailVC alloc]init];
            FNNavigationVC *nav = (FNNavigationVC *)[(FNTabBarVC *)self.window.rootViewController selectedViewController];
            [nav pushViewController:bonusDetailVC animated:YES];
        }
        else
        {
            FNOrderVC *orderVC = [[FNOrderVC alloc]init];
            orderVC.stateTag = FNTitleTypeOrderStateAll;
            orderVC.isNoti = YES;
            FNNavigationVC *nav = (FNNavigationVC *)[(FNTabBarVC *)self.window.rootViewController selectedViewController];
            [nav pushViewController:orderVC animated:YES];
        }
    }
    else if ([json[@"obj_type"] isEqualToString:@"url"])
    {
        FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:json[@"content"]]];
        
        vc.title = json[@"title"];
        
        FNNavigationVC *nav = (FNNavigationVC *)[(FNTabBarVC *)self.window.rootViewController selectedViewController];
        
        [nav pushViewController:vc animated:YES];
    }
    _remoteNoti = nil;
}

#pragma mark -

//打开网页
// 在支付页面点击X号
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([url.scheme isEqualToString:@"group.jfshare.today"])
    {
        int type = [[[url.host componentsSeparatedByString:@"="] lastObject]intValue];
        [self goDiffientVC:type];
        
        return YES;
    }
    
    
    NSString *string = url.absoluteString;
    
    if ([string hasPrefix:@"jfshare://"])
    {
        [FNStraddleService setStraddleType:FNStraddleTypeDetail];
    }
    
    if([url.host hasPrefix:@"resultCode="])
    {
        [FNStraddleService setStraddleType:FNStraddleTypeBestPay];
        
    }
    return [self handleStraddleURL:url];
}


- (void)goDiffientVC:(FNMainConfigType)configType
{
    FNTabBarVC * tabBarVC  = (FNTabBarVC *)self.window.rootViewController;
    [tabBarVC dismissViewControllerAnimated:YES completion:nil];
    FNNavigationVC *nav = (FNNavigationVC *)[tabBarVC  selectedViewController];
    
    switch (configType) {
        case FNMainBonusInterflow:
        {
            //0
            FNHopeVC *hopeVC = [[FNHopeVC alloc]init];
            [nav pushViewController:hopeVC animated:NO];
        }
            break;
            
            
        case FNMainBonusRecharge:
        {//1
            FNBonusRechargeVC *bonusRecharge = [[FNBonusRechargeVC alloc]init];
            [nav pushViewController:bonusRecharge animated:NO];
        }
            break;
        case FNMainBonusWallet:
        {//2
            FNCateProductListVC *cateProductListVC = [[FNCateProductListVC alloc]init];
            cateProductListVC.isVirtual = YES;
            cateProductListVC.secCategory.subjectId = @"1012";
            [nav  pushViewController:cateProductListVC animated:NO];

        }
            break;
        case FNMainDiscountCard:
        {//3
            NSString *url = @"https://ecentre.spdbccc.com.cn/creditcard/indexActivity.htm?data=P766829";
            NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:encodedString]];
            web.title = @"开卡有礼";
            [nav pushViewController:web animated:YES];
        }
            break;
        case FNMainBankCardGift:
        {//4
            FNSZWelcomeVC * vc = [[FNSZWelcomeVC alloc]init];
            [nav pushViewController:vc animated:NO];

        }
            break;
        case FNMainMobileRecharge:
        {//5
            FNMobileRechargeVC *mobileRecharge = [[FNMobileRechargeVC alloc]init];
            [nav pushViewController:mobileRecharge animated:NO];
        }
            break;
        case FNMainFlowRecharge:
        {//6
            
            FNFlowRechargeVC * flowRechargeVC = [[FNFlowRechargeVC alloc]init];
            [nav pushViewController:flowRechargeVC animated:NO];
        }
            break;
        case FNMainQCoinRecharge:
        {//7
            FNQCoinRechargeVC *QCoinVC = [[FNQCoinRechargeVC alloc]init];
            [nav pushViewController:QCoinVC animated:NO];
        }
            break;
        case FNMainGameCard:
        {//8
            FNGameCardVC * gameCardVC = [[FNGameCardVC alloc]init];
            [nav pushViewController:gameCardVC animated:NO];
            
        }
            break;
        case FNMainGlobalFood:
        {//9
            
            FNCateProductListVC *cateProductListVC = [[FNCateProductListVC alloc]init];
            cateProductListVC.isVirtual = NO;
            FNHeadRightModel * model = [[FNHeadRightModel alloc]init];
            model.subjectId = @"1006";
            model.subjectName = @"食品酒水";
            cateProductListVC.secCategory = model;
            [nav pushViewController:cateProductListVC animated:NO];
        }
            break;
            
        default:
            break;
    }
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleStraddleURL:url];
}

// 当该应用被其他应用打开的时候，会调用改方法，并能实现两个应用间数据的传递
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *string = url.absoluteString;
    if([url.host hasPrefix:@"resultCode="])
    {
        [FNStraddleService setStraddleType:FNStraddleTypeBestPay];
        
    }else if ([string hasPrefix:@"group.jfshare.today://"])
    {
        int type = [[[url.host componentsSeparatedByString:@"="] lastObject]intValue];
        [self goDiffientVC:type];
    }else if ([string hasPrefix:@"jfshare://"])
    {
        [FNStraddleService setStraddleType:FNStraddleTypeDetail];
    }
    
    return [self handleStraddleURL:url];
}

- (BOOL)handleStraddleURL:(NSURL *)url
{
    switch (FNStraddleServiceType)
    {
        case FNStraddleTypeUMSocial:
            
            return [UMSocialSnsService handleOpenURL:url];
            
        case FNStraddleTypeWXPay:
            
            return [WXApi handleOpenURL:url delegate:self];
            
        case FNStraddleTypeAliPay:
            
            if ([url.host isEqualToString:@"safepay"])
            {
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                }];
                [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                    
                    NSString *success = nil;
                    
                    NSArray *resultStringArray =[resultDic[@"result"] componentsSeparatedByString:NSLocalizedString(@"&", nil)];
                    for (NSString *str in resultStringArray)
                    {
                        NSString *newstring = nil;
                        newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                        for (int i = 0 ; i < [strArray count] ; i++)
                        {
                            NSString *st = [strArray objectAtIndex:i];
                            if ([st isEqualToString:@"success"])
                            {
                                success = [strArray objectAtIndex:1];
                            }
                        }
                    }
                    
                    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"] &&
                        [success isEqualToString:@"true"])
                        //&&[sign isEqualToString:FNPayInfo[@"sign"]]//这里android没有校验，暂时去掉了
                    {
                        _isActive = YES;
                        
                        NSDictionary *account = [FNUserAccountArgs getUserAccount];
                        
                        //有效期内直接进行跳转到支付成功
                        
                        if ([FNUserAccountArgs isUserAccountInfoAvailable])
                        {
                            if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                            {
                                FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                                szPayFinishVC.amount = FNPayInfo[@"price"];

                                [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                                
                            }else
                            {
                                
                                FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                                
                                finish.isFinish = YES;
                                finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                                finish.bonus = FNPayInfo[@"price"];
                                finish.orderType = [FNPayInfo[@"orderType"] intValue];
                                finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                                
                                if ([finish.isVirtual intValue]== 1)
                                {
                                    finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                                    
                                }
                                else
                                {
                                    finish.isVirtualGoods =  [FNPayInfo[@"isVirtualGoods"] boolValue];
                                }
                                
                                [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                            }
                            return ;
                        }
                        
                        if (isWechatLogin)
                        {
                            [[[FNLoginBO port02] withOutUserInfo] validateWithUnionId:FNUserWechatAccountInfo[@"unionId"] openId:account[@"openId"] token:FNUserWechatAccountInfo[@"accessToken"] block:^(id result) {
                                
                                if ([result[@"code"] integerValue] != 200)
                                {
                                    if ([result[@"code"] integerValue] == 500)
                                    {
                                        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                                            [FNLoginBO loginAuthFail];
                                        } otherTitle: nil];
                                        return ;
                                    }else
                                    {
                                        
                                        [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                                        
                                        return ;
                                    }
                                }
                                if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                                {
                                    FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                                    [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                                    
                                }else
                                {
                                    FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                                    
                                    finish.isFinish = YES;
                                    finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                                    
                                    finish.bonus = FNPayInfo[@"price"];
                                    finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                                    finish.orderType = [FNPayInfo[@"orderType"] intValue];
                                    if ([finish.isVirtual intValue]== 1)
                                    {
                                        finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                                        
                                    }
                                    else
                                    {
                                        finish.isVirtualGoods =  [FNPayInfo[@"isVirtualGoods"] boolValue];
                                    }
                                    
                                    [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                                }
                                
                                
                            }];
                        }
                        else if(account[@"pwdEnc"])
                        {
                            [[[FNLoginBO port02] withOutUserInfo] loginWithName:account[@"mobile"] pwd:account[@"pwdEnc"] block:^(id result) {
                                
                                if ([result[@"code"] integerValue] != 200)
                                {
                                    if ([result[@"code"] integerValue] == 500)
                                    {
                                        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                                            [FNLoginBO loginAuthFail];
                                        } otherTitle: nil];
                                        return ;
                                        
                                        return ;
                                    }else
                                    {
                                        [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                                        
                                        return ;
                                    }
                                }
                                
                                if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                                {
                                    FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                                    [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                                    
                                }else
                                {
                                    FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                                    
                                    finish.isFinish = YES;
                                    finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                                    finish.orderType = [FNPayInfo[@"orderType"] intValue];
                                    
                                    finish.bonus = FNPayInfo[@"price"];
                                    finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                                    
                                    if ([finish.isVirtual intValue]== 1)
                                    {
                                        finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                                        
                                    }
                                    else
                                    {
                                        finish.isVirtualGoods =  [FNPayInfo[@"isVirtualGoods"] boolValue];
                                    }
                                    
                                    [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                                    
                                }
                                
                            }];
                        }
                        else if(FNUserAccountInfo[@"userId"])
                        {
                            [[FNLoginBO port02] getAuthInfoWithBlock:^(id result) {
                                
                                if ([result[@"code"] integerValue] == 200)
                                {
                                    [FNUserAccountArgs getUserAccountInfo];
                                    
                                    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:FNUserAccountInfo];
                                    
                                    [info setObject:result[@"token"] forKey:@"token"];
                                    [info setObject:result[@"ppInfo"] forKey:@"ppInfo"];
                                    [info setObject:result[@"curTime"] forKey:@"curTime"];
                                    
                                    [FNUserAccountArgs setUserAccountInfo:info];
                                    
                                    [FNTokenFetcher start];
                                    
                                    if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                                    {
                                        FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                                        [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                                        
                                    }else
                                    {
                                        FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                                        
                                        finish.isFinish = YES;
                                        finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                                        finish.orderType = [FNPayInfo[@"orderType"] intValue];
                                        
                                        finish.bonus = FNPayInfo[@"price"];
                                        finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                                        
                                        if ([finish.isVirtual intValue]== 1)
                                        {
                                            finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                                            
                                        }
                                        else
                                        {
                                            finish.isVirtualGoods =  [FNPayInfo[@"isVirtualGoods"] boolValue];
                                        }
                                        
                                        [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                                    }
                                }
                                else
                                {
                                    [FNTokenFetcher cancel];
                                    
                                    [FNUserAccountArgs removeUserAccountInfo];
                                    
                                    [FNLoginBO loginAuthFail];
                                }
                            }];
                        }
                    }
                    else
                    {
                        [self goOfficialPopBack:YES];
                    }
                }];
                
                [[AlipaySDK defaultService] processAuth_V2Result:url
                                                 standbyCallback:^(NSDictionary *resultDic) {
                                                     
                                                     
                                                 }];
                
            }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
                [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
                    
                }];
            }
            
            return YES;
            
        case FNStraddleTypeNone:
            
            return YES;
            
        case FNStraddleTypeDetail:
        {
            NSString *string = url.absoluteString;
            NSArray * productArr = [string componentsSeparatedByString:@"/"];
            NSString * secondStr = productArr[2];
            NSString *productId = [productArr lastObject];
            
            if([secondStr isEqualToString:@"detail"] && ![NSString isEmptyString:productId])
            {
                FNTabBarVC *tabBarVC = (FNTabBarVC *)self.window.rootViewController;
                FNNavigationVC *navVC = [tabBarVC selectedViewController];
                UIViewController *viewController = navVC.childViewControllers.lastObject;
                if([viewController isKindOfClass:[FNPayVC class]])
                {
                    return  YES;
                }
                else if ([viewController isKindOfClass:[FNDetailVC class]])
                {
                    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:navVC.viewControllers];
                    [navigationArray removeLastObject];
                    navVC.viewControllers = navigationArray;
                    
                    FNDetailVC * vc = [[FNDetailVC alloc]init];
                    vc.fromOtherApp = YES;
                    vc.productId = productId;
                    [navVC pushViewController:vc animated:YES];
                }
                else
                {
                    FNDetailVC * vc = [[FNDetailVC alloc]init];
                    vc.fromOtherApp = YES;
                    vc.productId = productId;
                    [navVC  pushViewController:vc animated:YES];
                }
            }
        }
            return YES;
            
        case FNStraddleTypeBestPay:
            
            [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"确保结果显示不会出错:%@",resultDic);
            }];
            
            return YES;
    }
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        if (resp.errCode == WXSuccess)
        {
            _isActive = YES;
            
            NSDictionary *account = [FNUserAccountArgs getUserAccount];
            
            //有效期内直接进行跳转到支付成功
            
            if ([FNUserAccountArgs isUserAccountInfoAvailable])
            {
                if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                {
                    FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                    [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                    
                }else
                {
                    FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                    
                    finish.isFinish = YES;
                    finish.orderType = [FNPayInfo[@"orderType"] intValue];
                    
                    finish.bonus = FNPayInfo[@"price"];
                    finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                    finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                    
                    if ([finish.isVirtual intValue]== 1)
                    {
                        finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                        
                    }
                    else
                    {
                        finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                    }
                    [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                }
                return ;
            }
            
            if (isWechatLogin)
            {
                [[[FNLoginBO port02] withOutUserInfo] validateWithUnionId:FNUserWechatAccountInfo[@"unionId"] openId:account[@"openId"] token:FNUserWechatAccountInfo[@"accessToken"] block:^(id result) {
                    
                    if ([result[@"code"] integerValue] != 200)
                    {
                        if ([result[@"code"] integerValue] == 500)
                        {
                            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                                [FNLoginBO loginAuthFail];
                            } otherTitle: nil];
                            return ;
                            
                            return ;
                        }else
                        {
                            [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                            
                            return ;
                        }
                    }
                    if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                    {
                        FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                        [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                        
                    }else
                    {
                        
                        FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                        
                        finish.isFinish = YES;
                        finish.orderType = [FNPayInfo[@"orderType"] intValue];
                        
                        finish.bonus = FNPayInfo[@"price"];
                        finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                        
                        finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                        
                        if ([finish.isVirtual intValue]== 1)
                        {
                            finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                            
                        }
                        else
                        {
                            finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                        }
                        [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                    }
                }];
            }
            else if (account[@"pwdEnc"])
            {
                [[[FNLoginBO port02] withOutUserInfo] loginWithName:account[@"mobile"] pwd:account[@"pwdEnc"] block:^(id result) {
                    
                    if ([result[@"code"] integerValue] != 200)
                    {
                        if ([result[@"code"] integerValue] == 500)
                        {
                            [UIAlertView alertViewWithMessage:result[@"desc"]];
                            
                            return ;
                        }else
                        {
                            [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                            
                            return ;
                        }
                    }
                    if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                    {
                        FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                        [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                        
                    }else
                    {
                        FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                        
                        finish.isFinish = YES;
                        finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                        finish.orderType = [FNPayInfo[@"orderType"] intValue];
                        
                        finish.bonus = FNPayInfo[@"price"];
                        finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                        
                        if ([finish.isVirtual intValue]== 1)
                        {
                            finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                            
                        }
                        else
                        {
                            finish.isVirtualGoods =  [FNPayInfo[@"isVirtualGoods"] boolValue];
                        }
                        [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                    }
                }];
            }
            else if(FNUserAccountInfo[@"userId"])
            {
                [[FNLoginBO port02] getAuthInfoWithBlock:^(id result) {
                    
                    if ([result[@"code"] integerValue] == 200)
                    {
                        [FNUserAccountArgs getUserAccountInfo];
                        
                        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:FNUserAccountInfo];
                        
                        [info setObject:result[@"token"] forKey:@"token"];
                        [info setObject:result[@"ppInfo"] forKey:@"ppInfo"];
                        [info setObject:result[@"curTime"] forKey:@"curTime"];
                        
                        [FNUserAccountArgs setUserAccountInfo:info];
                        
                        [FNTokenFetcher start];
                        if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                        {
                            FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                            [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                            
                        }else
                        {
                            FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                            
                            finish.isFinish = YES;
                            finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                            finish.orderType = [FNPayInfo[@"orderType"] intValue];
                            
                            finish.bonus = FNPayInfo[@"price"];
                            finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                            
                            if ([finish.isVirtual intValue]== 1)
                            {
                                finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                                
                            }
                            else
                            {
                                finish.isVirtualGoods =  [FNPayInfo[@"isVirtualGoods"] boolValue];
                            }
                            [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                        }
                    }
                    else
                    {
                        [FNTokenFetcher cancel];
                        
                        [FNUserAccountArgs removeUserAccountInfo];
                        
                        [FNLoginBO loginAuthFail];
                    }
                }];
            }
            
        }
        else
        {
            _isActive = NO;
            
            [self goOfficialPopBack:YES];
        }
    }
}

//yes为官方渠道app跳转，no为按home键返回
//必须先登录成功再进行跳转
//每次回到桌面重新登录，

- (void)goOfficialPopBack:(BOOL)isOfficialBack
{
    NSDictionary *account = [FNUserAccountArgs getUserAccount];
    
    //客户端激活后就不用登录了
    if (_isActive)
    {
        return;
    }
    
    _isActive = YES;
    
    //判断token是否在有效期内，有效期为返回token 刷新时间的90%，超过则进行刷新
    
    if ([FNUserAccountArgs isUserAccountInfoAvailable])
    {
        [[FNCartBO port02] getCartCountWithBlock:nil];
        
        [self routeVC:isOfficialBack];
        
        return;
    }
    
    //微信登陆
    
    if (isWechatLogin)
    {
        [FNUserAccountArgs getUserWechatAccountInfo];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *date = [FNUserWechatAccountInfo valueForKey:@"currentDate"];
        
        NSDate *sysDate = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
        
        NSTimeInterval inter = [sysDate timeIntervalSinceDate:date];
        
        NSTimeInterval intervalAccess = 2.0 * 60.0 * 60.0 - inter;       //小于1小时55分
        
        NSTimeInterval intervalRefresh = 30.0 * 24.0 * 60.0 * 60.0 - inter;      //小于29天
        
        if (!FNUserWechatAccountInfo)
        {
            return;
        }
        
        if (intervalAccess <= 5.0 * 60 || (intervalRefresh < 24.0 * 60 * 60 && intervalRefresh > 0))
        {
            [[[[FNLoginBO port02] withOutUserInfo] isWX] refreshWithToken:FNUserWechatAccountInfo[@"refreshToken"] block:^(id result) {
                
                if (result[@"errcode"])
                {
                    [FNUserAccountArgs removeUserAccount];
                    
                    [FNUserAccountArgs removeUserAccountInfo];
                    
                    return ;
                }
                
                //微信－刷新access_token之后再进行鉴权操作
                
                [[[FNLoginBO port02] withOutUserInfo] validateWithUnionId:FNUserWechatAccountInfo[@"unionId"] openId:account[@"openId"] token:FNUserWechatAccountInfo[@"accessToken"] block:^(id result) {
                    
                    if ([result[@"code"] integerValue] != 200)
                    {
                        if ([result[@"code"] integerValue] == 500)
                        {
                            [UIAlertView alertViewWithMessage:result[@"desc"]];
                            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                                [FNLoginBO loginAuthFail];
                            } otherTitle: nil];
                            return ;
                            
                            
                        }else
                        {
                            [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                            
                            return ;
                        }
                    }
                    
                    [self routeVC:isOfficialBack];
                }];
                
            }];
        }
        else if (intervalRefresh <= 0)
        {
            [FNUserAccountArgs removeUserWechatAccountInfo];
        }
        else
        {
            //微信信息未过期，则直接登录
            
            [[[FNLoginBO port02] withOutUserInfo] validateWithUnionId:account[@"unionId"] openId:account[@"openId"] token:account[@"accessToken"] block:^(id result) {
                
                if ([result[@"code"] integerValue] != 200)
                {
                    if ([result[@"code"] integerValue] == 500)
                    {
                        [UIAlertView alertViewWithMessage:result[@"desc"]];
                        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                            [FNLoginBO loginAuthFail];
                        } otherTitle: nil];
                        return ;
                    }else
                    {
                        [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                        
                        return ;
                    }
                }
                
                
                [self routeVC:isOfficialBack];
            }];
        }
        
        return;
    }
    
    // 正常账号密码登陆
    
    if (account[@"pwdEnc"])
    {
        [[[FNLoginBO port02] withOutUserInfo] loginWithName:account[@"mobile"] pwd:account[@"pwdEnc"] block:^(id result) {
            
            if ([result[@"code"] integerValue] != 200)
            {
                if ([result[@"code"] integerValue] == 500)
                {
                    [UIAlertView alertViewWithMessage:result[@"desc"]];
                    [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                        [FNLoginBO loginAuthFail];
                    } otherTitle: nil];
                    return ;
                    
                }else
                {
                    [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                    
                }
                return ;
                
            }
            [self routeVC:isOfficialBack];
        }];
    }
    else if(FNUserAccountInfo[@"userId"])
    {
        [[FNLoginBO port02] getAuthInfoWithBlock:^(id result) {
            
            if ([result[@"code"] integerValue] == 200)
            {
                [FNUserAccountArgs getUserAccountInfo];
                
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:FNUserAccountInfo];
                
                [info setObject:result[@"token"] forKey:@"token"];
                [info setObject:result[@"ppInfo"] forKey:@"ppInfo"];
                [info setObject:result[@"curTime"] forKey:@"curTime"];
                
                [FNUserAccountArgs setUserAccountInfo:info];
                
                [[FNCartBO port02] getCartCountWithBlock:nil];
                
                [FNTokenFetcher start];
                
                [self routeVC:isOfficialBack];
            }
            else
            {
                [FNTokenFetcher cancel];
                
                [FNUserAccountArgs removeUserAccountInfo];
                
                [FNLoginBO loginAuthFail];
            }
        }];
    }
}

- (void)routeVC:(BOOL)isOfficialBack
{
    if (!FNPayInfo)
    {
        return;
    }
    
    if (isOfficialBack)
    {
        if ( FNStraddleServiceType != FNStraddleTypeBestPay )
        {
            
            FNPayInfo = nil;
            [UIAlertView alertViewWithMessage:@"支付已取消"];
        }
        
        for (UIViewController *vc  in FNPayVCExtern.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[FNOrderVC class]])
            {
                [FNPayVCExtern.navigationController popToViewController:vc animated:YES];
                
                return ;
            }
            else if ([vc isKindOfClass:[FNPayVC class]])
            {
                NSObject *root = [[self window] rootViewController];
                
                if ([root isKindOfClass:[FNTabBarVC class]])
                {
                    FNTabBarVC *tab = (FNTabBarVC *)root;
                    
                    [tab goTabIndex:3];
                    
                    UINavigationController *my = [tab selectedViewController];
                    
                    FNOrderVC *orderVC = [[FNOrderVC alloc]init];
                    
                    orderVC.stateTag = FNTitleTypeOrderStatePaying;
                    
                    orderVC.isPayFinish = YES;
                    
                    [my pushViewController:orderVC animated:NO];
                }
                return;
            }
        }
    }
    else
    {
        
        [[FNCartBO port02] getOrderDetailWithOrderID:[FNPayInfo[@"orderId"] lastObject] block:^(id result){
            
            if (![result isKindOfClass:[FNOrderArgs class]])
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];
                
                return ;
            }
            
            FNOrderArgs *order = (FNOrderArgs *)result;
            
            switch ([order.orderState integerValue])
            {
                case FNOrderStateShipping:
                case FNOrderStateFinish:
                case FNOrderStateFinishCommenting:
                {
                    if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                    {
                        FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                        [FNPayVCExtern.navigationController pushViewController:szPayFinishVC animated:YES];
                        
                    }else
                    {
                        FNPayFinishVC *finish = [[FNPayFinishVC alloc] init];
                        
                        finish.isFinish = YES;
                        finish.orderType = [FNPayInfo[@"orderType"] intValue];
                        
                        finish.bonus = FNPayInfo[@"price"];
                        finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                        
                        finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                        
                        if ([finish.isVirtual intValue]== 1)
                        {
                            finish.isVirtualGoods = YES;
                            
                        }
                        else
                        {
                            finish.isVirtualGoods = NO;
                        }
                        [FNPayVCExtern.navigationController pushViewController:finish animated:YES];
                    }
                }
                    break;
                case FNOrderStatePaying:
                {
                    [UIAlertView alertViewWithMessage:@"支付已取消"];
                    
                    FNPayInfo = nil;
                    
                    NSObject *root = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
                    
                    if ([root isKindOfClass:[FNTabBarVC class]])
                    {
                        FNTabBarVC *tab = (FNTabBarVC *)root;
                        
                        [tab goTabIndex:3];
                        
                        UINavigationController *my = [tab selectedViewController];
                        
                        FNOrderVC *orderVC = [[FNOrderVC alloc]init];
                        
                        orderVC.stateTag = FNTitleTypeOrderStatePaying;
                        
                        [my pushViewController:orderVC animated:NO];
                    }
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
    }
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    _isActive = NO;
    
    [FNTokenFetcher cancel];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//  网页打开
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //---这里需要保存时间，下次进行比较，如果小于30分钟，则进行timer刷新，否则不进行刷新
    //这里直接进行刷新token，如果时间短，则会一直刷新，超时后，鉴权失败的问题还是没解决，如果时间长，则很长刷新，直接提示鉴权失败
    
    [self goOfficialPopBack:NO];
    [UMSocialSnsService  applicationDidBecomeActive];
    
    [FNStraddleService setStraddleType:FNStraddleTypeNone];
    
    [FNPushManager setBadge:0];
    
    [self setRemoteNoti];
    
    if (FNMyIsEnforceUpdate == 2)
    {
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:FNMyUpdateInfo[@"upgradeDesc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FNMyUpdateInfo[@"url"]]];
            }
            
        } otherTitle:nil, nil];
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
