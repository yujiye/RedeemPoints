//
//  FNSystemCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

#import "FNMessageArgs.h"

#import "FNMacro.h"

@interface FNSystemCell : UITableViewCell

@property (nonatomic, strong) UILabel * title;

@property (nonatomic, strong) UILabel * content;

@property (nonatomic, strong) FNMessageArgs * model;

+ (instancetype)systemTableView:(UITableView *)tabelView;

@end
