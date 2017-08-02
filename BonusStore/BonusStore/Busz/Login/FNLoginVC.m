//
//  FNLoginVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNLoginVC.h"

#import "FNLoginBO.h"

#import "FNCartBO.h"

//#import "FNFingerTouch.h"

@interface FNLoginVC ()<UITextFieldDelegate>
{
    FNLoginView * _quickLoginView;
    
    FNNomLoginView * _normalLoginView;
    
    void (^FNGoMainBlock) (void);
    
    void (^FNGoSelectedVCBlock) (void);     //跳转到指定vc
    
    dispatch_source_t _timer;
    
}

@property (nonatomic, strong) UIButton * shortCutBtn;

@property (nonatomic, strong) UIButton * normalBtn;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy)NSString * graphCodeId;

@end

@implementation FNLoginVC

- (void)viewDidDisappear:(BOOL)animated
{
    if (_timer )
    {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    [self getCodeBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    FNLoginIsScan = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //指纹识别
//    [FNFingerTouch authenticateUser];
    self.title = @"登录";
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(graphCodeChanged:) name:@"graphCodeChanged" object:nil];

    [self setNavigaitionBackItem];
    
    [FNNavigationBarItem setNavgationRightItemWithTitle:@"注册" target:self action:@selector(goRegister)];

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    _isSelect = YES;

    
    [self creatButton];
    
    [self createView];
    
    [self registerAndCancelNotification:YES];
    
    
    CALayer *line = [CALayer layerWithFrame:CGRectMake(30, kWindowHeight-180, kWindowWidth-60, 1)];
    
    [self.view.layer addSublayer:line];
    
    
    UILabel *wechatTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kWindowHeight-190, 150, 20)];
    
    wechatTipLabel.text = @" 使用第三方账号登录 ";
    
    wechatTipLabel.font = [UIFont fzltWithSize:12];

    CGSize size = [wechatTipLabel.text boundingRectWithSize:CGSizeMake(kWindowWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
    
    UIReframeWithW(wechatTipLabel, size.width);
    
    wechatTipLabel.textAlignment = NSTextAlignmentCenter;
    
    wechatTipLabel.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [wechatTipLabel setHorizonCenterWithSuperView:self.view];
    
    [self.view addSubview:wechatTipLabel];
    
    
    UIButton *wechatBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    wechatBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 53, 53);
    
    [wechatBut setBackgroundImage:[UIImage imageNamed:@"vendor_wechat"] forState:UIControlStateNormal];
    
    __weak __typeof(self) weakSelf = self;
    
    [wechatBut addSuperView:self.view ActionBlock:^(id sender) {
        
        FNStraddleServiceType = FNStraddleTypeUMSocial;
        
        UMSocialSnsPlatform *platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        
        platform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:platform.platformName];
                
                if (snsAccount == nil)
                {
                    [self.view makeToast:@"用户信息获取失败，请更换登录方式"];
                    return ;
                }
                [FNUserAccountArgs setUserWechatAccountInfo:@{@"openId":snsAccount.openId,
                                                              @"unionId":snsAccount.unionId,
                                                              @"accessToken":snsAccount.accessToken,
                                                              @"refreshToken":snsAccount.refreshToken,
                                                              @"iconURL":snsAccount.iconURL,
                                                              @"usid":snsAccount.usid,
                                                              @"userName":snsAccount.userName,
                                                              @"currentDate":[NSDate date]}];
                
                [[[FNLoginBO port02] withOutUserInfo] validateWithUnionId:snsAccount.unionId openId:snsAccount.openId token:snsAccount.accessToken block:^(id result) {
                   
                    if ([result[@"code"] integerValue] == 200)
                    {
                        
                        if (![NSString isEmptyString:result[@"failCode"]] &&[result[@"failCode"] integerValue] == 1003) //用户名不存在
                        {
                            FNBindMobileVC *vc = [[FNBindMobileVC alloc] init];
                            
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                            
                        }else if( ![NSString isEmptyString:result[@"failCode"]] && ([result[@"failCode"] integerValue]== 1999 ||[result[@"failCode"] integerValue]== 3002 ))
                        {// 1999 黑名单  3002验证参数错误
                            
                            [UIAlertView alertViewWithMessage:result[@"desc"]];
                            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:result[@"desc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                                [FNLoginBO loginAuthFail];
                            } otherTitle: nil];
                            return ;
                        }
                        else
                        {
                            [weakSelf goBack];
                        }
                    }
                    else
                    {
                        [UIAlertView alertViewWithMessage:@"验证失效，请重新登录"];
                    }
                }];
            }
        });
    }];
    
    [wechatBut setHorizonCenterWithSuperView:self.view];
    
}

