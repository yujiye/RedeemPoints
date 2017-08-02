//
//  FNTouchArgs.m
//  BonusStore
//
//  Created by cindy on 2017/2/10.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNTouchArgs.h"

@implementation FNTouchArgs

+ (NSArray *)widgetArr
{
    
    NSMutableArray * arrM = [NSMutableArray array];
    
    NSArray * imgArr = @[@"main_bonus_interflow",@"main_bonus_recharge",@"main_card_icon",@"main_blank",@"main_blank_sz",@"main_mobile_recharge",@"main_bonus_flowRecharge",@"main_bonus_QCoin",@"main_bonus_gameCard",@"main_bonus_globalFood"];
    NSArray * labelArr = @[@"积分互通",@"积分充值",@"特惠卡券",@"开卡有礼",@"深圳通 ",@"话费充值",@"流量充值",@"Q币充值",@"游戏点卡", @"全球美食"];
    NSArray * typeArr = @[@"interflow",@"recharge",@"cardIcon",@"blank",@"bonusWallet",@"mobileRecharge",@"flowRecharge",@"QCoin",@"gameCard",@"globalFood"];
    for (int i = 0; i< imgArr.count ;i++)
    {
        FNTouchArgs * touchArgs = [[FNTouchArgs alloc]init];
        touchArgs.imageName = imgArr[i];
        touchArgs.title = labelArr[i];
        touchArgs.type = typeArr[i];
        [arrM addObject:touchArgs];
    }
    return arrM.copy;
}


@end
