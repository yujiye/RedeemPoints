//
//  UILabel+Cate.m
//  YueXin
//
//  Created by feinno on 15/6/29.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "UILabel+Cate.h"

@implementation UILabel (Cate)

+ (instancetype)labelWithFrame:(CGRect)frame
{
    return [[UILabel alloc] initWithFrame:frame];
}

- (void)setText:(NSString *)text align:(NSTextAlignment)align
{
    self.text = text;
    self.textAlignment = align;
}

-(void)clearBGWithFontOfArialSize:(float)size textColor:(UIColor *)color{
    [self clearBackgroundWithFont:[UIFont fontWithName:FONT_NAME_ARIAL size:size] textColor:color];
}

-(void)clearBGWithFontOfArialMTSize:(float)size textColor:(UIColor *)color{
    [self clearBackgroundWithFont:[UIFont fontWithName:FONT_NAME_ARIAL_BOLD size:size] textColor:color];
}

-(void)clearBackgroundWithFont:(UIFont *)font textColor:(UIColor *)color{
    [self setBackgroundColor:[UIColor clearColor] font:font textColor:color];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor font:(UIFont *)font textColor:(UIColor *)color{
    self.backgroundColor = backgroundColor;
    self.font = font;
    self.textColor = color;
}

- (CGSize)getBoundsWithMaxWidth:(CGFloat)width
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:CGSizeMake(width, 2000)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

-(void)addTarget:(NSObject *)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}



// 设置换行的label 的size
- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setHeadIndent:0];
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
}

- (CGFloat)fontHeight
{
    return self.font.lineHeight;
}

- (void)setEllipseCount:(NSInteger)count
{
    CGSize size;

    if (count<99)
    {
        self.text = [NSString stringWithFormat:@"%zd",count];
        size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        [self setCorner:size.height/2.0];
    }
    else
    {
        self.text = @"99+";
        size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        [self setCorner:7];
    }
    self.textAlignment = NSTextAlignmentCenter;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width+5, size.height);
    
}

@end
