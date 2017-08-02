//
//  FNScrollView.m
//  BonusStore
//
//  Created by Nemo on 17/5/5.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNScrollView.h"

@interface FNScrollView ()
{
    void (^_touchState) (FNTouchState state);
}

@end

@implementation FNScrollView

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchState(FNTouchStateBegan);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchState(FNTouchStateMoved);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchState(FNTouchStateCancelled);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _touchState(FNTouchStateEnded);
}

- (void)touchStateChangeBlock:(void (^) (FNTouchState state))block
{
    _touchState = nil;
    
    _touchState = block;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
