//
//  FNCartItemModel.m
//  BonusStore
//
//  Created by feinno on 16/4/29.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCartItemModel.h"

@implementation FNCartItemModel

- (void)setActiveState:(int)activeState
{
    if (_activeState != activeState)
    {
        _activeState = activeState;
    }
    
    if (activeState >= 300 && activeState <= 399)
    {
        self.enabled = YES;
    }
    else
    {
        self.enabled = NO;
    }
}


@end
