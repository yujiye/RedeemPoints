//
//  UIButton+Cate.m
//  YueXin
//
//  Created by feinno on 15/6/29.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "UIButton+Cate.h"

static char UIBUTTON_ACTION_KEY;

@implementation UIButton (Cate)


-(void)setFrameWithOriginal:(CGPoint)point image:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
    self.frame = CGRectMake(point.x, point.y, kImage_W(image), kImage_H(image));
    
}
-(void)setDefaultStateTitle:(NSString *)title titleColor:(UIColor *)color{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
}
-(void)setImageNormal:(UIImage *)normal hightLighted:(UIImage *)hightLighted{
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:hightLighted forState:UIControlStateHighlighted];
}
-(void)setImageNormal:(UIImage *)normal selected:(UIImage *)selected{
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:selected forState:UIControlStateSelected];
}

-(void)addSuperView:(UIView *)superView ActionBlock:(UIButtonActionBlock)block{
    
    [superView addSubview:self];
    
    objc_setAssociatedObject(self, &UIBUTTON_ACTION_KEY, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonClick{
    UIButtonActionBlock block = objc_getAssociatedObject(self, &UIBUTTON_ACTION_KEY);
    if (block) {
        block(self);
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (!enabled)
    {
        objc_removeAssociatedObjects(self);
    }
    
    [super setEnabled:enabled];
}

@end
