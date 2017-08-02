//
//  XMTabbarVC.m
//  BonusStore
//
//  Created by Nemo on 15/12/27.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import "FNTabBarVC.h"
#import "FNLoginBO.h"
#import "FNCartBO.h"
NSString *const FNCartBadgeUpdateNotification       =   @"FNCartBadgeUpdateNotification";

NSString *const FNUserAccountIsLoginNotification    =   @"FNUserAccountIsLoginNotification";

NSString *const FNUserAccountCancelNotification  = @"FNUserAccountCancelNotification";

@interface FNTabBarVC ()<UITabBarControllerDelegate>


@end

@implementation FNTabBarVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.delegate = self;
    
    self.tabBar.tintColor = [UIColor redColor];

    NSArray *titles = @[@"首页", @"分类", @"购物车", @"我的"];
    
    NSArray *images = @[@"tab_main_n", @"tab_cate_n", @"tab_cart_n", @"tab_my_n"];
    
    NSArray *selected = @[@"tab_main_s", @"tab_cate_s", @"tab_cart_s", @"tab_my_s"];
    
    for (int i = 0; i<titles.count; i++)
    {
        UITabBarItem *home = [[UITabBarItem alloc]initWithTitle:titles[i] image:[UIImage imageNamed:images[i]] tag:i];
        
        home.selectedImage = [[UIImage imageNamed:selected[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self.viewControllers[i] setTabBarItem:home];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR_RED_ALPHA} forState:UIControlStateSelected];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginViewController:) name:FNUserAccountIsLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelClickToMainVC:) name:FNUserAccountCancelNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCartBadge:) name:FNCartBadgeUpdateNotification object:nil];
    
    
}

- (void)cancelClickToMainVC:(NSNotification *)noti
{
    isIgnore = NO;
    
    [self goTabIndex:0];

}
- (void)updateCartBadge:(NSNotification *)noti
{
    UITabBarItem *item = [self.viewControllers[2] tabBarItem];
    
    [item setBadgeValue:[[noti object] stringValue]];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UIViewController *vc = [[(UINavigationController *)viewController viewControllers] firstObject];
        
        if ([vc isKindOfClass:[FNMyVC class]])
        {
            _tabSelectedIndex = 3;

            return [FNLoginBO isLogin];
        }
        else if ([vc isKindOfClass:[FNMySetVC class]])
        {
            _tabSelectedIndex = 3;
            
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
            
            return [FNLoginBO isLogin];
        }
        else if ([vc isKindOfClass:[FNCartVC class]])
        {
            _tabSelectedIndex = 2;
            
            return [FNLoginBO isLogin];
        }
        else if ([vc isKindOfClass:[FNCateVC class]])
        {
            _tabSelectedIndex = 1;
        }
        else if ([vc isKindOfClass:[FNMainVC class]])
        {
            _tabSelectedIndex = 0;
        }
        
        if ([vc isKindOfClass:[FNOrderVC class]] || [vc isKindOfClass:[FNPayVC class]] || [vc isKindOfClass:[FNWebVC class]])
        {
            if (![FNLoginBO isLogin])
            {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([self.selectedViewController isKindOfClass:[FNNavigationVC class]])
    {
        [(FNNavigationVC *)self.navigationController removeAllScreenShot];
    }
}

- (void)presentLoginViewController:(NSNotification *)noti
{
    NSDictionary *info = noti.object;
    
    FNLoginVC *login = [[FNLoginVC alloc] init];
    
    login.isAuthFail = [info[@"isAuth"] boolValue];
    
    //鉴权失败，弹出登录，需要区别正常的登录
    [login goMainWithBlock:^{
        
        if ([info[@"isAuth"] boolValue])
        {
            [login dismissViewControllerAnimated:NO completion:^{
                
                [self goTabIndex:0];
            }];
        }
        else
        {
            [login dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    if (!FNLoginIsScan)
    {
        [login goSelectedVCWithBlock:^{
            
            self.selectedIndex = _tabSelectedIndex;
            
            if (_tabSelectedIndex == 0 || _tabSelectedIndex == 1)
            {
                
            }
            else
            {
                _tabSelectedIndex = 0;
            }
            
        }];
    }
    
    FNNavigationVC *nav = [[FNNavigationVC alloc] initWithRootViewController:login];
    isIgnore = NO;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Notif_LoginTokenUpdated" object:nil];
}

@end
