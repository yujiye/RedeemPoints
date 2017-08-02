//
//  FNCodeView.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNMacro.h"


@interface FNCodeView : UIImageView

@property (nonatomic, strong) NSArray * changeArray;

@property (nonatomic, strong) NSMutableString * changeString;

@property (nonatomic, strong) UILabel * coldeLabel;

@property (nonatomic, assign) NSUInteger random;

@end
