//
//  FNBonusBO.m
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusBO.h"

@implementation FNBonusBO
+ (void)isPurchaseMobile:(NSString *)mobile block:(FNNetFinish)block
{
    NSDictionary *para = @{@"mobile":mobile};
    [[FNNetManager shared]postURL:@"buyer/isPurchaseMobile" paras:para finish:^(id  _Nonnull result) {
        block(result);

    } fail:^(NSError * _Nonnull error) {
        block(nil);

    }];

}

+(void)userAuthorizeWithScore:(NSString *)score block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"1" forKey:@"h5Type"];
    [para setObject:score forKey:@"score"];
    [[FNNetManager shared] postURL:@"buyer/userAuthorize" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];

}

+ (void)getBonusWithBlock:(FNNetFinish)block
{
    NSDictionary *para = nil;
    
    [[FNNetManager shared] postURL:@"buyer/scoreTotal" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

//不传参数type为获取全部getBonusListWithPage
+ (void)getBonusListWithPage:(NSInteger)page time:(FNBonusTime)time type:(FNBonusType)type block:(FNNetFinish)blcok
{
    NSString *st = @"";
    
    NSString *et = @"";
    
    NSDictionary * para;
    
    switch (time)
    {
        case FNBonusTimeAll:
            
            break;
        case FNBonusTimeDay:
            
            st = [FNTools timeWithInterval:-24*60*60];
            et = [FNTools timeWithDate:[NSDate date]];
            break;
        case FNBonusTimeTriduum:
            st = [FNTools timeWithInterval:-24*2*60*60];
            et = [FNTools timeWithDate:[NSDate date]];
            break;
        case FNBonusTimeWeek:
            st = [FNTools timeWithInterval:-24*7*60*60];
            et = [FNTools timeWithDate:[NSDate date]];
            break;
        case FNBonusMonth:
            st = [FNTools timeWithInterval:-24*30*60*60];
            et = [FNTools timeWithDate:[NSDate date]];
            break;
        case FNBonusTrimester:
            st = [FNTools timeWithInterval:-24*90*60*60];
            et = [FNTools timeWithDate:[NSDate date]];
            break;
            
        default:
            break;
    }
    
    if (type)
    {
        para = @{@"curPage":@(page),
                 @"perCount":@(MAIN_PER_PAGE),
                 @"type":@(type),
                 @"inOrOut":@(FNBonusIncomeTypeAll),
                 @"startTime":st,
                 @"endTime":et
                 };
    }
    else
    {
        para = @{@"curPage":@(page),
                 @"perCount":@(MAIN_PER_PAGE),
                 @"type":@(type),
                 @"inOrOut":@(FNBonusIncomeTypeAll),
                 @"startTime":st,
                 @"endTime":et
                 };
    }
    
    [[FNNetManager shared] postURL:@"buyer/scoreTrade" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray * array = [NSMutableArray array];
            
            for (NSDictionary * dict in result[@"scoreTrades"])
            {
                [array addObject:[FNBonusDetailedModel makeEntityWithJSON:dict]];
            }
            
            blcok(array);
            
            return ;
        }
        
        blcok(result);
        
    } fail:^(NSError *error) {
        
        blcok(nil);
        
    }];
}

+ (void)rechargeBonusWithCardName:(NSString *)cardName cardPsd:(NSString *)cardPsd block:(FNNetFinish)block
{
    NSDictionary *para = @{@"cardName":cardName,
                           @"cardPsd":cardPsd
                           };
    [[FNNetManager shared]postURL:@"buyer/recharge" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
    }];
}

+ (void)getRechargeBonusListWithPreCount:(NSInteger)perCount curPage:(NSInteger)curPage block:(FNNetFinish)block
{
    NSDictionary *para = @{@"perCount":@(perCount),
                           @"curPage":@(curPage)
                           };
    [[FNNetManager shared]postURL:@"buyer/queryRechargeCards" paras:para finish:^(id result) {
        
      
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
    }];
}


