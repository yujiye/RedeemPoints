//
//  FNFlowRechargeCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/10/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNFlowRechargeCell.h"

@implementation FNFlowRechargeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    CGFloat height = 55;
      if (IS_IPHONE_5)
      {
          height = 45;
      }
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,(kScreenWidth - 4*16)/3 , height)];
        _bgView.backgroundColor = MAIN_COLOR_WHITE;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5.0;
        _bgView.layer.borderWidth = 1.0;
        _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_bgView];
        
        _flowLab = [[UILabel alloc]initWithFrame:CGRectMake(0,(height- 30)*0.5, (kScreenWidth - 4*16)/3, 30)];
        _flowLab.font = [UIFont systemFontOfSize:20];
        _flowLab.textColor = [UIColor lightGrayColor];
        _flowLab.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_flowLab];
    }
    return self;
}

@end
