//
//  FNFocusView.m
//  BonusStore
//
//  Created by Nemo on 16/4/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNFocusView.h"
#import "FNScrollView.h"

static CGFloat FN_FOCUS_PAGE_MARGIN             =   30;

static NSTimeInterval FN_FOCUS_TIMER_INTERVAL   =   3;

@interface FNFocusView ()<UIScrollViewDelegate>
{
    FNScrollView *_scrollView;
    
    CGRect _rect;
    
    NSTimer *_timer;
    
    NSInteger _currentPage;
    
    UIImageView *_leftImageView;
    
    UIImageView *_centerImageView;
    
    UIImageView *_rightImageView;
    
    void (^FNFocusDidSelected) (NSInteger index, FNImageArgs *args);
}

@end

@implementation FNFocusView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _rect = frame;
        
        _pageAlign = FNFocusPageAlignCenter;
        
        _imageViews = [[NSMutableArray alloc] init];
        
        _scrollView = [[FNScrollView alloc] initWithFrame:frame];
        
        _scrollView.pagingEnabled = YES;
        
        _scrollView.delegate = self;
        
        _scrollView.bounces = NO;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
                
        [self addSubview:_scrollView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        
        [self addGestureRecognizer:tapGesture];
        
        [_scrollView setContentSize:CGSizeMake(3*self.width, self.height)];
        
        _scrollView.delaysContentTouches = NO;
        
        _scrollView.canCancelContentTouches = YES;
        
        [_scrollView touchStateChangeBlock:^(FNTouchState state) {
            
            //这里没有使用cancel，是因为当touchbegan后，进行滑动，会出发touchcancel，所以没有用
            //touchmoved 不需要，会走scrollview的move代理
            switch (state)
            {
                case FNTouchStateBegan:
                    [self touchDown];
                    break;
                case FNTouchStateEnded:
                    [self touchUp];
                    break;
                    
                default:
                    break;
            }
        }];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        
        [_scrollView addSubview:_leftImageView];
        
        [_imageViews addObject:_leftImageView];

        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
        
        [_scrollView addSubview:_centerImageView];
        
        [_imageViews addObject:_centerImageView];

        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * self.width, 0, self.width, self.height)];
        
        [_scrollView addSubview:_rightImageView];
        
        [_scrollView addTarget:self action:@selector(callback:)];
        
        [_imageViews addObject:_rightImageView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        [self addSubview:_pageControl];
    }
    
    return self;
}

- (void)tapClick:(UIGestureRecognizer *)tap
{
   if(tap.state !=UIGestureRecognizerStateEnded)
   {
       [self setIsAutoLoop:NO];
   }else
   {
       [self setIsAutoLoop:YES];

   }
    
}
- (void)setItems:(NSArray *)items
{
    _items = items;
    
    
    NSInteger cnt = _items.count;
    
   
    _pageControl.numberOfPages = cnt;
    
    [self changeImageLeft:cnt-1 center:0 right:1];
    
}

- (void)setPageAlign:(FNFocusPageAlign)pageAlign
{
    switch (pageAlign)
    {
        case FNFocusPageAlignLeft:
            
            UIReframeWithX(_pageControl, 0);
            
            break;
            
        case FNFocusPageAlignCenter:
            
            UIReframeWithX(_pageControl, kAverageValue(self.width - _items.count*FN_FOCUS_PAGE_MARGIN));
            
            break;
            
        case FNFocusPageAlignRight:
            
            UIReframeWithX(_pageControl, self.width-_items.count*FN_FOCUS_PAGE_MARGIN);
            
            break;
            
        default:
            break;
    }
}

- (void)setIsAutoLoop:(BOOL)isAutoLoop
{
    _isAutoLoop = isAutoLoop;
    
    if (_timer.valid && _isAutoLoop)
    {
        return;
    }
    
    if (_isAutoLoop)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:FN_FOCUS_TIMER_INTERVAL target:self selector:@selector(loop) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    else
    {
        if (_timer)
        {
            [_timer invalidate];
            
            _timer = nil;
        }
    }
}

