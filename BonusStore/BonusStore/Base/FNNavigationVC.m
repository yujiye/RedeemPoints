//
//  FNNavigationVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/10/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNNavigationVC.h"
#import "FNHeader.h"
#import "FNLoginBO.h"
#define OffsetFloat  0.5// 拉伸参数
#define OffetDistance 100// 最小回弹距离

@interface FNNavigationVC ()<UIGestureRecognizerDelegate>

@property(nonatomic,assign) CGPoint startPoint;

@property(nonatomic,strong) UIImageView *lastScreenShotView;

@property (nonatomic, assign) BOOL isMoving;

@end

@implementation FNNavigationVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.dragBack = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didHandlePanGesture:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test:) name:@"KRemoveTestPIc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenClick:) name:@"Notif_LoginTokenUpdated" object:nil];


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KRemoveTestPIc" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notif_LoginTokenUpdated" object:nil];

}

- (void)tokenClick:(NSNotification *)noti
{
    BOOL isShow = NO;
    NSMutableDictionary *infos = [NSMutableDictionary dictionaryWithDictionary:[FNUserAccountArgs getUserAccount]];
    if([NSString isEmptyString:[infos objectForKey:@"pwdEnc"]])
    {
        // 已经处理过了
        isShow = YES;
        [FNLoginBO loginAuthFail];
        
    }else
    {
        isShow = NO;
    }
    if (!isShow)
    {
        
        isIgnore = YES;
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"您的帐号已在其他设备登录，是否重新登录" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {
                
                [FNLoginBO loginAuthFail];
            }
            else
            {
                [FNLoginBO loginCancel];
                
            }
            
        } otherTitle:@"取消", nil];
        
    }
}


- (void)test:(NSNotification *)not
{
    NSInteger count = [[not.userInfo valueForKey:@"position"] integerValue];

    NSInteger picNum = self.screenShots.count;
    if (count == self.screenShots.count ) {//pop 到上一个控制器
        return ;
    }
    [self.screenShots removeObjectsInRange:NSMakeRange(count, picNum - count)];
    
}

- (NSMutableArray *)screenShots
{
    if (!_screenShots)
    {
        _screenShots = [NSMutableArray array];
    }
    return _screenShots;
}

-(void)initViews
{
    
    self.bgView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view.superview insertSubview:self.bgView belowSubview:self.view];
    
    self.bgView.hidden = NO;
    if (self.lastScreenShotView) [self.lastScreenShotView removeFromSuperview];
    UIImage *lastScreenShot = [self.screenShots lastObject];
    self.lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    self.lastScreenShotView.frame = (CGRect){-(kScreenWidth * OffsetFloat),0,kScreenWidth,kScreenHeight};
    self.lastScreenShotView.backgroundColor = MAIN_COLOR_RED_ALPHA;
    [self.bgView addSubview:self.lastScreenShotView];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        [self.screenShots addObject:[self capture]];
    }
    [super pushViewController:viewController animated:animated];
    
}

-(void)pushAnimation:(UIViewController *)viewController
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.2];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [super pushViewController:viewController animated:NO];
    [self.view.layer addAnimation:animation forKey:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (animated)
    {
        [self popAnimation];
        return nil;
    } else
    {
        return [super popViewControllerAnimated:animated];
    }
}
- (void) popAnimation
{
    if (self.viewControllers.count == 1)
    {
        return;
    }
    [self initViews];
    [UIView animateWithDuration:0.4 animations:^{
        [self doMoveViewWithX:kScreenWidth];
    } completion:^(BOOL finished) {
        [self completionPanBackAnimation];
    }];
}

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark ------------  UIPanGestureRecognizer -------

-(void)didHandlePanGesture:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 && !self.dragBack) return;
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
    
    CGFloat offsetX = touchPoint.x - self.startPoint.x;
    if(recoginzer.state == UIGestureRecognizerStateBegan)
    {
        [self initViews];
        
        _isMoving = YES;
        _startPoint = touchPoint;
        offsetX = 0;
    }
    
    if(recoginzer.state == UIGestureRecognizerStateEnded)
    {
        if (offsetX > OffetDistance)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:kScreenWidth];
            } completion:^(BOOL finished) {
                [self completionPanBackAnimation];
                
                self.isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:0];
            } completion:^(BOOL finished) {
                self.isMoving = NO;
                self.bgView.hidden = YES;
            }];
        }
        self.isMoving = NO;
    }
    if(recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self doMoveViewWithX:0];
        } completion:^(BOOL finished) {
            self.isMoving = NO;
            self.bgView.hidden = YES;
        }];
        self.isMoving = NO;
    }
    if (self.isMoving) {
        [self doMoveViewWithX:offsetX];
    }
    
}

-(void)doMoveViewWithX:(CGFloat)x
{
    x = x>kScreenWidth?kScreenWidth:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    self.lastScreenShotView.frame = (CGRect){-(kScreenWidth*OffsetFloat)+x*OffsetFloat,0,kScreenWidth,kScreenHeight};
}

-(void)completionPanBackAnimation
{
    [self.screenShots removeLastObject];
    [super popViewControllerAnimated:NO];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    self.view.frame = frame;
    self.bgView.hidden = YES;
}

- (void)removeAllScreenShot
{
    [self.screenShots removeAllObjects];
    self.bgView.hidden = YES;
}

- (void)removeLastScreenShot
{
    [self.screenShots removeLastObject];
    self.bgView.hidden = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        
        CGPoint tPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
        if (tPoint.x > 0)
        {
            for (UIViewController *viewController in self.viewControllers)
            {
                if ([viewController isKindOfClass:[FNPayVC class]]||
                    [viewController isKindOfClass:[FNSZPayFinishVC class]]
                    || [viewController isKindOfClass:[FNSZDetailVC class]]
                    ||[viewController isKindOfClass:[FNSZSuccessVC class]]
                    ||[viewController isKindOfClass:[FNBuyCouponVC class]]
                    ||[viewController isKindOfClass:[FNMyOrderVC class]]
                    ||[viewController isKindOfClass:[FNOrderConfVC class]]
                    ||[viewController isKindOfClass:[FNReChargeOrderVC class]]
                    ||[viewController isKindOfClass:[FNSZBLRechargeVC class]]
                    ||[viewController isKindOfClass:[FNSZBLSearchListVC class]]
                    ||[viewController isKindOfClass:[FNSZPayFinishVC class]])
                {
                    return NO;
                }
            }
        }
        else
        {
            for (UIView *view in self.visibleViewController.view.subviews)
            {
                
                if ([view isKindOfClass:[UITableView class]] )
                {
                    return NO;
                }
            }
        }
    }
    return YES;
}



@end
