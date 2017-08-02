//
//  FNTurnLoadView.m
//  BonusStore
//
//  Created by cindy on 2017/5/3.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNTurnLoadView.h"
#import "FNHeader.h"

@interface FNTurnLoadView ()

@property (nonatomic,strong) UIActivityIndicatorView  * activityIndicator;

@end

@implementation FNTurnLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //创建蒙版
        UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        [self addSubview:coverView];
        coverView.backgroundColor = [UIColor blackColor];
        coverView.alpha = 0.2;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth -210)*0.5, (kScreenHeight - 64 -100-100)*0.5, 210, 100)];
        bgView.backgroundColor = UIColorWith0xRGB(0x333333);
        [self addSubview:bgView];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((210-48)*0.5, 10, 50, 50)];
        [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [bgView addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+50+10, 210-20, 14)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"正在连接蓝牙盒子，请稍候...";
        [bgView addSubview:label];
        
    }
    return self;
}


-(void)willHide
{
    [self removeFromSuperview];
    [_activityIndicator stopAnimating];
}

@end
