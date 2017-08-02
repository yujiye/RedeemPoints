//
//  FNNoNetBar.h
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNNoNetBar : UIView

+ (instancetype)shared;

- (void)goMainWithBlock:(UIButtonActionBlock)block;

@end
