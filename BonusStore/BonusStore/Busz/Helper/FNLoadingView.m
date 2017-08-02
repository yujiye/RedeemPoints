//
//  FNLoadingView.m
//  BonusStore
//
//  Created by Nemo on 16/5/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNLoadingView.h"

@interface FNLoadingView ()
{
    UIButtonActionBlock _block;

}

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FNLoadingView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self setCorner:5];
        
        UIImageView *_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, frame.size.width-20, frame.size.height-50)];
        
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_iconView setHorizonCenterWithSuperView:self];
        
        _iconView.image = [UIImage imageNamed:@"loading"];
        
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.y + _iconView.height+5, frame.size.width, 20)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.text = @"正在加载中...";
        
        [_titleLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:[UIColor whiteColor]];
        
        [self addSubview:_titleLabel];
        
    }
    return self;
}

+ (void)showInView:(UIView *)view
{
    [[FNLoadingLock shared].lock lock];
    
    FNLoadingView *beforeLoadingView = [[FNLoadingLock shared].list valueForKey:[NSString stringWithFormat:@"%ld",view.hash]];
    
    if (beforeLoadingView)
    {
        return;
    }
    
    FNLoadingView *_loadingView = [[FNLoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [[FNLoadingLock shared].list setObject:_loadingView forKey:[NSString stringWithFormat:@"%ld",view.hash]];

    [view addSubview:_loadingView];
    
    [_loadingView setHorizonCenterWithSuperView:view];
    
    [_loadingView setVerticalCenterWithSuperView:view];
    
    [[FNLoadingLock shared].lock unlock];
}

+ (void)showInView:(UIView *)view text:(NSString *)text
{
    [[FNLoadingLock shared].lock lock];
    
    FNLoadingView *_loadingView = [[FNLoadingLock shared].list valueForKey:[NSString stringWithFormat:@"%ld",view.hash]];

    if (_loadingView)
    {
        _loadingView.titleLabel.text = text;
    }
    
    [[FNLoadingLock shared].lock unlock];
}

+ (void)hideFromView:(UIView *)view
{
    [[FNLoadingLock shared].lock lock];
    
    FNLoadingView *_loadingView = [[FNLoadingLock shared].list valueForKey:[NSString stringWithFormat:@"%ld",view.hash]];
    
    if (_loadingView)
    {
        [_loadingView removeFromSuperview];
        
        [[FNLoadingLock shared].list removeObjectForKey:[NSString stringWithFormat:@"%ld",view.hash]];
    }
    
    [[FNLoadingLock shared].lock unlock];
}

+ (void)hide
{
    [[FNLoadingLock shared].lock lock];
    
    NSDictionary *info = [[FNLoadingLock shared].list copy];
    
    for (NSString *hash in [info allKeys])
    {
        if ([[[FNLoadingLock shared].list valueForKey:hash] isKindOfClass:[UIView class]])
        {
            [(UIView *)[[FNLoadingLock shared].list valueForKey:hash] removeFromSuperview];
        }
    }
    
    [[FNLoadingLock shared].list removeAllObjects];
    
    [[FNLoadingLock shared].lock unlock];
}


@end

@implementation FNLoadingLock

+ (instancetype)shared
{
    static FNLoadingLock *_loadingLock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loadingLock = [[FNLoadingLock alloc] init];
        
        _loadingLock.lock = [[NSRecursiveLock alloc] init];
        
        _loadingLock.list = [[NSMutableDictionary alloc] init];
    });
    return _loadingLock;
}

@end
