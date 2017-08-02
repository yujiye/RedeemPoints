//
//  XMSegBar.h
//  PandaFinancial
//
//  Created by Nemo on 16/1/3.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNMacro.h"
#import "FNCommon.h"

// Seg index start from 0.

@interface FNSegBar : UIView

@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)UIColor *lineColor;

@property (nonatomic, strong)UIColor *defaultTitleColor;

@property (nonatomic, strong)UIColor *selectedTitleColor;

- (void)setItems:(NSArray *)items;

- (void)selectedItemWithBlock:(FNSelectedIndex)block;

@end
