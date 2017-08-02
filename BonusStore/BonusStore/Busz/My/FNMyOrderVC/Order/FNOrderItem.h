//
//  FNOrderItem.h
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNOrderItem : NSObject
@property (nonatomic, copy) NSString  *goodsPictureUrl; // 产品图片的url
@property (nonatomic, copy) NSString  *goodsName; // 产品名称
@property (nonatomic, copy) NSString *goodsDetail; // 产品补充说明
@property (nonatomic, copy) NSString *goodsPrice;  // 产品价格
@property (nonatomic, copy) NSString *goodsScore;  // 产品积分
@property (nonatomic, copy) NSString *usdPrice; //运费
@property (nonatomic,copy)NSString *commentsString;  // 留言内容

+ (NSMutableArray *)orderItems;

@end
