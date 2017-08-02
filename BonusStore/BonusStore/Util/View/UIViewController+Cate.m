//
//  UIViewController+Cate.m
//  YueXin
//
//  Created by feinno on 15/6/24.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "UIViewController+Cate.h"

#import "FNLoginBO.h"
#import "AppDelegate.h"

static FNNoNetView *_noNetView;

static FNNoNetBar *_noNetBar;

@implementation UIViewController (Cate)

-(void)autoFitInsets{
    self.navigationController.navigationBar.translucent = NO;

    self.automaticallyAdjustsScrollViewInsets = NO;

}

-(void)addNotiWithSel:(SEL)sel{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:sel name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:sel name:UIKeyboardWillShowNotification object:nil];
}
-(void)removeNoti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void) setWhiteTitle:(NSString *)title
{
    self.title = title;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:18] };
}

-(void)setNavigationBarTintColor:(UIColor *)color{
    self.navigationController.navigationBar.tintColor = color;
}

-(void)setNavigationBarBackground:(UIColor *)color{
    UIImage *backgroundImage = [self imageWithColor:color];
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}
-(void)setNavigaitionBackItemToChi{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)goBack
{
    UIViewController *fromVC = [self.navigationController topViewController];
    
    if ([fromVC isKindOfClass:[FNMessageCenterVC class]] || [fromVC isKindOfClass:[FNOrderVC class]]|| [fromVC isKindOfClass:[FNWebVC class]] )
    {
        unsigned int out;
        
        objc_property_t *p = class_copyPropertyList([fromVC class], &out);
        
        for (int i = 0; i<out; i++)
        {
            NSString *name = [NSString stringWithCString:property_getName(p[i]) encoding:NSUTF8StringEncoding];
            
            if ([name isEqualToString:@"isNoti"])
            {
                BOOL isNoti = [[fromVC valueForKeyPath:@"isNoti"] boolValue];
                
                if (isNoti)
                {
                    [fromVC.navigationController popViewControllerAnimated:YES];
                    
                    return;
                }
            }
        }
    }
    else if ([fromVC isKindOfClass:[FNLoginVC class]])
    {
        [fromVC dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goMain
{
    [self goTabIndex:0];
}

- (void)goTabIndex:(NSInteger)index
{
    if ([self.navigationController isKindOfClass:[FNNavigationVC class]])
    {
        [(FNNavigationVC *)self.navigationController removeAllScreenShot];
        [[(FNNavigationVC *)self.navigationController bgView] removeFromSuperview];
    }
    
    [(FNNavigationVC *)self.navigationController removeAllScreenShot];
    NSObject *root = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if ([root isKindOfClass:[FNTabBarVC class]])
    {
        FNTabBarVC *tab = (FNTabBarVC *)root;
        
        UINavigationController *main = [tab selectedViewController];
        
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: main.viewControllers];
        
        NSInteger cnt = navigationArray.count;

        for (UIViewController *vc in main.viewControllers)
        {
            if(cnt == 1)
            {
                break;
            }
            [navigationArray removeLastObject];
            
            cnt--;
        }
        
        main.viewControllers = navigationArray;
        
        tab.selectedViewController = main;

        if ([main.topViewController isKindOfClass:[FNCartVC class]]||
            [main.topViewController isKindOfClass:[FNCateVC class]]||
            [main.topViewController isKindOfClass:[FNMyVC class]])
        {
            main.navigationBar.hidden = NO;
        }
        
        tab.tabSelectedIndex = index;
        
        [tab setSelectedIndex:index];
    }
}

static UIView *_moreView;

- (void)hiddenMore
{
    [_moreView removeFromSuperview];
}

- (void)goMore
{
    __weak __typeof(self) weakSelf = self;
    
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    
    _moreView.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_moreView];
    
    [_moreView addTarget:self action:@selector(hiddenMore)];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth-100, NAVIGATION_BAR_HEIGHT-15, 96, 166)];
    
    view.userInteractionEnabled = YES;
    
    [_moreView addSubview:view];
    
    view.image = [UIImage imageNamed:@"nav_more_bg"];
    
    NSArray *images = @[@"nav_more_msg",@"nav_more_home",@"nav_more_my"];
    
    NSArray *titles = @[@"消息",@"首页",@"我的"];
    
    NSUInteger index= 0 ;
    
    for (NSString *im in images)
    {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        
        but.frame = CGRectMake(0, 12 + index*48, 96, 48);
        
        [but setImage:[UIImage imageNamed:im] forState:UIControlStateNormal];
        
        [but setTitle:titles[index] forState:UIControlStateNormal];
        
        but.titleLabel.font = [UIFont fzltWithSize:15];
        
        [but setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 15)];

        [but setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
        
        but.tag = index;
        
        [but addSuperView:view ActionBlock:^(id sender) {

            [_moreView removeFromSuperview];

            switch ([(UIButton *)sender tag])
            {
                case 0:
                {
                    if (![FNLoginBO isLogin])
                    {
                        return ;
                    }

                    for (UIViewController *vc in weakSelf.navigationController.viewControllers)
                    {
                        if ([vc isKindOfClass:[FNMessageCenterVC class]])
                        {
                            [weakSelf.navigationController popToViewController:vc animated:YES];
                        
                            return;
                        }
                    }
                    
                    if (![weakSelf isKindOfClass:[FNMessageCenterVC class]])
                    {
                        FNMessageCenterVC *vc = [[FNMessageCenterVC alloc] init];
                        
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                }
                    break;
                case 1:
                {

                    [weakSelf goMain];
                }
                    break;
                case 2:
                {
                    if (![FNLoginBO isLogin])
                    {
                        return ;
                    }

                    [weakSelf goTabIndex:3];
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        index++;
    }
}

- (void)setNavigaitionBackItem
{
    if (isTianYi)
    {
        [FNNavigationBarItem setCustomLeftWithTarget:self image:[UIImage imageNamed:@"nav_back_nor"] action:@selector(goMain)];
        isTianYi = NO;
        
    }else
    {
     [FNNavigationBarItem setCustomLeftWithTarget:self image:[UIImage imageNamed:@"nav_back_nor"] action:@selector(goBack)];
    }

}

- (UIBarButtonItem *)setNavigaitionMoreItem
{
    return [FNNavigationBarItem setCustomRightWithTarget:self image:[UIImage imageNamed:@"nav_more_nor"] action:@selector(goMore)];
}

- (UIBarButtonItem *)setNavigaitionHelpItem
{
    return [FNNavigationBarItem setCustomRightWithTarget:self image:[UIImage imageNamed:@"help"] action:@selector(goHelp)];
}

- (UIBarButtonItem *)setNavigaitionSZTHelpItem
{
    return [FNNavigationBarItem setCustomRightWithTarget:self image:[UIImage imageNamed:@"help"] action:@selector(goSZTHelp)];

}
- (void)setNavigationRightItem
{

}

+ (void)load
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method viewDidLoaded = class_getInstanceMethod(self, @selector(viewDidLoaded));
        method_exchangeImplementations(viewDidLoad, viewDidLoaded);
        
        Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method viewWillAppeared = class_getInstanceMethod(self, @selector(viewWillAppeared:));
        method_exchangeImplementations(viewWillAppear, viewWillAppeared);
        
        Method viewWillDisappear = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method viewWillDisappeared = class_getInstanceMethod(self, @selector(viewWillDisappeared:));
        method_exchangeImplementations(viewWillDisappear, viewWillDisappeared);
        
        Method viewDidAppear = class_getInstanceMethod(self, @selector(viewDidAppear:));
        Method viewDidAppeared = class_getInstanceMethod(self, @selector(viewDidAppeared:));
        method_exchangeImplementations(viewDidAppear, viewDidAppeared);
        
        Method viewDidDisappear = class_getInstanceMethod(self, @selector(viewDidDisappear:));
        Method viewDidDisappeared = class_getInstanceMethod(self, @selector(viewDidDisappeared:));
        method_exchangeImplementations(viewDidDisappear, viewDidDisappeared);

        Method title = class_getInstanceMethod(self, @selector(setTitle:));
        Method titled = class_getInstanceMethod(self, @selector(setTitled:));
        method_exchangeImplementations(title, titled);
    });
}

- (void)viewWillAppeared:(BOOL)animated
{
    [self viewWillAppeared:animated];

    if ([self isKindOfClass:[FNScanVC class]] ||
        [self isKindOfClass:[FNWebVC class]] ||
        [self isKindOfClass:[FNMessageCenterVC class]] ||
        [self isKindOfClass:[FNHopeVC class]] ||
        [self isKindOfClass:[FNHebaoIntroVC class]] ||
        [self isKindOfClass:[FNMyBonusVC class]] ||
        [self isKindOfClass:[FNDetailVC class]] ||
        [self isKindOfClass:[FNCateProductListVC class]] ||
        [self isKindOfClass:[FNFillOrderVC class]] ||
        [self isKindOfClass:[FNPersonalVC class]] ||
        [self isKindOfClass:[FNManageAddressVC class]] ||
        [self isKindOfClass:[FNMyHelpVC class]] ||
        [self isKindOfClass:[FNMySetVC class]] ||
        [self isKindOfClass:[FNBonusRechargeVC class]] ||
        [self isKindOfClass:[FNVirfulOrderVC class]] ||
        [self isKindOfClass:[FNFillOrderVC class]]
        )
    {
        self.navigationController.tabBarController.tabBar.hidden = YES;
        
        return ;
    }
    
    if ([self isKindOfClass:[FNMainVC class]] ||
        [self isKindOfClass:[FNCartVC class]]||
        [self isKindOfClass:[FNCateVC class]]||
        [self isKindOfClass:[FNMyVC class]])
    {
        self.navigationController.tabBarController.tabBar.hidden = NO;
        
        return ;
    }
}

- (void)viewWillDisappeared:(BOOL)animated
{
    [self viewWillDisappeared:animated];
}

- (void)viewDidAppeared:(BOOL)animated
{
    [self viewDidAppeared:animated];

#if !TARGET_DEV
    [self injectDidAppear];
#endif
}

- (void)viewDidDisappeared:(BOOL)animated
{
    [self viewDidDisappeared:animated];

#if !TARGET_DEV
    [self injectDidDisappear];
#endif
}

- (void)viewDidLoaded
{
    [self viewDidLoaded];
    
    [self autoFitInsets];
    
}

- (void)setTitled:(NSString *)title
{
    [FNNavigationBarItem setCustomTitle:title target:self];
}

-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)endEditing
{
    [self.view endEditing:YES];
}

