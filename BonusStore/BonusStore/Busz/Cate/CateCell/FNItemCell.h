//
//  FNItemCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNMacro.h"

#import "FNHeader.h"

#import "FNItemModel.h"

#import "Masonry.h"

@interface FNItemCell : UITableViewCell

@property (nonatomic, strong) UIImageView * imageName;

@property (nonatomic, strong) UILabel * title;

@property (nonatomic, strong) UILabel * money;

@property (nonatomic, strong) UILabel * integration;

@property (nonatomic, strong) FNItemModel * model;

+ (instancetype)sellerItemTableView:(UITableView *)tableView;


@end
