//
//  FNNavigationController.m
//  BonusStore
//
//  Created by Nemo on 16/1/2.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "FNNavigationController.h"

@interface FNNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation FNNavigationController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if ([fromVC isKindOfClass:[FNMainVC class]] || [fromVC isKindOfClass:[FNCateVC class]] || [fromVC isKindOfClass:[FNCartVC class]] || [fromVC isKindOfClass:[FNMyVC class]])
    {
        self.tabBarController.tabBar.hidden = YES;
    }
    else if ([toVC isKindOfClass:[FNMainVC class]] || [toVC isKindOfClass:[FNCateVC class]] || [toVC isKindOfClass:[FNCartVC class]] || [toVC isKindOfClass:[FNMyVC class]])
    {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    //从支付成功到待发货订单，不能右滑返回
    
    if ([toVC isKindOfClass:[FNPayVC class]] || [toVC isKindOfClass:[FNPayFinishVC class]] || [fromVC isKindOfClass:[FNPayFinishVC class]] || [toVC isKindOfClass:[FNSZPayFinishVC class]] ||[fromVC isKindOfClass:[FNSZPayFinishVC class]] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    else
    {
        self.interactivePopGestureRecognizer.enabled = YES;
        
        self.interactivePopGestureRecognizer.delegate = self;
    }
    
    return nil;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1)
    {
        return NO;
    }
    
    return YES;
}


- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   return [super popToViewController:viewController animated:animated];
}

@end
