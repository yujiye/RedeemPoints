//
//  FNTextField.m
//  BonusStore
//
//  Created by qingPing on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNTextField.h"
#import "FNHeader.h"
@implementation FNTextField


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.isToolBar = YES;
        
    }
    return self;
}

- (void)setIsToolBar:(BOOL)isToolBar
{
    _isToolBar = isToolBar;
    
    if (_isToolBar)
    {
        self.inputAccessoryView = [self  keyToolbar];
    }
    else
    {
        self.inputAccessoryView = nil;
    }
}

- (UIToolbar *)keyToolbar
{
    
    UIToolbar *keyToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    keyToolbar.barTintColor =[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.5];
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick:)];
    
    UIBarButtonItem * doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClick:)];
    
    UIBarButtonItem  *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    keyToolbar.items = [NSArray arrayWithObjects:cancleButton,spaceButtonItem,doneButtonItem,nil];
    [keyToolbar sizeToFit];
    return keyToolbar ;
}


-(void)cancleButtonClick:(id)sender
{
    if([self.textFieldDelegate respondsToSelector:@selector(toolbarBtnClick:flag:)])
    {
        [self.textFieldDelegate toolbarBtnClick:self flag:0];
    }
}

-(void)doneButtonClick:(id)sender
{
    if([self.textFieldDelegate respondsToSelector:@selector(toolbarBtnClick:flag:)])
    {
        [self.textFieldDelegate toolbarBtnClick:self flag:1];
    }
}

- (void)drawPlaceholderInRect:(CGRect)rect 
{

    
    if (IS_IPHONE_4_OR_LESS)
    {
        if (self.placeholderFont)
        {
            CGRect center = CGRectMake(rect.origin.x, (self.frame.size.height-rect.size.height)/2.0+15, rect.size.width, self.frame.size.height);
            [[self placeholder] drawInRect:center withAttributes:@{NSForegroundColorAttributeName:UIColorWith0xRGB(0x999999),
                                                                   NSFontAttributeName:[UIFont fzltWithSize:self.placeholderFont]}];
        }
        else
        {
            CGRect center = CGRectMake(rect.origin.x, (self.frame.size.height-rect.size.height)/2.0+10, rect.size.width, self.frame.size.height);
            [[self placeholder] drawInRect:center withAttributes:@{NSForegroundColorAttributeName:UIColorWith0xRGB(0x999999),
                                                                   NSFontAttributeName:[UIFont fzltWithSize:15]}];
        }

    }
    else
    {
        if (self.placeholderFont && self.isSanPayVC == YES)
        {
            CGRect center = CGRectMake(rect.origin.x, (self.frame.size.height-rect.size.height)/2.0+6, rect.size.width, self.frame.size.height);
            [[self placeholder] drawInRect:center withAttributes:@{NSForegroundColorAttributeName:UIColorWith0xRGB(0x999999),
                                                                   NSFontAttributeName:[UIFont fzltWithSize:self.placeholderFont]}];
        }
        else if (self.placeholderFont)
        {
            CGRect center = CGRectMake(rect.origin.x, (self.frame.size.height-rect.size.height)/2.0+15, rect.size.width, self.frame.size.height);
            [[self placeholder] drawInRect:center withAttributes:@{NSForegroundColorAttributeName:UIColorWith0xRGB(0x999999),
                                                                   NSFontAttributeName:[UIFont fzltWithSize:self.placeholderFont]}];
        }
        else
        {
            CGRect center = CGRectMake(rect.origin.x, (self.frame.size.height-rect.size.height)/2.0+10, rect.size.width, self.frame.size.height);
            [[self placeholder] drawInRect:center withAttributes:@{NSForegroundColorAttributeName:UIColorWith0xRGB(0x999999),
                                                                   NSFontAttributeName:[UIFont fzltWithSize:15]}];
        }

    }
}



@end
