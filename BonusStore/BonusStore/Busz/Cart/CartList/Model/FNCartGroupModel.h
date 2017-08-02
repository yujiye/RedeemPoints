//
//  FNCartGroupModel.h
//  BonusStore
//
//  Created by feinno on 16/4/29.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

typedef enum : NSUInteger {
    kSelecteBtnNoSelect,
    kSelecteBtnHalfSelect,
    kSelecteBtnAllSelect,
} kSelecteBtnStatus;

@interface FNCartGroupModel : NSObject

@property (nonatomic,copy)NSString *postage; //运费值
@property (nonatomic, assign) int sellerId; // 商家ID
@property (nonatomic, copy) NSString *sellerName ; // 商家名称
@property (nonatomic, copy) NSString *remark ; // 商家活动
@property (nonatomic, copy) NSString *buyerComment ; // 买家备注
@property (nonatomic, strong) NSMutableArray *productList ; // 商家下的商品
@property (nonatomic, assign) kSelecteBtnStatus selecteStatus; // 商场选择按钮的状态

+(NSDictionary *)mj_objectClassInArray;

@end
