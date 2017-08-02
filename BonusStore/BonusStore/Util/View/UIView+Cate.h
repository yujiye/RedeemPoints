//
//  UIView+Cate.h
//  YueXin
//
//  Created by feinno on 15/6/25.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface UIView (Cate)

-(id)initWithSuperView:(UIView *)superView;

-(void)setCorner:(CGFloat)corner;

- (UIImage *)setImageCorner:(CGFloat)corner;

-(void)setBorderWithWidth:(CGFloat)width color:(UIColor *)color;

-(void)setCenterXView:(UIView *)view y:(CGFloat)y size:(CGSize)size;
+(void)setHorizonCenterWithView:(UIView *)view superView:(UIView *)superView;

+(void)setVerticalCenterWithView:(UIView *)view superView:(UIView *)superView;

-(void)setHorizonCenterWithSuperView:(UIView *)view;

-(void)setVerticalCenterWithSuperView:(UIView *)view;

- (void)setVerticalCenter;

-(void)addTarget:(NSObject *)target action:(SEL)action;

- (CGFloat) width;

- (CGFloat) height;

- (CGFloat) x;

- (CGFloat) y;

- (CGFloat) cx;

- (CGFloat) cy;

- (CGFloat) top;

- (CGFloat) bottom;

- (CGFloat) left;

- (CGFloat) right;

- (void) reframeW:(CGFloat)width;

- (void) reframeH:(CGFloat)height;

- (void) reframeX:(CGFloat)x;

- (void) reframeY:(CGFloat)y;

- (void)beadWithDiameter:(CGFloat)diameter;

@end
