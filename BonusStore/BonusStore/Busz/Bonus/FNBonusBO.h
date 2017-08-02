//
//  FNBonusBO.h
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseBO.h"

@interface FNBonusBO : FNBaseBO

// 验证手机号是否是广东电信账号

+ (void)isPurchaseMobile:(NSString *)mobile block:(FNNetFinish)block;

// 积分兑出登录鉴权
+(void)userAuthorizeWithScore:(NSString *)score  block:(FNNetFinish)block;

//获取用户积分
+ (void)getBonusWithBlock:(FNNetFinish)block;

//获取用户积分列表
+ (void)getBonusListWithPage:(NSInteger)page time:(FNBonusTime)time type:(FNBonusType)type block:(FNNetFinish)blcok;

//积分充值
+ (void)rechargeBonusWithCardName:(NSString *)cardName cardPsd:(NSString *)cardPsd block:(FNNetFinish)block;

//查询积分充值记录
+ (void)getRechargeBonusListWithPreCount:(NSInteger)perCount curPage:(NSInteger)curPage block:(FNNetFinish)block;

//
+ (void)teleInWithBlock:(FNNetFinish)block;

//  检测该手机号是否被其他聚分享账号绑定
+ (void)checkTeleBindedWithMobile:(NSString *)mobile block:(FNNetFinish)block;

// 兑换的时候先查询是否绑定了手机账号（也就是是否是第一次兑换），如果绑定了就直接拿绑定的手机号
+ (void)checkAccountIsBinded:(FNNetFinish)block;

//兑出积分查询
+ (void)getBonusDetailWithBlock:(FNNetFinish)block;

//兑出积分 （如果第一次兑换的话就绑定账号）
+ (void)teleOutWithMobile:(NSString *)mobile bonus:(NSInteger)bonus prame:(NSArray *)prameArr captchaDesc:(NSString *)captchaDesc block:(FNNetFinish)block;

@end
