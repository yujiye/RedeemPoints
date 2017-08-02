//
//  UILabel+Cate.h
//  YueXin
//
//  Created by feinno on 15/6/29.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface UILabel (Cate)

+ (instancetype)labelWithFrame:(CGRect)frame;

- (void)setText:(NSString *)text align:(NSTextAlignment)align;

-(void)clearBGWithFontOfArialSize:(float)size textColor:(UIColor *)color;

-(void)clearBGWithFontOfArialMTSize:(float)size textColor:(UIColor *)color;

-(void)clearBackgroundWithFont:(UIFont *)font textColor:(UIColor *)color;

-(void)setBackgroundColor:(UIColor *)backgroundColor font:(UIFont *)font textColor:(UIColor *)color;

- (CGSize)getBoundsWithMaxWidth:(CGFloat)width;

-(void)addTarget:(NSObject *)target action:(SEL)action;

// 设置换行的label 的size
- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str;

- (CGFloat)fontHeight;

- (void)setEllipseCount:(NSInteger)count;

@end
