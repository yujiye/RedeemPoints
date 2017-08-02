//
//  UIView+Cate.m
//  YueXin
//
//  Created by feinno on 15/6/25.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "UIView+Cate.h"

@implementation UIView (Cate)


-(void)setCorner:(CGFloat)corner{
    self.layer.cornerRadius = corner;
    self.layer.masksToBounds = YES;
}

- (UIImage *)setImageCorner:(CGFloat)corner
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.width, self.height));
    CGContextClip(context);
    [self setNeedsLayout];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color{
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}

-(id)initWithSuperView:(UIView *)superView{
    UIView *view = [self init];
    [superView addSubview:view];
    return view;
}

/**
 *  suggest to use instance method not static method.
 */
+(void)setHorizonCenterWithView:(UIView *)view superView:(UIView *)superView{
    CGRect rect = view.frame;
    rect.origin.x = kAverageValue(kView_W(superView)-kView_W(view));
    view.frame = rect;
}
+(void)setVerticalCenterWithView:(UIView *)view superView:(UIView *)superView{
    CGRect rect = view.frame;
    rect.origin.y = kAverageValue(kView_H(superView)-kView_H(view));
    view.frame = rect;
}

-(void)setHorizonCenterWithSuperView:(UIView *)view{
    CGRect rect = self.frame;
    rect.origin.x = kAverageValue(kView_W(view)-kView_W(self));
    self.frame = rect;
}
-(void)setVerticalCenterWithSuperView:(UIView *)view{
    CGRect rect = self.frame;
    rect.origin.y = kAverageValue(kView_H(view)-kView_H(self));
    self.frame = rect;
}
- (void)setVerticalCenter
{
    if (self.superview)
    {
        CGRect rect = self.frame;
        rect.origin.y = kAverageValue(kView_H(self.superview)-kView_H(self));
        self.frame = rect;
    }
}


-(void)addTarget:(NSObject *)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (CGFloat) height
{
    return self.frame.size.height;
}

- (CGFloat) x
{
    return self.frame.origin.x;
}

- (CGFloat) y
{
    return self.frame.origin.y;
}

- (CGFloat) cx
{
    return self.center.x;
}

- (CGFloat) cy
{
    return self.center.y;
}

- (CGFloat) top
{
    return self.y;
}

- (CGFloat) bottom
{
    return self.y + self.height;
}

- (CGFloat) left
{
    return self.x;
}

- (CGFloat) right
{
    return self.x + self.width;
}

- (void) reframeW:(CGFloat)width
{
    CGRect rect = self.frame;
    
    rect.size.width = width;
    
    self.frame = rect;
}

- (void) reframeH:(CGFloat)height
{
    CGRect rect = self.frame;
    
    rect.size.height = height;
    
    self.frame = rect;
}

- (void) reframeX:(CGFloat)x
{
    CGRect rect = self.frame;
    
    rect.origin.x = x;
    
    self.frame = rect;
}

- (void) reframeY:(CGFloat)y
{
    CGRect rect = self.frame;
    
    rect.origin.y = y;
    
    self.frame = rect;
}

- (void)beadWithDiameter:(CGFloat)diameter
{

    
}
@end
