//
//  FNMainHeaderReusableView.m
//  BonusStore
//
//  Created by Nemo on 16/4/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainHeaderReusableView.h"
#import "FNLoginBO.h"
#import "FNSearchVC.h"
@interface FNMainHeaderReusableView ()
{
    
    FNSelectedIndex _block;
}

@end

@implementation FNMainHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
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
        
        _focusView = [[FNFocusView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 178*kscale)];
        [self addSubview:_focusView];
 
        _configView = [[FNMainConfigHeaderView alloc]initWithFrame:CGRectMake(0, _focusView.height, kScreenWidth, 173+135*kscale)];
        [self addSubview:_configView];
        
        _productHeaderView = [[FNMainProductHeaderView alloc]initWithFrame:CGRectMake(_configView.x, _configView.y+_configView.height+8,_configView.width , 367*kscale)];
        [self addSubview:_productHeaderView];
        UIView * bgview = [[UIView alloc]initWithFrame:CGRectMake(0, _productHeaderView.y+_productHeaderView.height, kScreenWidth, 40)];
        bgview.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:bgview];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-60)/2,0,60, 40)];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = UIColorWith0xRGB(0xFF7F7F);
        lable.text = @"积分特惠";
        lable.textAlignment = NSTextAlignmentCenter;
        [bgview addSubview:lable];
        
        UIImageView * leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lable.frame)-21, 18, 21, 4)];
        leftImg.image = [UIImage imageNamed:@"main_rightImg"];
        [bgview addSubview:leftImg];
        
        UIImageView * rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame), 18, 21, 4)];
        rightImg.image = [UIImage imageNamed:@"main_leftImg"];
        [bgview addSubview:rightImg];
        
    }
    return self;
}

- (void)selectedIndex:(UIGestureRecognizer *)sender
{
    _block(sender.view.tag);
}

- (void)goItemIndexBlock:(FNSelectedIndex)block
{
    _block = block;
}

- (void)goMessage
{
    if (![FNLoginBO isLogin])
    {
        return;
    }
    
    [FNMessageNoti touchOff];
    
    FNMessageCenterVC *vc = [[FNMessageCenterVC alloc] init];
    
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (void)goScan
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
    {
        [UIAlertView alertViewWithMessage:@"您的相机功能好像有点问题哦～\n去\"设置>隐私>相机\"开启一下"];
    }
    else if(status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined)
    {
        FNScanVC *vc = [[FNScanVC alloc] init];
        
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)goSearchVC
{
    FNSearchVC *searchVC = [[FNSearchVC alloc]init];
    
    [[self viewController].navigationController pushViewController:searchVC animated:YES];
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
