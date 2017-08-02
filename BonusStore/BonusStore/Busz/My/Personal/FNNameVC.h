//
//  FNNameVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

#import "FNPersonalModel.h"

typedef void (^Name)(FNPersonalModel * model);

@interface FNNameVC : UIViewController

@property (nonatomic, strong) UITextField * nameText;

@property (nonatomic, copy) Name nameBlock;

@property (nonatomic, strong) FNPersonalModel * model;
 
@property (nonatomic, strong) NSString * name;

@end