//  检测该手机号是否被其他聚分享账号绑定
+ (void)checkTeleBindedWithMobile:(NSString *)mobile block:(FNNetFinish)block
{
    NSDictionary *para = @{@"account":mobile};
    [[FNNetManager shared]postURL:@"buyer/isAccountRela" paras:para finish:^(id result) {
        
        block(result);
        
        
    } fail:^(NSError *error) {
        block(nil);
        
    }];
    
}


// 下一次兑换的时候先查询是否绑定了账号，如果绑定了就直接拿绑定的手机号
+ (void)checkAccountIsBinded:(FNNetFinish)block
{
    NSString * para = nil;

    [[FNNetManager shared] postURL:@"buyer/isUserIdRela" paras:para  finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
    
    
}

//tele -> jfshare == url
+ (void)teleInWithBlock:(FNNetFinish)block
{
    NSString * para = nil;

    [[FNNetManager shared] getURL:@"active/toExchangeDianXin" paras:para finish:^(id result) {
      
        block(result);
        
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getBonusDetailWithBlock:(FNNetFinish)block
{
    NSString * para = nil;
    [[FNNetManager shared] postURL:@"buyer/queryCachAmount" paras:para finish:^(id result) {
        
        block(result);
        
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)teleOutWithMobile:(NSString *)mobile bonus:(NSInteger)bonus prame:(NSArray *)prameArr captchaDesc:(NSString *)captchaDesc block:(FNNetFinish)block
{    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(bonus) forKey:@"CachAmount"];
    [para setObject:mobile forKey:@"deviceNo"];
    [para setObject:captchaDesc forKey:@"captchaDesc"];
    NSDictionary * userInfo =  [FNUserAccountArgs getUserAccount];
    NSString * bonusMobile = [userInfo valueForKey:@"mobile"];
    
    [para setObject:bonusMobile forKey:@"mobile"];
    if(prameArr.count == 0)
    {
      [para setObject:@"1" forKey:@"isFirst"];

    }else{
        
        [para setObject:@"0" forKey:@"isFirst"];

    [prameArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj hasPrefix:@"CustID"])
        {
            NSString *custId = [[obj componentsSeparatedByString:@"="] lastObject];
            if (![NSString isEmptyString:custId])
            {
              [para setObject:custId forKey:@"custId"];
            }
        }
        if ([obj hasPrefix:@"ProvicneID"])
        {
            NSString *provicneId = [[obj componentsSeparatedByString:@"="] lastObject];
            if (![NSString isEmptyString:provicneId])
            {
                [para setObject:provicneId forKey:@"provicneId"];
            }
        }
        if ([obj hasPrefix:@"CityID"])
        {
            NSString *cityId = [[obj componentsSeparatedByString:@"="] lastObject];
            if (![NSString isEmptyString:cityId])
            {
                [para setObject:cityId forKey:@"cityId"];
            }
        }
        if ([obj hasPrefix:@"StarLevel"])
        {
            NSString *starLevel = [[obj componentsSeparatedByString:@"="] lastObject];
            if (![NSString isEmptyString:starLevel])
            {
                [para setObject:starLevel forKey:@"starLevel"];
            }
        }
        if ([obj hasPrefix:@"DeviceType"])
        {
            NSString *deviceType = [[obj componentsSeparatedByString:@"="] lastObject];
            if (![NSString isEmptyString:deviceType])
            {
                [para setObject:deviceType forKey:@"deviceType"];
            }
        }
        if ([obj hasPrefix:@"RequestTime"])
        {
            NSString *requestTime = [[obj componentsSeparatedByString:@"="] lastObject];
            if (![NSString isEmptyString:requestTime])
            {
                [para setObject:requestTime forKey:@"requestTime"];
            }
        }
  
        if ([obj hasPrefix:@"Sign"])
        {
            NSString *sign = [[obj componentsSeparatedByString:@"="] lastObject];
            if (![NSString isEmptyString:sign])
            {
                [para setObject:sign forKey:@"sign"];
            }
        }
        
    }];
    }
    
    [[FNNetManager shared] postURL:@"buyer/cachAmountCall" paras:para finish:^(id result) {
                
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

@end
