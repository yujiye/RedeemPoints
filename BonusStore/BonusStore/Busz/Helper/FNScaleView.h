//
//  FNScaleView.h
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNScaleView : UIView

@property (nonatomic, strong) UIImageView *leftView;

@property (nonatomic, strong) UIImageView *rightView;

- (void)setScale:(CGFloat)scale;

@end
