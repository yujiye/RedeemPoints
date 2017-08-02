//
//  FNRightCollectionCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeadRightModel.h"

#import "FNHeader.h"

@interface FNRightCollectionCell : UICollectionViewCell

@property (nonatomic, strong) FNHeadRightModel *curHeadRightModel;

@property (nonatomic, strong) UIImageView * nameImageView;

@property (nonatomic, strong) UILabel * nameLabel;


@end
