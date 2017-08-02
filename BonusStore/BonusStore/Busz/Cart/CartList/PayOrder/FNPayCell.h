//
//  FNPayCell.h
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
@class FNPayWayArgs;

@interface FNPayCell : UITableViewCell

@property (nonatomic, strong) UIImageView *checkView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

+ (instancetype)dequeueReusableWithTableView:(UITableView *)tableView;

- (void)setPay:(FNPayWayArgs *)pay;

@end
