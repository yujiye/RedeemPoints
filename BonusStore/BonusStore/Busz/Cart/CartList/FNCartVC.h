//
//  FNCartVC.h
//  BonusStore
//
//  Created by Nemo on 16/4/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNCartVC : UIViewController

// 是否是从详情页的购物车图标过来
@property(nonatomic,assign)BOOL isComeFromCartImage;

- (void)hideTabBar;

@end
