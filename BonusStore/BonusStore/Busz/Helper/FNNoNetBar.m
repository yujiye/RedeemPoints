//
//  FNNoNetBar.m
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNNoNetBar.h"

@interface FNNoNetBar ()
{
    UIButtonActionBlock _block;
}

@end

@implementation FNNoNetBar

+ (instancetype)shared
{
    static FNNoNetBar *_bar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bar = [[FNNoNetBar alloc] init];
    });
    
    return _bar;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
        self.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, kWindowWidth, 50);
        
        self.backgroundColor = UIColorWithRGB(53, 53, 53);
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 20, 20)];

        imageView.image = [UIImage imageNamed:@"net_logo"];

        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [imageView setVerticalCenterWithSuperView:self];

        [self addSubview:imageView];

        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(imageView.x + imageView.width + 5, 0, self.width-50, 20)];

        tip.text = @"网络请求失败，请检查您的网络设置！";

        [tip setVerticalCenterWithSuperView:self];

        [tip clearBackgroundWithFont:[UIFont fzltWithSize:15] textColor:[UIColor whiteColor]];

        [self addSubview:tip];
        
        [self addTarget:self action:@selector(goSetting)];
    
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

- (void)goMainWithBlock:(UIButtonActionBlock)block
{
    _block = nil;
    
    _block = block;
}

- (void)goSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
   
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        NSURL * url = [NSURL URLWithString:@"prefs:root=SETTING"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
