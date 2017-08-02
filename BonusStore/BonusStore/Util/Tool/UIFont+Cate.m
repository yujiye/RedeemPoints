//
//  UIFont+Cate.m
//  BonusStore
//
//  Created by Nemo on 16/4/18.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "UIFont+Cate.h"

@implementation UIFont (Cate)

+ (UIFont *)fzltWithSize:(CGFloat)size
{
    return [UIFont fontWithName:FONT_NAME_LTH size:size];
}

+ (UIFont *)fzltBoldWithSize:(CGFloat)size
{
    return [UIFont fontWithName:FONT_NAME_LTH_BOLD size:size];
}

@end
