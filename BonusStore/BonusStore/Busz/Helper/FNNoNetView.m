
//
//  FNNoNetView.m
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNNoNetView.h"

@interface FNNoNetView ()
{
    UIButtonActionBlock _block;
}

@end

@implementation FNNoNetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 75, 60, 41)];
        
        [_iconView setHorizonCenterWithSuperView:self];
                
        [self addSubview:_iconView];
        
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.y + _iconView.height + 10, kWindowWidth, 30)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.text = @"网络请求失败！";
        
        [_titleLabel clearBackgroundWithFont:[UIFont fzltWithSize:22] textColor:[UIColor blackColor]];
        
        [self addSubview:_titleLabel];
        
        UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.y + _titleLabel.height, kWindowWidth, 40)];
        
        subTitleLabel.numberOfLines = 2;
        
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        subTitleLabel.text = @"请检查您的网络\n重新加载吧";
        
        [subTitleLabel clearBackgroundWithFont:[UIFont fzltWithSize:13] textColor:UIColorWith0xRGB(0x8c8c8c)];
        
        [self addSubview:subTitleLabel];
        
        FNButton *indexBut = [FNButton buttonWithType:FNButtonTypeEdge title:@"再逛逛"];
        
        indexBut.frame = CGRectMake(91, subTitleLabel.y + subTitleLabel.height + 12, self.width-91*2, 40);
        
        [indexBut setCorner:5];
        
        [indexBut addSuperView:self ActionBlock:^(id sender) {
            
            if (_block)
            {
                _block(sender);
            }
            
        }];
        
        indexBut.layer.borderColor = [MAIN_COLOR_GRAY_ALPHA CGColor];
        
        [indexBut setTitleColor:MAIN_COLOR_GRAY_ALPHA forState:UIControlStateNormal];

    }
    return self;
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;
}

- (void)setActionBlock:(UIButtonActionBlock)block
{
    _block = nil;
    
    _block = block;
}

@end
