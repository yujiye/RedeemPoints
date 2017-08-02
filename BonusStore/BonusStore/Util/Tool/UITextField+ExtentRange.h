//
//  UITextField+ExtentRange.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/25.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end
