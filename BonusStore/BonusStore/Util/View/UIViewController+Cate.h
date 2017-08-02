//
//  UIViewController+Cate.h
//  YueXin
//
//  Created by feinno on 15/6/24.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface UIViewController (Cate)

-(void)autoFitInsets;

//Notification center.
-(void)addNotiWithSel:(SEL)sel;
-(void)removeNoti;

- (void)setWhiteTitle:(NSString *)title;

-(void)setNavigationBarTintColor:(UIColor *)color;
-(void)setNavigationBarBackground:(UIColor *)color;

//set navigation bar back item title with 返回.
-(void)setNavigaitionBackItemToChi;
//set navigation bar back item with defautl image.
- (void)setNavigaitionBackItem;
- (UIBarButtonItem *)setNavigaitionMoreItem;
- (UIBarButtonItem *)setNavigaitionHelpItem;
- (UIBarButtonItem *)setNavigaitionSZTHelpItem;

- (void)endEditing;
- (void)goBack;
- (void)goMain;
- (void)goMore;

- (void)setTitleLogo;

- (void)showTipWithResult:(id)result;

- (void)shareWithText:(NSString *)text image:(id)image url:(NSString *)url title:(NSString *)title delegate:(id)delegate;

- (void)pushToClazz:(Class)clazz animated:(BOOL)animated;

- (void)pushToVC:(id)vc animated:(BOOL)animated;

// Show unreachable view if unable to connect to the internet.
- (void)showUnreach;

// Hide unreachable view if unable to connect to the internet.
- (void)hideUnreach;

- (void)goTabIndex:(NSInteger)index;

@end
