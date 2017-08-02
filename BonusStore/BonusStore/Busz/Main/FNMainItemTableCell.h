//
//  FNMainItemTableCell.h
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNCommon.h"
#import "FNProductArgs.h"

@interface FNMainItemTableCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *rankArray;

- (void)goAllWithBlock:(void (^) (void))block;

- (void)didSelectedIndexBlock:(void (^) (FNProductArgs *product, NSInteger index))block;

- (void)refresh;

@end
