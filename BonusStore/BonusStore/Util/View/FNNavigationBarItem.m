//
//  FNNavigationBarItem.m
//  CardPacket
//
//  Created by feinno on 15/3/16.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "FNNavigationBarItem.h"


@implementation FNNavigationBarItem


+(UIBarButtonItem *)initItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action
{
    return [[UIBarButtonItem alloc]initWithImage:IMAGE_NAME(image) style:UIBarButtonItemStylePlain target:target action:action];
}

+(void)setNavgationBackItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action
{
    UIBarButtonItem *backItem = [self initItemWithImage:image target:target action:action];
    [target.navigationItem setBackBarButtonItem:backItem];
}
+(void)setNavgationLeftItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action
{
    UIBarButtonItem *leftItem = [self initItemWithImage:image target:target action:action];
    [target.navigationItem setLeftBarButtonItem:leftItem];
}
+(void)setNavgationRightItemWithImage:(NSString *)image target:(UIViewController *)target action:(SEL)action
{
    UIBarButtonItem *rightItem = [self initItemWithImage:image target:target action:action];
    [target.navigationItem setRightBarButtonItem:rightItem];
}
+(void)setNavgationCustomItem:(UIView *)item target:(UIViewController *)target
{
    UIBarButtonItem *cusItem = [[UIBarButtonItem alloc]initWithCustomView:item];
    [target.navigationItem setBackBarButtonItem:cusItem];
}

+(void)setNavgationLeftItemWithTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
    leftItem.tintColor = UIColorWith0xRGB(0x4a4a4a);
    [target.navigationItem setLeftBarButtonItem:leftItem];
}
+(void)setNavgationRightItemWithTitle:(NSString *)title target:(UIViewController *)target action:(SEL)action{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
    rightItem.tintColor = UIColorWith0xRGB(0x4a4a4a);
    [target.navigationItem setRightBarButtonItem:rightItem];
}

static const NSInteger NAV_PADDING = 8;
+(UIButton *)setCustomItemWithOriginal:(CGPoint)original image:(UIImage *)image target:(UIViewController *)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(original.x, original.y, kImage_W(image), kImage_H(image));
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(void)setCustomBackWithTarget:(UIViewController *)target action:(SEL)action{
    NSString *imageName = @"FN_back_n";
    if (!IMAGE_NAME(imageName)) {
        NSLog(@"%s : Lacking of back icon!!!",__FUNCTION__);
    }
    UIButton *btn = [self setCustomItemWithOriginal:CGPointMake(0, 0) image:IMAGE_NAME(imageName) target:target action:action];
    
    UIBarButtonItem *cusItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [target.navigationItem setLeftBarButtonItem:cusItem];
}
+(void)setCustomLeftWithTarget:(UIViewController *)target image:(UIImage *)image action:(SEL)action{
    UIButton *btn = [self setCustomItemWithOriginal:CGPointMake(kImage_W(image)+NAV_PADDING, 0) image:image target:target action:action];
    
    UIBarButtonItem *cusItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [target.navigationItem setLeftBarButtonItem:cusItem];
}
+(UIBarButtonItem *)setCustomRightWithTarget:(UIViewController *)target image:(UIImage *)image action:(SEL)action{
    UIButton *btn = [self setCustomItemWithOriginal:CGPointMake(kWindowWidth-kImage_W(image)-NAV_PADDING, 0) image:image target:target action:action];
    
    UIBarButtonItem *cusItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [target.navigationItem setRightBarButtonItem:cusItem];
    return cusItem;
}

+(void)setCustomTitle:(NSString *)title target:(UIViewController *)target{
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(kAverageValue(kWindowWidth-200), NAVIGATION_BAR_HEIGHT, 200, 30)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = MAIN_COLOR_BLACK_ALPHA;//UIColorWithRGB(43, 171, 56);
    titleLable.font = [UIFont fzltWithSize:18];
    target.navigationItem.titleView = titleLable;
}

+(void)setCustomImage:(UIImage *)image target:(UIViewController *)target
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAverageValue(kWindowWidth-kImage_W(image)), STATE_BAR_HEIGHT, kImage_W(image), kImage_H(image))];
    imageView.image = image;
    target.navigationItem.titleView = imageView;
}



@end
