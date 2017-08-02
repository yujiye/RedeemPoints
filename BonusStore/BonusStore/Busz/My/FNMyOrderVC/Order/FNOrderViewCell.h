//
//  FNOrderViewCell.h
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNProductArgs.h"
#import "FNOrderArgs.h"
#import "FNBaseCell.h"
#import "FNButton.h"
@class FNOrderViewCell;

@protocol FNReturnGoodsDelegate <NSObject>

@optional

- (void)returnGoodsAction:(FNOrderViewCell *)returnGoods;

@end


@interface FNOrderViewCell : FNBaseCell

@property (nonatomic, weak) UIImageView *goodsPicture; // 产品图片
@property (nonatomic, weak) UILabel *goodsName; // 产品名称
@property (nonatomic, weak) UILabel *goodsDetail; // 产品补充说明
@property (nonatomic, weak) UILabel *goodsPrice;  // 产品价格
@property (nonatomic,weak) UILabel *usdLabel;   // 运费

@property (nonatomic,weak)UILabel * commentsLabel; // 给卖家的留言框
@property (nonatomic,weak)UILabel *grayLine1;
@property (nonatomic,strong)FNButton *returnBut;
@property (nonatomic,strong)UILabel *returnStateLabel;
// 实物
@property (nonatomic,strong) FNOrderArgs *orderItem;

@property(nonatomic,strong)FNProductArgs *product;
@property (nonatomic, weak)id<FNReturnGoodsDelegate>delegate;


// 虚拟物品
@property (nonatomic,strong) FNProductDetailArgs *virutualItem;

@property (nonatomic,strong)NSIndexPath *indexPath;

- (void)setReturnState:(FNOrderState)state order:(FNOrderArgs *)order;

+ (CGFloat )orderCellHeightWithOrderItem:(FNOrderArgs *)orderItem;


+ (CGFloat )orderCellHeightWithVirutualItem:(FNProductDetailArgs *)virutualItem;



@end
