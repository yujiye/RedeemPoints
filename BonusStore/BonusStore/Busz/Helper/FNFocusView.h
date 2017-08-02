//
//  FNFocusView.h
//  BonusStore
//
//  Created by Nemo on 16/4/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Cate.h"

@interface FNFocusView : UIView

/**
 *  You should set isAutoLoop to NO before you release focos view.
 */
@property (nonatomic, assign) BOOL isAutoLoop;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) UIPageControl *pageControl;   // Default is foreground is white and backgroud is black.

@property (nonatomic, assign) FNFocusPageAlign pageAlign;   // Default is center.

- (void)focusDidSelectedIndex:(void (^) (NSInteger index, FNImageArgs *args))block;

@property (nonatomic, strong) NSMutableArray *imageViews;

@end