- (void)graphCodeChanged:(NSNotification *)noti
{
    self.graphCodeId = noti.userInfo[@"graphCodeChanged"];
    
}

- (void)creatButton
{
    _shortCutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _shortCutBtn.frame = CGRectMake(29, 20, 65, 30);
    
    _shortCutBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:16];
    
    [_shortCutBtn setTitle:@"快捷登录" forState:UIControlStateNormal];
    
    [_shortCutBtn setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal ];
    
    [self.view addSubview:_shortCutBtn];
    
    [_shortCutBtn addTarget:self action:@selector(exchangeToQuickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _normalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _normalBtn.frame = CGRectMake(kScreenWidth - 29-65, 20, 65, 30);
    
    _normalBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:16];
    
    //普通登录
    [_normalBtn setTitle:@"普通登录" forState:UIControlStateNormal];
    
    [_normalBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal ];
    
    [self.view addSubview:_normalBtn];
  
    [_normalBtn addTarget:self action:@selector(exchangeToNormalLogin) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createView
{
    NSDictionary * dict =  [FNUserAccountArgs getUserAccount];
    //快捷登录
    _quickLoginView = [[FNLoginView alloc]initWithFrame:CGRectMake(0,80,kScreenWidth, kScreenHeight - 30 - 20)];
   
   
    [_quickLoginView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [_quickLoginView.getCodeBtn addTarget:self action:@selector(verifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_quickLoginView.loginBtn addTarget:self action:@selector(quickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _quickLoginView.loginBtn.enabled = false;
    
    [self.view addSubview:_quickLoginView];
    
    //普通登录
    _normalLoginView = [[FNNomLoginView alloc]initWithFrame:CGRectMake(0,80,kScreenWidth, kScreenHeight - 30 - 20)];
    
    //如果授权失败，不显示scan label，fnlogin
    if (!self.isAuthFail && FNLoginIsScan)
    {
        _quickLoginView.scanLabel.hidden = NO;
        _normalLoginView.scanLabel.hidden = NO;
    }
    
    _normalLoginView.passWordText.secureTextEntry = YES;
    
    [_normalLoginView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
    [_normalLoginView.eyeBtn addTarget:self action:@selector(eyeButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_normalLoginView.loginBtn addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];

    [_normalLoginView.forgetPassBtn addTarget:self action:@selector(forgetBtn) forControlEvents: UIControlEventTouchUpInside ];
    
    [self.view addSubview:_normalLoginView];
    
    _quickLoginView.hidden = NO;
    
    _normalLoginView.hidden = YES;

    if ([NSString isEmptyString:dict[@"mobile"]])
    {
        _quickLoginView.telepNumTextField.text = nil;
        
        _normalLoginView.telepNumTextField.text = nil;
    }
    else
    {
        _quickLoginView.telepNumTextField.text = dict[@"mobile"];
        
        _normalLoginView.telepNumTextField.text = dict[@"mobile"];
        
        _normalLoginView.loginBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
    }
    
    
    [self autofitNoNet:[FNReachability isReach]];
}

#pragma  mark -快捷登录
- (void)exchangeToQuickLogin
{
    _quickLoginView.hidden = NO;
    
    [_shortCutBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    
    [_normalBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    
    _normalLoginView .hidden = YES;

}

- (void)verifyCode
{
    if (_quickLoginView.telepNumTextField.text.length != 0)
    {
        if (![_quickLoginView.telepNumTextField.text isMobile])
        {
            [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
            
            return;
        }
        
        if(_quickLoginView.graphTextField.text.length ==0)
        {
            [UIAlertView alertViewWithMessage:@"请输入正确的图形验证码"];
            
            return;
        }
        
        [FNLoadingView showInView:self.view];
        
        [[[FNLoginBO port02] withOutUserInfo] getSMSWithMobile:_quickLoginView.telepNumTextField.text withId:self.graphCodeId value:_quickLoginView.graphTextField.text block:^(id result) {
            
            [FNLoadingView hideFromView:self.view];
            
            if (!result)
            {
                return ;
            }
            
            if ([result[@"code"] integerValue] == 200)
            {
                [self getCode];
                
                _quickLoginView.loginBtn.enabled = true;
                
                _quickLoginView.loginBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
            }
            else
            {
                if(result)
                {
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
                
                _quickLoginView.loginBtn.enabled = false;
                
                _quickLoginView.loginBtn.backgroundColor = UIColorWithRGB(167.0, 170.0, 166.0);
            }

        }];
        
    }
    else
    {
        [UIAlertView alertViewWithMessage:@"请输入手机号"];
        
        _quickLoginView.loginBtn.enabled = false;
        
        _quickLoginView.loginBtn.backgroundColor = UIColorWithRGB(167.0, 170.0, 166.0);
    }

}

- (void)getCode
{
    //NSTimer
    
    __block int timeout=120;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //接收事件
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){
            
            dispatch_source_cancel(_timer);//停止
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [self getCodeBtn];
                
            });
            
        }else{
            
            int seconds = timeout % 354;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_quickLoginView.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                _quickLoginView.getCodeBtn.layer.borderColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
                
                [_quickLoginView.getCodeBtn setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
                
                _quickLoginView.getCodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
}
- (void)quickLogin
{
    if (_quickLoginView.loginBtn.enabled ==false)
    {
        _quickLoginView.loginBtn.enabled = true;
    }
    
    if (![_quickLoginView.telepNumTextField.text isMobile])
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
        
        return;
    }
    else if (_quickLoginView.codeTextField.text.length == 0)
    {
        [UIAlertView alertViewWithMessage:@"请输入验证码"];

        return;
    }

    __weak __typeof(self) weakSelf = self;
    
    [FNLoadingView showInView:self.view];
    
    [[[FNLoginBO port02] withOutUserInfo] loginWithMobile:_quickLoginView.telepNumTextField.text sms:_quickLoginView.codeTextField.text block:^(id result) {
        
        [FNLoadingView hideFromView:self.view];
        
        if ([result[@"code"] integerValue] != 200)
        {
            if(result)
            {
                [self.view makeToast:result[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
            
            return ;
        }
        
        if (FNGoSelectedVCBlock)
        {
            FNGoSelectedVCBlock();
        }
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    }];
}

- (void)normalLogin
{
    
    if (![_normalLoginView.telepNumTextField.text isMobile])
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
        
        return;
    }
    else if (_normalLoginView.passWordText.text.length == 0)
    {
        [UIAlertView alertViewWithMessage:@"请输入密码"];
        
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    [FNLoadingView showInView:self.view];

    [[[FNLoginBO port02] withOutUserInfo] isRegisterWithMobile:_normalLoginView.telepNumTextField.text block:^(id result) {
        [FNLoadingView hideFromView:self.view];
        if ([result[@"code"] integerValue] == 200)
        {
            if ([result[@"value"] boolValue])
            {
                [FNLoadingView showInView:self.view];
                [[[FNLoginBO port02] withOutUserInfo] loginWithName:_normalLoginView.telepNumTextField.text pwd:_normalLoginView.passWordText.text block:^(id result) {
                    
                    [FNLoadingView hideFromView:self.view];
                    
                    if ([result[@"code"] integerValue] != 200)
                    {
                        if(result)
                        {
                            [self.view makeToast:result[@"desc"]];
                        }else
                        {
                            [self.view makeToast:@"加载失败,请重试"];
                        }
                        
                        return ;
                    }
                    
                    if (FNGoSelectedVCBlock)
                    {
                        FNGoSelectedVCBlock();
                    }

                    if ([self.navigationController.viewControllers count] == 2)
                    {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            
                            //如果被踢之后，两次账号不相同，则返回到主界面
                            //如果不管账号是否相同都回到首页，只留一句就行:goTabIndex
                            
                            if (!FNUserAccountIsSameToLastTime && FNUserAccountIsAuthFail)
                            {
                                FNUserAccountIsAuthFail = NO;
                                
                                [weakSelf goTabIndex:0];
                            }
                        }];
                    }
                }];
                
            }
            else
            {
                [UIAlertView alertViewWithMessage:@"该用户未注册，请先注册"];
            }
        }
        else
        {
             [FNLoadingView hideFromView:self.view];
            if(result)
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];
            }
            else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
        }
    }];
}

#pragma mark - 普通登录
- (void)exchangeToNormalLogin
{
    _quickLoginView.hidden = YES;
    
    _normalLoginView.hidden = NO;
    
    [_shortCutBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    
    [_normalBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
}

#pragma  mark - 普通登录  --忘记密码
- (void)forgetBtn
{
    FNForgetPassVC * forget = [[FNForgetPassVC alloc]init];
    
    [self.navigationController pushViewController:forget animated:YES];
}

#pragma mark - 注册
- (void)goRegister
{
    FNRegisterVC * registerVC = [[FNRegisterVC alloc]init];
    

    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - 普通登录  --明(密)文
- (void)eyeButton
{
    NSString * text = _normalLoginView.passWordText.text;
    
    _isSelect = !_isSelect;
    
    if (_isSelect == YES) {
        
        [_normalLoginView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
        
        _normalLoginView.passWordText.secureTextEntry = YES;
    }else
    {
        [_normalLoginView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-icon"] forState:UIControlStateNormal];
        
        _normalLoginView.passWordText.secureTextEntry = NO;
        
        _normalLoginView.passWordText.text = @" ";
        
        _normalLoginView.passWordText.text = text;
    }
    
}

#pragma maek - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * currentStr = [textField.text stringByReplacingCharactersInRange:range withString:string ];
    if (currentStr.length>11)
    {
        return false;
    }
    return true;
}

- (void)goBack
{
    //如果授权失败，则把用户信息清除，否则不做处理
    if (self.isAuthFail)
    {
        [self goTabIndex:0];
        
        [FNUserAccountArgs removeUserAccountInfo];
    }
    
    FNUserAccountIsAuthFail = NO;

    if (FNLoginIsScan == YES)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (FNGoMainBlock)
    {
        FNGoMainBlock();
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _quickLoginView.codeTextField || textField == _normalLoginView.passWordText)
    {
        
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
    
}

- (void)goMainWithBlock:(void (^) (void))block
{
    FNGoMainBlock = nil;
    
    FNGoMainBlock = block;
}

- (void)goSelectedVCWithBlock:(void (^) (void))block
{
    FNGoSelectedVCBlock = nil;
    
    FNGoSelectedVCBlock = block;
}

- (void)getCodeBtn
{
    _quickLoginView.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
    
    [_quickLoginView.getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    [_quickLoginView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    
    _quickLoginView.getCodeBtn.userInteractionEnabled = YES;
    
    _quickLoginView.loginBtn.enabled = false;
    
    _quickLoginView.loginBtn.backgroundColor = UIColorWithRGB(167.0, 170.0, 166.0);
}

- (void)netChanged:(NSNotification *)noti
{
    if ([noti.userInfo[@"AFNetworkingReachabilityNotificationStatusItem"] integerValue] == AFNetworkReachabilityStatusNotReachable)
    {
        [self autofitNoNet:NO];
    }
    else
    {
        [self autofitNoNet:YES];
    }
}

- (void)registerAndCancelNotification:(BOOL)isReg
{
    if (isReg)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
}

- (void)autofitNoNet:(BOOL)isNet
{
    if (isNet)
    {
        UIReframeWithY(_normalLoginView, 80);
        UIReframeWithY(_quickLoginView, 80);
        UIReframeWithY(_shortCutBtn, 20);
        UIReframeWithY(_normalBtn, 20);
    }
    else
    {
        UIReframeWithY(_normalLoginView, 130);
        UIReframeWithY(_quickLoginView, 130);
        UIReframeWithY(_shortCutBtn, 70);
        UIReframeWithY(_normalBtn, 70);
    }
}

- (void)dealloc
{
    FNLoginIsScan = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"graphCodeChanged" object:nil];
    [self registerAndCancelNotification:NO];
}

@end
