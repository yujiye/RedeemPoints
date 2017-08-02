//
//  FNSkuPriceAndStock.h
//  BonusStore
//
//  Created by feinno on 16/5/19.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseArgs.h"

@interface FNSkuPriceAndStock : FNBaseArgs

@property (nonatomic, copy) NSString * productId;//商品ID
@property (nonatomic,assign)int sellerId;// 卖家ID
@property (nonatomic, copy)NSString *skuNum; // sku编码
@property (nonatomic,assign)int storehouseId;// 仓库id
@property (nonatomic,assign)int count;// 商品当前库存数
@property (nonatomic, copy)NSString *curPrice; // 销售价
@property (nonatomic, copy)NSString *orgPrice; // 商品原价
@property (nonatomic,copy)NSString * weight;
@end
