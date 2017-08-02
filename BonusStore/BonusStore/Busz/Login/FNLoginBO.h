//
//  FNLoginBO.h
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseBO.h"
#import "FNHeader.h"

UIKIT_EXTERN BOOL FNUserAccountIsLogin;

UIKIT_EXTERN BOOL FNUserAccountIsSameToLastTime;

UIKIT_EXTERN BOOL FNUserAccountIsAuthFail;

@interface FNLoginBO : FNBaseBO
+(void)loginCancel;

//鉴权失败，处理501错误
+ (void)loginAuthFail;

+ (BOOL)isLogin;

//校验失败后，提示用户是否重新登录
+ (void)autoLoginWithBlock:(FNNetFinish)block;

@end

@interface FNLoginBO (Extension)

//登录(手机\短信)
+ (void)loginWithMobile:(NSString *)mobile sms:(NSString *)sms block:(FNNetFinish)block;

/**
 *  登录：有验证码
 *
 *  @param mobile mobile
 *  @param pwd    password
 *  @param code   the graphic code value
 *  @param random the random value pass to server
 *  @param block  callback
 */
+ (void)loginWithMobile:(NSString *)mobile pwd:(NSString *)pwd code:(NSString *)code random:(NSUInteger)random block:(FNNetFinish)block;

//登录：无验证码
+ (void)loginWithName:(NSString *)name pwd:(NSString *)pwd block:(FNNetFinish)block;

//获取短信验证码
+ (void)getSMSWithMobile:(NSString *)mobile block:(FNNetFinish)block;


//用户名密码注册
+ (void)registerWithMobile:(NSString *)mobile pwd:(NSString *)pwd codeID:(NSString *)codeID code:(NSString *)code block:(FNNetFinish)block;

//重置密码
+ (void)resetPwdWithMobile:(NSString *)mobile pwd:(NSString *)pwd captcha:(NSString *)captcha block:(FNNetFinish)block;


//有图验的获取验证码
+ (void)getSMSWithMobile:(NSString *)mobile  withId:(NSString *)codeId  value:(NSString *)value block:(FNNetFinish)block;

//判断手机号是否存在
+ (void)isRegisterWithMobile:(NSString *)mobile block:(FNNetFinish)block;

//获取鉴权信息
+ (void)getAuthInfoWithBlock:(FNNetFinish)block;

//校验wechat token
+ (void)validateWithUnionId:(NSString *)unionId openId:(NSString *)openId token:(NSString *)token block:(FNNetFinish)block;

//刷新wechat token
+ (void)refreshWithToken:(NSString *)token block:(FNNetFinish)block;

//绑定手机号
+ (void)bindMobile:(NSString *)mobile captcha:(NSString *)captcha block:(FNNetFinish)block;

@end
