//
//  FNRechargeBO.h
//  BonusStore
//
//  Created by sugarwhi on 16/10/16.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"
#import "FNBaseBO.h"
@interface FNRechargeBO :FNBaseBO

/***
 *  话费充值,流量充值，Q币
 *  totlalSum:充值金额
 *  receiverMobile:充值号码
 */
+(void)rechargeMoneyWithTotalSum:(NSString *)totalSum flowno:(NSString *)flowno company:(NSString *)company provinceName:(NSString *)provinceName receiverMobile:(NSString *)receiverMobile block:(FNNetFinish)block;

/***
 *  游戏点卡充值
 *  totalSum:总金额
 *  receiverMobile:游戏id,区域id,区域name,服务器id,服务器名字,账号(逗号分隔)
 *  flowno : 单价
 *  company :购买数量
 *  provinceName : 用户IP
 *  sellerComment:商品名称
 */
+(void)payOrderCreatesWithTotalSum:(NSString *)totalSum flowno:(NSString *)flowno company:(NSString *)company receiverMobile:(NSString *)receiverMobile sellerComment:(NSString *)sellerComment provinceName:(NSString *)provinceName  block:(FNNetFinish)block;


/***
 *  归属地查询
 */
+ (void)mobileInfoWithMobile:(NSString *)mobile block:(FNNetFinish)block;


/***
 *  获取游戏名称列表和搜索列表
 *
 */

+(void)getGameNameWithFirstpy:(NSString *)py name:(NSString *)name thirdGameId:(NSString *)thirdGameId block:(FNNetFinish)block;

/***
 *  获取游戏的区和服务的列表
 *
 */
+(void)getAreaListAndSeaverListWith:(NSString *)gameId block:(FNNetFinish)block;



@end
