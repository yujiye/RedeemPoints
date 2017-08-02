//
//  FNLoginBO.m
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNLoginBO.h"
#import "FNCartBO.h"

BOOL FNUserAccountIsLogin;      //这个应该放到登陆之后自动设置

BOOL FNUserAccountIsSameToLastTime;    //被踢下线后，再次登陆是否与上次登陆是同一账号，如果是：直接dismiss，否则：回到首页

BOOL FNUserAccountIsAuthFail;  //是否是被踢下线

@implementation FNLoginBO

// 被踢下线点击“取消”按钮
+(void)loginCancel
{

    FNUserAccountIsAuthFail = NO ;

    [FNTokenFetcher cancel];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[FNUserAccountArgs getUserAccount]];
    
    [info removeObjectForKey:@"pwdEnc"];
    
    [FNUserAccountArgs setUserAccount:info];

     [[NSNotificationCenter defaultCenter] postNotificationName:FNUserAccountCancelNotification object:@{@"isAuth":@(YES)}];
    
}



+ (void)loginAuthFail
{
    FNUserAccountIsAuthFail = NO ;

    [FNTokenFetcher cancel];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[FNUserAccountArgs getUserAccount]];
    
    [info removeObjectForKey:@"pwdEnc"];
    
    [FNUserAccountArgs setUserAccount:info];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FNUserAccountIsLoginNotification object:@{@"isAuth":@(YES)}];
}

+ (BOOL)isLogin
{
    [FNUserAccountArgs getUserAccountInfo];
    
    if (!FNUserAccountInfo)
    {
        FNUserAccountIsLogin = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FNUserAccountIsLoginNotification object:@{@"isLogin":@(FNUserAccountIsLogin)}];
    }
    else
    {
        FNUserAccountIsLogin = YES;
    }
    
    return FNUserAccountIsLogin;
}

+ (void)autoLoginWithBlock:(FNNetFinish)block
{
    NSDictionary *account = [FNUserAccountArgs getUserAccount];

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
                    
                    block(nil);
                    
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
                    
                             block(nil);
                            return ;
                        }else
                        {
                            [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                             block(nil);
                            return ;
                        }
                    }
                    
                    
                    block(result);

                }];
                
            }];
        }
        else if (intervalRefresh <= 0)
        {
            [FNUserAccountArgs removeUserWechatAccountInfo];
            
            block(nil);
        }
        else
        {
            //微信信息未过期，则直接登录
            
            [[[FNLoginBO port02] withOutUserInfo] validateWithUnionId:account[@"unionId"] openId:account[@"openId"] token:account[@"accessToken"] block:^(id result) {
                
                
                if ([result[@"code"] integerValue] != 200)
                {
                    if ([result[@"code"] integerValue] == 500)
                    {
                        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                            [FNLoginBO loginAuthFail];
                        } otherTitle: nil];
               
                        block(nil);
                        return ;
                    }else
                    {
                        [UIAlertView alertViewWithMessage:@"登录失败，请重试"];
                        block(nil);
                        return ;
                    }
                }

                block(result);
                
            }];
        }
        
        return;
    }
    
    // 正常账号密码登陆
    
    if (account[@"pwdEnc"])
    {
        [[[FNLoginBO port02] withOutUserInfo] loginWithName:account[@"mobile"] pwd:account[@"pwdEnc"] block:^(id result) {
            
            if ([result[@"code"] integerValue] == 200)
            {
                if ([result[@"failCode"] integerValue] == 1999)
                {
                    //log remark.
                    [UIAlertView alertViewWithMessage:result[@"failCode"]];
                }
                else
                {
                    block(result);
                }
            }
            else
            {
                if ([result[@"code"] integerValue] == 500)
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];
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

                block(result);
            }
            else
            {
                [FNTokenFetcher cancel];
                
                [FNUserAccountArgs removeUserAccountInfo];
                
                [FNLoginBO loginAuthFail];
                
                block(nil);
            }
        }];
    }
}

@end

@implementation FNLoginBO(Extension)

