//
//  FNMainItemTableSubCell.h
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNProductArgs.h"

@interface FNMainItemCollectionSubCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSNumber *index;

@property (nonatomic, strong) FNProductArgs *product;

@end