- (void)setTitleLogo
{
}

- (void)initNoNetView
{
    _noNetView = [[FNNoNetView alloc ]initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-NAVIGATION_BAR_HEIGHT)];
    
    [self.view addSubview:_noNetView];
    
    _noNetBar = [[FNNoNetBar alloc] init];
    
    [self.view addSubview:_noNetBar];
    
    _noNetView.hidden = YES;
    
    _noNetBar.hidden = YES;
}

- (void)showUnreach
{
    [self.view bringSubviewToFront:_noNetView];
    
    [self.view bringSubviewToFront:_noNetBar];
    
    _noNetView.hidden = NO;
    
    _noNetBar.hidden = NO;
}

- (void)hideUnreach
{
    [self.view sendSubviewToBack:_noNetView];
    
    [self.view sendSubviewToBack:_noNetBar];

    _noNetView.hidden = YES;
    
    _noNetBar.hidden = YES;
}

- (void)showTipWithResult:(id)result
{
    if(result)
    {
        [self.view makeToast:result[@"desc"]];
    }else
    {
        [self.view makeToast:@"加载失败,请重试"];
    }
}
 
- (void)shareWithText:(NSString *)text image:(id)image url:(NSString *)url title:(NSString *)title delegate:(id)delegate
{
    [FNStraddleService setStraddleType:FNStraddleTypeUMSocial];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    
    if ([image isKindOfClass:[NSString class]])
    {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:image];
    }
    else
    {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:nil];
    }
    
    [UMSocialData defaultData].extConfig.qqData.url = url;
    
    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    
    [UMSocialData defaultData].extConfig.qqData.title = title;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    
    [UMSocialSnsService presentSnsIconSheetView:delegate
                                         appKey:FN_UMENG_KEY
                                      shareText:text
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                       delegate:delegate];
}

