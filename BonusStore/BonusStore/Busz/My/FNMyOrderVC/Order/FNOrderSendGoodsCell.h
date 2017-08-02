//
//  FNOrderSendGoodsCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

#import "FNOrderSendGoods.h"

@interface FNOrderSendGoodsCell : UITableViewCell

@property (nonatomic, strong) UILabel * titleName;

@property (nonatomic, strong) UIImageView * image;

@property (nonatomic, strong) UILabel * num;

@property (nonatomic, strong) UIImageView * rightImage;

@property (nonatomic, strong) UILabel * status;

@property (nonatomic, strong) FNOrderSendGoods *model;

@property (nonatomic, strong) NSArray * array;

+ (instancetype)sendGoodsTableView:(UITableView *)tabelView;

@end
