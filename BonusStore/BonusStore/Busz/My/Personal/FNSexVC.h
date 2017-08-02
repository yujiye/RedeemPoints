//
//  FNSexVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

#import "FNPersonalModel.h"

typedef void (^Sex) (NSInteger sex);

@interface FNSexVC : UIViewController

@property (nonatomic, copy) Sex sexBlock;

@property (nonatomic, strong) NSString *sex;

@end
