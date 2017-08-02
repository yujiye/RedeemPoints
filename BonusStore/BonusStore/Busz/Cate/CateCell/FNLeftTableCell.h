//
//  FNLeftTableCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNLeftTableCell : UITableViewCell

@property (nonatomic, strong) UIView * leftColorView;

@property (nonatomic, strong) UILabel * nameLabel;

@property(strong,nonatomic) FNCateParentModel *curLeftTagModel;
//是否被选中
@property(assign,nonatomic) BOOL hasBeenSelected;

@end
