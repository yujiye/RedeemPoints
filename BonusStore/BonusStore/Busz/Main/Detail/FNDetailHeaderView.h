//
//  FNDetailHeaderView.h
//  BonusStore
//
//  Created by feinno on 16/6/16.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNCartItemModel.h"
@interface FNDetailHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * viceNameLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic,strong) UILabel * orgPriceLabel;
@property (nonatomic, strong) UILabel * scoreLabel;
@property (nonatomic, strong) UILabel * shareLabel;
@property (nonatomic, strong) UILabel * lineLabel;
@property (nonatomic, strong) UILabel *moneyLa;
@property (nonatomic, strong) UILabel *sendLab;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong)UIButton *clickBtn;
@property (nonatomic, strong) FNCartItemModel * productModel;

+ (instancetype)detailHeaderViewWithTableView:(UITableView *)tableView;

-(CGFloat)height;

@end
