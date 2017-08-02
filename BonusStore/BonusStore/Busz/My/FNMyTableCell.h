//
//  FNMyTableCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

@class FNSymmetryView;

@interface FNMyTableCell : FNBaseCell

@property (nonatomic,strong)UIImageView * leftImage;

@property (nonatomic,strong)UILabel * nameLabel;

@property (nonatomic,strong)UILabel *rightLabel;

@end
