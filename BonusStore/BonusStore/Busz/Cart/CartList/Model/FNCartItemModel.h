//
//  FNCartItemModel.h
//  BonusStore
//
//  Created by feinno on 16/4/29.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNSkuNumModel.h"

@interface FNCartItemModel : NSObject

@property (nonatomic, copy) NSString *detailKey; // 商品详情key
@property (nonatomic, copy) NSString *productId; // 商品ID
@property (nonatomic, copy) NSString *productName; // 商品名称
@property (nonatomic,copy) NSString *storehouseId; // 仓库id
@property (nonatomic,copy) NSString *storehouseIds; // 仓库ids
@property (nonatomic,assign)int postageId; //邮费模版ID
@property (nonatomic, strong) FNSkuNumModel *sku;
@property (nonatomic, copy) NSString *cartPrice;  // 购物车价格
@property (nonatomic, assign)int activeState; // 商品状态 ，［300.399］则可用
@property (nonatomic, assign)BOOL enabled;   //根据activeState状态来显示商品是否可用
@property (nonatomic, assign) int  skuCount;  // 商品库存
@property (nonatomic, assign ) int  count;  //商品数量
@property (nonatomic, copy) NSString *imgKey;  // 商品图片
@property (nonatomic,copy) NSString * watchTime;// 虚拟商品观看时间
@property (nonatomic,copy) NSString * curPrice;// 获取库存后商品价格
@property (nonatomic,copy)NSString *mobleNo;
@property (nonatomic,assign)BOOL isOver; //库存是否大于填写的
@property (nonatomic,copy) NSString * productDesc; // 产品描述
@property (nonatomic, copy)NSString *remark; // 产品标示
@property (nonatomic,copy)NSString *sellerId; //卖家ID
@property (nonatomic,copy)NSString *sellerName; //卖家名称
@property (nonatomic,copy)NSString *minCurPrice;
@property (nonatomic,copy)NSString *maxOrgPrice;
@property (nonatomic,assign) int subjectId; //类目ID
@property(nonatomic,assign) int type;
@property (nonatomic,copy) NSString * viceName; //副标题
@property (nonatomic, assign) BOOL isSelecte; // 产品是否选中

@end
