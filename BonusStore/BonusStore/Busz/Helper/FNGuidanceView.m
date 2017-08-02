//
//  FNGuidanceView.m
//
//
//  Created by Nemo on 16/1/12.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "FNGuidanceView.h"

@interface FNGuidanceView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    
    UIButtonActionBlock _block;
    
    UIPageControl *_control;
}
@end

@implementation FNGuidanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
   
        [self initView];
        
    }
    return self;
}

- (void)initView
{
    NSArray *images = nil;
    
    if (IS_IPHONE_6P)
    {
        images = @[@"guidance_6p",@"guidance_6p"];
    }
    else
    {
        images = @[@"guidance_6",@"guidance_6"];
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    
    _scrollView.backgroundColor = UIColorWithRGB(255, 56, 65);
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    NSInteger i = 0;
    
    for (NSString *name in images)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.width, 0, self.width, self.height)];
        
        imageView.backgroundColor = [UIColor whiteColor];
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%ld",name,i]];
        
        [_scrollView addSubview:imageView];
        
        if (i == images.count-1)
        {
            UIView *last = [self initLastView];
            
            [_scrollView addSubview:last];
        }
        
        i++;
    }
    
    [_scrollView setContentSize:CGSizeMake(images.count*kWindowWidth, _scrollView.height)];
    
    _control = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kWindowHeight-50, kWindowWidth, 20)];
    
    [self addSubview:_control];
    
    _control.numberOfPages = images.count;
}

- (UIView *)initLastView
{
    UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(kWindowWidth, 0, kWindowWidth, kWindowHeight)];
    
    [lastView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"guidanceSec_6_0"]]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, 149, 42)];
    
    [imageView setHorizonCenterWithSuperView:lastView];
    
    imageView.image = [UIImage imageNamed:@"logo-white@2"];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [lastView addSubview:imageView];
    
    NSArray *titles = @[@"注册帐号",@"立即登录",@"随便逛逛"];
    
    NSInteger i = 0;
    
    for (NSString *t in titles)
    {
        FNButton *indexBut = [FNButton buttonWithType:FNButtonTypePlain title:t];
        
        indexBut.frame = CGRectMake(37, imageView.y + imageView.height + 30 + i*(50+10), kWindowWidth-37*2, 50);
        
        indexBut.tag = i;
        
        [indexBut setCorner:5];
        
        [indexBut addSuperView:lastView ActionBlock:^(id sender) {
            
            _block(sender);
            
        }];
        
        if (i == titles.count - 1)
        {
            [indexBut setBackgroundColor:UIColorWithRGB(251, 93, 111)];
            
            [indexBut setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        }
        if (i == 1 || i == 0)
        {
            [indexBut setBackgroundColor:MAIN_COLOR_WHITE];
            
            [indexBut setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
        }
        
        i++;
    }
    
    return lastView;
}

- (void)initLastBlock:(UIButtonActionBlock)block
{
    _block = nil;
    
    _block = [block copy];
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/kWindowWidth;
    
    _control.currentPage = index;
}

@end
