//
//  FNSegListBar.h
//  BonusStore
//
//  Created by Nemo on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNSegListBar : UIView

@property (nonatomic, assign)NSInteger selectedIndex;

- (void)setItems:(NSArray *)items;

- (void)selectedColumnWithBlock:(void (^) (NSInteger index))block;

- (void)selectedItemWithBlock:(void (^) (NSArray *array))block;

- (void)initMaskWithPoint:(CGPoint)point;

- (void)deallocMask;

@end
