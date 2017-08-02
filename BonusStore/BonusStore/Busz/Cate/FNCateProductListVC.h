//
//  FNCateCheckAll.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

@class FNHeadRightModel;

@interface FNCateProductListVC : UIViewController

@property (nonatomic, strong) FNHeadRightModel *secCategory;

@property (nonatomic, assign)BOOL isVirtual;

@end
