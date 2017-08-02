//
//  FNTableView.m
//  BonusStore
//
//  Created by Nemo on 16/4/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNTableView.h"

@implementation FNTableView


- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{    
    if ([view isKindOfClass:NSClassFromString(@"UIImageView")] || [view isKindOfClass:NSClassFromString(@"UILabel")])
    {
        return NO;
    }
    
    return YES;
}

@end
