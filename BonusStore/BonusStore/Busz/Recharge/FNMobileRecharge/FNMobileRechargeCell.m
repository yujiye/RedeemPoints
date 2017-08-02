//
//  FNMobileRechargeCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMobileRechargeCell.h"

@interface FNMobileRechargeCell ()

@end

@implementation FNMobileRechargeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,(kScreenWidth - 4*16)/3 , 80)];
        _bgView.backgroundColor = MAIN_COLOR_WHITE;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5.0;
        _bgView.layer.borderWidth = 1.0;
        _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_bgView];
        
        _defaultLab = [[UILabel alloc]initWithFrame:CGRectMake(0,25 , (kScreenWidth - 4*16)/3, 30)];
        _defaultLab.font = [UIFont systemFontOfSize:20];
        _defaultLab.textColor = [UIColor lightGrayColor];
        _defaultLab.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_defaultLab];
        
    }
    return self;
}
    

@end

