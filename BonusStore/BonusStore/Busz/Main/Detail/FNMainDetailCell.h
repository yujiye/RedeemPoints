//
//  FNMainDetailCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/9/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

@interface FNMainDetailCell : UITableViewCell

@property (nonatomic, strong)UILabel *shopNameLab;

@property (nonatomic, strong)UIImageView *leftImg;

@property (nonatomic, strong)UILabel *freightLab;

+ (instancetype)mainDetailCellTableView:(UITableView *)tableView;

@end