- (void)pushToClazz:(Class)clazz animated:(BOOL)animated
{
    if (self.navigationController)
    {
        UIViewController *controller = [[clazz alloc] init];
        
        [self.navigationController pushViewController:controller animated:animated];
    }
}

- (void)pushToVC:(id)vc animated:(BOOL)animated
{
    if (self.navigationController)
    {
        UIViewController *controller = [[vc alloc] init];
        
        [self.navigationController pushViewController:controller animated:animated];
    }
}

- (void)goHelp
{
    FNWebVC *help = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"duihuan" ofType:@"html"]];
    
    help.title = @"中国电信积分兑换";
    help.isMoreItem = YES;
    [self.navigationController pushViewController:help animated:YES];
}

- (void)goSZTHelp
{
    FNWebVC *help = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"help" ofType:@"html"]];
    help.title = @"帮助中心";
    help.isMoreItem = NO;
    [self.navigationController pushViewController:help animated:YES];
}


#pragma mark - UBS

- (void)injectDidAppear
{
    NSString *page = [self pageEventID:YES];
    if (![page isEmpty])
    {
        [FNUBSManager pageStart:page];
    }
}

- (void)injectDidDisappear
{
    NSString *page = [self pageEventID:NO];
    if (![page isEmpty])
    {
        [FNUBSManager pageEnd:page];
    }
}

