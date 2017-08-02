//
//  FNFillOrderHeaderView.h
//  BonusStore
//
//  Created by feinno on 16/4/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FNFillOrderGroup;
#import "FNCartGroupModel.h"
@interface FNFillOrderHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) FNCartGroupModel * cartGroup;

@property (nonatomic,weak) UILabel * nameLabel;

+ (instancetype)fillOrderHeaderViewWithTableView:(UITableView *) tableView;


@end
