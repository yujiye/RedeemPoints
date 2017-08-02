//
//  FNBaseCell.h
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FNBaseCell : UITableViewCell

+ (__kindof FNBaseCell *)dequeueWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END