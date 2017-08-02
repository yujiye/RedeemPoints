//
//  FNMyBO.h
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseBO.h"
#import "FNHeader.h"
@class FNUserAccountArgs;

UIKIT_EXTERN NSDictionary *FNMyUpdateInfo;

UIKIT_EXTERN NSInteger FNMyIsEnforceUpdate;

@interface FNMyBO : FNBaseBO

@end

@interface FNMyBO (Extension)

//个人中心
+ (void)getPersonalWithBlock:(FNNetFinish)block;

//修改个人信息
+ (void)updateUser:(FNPersonalModel *)user block:(FNNetFinish)block;

//修改个人注册手机号
+ (void)updateUserWithMobile:(NSString *)mobile pwd:(NSString *)pwd captcha:(NSString *)captcha block:(FNNetFinish)block;

//获取用户个人信息
+ (void)getUserInfoWithBlock:(FNNetFinish)block;

//获取用户微信个人信息
+ (void)getWXUserInfoWithOpenId:(NSString *)openId token:(NSString *)token block:(FNNetFinish)block;

//查询收货地址列表：
+ (void)getAddrListWithBlock:(FNNetFinish)block;

// 设置为默认地址
+ (void)setDefaultAddressWithId:(int)AddressId block:(FNNetFinish)block;

//删除收货地址
+ (void)delAddrWithAddrID:(int)AddressId block:(FNNetFinish)block;

//新增收货地址
+ (void)addAddrWithUser:(FNAddressModel *)addressModel block:(FNNetFinish)block;

// 修改收货地址
+ (void)updateAddrWithUser:(FNAddressModel *)addressModel block:(FNNetFinish)block;

// 查询全国省份列表
+ (void)getProVincesListWithBlock:(FNNetFinish)block;

// 获得某个省份下的城市列表
+ (void)getCitysListWithProvinceId:(NSInteger)provinceId block:(FNNetFinish)block;

// 获得某个城市下的乡镇列表
+ (void)getCountysListWithCityId:(NSInteger)cityId block:(FNNetFinish)block;

//获取物流信息
+ (void)getExpressWithOrderID:(NSString *)orderID expressId:(NSString *)expressId expressNo:(NSString *)expressNo  block:(FNNetFinish)block;

//App端获取升级信息
+ (void)getUpdateWithBlock:(FNNetFinish)block;

//上传头像
+ (void)uploadImage:(NSString *)image block:(FNNetFinish)block;


// 获取虚拟订单的卡密列表
+(void)getVirtualCardListProductId:(NSString *)productId orderId:(NSString *)orderId number:(int)number skuNum:(NSString *)skuNum block:(FNNetFinish)block;



@end
