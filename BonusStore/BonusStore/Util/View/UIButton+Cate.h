//
//  UIButton+Cate.h
//  YueXin
//
//  Created by feinno on 15/6/29.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNCommon.h"

@interface UIButton (Cate)

-(void)setFrameWithOriginal:(CGPoint)point image:(UIImage *)image;

-(void)setDefaultStateTitle:(NSString *)title titleColor:(UIColor *)color;

-(void)setImageNormal:(UIImage *)normal hightLighted:(UIImage *)hightLighted;

-(void)setImageNormal:(UIImage *)normal selected:(UIImage *)selected;

-(void)addSuperView:(UIView *)superView ActionBlock:(UIButtonActionBlock)block;

@end
