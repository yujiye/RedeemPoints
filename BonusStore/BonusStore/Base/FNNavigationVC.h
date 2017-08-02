//
//  FNNavigationVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/10/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNNavigationVC : UINavigationController

@property (nonatomic,assign) BOOL dragBack;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSMutableArray *screenShots;

- (void)removeLastScreenShot;

- (void)removeAllScreenShot;

@end
