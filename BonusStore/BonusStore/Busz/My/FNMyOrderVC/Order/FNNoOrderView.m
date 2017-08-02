//
//  FNNoOrderView.m
//  BonusStore
//
//  Created by Nemo on 16/4/29.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNNoOrderView.h"

@interface FNNoOrderView ()
{
    UIButtonActionBlock _block;
}

@end

@implementation FNNoOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 95, 224, 171)];
        
        [_iconView setHorizonCenterWithSuperView:self];
        
        _iconView.image = [UIImage imageNamed:@"cart_welcome_normal"];
        
        [self addSubview:_iconView];
        
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.y + _iconView.height + 10, kWindowWidth, 30)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.text = @"客官～您还没有订单";
        
        [_titleLabel clearBackgroundWithFont:[UIFont fzltWithSize:18] textColor:[UIColor blackColor]];
        
        [self addSubview:_titleLabel];
        
        FNButton *indexBut = [FNButton buttonWithType:FNButtonTypePlain title:@"去逛逛"];
        
        indexBut.frame = CGRectMake(91, _titleLabel.y + _titleLabel.height, self.width-91*2, 40);
        
        [indexBut setCorner:5];
        
        [indexBut addSuperView:self ActionBlock:^(id sender) {
            
            if (_block)
            {
                _block(sender);
            }
            
        }];
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
