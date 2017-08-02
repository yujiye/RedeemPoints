//
//  FNEmptyCartView.m
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNEmptyCartView.h"

@interface FNEmptyCartView ()
{
    UIButtonActionBlock _loginBlock;
    
    UIButtonActionBlock _registerBlock;
}

@end

@implementation FNEmptyCartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35, kWindowWidth, 150)];
        
        [imageView setHorizonCenterWithSuperView:self];
        
        imageView.image = [UIImage imageNamed:@"cart_welcome_normal"];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:imageView];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.y + imageView.height + 5, self.width, 20)];
        
        tip.text = @"客官～您还没有登录哟～";
        
        tip.textAlignment = NSTextAlignmentCenter;
        
        [tip clearBackgroundWithFont:[UIFont fzltWithSize:18] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [self addSubview:tip];
        
        NSArray *titles = @[@"登录",@"注册"];
        
        NSInteger i = 0;
        
        for (NSString *t in titles)
        {
            FNButton *indexBut = [FNButton buttonWithType:FNButtonTypePlain title:t];
            
            indexBut.frame = CGRectMake(85, imageView.y + imageView.height + 30 + i*(50+10), kWindowWidth-85*2, 50);
            
            indexBut.tag = i;
            
            [indexBut setCorner:5];
            
            [indexBut addSuperView:self ActionBlock:^(id sender) {
                
                if ([(UIButton *)sender tag] == 0)
                {
                    _loginBlock(sender);
                }
                else
                {
                    _registerBlock(sender);
                }
                
            }];
            
            if (i == titles.count - 1)
            {
                [indexBut setBackgroundColor:UIColorWithRGB(133, 151, 248)];
            }
            
            i++;
        }
        
        
    }
    return self;
}


- (void)setLoginBlock:(UIButtonActionBlock)block
{
    _loginBlock = nil;
    
    _loginBlock = block;
}

- (void)setRegisterBlock:(UIButtonActionBlock)block
{
    _registerBlock = nil;
    
    _registerBlock = block;
}

@end
