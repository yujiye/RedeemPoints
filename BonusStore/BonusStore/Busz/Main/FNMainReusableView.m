//
//  FNMainReusableView.m
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainReusableView.h"

@implementation FNMainReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = MAIN_BACKGROUND_COLOR;
        _checkAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkAllBtn.frame = CGRectMake((kScreenWidth - 150)/2, 15, 150, 34);
        _checkAllBtn.layer.masksToBounds = YES;
        _checkAllBtn.layer.cornerRadius = 17;
        _checkAllBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
        _checkAllBtn.layer.borderWidth = 1.0;
        [_checkAllBtn setTitle:@"浏览更多商品" forState:UIControlStateNormal];
        [_checkAllBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
        _checkAllBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_checkAllBtn];
        
    }
    return self;
}

@end


@implementation FNMainReusableViewTwo
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = MAIN_BACKGROUND_COLOR;
        
    }
    return self;
}
@end