+ (void)loginWithMobile:(NSString *)mobile sms:(NSString *)sms block:(FNNetFinish)block
{
    NSDictionary *para = @{@"mobile":mobile,
                           @"captchaDesc":sms,
                           @"browser":[FNDevice idfa]};
    
    [[FNNetManager shared] postURL:@"buyer/login" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            //需要判断是否是同一账号，是：直接dismiss，否：回到首页
            
            NSDictionary *info = [FNUserAccountArgs getUserAccount];
            
            if (FNUserAccountIsAuthFail)
            {
                if ([mobile isEqualToString:info[@"mobile"]])
                {
                    FNUserAccountIsSameToLastTime = YES;
                }
                else
                {
                    FNUserAccountIsSameToLastTime = NO;
                }
            }
            
            [FNUserAccountArgs setUserAccount:@{@"mobile":mobile}];

            [FNUserAccountArgs removeUserAccountInfo];
            
            [FNUserAccountArgs setUserAccountInfo:result];
            
//            [FNSZTongAuthArgs setToken:result[@"token"] openID:result[@"openId"]];        //深圳通鉴权信息
            
            [[FNCartBO port02] getCartCountWithBlock:nil];

            [FNTokenFetcher start];
            
            block(FNUserAccountInfo);
            
            return ;
        }
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)loginWithMobile:(NSString *)mobile pwd:(NSString *)pwd code:(NSString *)code random:(NSUInteger)random block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":mobile,
                                                                                @"pwdEnc":pwd,
                                                                                @"browser":[FNDevice idfa]
                                                                                }];
    
    if (code)
    {
        [para addEntriesFromDictionary:@{@"id":[NSString stringWithFormat:@"%@",@(random)],
                                         @"value":[code lowercaseString]}];
    }
    else
    {
        [para addEntriesFromDictionary:@{@"type":@"1"}];
    }
    
    [[FNNetManager shared] postURL:@"buyer/login2" paras:para finish:^(id result) {
        
        //login finish auto get cart count.
        
        if ([result[@"code"] integerValue] == 200)
        {
            //需要判断是否是同一账号，是：直接dismiss，否：回到首页
            
            NSDictionary *info = [FNUserAccountArgs getUserAccount];

            if (FNUserAccountIsAuthFail)
            {
                if ([mobile isEqualToString:info[@"mobile"]])
                {
                    FNUserAccountIsSameToLastTime = YES;
                }
                else
                {
                    FNUserAccountIsSameToLastTime = NO;
                }
            }
            
            [FNUserAccountArgs setUserAccount:@{@"mobile":mobile,
                                                @"pwdEnc":pwd}];
            
//            [FNSZTongAuthArgs setToken:result[@"token"] openID:result[@"openId"]];        //深圳通鉴权信息
            
            [FNUserAccountArgs removeUserAccountInfo];
            
            [FNUserAccountArgs setUserAccountInfo:result];
                        
            [FNUserAccountArgs getUserAccountInfo];
            
            [[FNCartBO port02] getCartCountWithBlock:nil];  //
            
            [FNTokenFetcher start];
            
            block(FNUserAccountInfo);
            
            return ;
        }
        else
        {
            [FNUserAccountArgs removeUserAccountInfo];
        }
        
        if (block)
        {
            block(result);
        }
        
    } fail:^(NSError *error) {
        
        if (block)
        {
            block(nil);
        }
    }];
}

+ (void)loginWithName:(NSString *)name pwd:(NSString *)pwd block:(FNNetFinish)block;
{
    [self loginWithMobile:name pwd:pwd code:nil random:0 block:block];
}



+ (void)getSMSWithMobile:(NSString *)mobile  withId:(NSString *)codeId  value:(NSString *)value block:(FNNetFinish)block
{
    NSDictionary *para = [NSDictionary dictionary];
    if (![NSString isEmptyString:mobile])
    {
        para = @{
                 @"mobile":mobile ,
                 @"id":codeId,
                  @"value":value
                 };
    }
    
    [[FNNetManager shared]postURL:@"buyer/sendMs" paras:para finish:^(id  _Nonnull result) {
        block(result);

    } fail:^(NSError * _Nonnull error) {
        block(nil);

    }];
   
}


