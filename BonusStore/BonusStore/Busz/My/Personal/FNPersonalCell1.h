//
//  FNPersonalCell1.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

@interface FNPersonalCell1 : UITableViewCell

@property (nonatomic, strong) UIImageView * headImage;

+ (instancetype)headCell:(UITableView *)tableview;

@end
