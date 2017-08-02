//
//  FNPersonalVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/5/9.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

#import "FNPersonalModel.h"

typedef void (^NameTextBlock)(NSString * nameText);

@interface FNPersonalVC : UIViewController

@property (nonatomic, copy) NameTextBlock nameBlock;

@property (nonatomic, copy) NSString * image;

@property (nonatomic, strong) UITableView * tableview;

@property (nonatomic, assign) BOOL update;

@property (nonatomic, strong) FNPersonalModel * model;

- (void)returnText:(NameTextBlock)block;


@end