+ (void)validateWithSMS:(NSString *)mobile captcha:(NSString *)captcha block:(FNNetFinish)block
{    
    NSDictionary *para = @{@"mobile":mobile,
                           @"captchaDesc":captcha};
    
    [[FNNetManager shared] getURL:@"buyer/validateMsgCaptcha" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)registerWithMobile:(NSString *)mobile pwd:(NSString *)pwd codeID:(NSString *)codeID code:(NSString *)code block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"mobile":mobile,
                                                                                @"pwdEnc":pwd,
                                                                                @"captchaDesc":codeID}];

    [[FNNetManager shared] postURL:@"buyer/regist" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)resetPwdWithMobile:(NSString *)mobile pwd:(NSString *)pwd captcha:(NSString *)captcha block:(FNNetFinish)block
{
    NSDictionary *para = @{@"mobile":mobile,
                           @"newPwd":pwd,
                           @"captchaDesc":captcha};
    
    [[FNNetManager shared] postURL:@"buyer/resetPwd" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)isRegisterWithMobile:(NSString *)mobile block:(FNNetFinish)block
{
    NSDictionary *para = @{@"mobile":mobile};
    
    [[FNNetManager shared] getURL:@"buyer/exists" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getAuthInfoWithBlock:(FNNetFinish)block
{
    NSDictionary *para = @{@"mobile":FNUserAccountInfo[@"loginName"]};
    
    [[FNNetManager shared] postURL:@"buyer/getAuthInfo" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)validateWithUnionId:(NSString *)unionId openId:(NSString *)openId token:(NSString *)token block:(FNNetFinish)block
{
    NSDictionary *para = @{@"browser":[FNDevice idfa],
                           @"thirdType":@(FNShareTypeWechat),
                           @"accessToken":token,
                           @"custId":unionId,
                           @"openId":openId,};

    [[FNNetManager shared] postURL:@"buyer/existsThirdUser" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            if (result[@"token"] && result[@"ppInfo"])
            {
                [FNUserAccountArgs setUserAccount:@{@"unionId":unionId,
                                                    @"openId":openId,
                                                    @"accessToken":token}];
                
//                [FNSZTongAuthArgs setToken:result[@"token"] openID:result[@"openId"]];        //深圳通鉴权信息
                
                [FNUserAccountArgs removeUserAccountInfo];
                
                
                [FNUserAccountArgs setUserAccountInfo:result];
                
                [FNUserAccountArgs getUserAccountInfo];
                
                [[FNCartBO port02] getCartCountWithBlock:nil];  //
                
                [FNTokenFetcher start];
            }
        }
        else
        {
            [FNUserAccountArgs removeUserAccountInfo];
        }

        if (block)
        {
            block(result);
        }
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)refreshWithToken:(NSString *)token block:(FNNetFinish)block
{
    NSDictionary *para = @{@"appid":FN_WECHAT_ID,
                           @"grant_type":@"refresh_token",
                           @"refresh_token":token};

    [[FNNetManager shared] getURL:@"oauth2/refresh_token" paras:para finish:^(id result) {

        if (result && !result[@"errcode"])
        {
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:FNUserWechatAccountInfo];
            [info setValue:result[@"access_token"] forKey:@"accessToken"];
            [info setValue:result[@"refresh_token"] forKey:@"refreshToken"];
            [info setValue:result[@"openid"] forKey:@"openId"];
            [FNUserAccountArgs setUserWechatAccountInfo:info];
            
//            [FNSZTongAuthArgs setToken:result[@"access_token"] openID:result[@"openid"]];        //深圳通鉴权信息
        }

        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)bindMobile:(NSString *)mobile captcha:(NSString *)captcha block:(FNNetFinish)block
{
    NSDictionary *para = @{@"mobile":mobile,
                           @"captchaDesc":captcha,
                           @"browser":[FNDevice idfa],
                           @"openId":FNUserWechatAccountInfo[@"openId"],
                           @"accessToken":FNUserWechatAccountInfo[@"accessToken"],
                           @"custId":FNUserWechatAccountInfo[@"unionId"],
                           @"extInfo":@"",      //扩展信息,现在可以不传
                           @"thirdType":@(FNShareTypeWechat),};

    [[FNNetManager shared] postURL:@"buyer/thirdUserSignin" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            [FNUserAccountArgs setUserAccount:@{@"unionId":FNUserWechatAccountInfo[@"unionId"],
                                                @"openId":FNUserWechatAccountInfo[@"openId"],
                                                @"accessToken":FNUserWechatAccountInfo[@"accessToken"]}];
            
            [FNUserAccountArgs removeUserAccountInfo];
            
            [FNUserAccountArgs setUserAccountInfo:result];
            
            [FNUserAccountArgs getUserAccountInfo];
            
            [[FNCartBO port02] getCartCountWithBlock:nil];  //
            
            [FNTokenFetcher start];
        }
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

@end
