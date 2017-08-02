//
//  FNMainBO.h
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseBO.h"
#import "FNCommon.h"
#import "FNImageArgs.h"

@interface FNMainBO : FNBaseBO

//获取轮播图
+ (void)getFocusImageListWithBlock:(FNNetFinish)block;

//首页商品列表-1
+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort block:(FNNetFinish)block;

//-列表／count-2
+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort perCount:(NSInteger)perCount block:(FNNetFinish)block;

//--列表／subjectID-3
+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort subjectID:(NSInteger)subjectID block:(FNNetFinish)block;

//商家
+(void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort sellerID:(NSInteger)sellerID  block:(FNNetFinish)block;


+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort perCount:(NSInteger)perCount sellerID:(NSInteger)sellerID block:(FNNetFinish)block;

//商品基本信息
+ (void)getProductDetailWithProductId:(NSString *)productId block:(FNNetFinish)block;

//获取skuItem
+ (void)getSKUItemWithProductID:(NSInteger)ID block:(FNNetFinish)block;

//系统消息列表
+ (void)getMessageListWithBlock:(FNNetFinish)block;

//扫描二维码
+ (void)getOrderPayListWithUserName:(NSString *)username  sellerDetailList:(NSArray *)sellerDetailList totalSum:(NSString *)totalSum tradeCode:(NSString *)tradeCode block:(FNNetFinish)block;

//根据类型进行商品搜索
+ (void)getSearchProductListWithPage:(NSInteger)page descType:(NSInteger)descType perCount:(NSInteger)perCount keyword:(NSString *)keyword block:(FNNetFinish)block;

//热门搜索关键字
+ (void)getHotSearchListWithModuleId:(NSString *)moduleId block:(FNNetFinish)block;

//首页模块配置
+ (void)getModelConfigOfProductListWithModuleId:(NSString *)moduleId curPage:(NSInteger)curPage perCount:(NSInteger)perCount block:(FNNetFinish)block;

//首页配置advertId不同
+ (void)getProductListWithAdvertId:(NSInteger)advertId block:(FNNetFinish)block;



@end
