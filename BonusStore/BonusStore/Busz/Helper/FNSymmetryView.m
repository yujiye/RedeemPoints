//
//  FNSymmetryView.m
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSymmetryView.h"

@implementation FNSymmetryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, frame.size.width/2.0, 20)];
        
        [_leftLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_GRAY_ALPHA];
        
        [_leftLabel setVerticalCenterWithSuperView:self];
        
        [self addSubview:_leftLabel];
        
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2.0 + 5, 5, frame.size.width/2.0 - 20, 20)];
        
        [_rightLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_GRAY_ALPHA];
        
        [_rightLabel setVerticalCenterWithSuperView:self];

        [self addSubview:_rightLabel];
    }
    return self;
}

@end