- (void)loop
{
    CGFloat a = _scrollView.contentOffset.x/self.width;
    
    CGFloat x = _scrollView.contentOffset.x;
    
    if (a - 1 != 0)
    {
        x = _currentPage * self.width;
    }
    
    if (_currentPage > fabs(10000.0))   //大于1w，则认为数据异常并清0
    {
        _currentPage = 0;
    }
    
    [_scrollView setContentOffset:CGPointMake(x +self.width, 0) animated:YES];
}

#pragma mark - ScrollView Delegate

- (void)touchDown
{
    if (!self.isAutoLoop)
    {
        return;
    }
    [self setIsAutoLoop:NO];
}

- (void)touchUp
{
    if (self.isAutoLoop)
    {
        return;
    }
    
    [self setIsAutoLoop:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self touchDown];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self touchUp];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

#pragma mark - Exchange image

- (void)changeImageLeft:(NSInteger)left center:(NSInteger)center right:(NSInteger)right
{
    NSURL *l = nil;
    NSURL *c = nil;
    NSURL *r = nil;
    
    FNImageArgs *item = _items[left];
    
    if (item.imgKey)
    {
        l = IMAGE_ID([_items[left] imgKey]);
        
        c = IMAGE_ID([_items[center] imgKey]);
        
        r = IMAGE_ID([_items[right] imgKey]);
    }
    else
    {
        l = [NSURL URLWithString:[(FNImageArgs *)_items[left] url]];
        
        c = [NSURL URLWithString:[(FNImageArgs *)_items[center] url]];
        
        r = [NSURL URLWithString:[(FNImageArgs *)_items[right] url]];
    }
    
    
    [_leftImageView sd_setImageWithURL:l placeholderImage:[UIImage imageNamed:@""]];
 
    [_centerImageView sd_setImageWithURL:c placeholderImage:[UIImage imageNamed:@""]];

    [_rightImageView sd_setImageWithURL:r placeholderImage:[UIImage imageNamed:@""]];
    
    [_scrollView setContentOffset:CGPointMake(self.width, 0)];
}

- (void)changeImageWithOffset:(CGFloat)offsetX
{
    NSInteger cnt = _items.count;
    
    if (offsetX >= self.width * 2)
    {
        _currentPage++;
        
        
        if (_currentPage == cnt-1)
        {
            [self changeImageLeft:_currentPage-1 center:_currentPage right:0];
        }
        else if (_currentPage == cnt)
        {
            _currentPage = 0;
            
            [self changeImageLeft:cnt - 1 center:0 right:1];
        }
        else
        {
            [self changeImageLeft:_currentPage - 1 center:_currentPage right:_currentPage + 1];
        }
    }
    
    if (offsetX <= 0)
    {
        _currentPage--;
        
        if (_currentPage == 0)
        {
            [self changeImageLeft:cnt - 1 center:0 right:1];
        }
        else if (_currentPage == -1)
        {
            _currentPage = cnt - 1;
            
            [self changeImageLeft:_currentPage - 1 center:_currentPage right:0];
        }
        else
        {
           
            [self changeImageLeft:_currentPage - 1 center:_currentPage right:_currentPage+1];
        }
    }
    
    _pageControl.currentPage = _currentPage;
}

- (void)focusDidSelectedIndex:(void (^) (NSInteger index, FNImageArgs *args))block
{
    FNFocusDidSelected = nil;
    
    FNFocusDidSelected = block;
}

- (void)callback:(UITapGestureRecognizer *)ges
{
    if ([(FNImageArgs *)_items[_currentPage] jump])
    {
        FNFocusDidSelected(_currentPage, _items[_currentPage]);
    }
    else
    {
        FNFocusDidSelected(0, nil);
    }
}


- (void)dealloc
{
    // Just in case.
    
    if (_timer)
    {
        [_timer invalidate];
        
        _timer = nil;
    }
}


@end
