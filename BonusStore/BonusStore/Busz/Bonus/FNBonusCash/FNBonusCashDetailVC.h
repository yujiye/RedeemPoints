//
//  FNBonusCashDetailVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/6/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

@interface FNBonusCashDetailVC : UIViewController

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, assign) NSInteger bonus;

@property (nonatomic, strong)NSArray * prameArr;

@property (nonatomic, assign)BOOL isNotFirstCash;

- (void)getCode:(id)sender;

@end