- (NSString *)pageEventID:(BOOL)isEvent
{
    NSDictionary *info = [self getInfoWithUBSPlist];
    
    NSString *className = NSStringFromClass([self class]);
    
    NSMutableString *name = [NSMutableString string];
    
    if (info[className][@"Page"])
    {
        [name appendFormat:@"%@_",info[className][@"Page"]];
        
        if ([className isEqualToString:@"FNDetailVC"])
        {
            [name appendFormat:@"%@_",[self getUBSWithProperty:@"productId"]];
        }
        else if ([className isEqualToString:@"FNAddNewAddressVC"])//plist 有值是因为只需在name后追加就可以了
        {
            [name appendFormat:@"%@_",[[self getUBSWithProperty:@"isEdit"] boolValue] ? @"编辑" : @"添加"];
        }
        else if([className isEqualToString:@"FNConfirmGetGoodsVC"]) //plist 是空的，因为这里需要处理
        {
            [name appendFormat:@"%@_",([[self getUBSWithProperty:@"state"] integerValue] == 1)  ? @"确认收货" : @"取消订单"];
        }

        [name appendFormat:@"%@",(isEvent ? @"Enter" : @"Leave")];

        NSLog(@"%@",name);
    }
    
    return name;
}

- (NSDictionary *)getInfoWithUBSPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FNUBS" ofType:@"plist"];
    
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:path];
    
    return info;
}

- (NSString *)getUBSWithProperty:(NSString *)property
{
    if ([property isEqualToString:@"productId"])
    {
        return [self valueForKeyPath:property];
    }
    else if ([property isEqualToString:@"isEdit"])
    {
        return [self valueForKeyPath:property];
    }
    
    return nil;
}

@end
