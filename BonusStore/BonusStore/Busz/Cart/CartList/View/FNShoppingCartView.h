//
//  FNShoppingCartView.h
//  BonusStore
//
//  Created by qingPing on 16/4/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNCartGroupModel.h"
@class FNShoppingCartView;

@protocol FNShoppingCartViewDelegate <NSObject>

@optional
// 商家选择按钮点击的代理事件
- (void) groupHeaderViewDidTouched:(FNShoppingCartView *) headerView;

// 去逛逛代理方法的实现 跳转到首页
- (void) goToHomeViewControllerClick:(FNShoppingCartView *) headerView;

// 跳转到商家列表
-(void)goToMerchantListControllerClick:(FNShoppingCartView *)headerView;

@end

@interface FNShoppingCartView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<FNShoppingCartViewDelegate>delegate;// 代理
@property (nonatomic, weak) FNCartGroupModel *cartGroup; // 数据
@property (nonatomic, weak) UILabel *shopNameLabel; // 商家名称
@property (nonatomic,weak)UIImageView *imageView1;  //  选择框
@property (nonatomic, weak) UIButton *selecteBtn; // 商家的选中状态
@property (nonatomic, weak) UILabel * discountLabel;//商家活动介绍
@property (nonatomic, weak) UIImageView *arrowImg; //箭头
@property (nonatomic, weak) UILabel * lineLabel ;
@property (nonatomic, weak) UIImageView *freightImg; // "邮"

+ (instancetype) groupHeaderViewWithTableView:(UITableView *) tableView;

// 购物车无商品时候的view
- (UIView *)viewWithNoShopping;

@end
