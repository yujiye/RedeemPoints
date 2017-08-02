//
//  FNMainProductHeaderView.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/27.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainProductHeaderView.h"

@interface FNMainProductHeaderView ()
{
    UIView *_bg;
}

@end

@implementation FNMainProductHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat kscale;
        
        if (IS_IPHONE_6)
        {
            kscale = 1;
            
        }else if (IS_IPHONE_6P)
        {
            kscale = (CGFloat)(414.0/375.0);
        }else
        {
            kscale = (CGFloat)(320.0/375.0);
        }
        self.backgroundColor = [UIColor whiteColor];
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 120*kscale)];
        _headImg.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:_headImg];
        
        _bg = [[UIView alloc]initWithFrame:CGRectMake(0, _headImg.y+_headImg.height, self.width, self.height - _headImg.height)];
        _bg.backgroundColor = MAIN_COLOR_WHITE;
        [self addSubview:_bg];
      
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 105*kscale, self.width, 1)];
        line1.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        [_bg addSubview:line1];
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2-1, 0, 1, self.height - _headImg.height)];
        line2.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        [_bg addSubview:line2];
        UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(self.width/4-1,105*kscale, 1, self.height -  _headImg.height -105*kscale )];
        line3.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        [_bg addSubview:line3];
        UILabel *line4 = [[UILabel alloc]initWithFrame:CGRectMake(self.width - self.width/4-1, line3.y, 1, line3.height)];
        line4.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        [_bg addSubview:line4];
    }
    
    return self;
}

- (void)setHeaderImg:(NSMutableArray *)headImgArray
{
    _imgArr = headImgArray;
    FNAdvertOfConfig *advert = headImgArray.firstObject;
    
    [_headImg sd_setImageWithURL:IMAGE_ID(advert.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
    [_headImg addTarget:self action:@selector(mainImgAdver:)];

}

- (void)mainImgAdver:(UIButton *)sender
{
     FNAdvertOfConfig *advert = _imgArr.firstObject;
    
    NSMutableString *j = [NSMutableString stringWithFormat:@"%@", advert.jump];

    if ([j rangeOfString:@"?"].length)
    {
        [j appendString:@"&app=app"];
    }
    else
    {
        [j appendString:@"?app=app"];
    }

    FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:j]];
    
    web.title = @"聚分享活动";
    web.isPop = YES;
    
    [[self viewController].navigationController pushViewController:web animated:YES];
}

- (void)setConfigForProductWithImgArray:(NSMutableArray *)imageArray
{
    if (imageArray.count == 0)
    {
        imageArray = [NSMutableArray arrayWithObjects:@"main_item_default.png",@"main_item_default.png",@"main_item_default.png",@"main_item_default.png",@"main_item_default.png",@"main_item_default.png", nil];
    }
    else
    {
      NSMutableArray *images = [NSMutableArray array];
    
      for (int i=0; i < 2; i ++)
     {
        [images addObject:imageArray[i]];
     }
    _productImageArr1 = images;

    CGFloat width = self.frame.size.width / images.count;
    NSInteger index = 0;
        CGFloat kscale;
        if (IS_IPHONE_6)
        {
            kscale = 1;
            
        }else if (IS_IPHONE_6P)
        {
            kscale = (CGFloat)(414.0/375.0);
        }else
        {
            kscale = (CGFloat)(320.0/375.0);
        }

    for (FNAdvertOfConfig *img in images)
    {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(10+width*index, 0, (self.frame.size.width - 20-20)/2 , 105 *kscale)];
        [view sd_setImageWithURL:IMAGE_ID(img.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
        [_bg addSubview:view];
        view.tag = index;
        view.contentMode = UIViewContentModeScaleAspectFit;
        [view addTarget:self action:@selector(selectedIndex:)];
        index++;
    }
    
    NSMutableArray *imagesArrays = [NSMutableArray array];
    for (int i =0; i <imageArray.count ; i ++)
    {
        if (i > 1)
        {
            [imagesArrays addObject:imageArray[i]];
        }
    }
    _productImageArr2 = imagesArrays;
    CGFloat widthMin = self.frame.size.width /4;
    
    NSInteger indexSecond = 0;
    for (FNAdvertOfConfig *img in imagesArrays)
    {
        CGFloat x;
        CGFloat width;
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
        {
            x = 5;
            width = 65;
        }
        else
        {
            x = 10;
            if (IS_IPHONE_6P)
            {
                width = 75;
            }
            else
            {
                width = 70;
            }
        }
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(x+widthMin*indexSecond, (15+105)*kscale, width, 110*kscale)];
        [view sd_setImageWithURL:IMAGE_ID(img.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
        [_bg addSubview:view];
        view.tag = indexSecond;
        view.contentMode = UIViewContentModeScaleAspectFit;
        [view addTarget:self action:@selector(selectedIndexOfProduct:)];
        indexSecond++;
    }
    }
    
}
//少个数组个数判断
- (void)selectedIndex:(UIGestureRecognizer *)sender
{
    NSMutableArray *urlArr = [NSMutableArray array];
    for (FNAdvertOfConfig *url in _productImageArr1)
    {
        [urlArr addObject:url.jump];
    }
    NSMutableString *j = [NSMutableString stringWithFormat:@"%@",urlArr[sender.view.tag] ];
    if ([j rangeOfString:@"data-detail.html?"].location !=NSNotFound)
    {
        
        NSArray *urlArr = [j componentsSeparatedByString:@"productId"];
        NSString *productId = [urlArr.lastObject substringFromIndex:1];
        FNDetailVC *mainDetailVC = [[FNDetailVC alloc]init];
        mainDetailVC.productId = productId;
        
        [[self viewController].navigationController pushViewController:mainDetailVC animated:YES];
    }
    else
    {
        
        if ([j rangeOfString:@"?"].length)
        {
            [j appendString:@"&app=app"];
        }
        else
        {
            [j appendString:@"?app=app"];
        }
        
        FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:j]];
        web.title = @"聚分享活动";
        [[self viewController].navigationController pushViewController:web animated:YES];
    }
    
}

- (void)selectedIndexOfProduct:(UIGestureRecognizer *)sender
{
    
    NSMutableArray *urlArr = [NSMutableArray array];
    for (FNAdvertOfConfig *url in _productImageArr2)
    {
        [urlArr addObject:url.jump];
    }
    NSMutableString *j = [NSMutableString stringWithFormat:@"%@", urlArr[sender.view.tag]];
    if ([j rangeOfString:@"data-detail.html?"].location !=NSNotFound)
    {
        
        NSArray *urlArr = [j componentsSeparatedByString:@"productId"];
        NSString *productId = [urlArr.lastObject substringFromIndex:1];
        FNDetailVC *mainDetailVC = [[FNDetailVC alloc]init];
        mainDetailVC.productId = productId;
        
        [[self viewController].navigationController pushViewController:mainDetailVC animated:YES];
    }
    else
    {
        if ([j rangeOfString:@"?"].length)
        {
            [j appendString:@"&app=app"];
        }
        else
        {
            [j appendString:@"?app=app"];
        }
        
        
        FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:j]];
        web.title = @"聚分享活动";
        [[self viewController].navigationController pushViewController:web animated:YES];
    }

}

- (UIViewController *)viewController
{
    UIViewController *vc = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            vc =  (UIViewController *)nextResponder;
            return (UIViewController*)nextResponder;
        }
    }
    return vc;
}

@end
