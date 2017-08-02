//
//  FNSZTongBO.h
//  BonusStore
//
//  Created by Nemo on 17/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"
#import "FNCommon.h"
#import "FNBaseBO.h"

@interface FNSZTongBO : FNBaseBO

/***
 *  深圳通卡券列表
 */
+(void)getCouponListBlock:(FNNetFinish)block;

/***
 *  购买深圳通券
 *  totlalSum:充值金额
 *  flowno:卡券code
 */
+(void)rechargeMoneyWithTotalSum:(NSString *)totalSum flowno:(NSString *)flowno block:(FNNetFinish)block;

/***
 *  深圳通图片列表
 */
+(void)getSZTCardImgListBlock:(FNNetFinish)block;

@end
