//
//  FNScaleView.m
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNScaleView.h"

@interface FNScaleView ()
{
    NSInteger _scale;
}

@end

@implementation FNScaleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, frame.size.width/2.0, 80)];
        
        [self addSubview:_leftView];
        
        
        _rightView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2.0 + 10, _leftView.y, frame.size.width/2.0, 80)];
        
        [self addSubview:_rightView];

    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    UIReframeWithW(_leftView, scale * self.width-40);
    
    UIReframeWithX(_rightView, _leftView.x + _leftView.width + 10);
    
    UIReframeWithW(_rightView, (1 - scale) * self.width);
}

@end
