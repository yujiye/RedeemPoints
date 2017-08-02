//
//  FNCateBO.h
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseBO.h"
#import "FNHeader.h"

@interface FNCateBO : FNBaseBO

//父分类
+ (void)getCateListWithBlock:(FNNetFinish)block;

//获取子分类
+ (void)getCateListWithParentID:(NSInteger)parentID block:(FNNetFinish)block;

//获取分类商品列表：
+ (void)getProductListWithCateID:(NSInteger)ID page:(NSInteger)page block:(FNNetFinish)block;

@end
