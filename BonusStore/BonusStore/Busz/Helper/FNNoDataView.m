//
//  FNNoDataView.m
//  BonusStore
//
//  Created by Nemo on 16/5/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNNoDataView.h"

@interface FNNoDataView()
{
    UIButtonActionBlock _block;
    
    UILabel *_titleLabel;
    
    FNNoDataType _type;
}

@end

@implementation FNNoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:FNNoDataTypeEmpty];
}

- (instancetype)initWithFrame:(CGRect)frame type:(FNNoDataType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = type;
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height/2.0 - NAVIGATION_BAR_HEIGHT - 72, 60, 72)];
        
        [_iconView setHorizonCenterWithSuperView:self];
        
        _iconView.image = [UIImage imageNamed:@"no_data_logo"];
        
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.y + _iconView.height + 10, frame.size.width, 30)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setType:type];
        
        [_titleLabel clearBackgroundWithFont:[UIFont fzltBoldWithSize:16] textColor:MAIN_COLOR_GRAY_ALPHA];
        
        [self addSubview:_titleLabel];
        
        [self addTarget:self action:@selector(refresh)];
        
        UILabel *_subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.y + _titleLabel.height + 10, frame.size.width, 30)];
        
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        _subTitleLabel.text = @"点击屏幕重试";
        
        [_subTitleLabel clearBackgroundWithFont:[UIFont fzltWithSize:15] textColor:MAIN_COLOR_GRAY_ALPHA];
        
        [self addSubview:_subTitleLabel];
        
        [self addTarget:self action:@selector(refresh)];
    }
    return self;
}

- (void)setTypeWithResult:(id)result
{
    if (!result)
    {
        [self setType:FNNoDataTypeError];
    }
    else
    {
        [self setType:FNNoDataTypeEmpty];
    }
}

- (void)setType:(FNNoDataType)type
{
    switch (type) {
        case FNNoDataTypeEmpty:
            _titleLabel.text = @"暂无数据";
            break;
        case FNNoDataTypeError:
            _titleLabel.text = @"获取数据失败";
            break;
            
        default:
            break;
    }
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;
}

- (void)refresh
{
    _block(nil);
}

- (void)setActionBlock:(UIButtonActionBlock)block
{
    _block = nil;
    
    _block = block;
}

@end
