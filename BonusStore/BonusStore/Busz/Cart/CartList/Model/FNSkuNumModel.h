//
//  FNSkuNumModel.h
//  BonusStore
//
//  Created by feinno on 16/5/2.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNSkuNumModel : NSObject
@property (nonatomic, copy) NSString *skuNum; // sku 编码
@property (nonatomic, copy) NSString *skuName; //sku名称
@property (nonatomic,copy) NSString * weight; //重量
@property (nonatomic,copy) NSString * key;
@property (nonatomic,copy) NSString * values;
@end
