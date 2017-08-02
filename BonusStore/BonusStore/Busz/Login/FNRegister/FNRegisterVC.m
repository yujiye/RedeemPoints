//
//  FNRegisterVC.m
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNRegisterVC.h"
#import "FNLoginBO.h"

@interface FNRegisterVC ()<UITextFieldDelegate>
{
    FNRegisterView *_registerView;
    
    dispatch_source_t _timer;
    
    BOOL _goToJFShareVC;
}

@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, assign)BOOL isSelectedEyeBtn;

@property (nonatomic, copy)NSString * graphCodeId;

@end

@implementation FNRegisterVC

- (void)viewDidDisappear:(BOOL)animated
{
 
    if (_timer && _goToJFShareVC !=YES)
    {
        dispatch_cancel(_timer);
        _timer = nil;
        
    }
    _goToJFShareVC = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.tabBarController.tabBar .hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"注册";
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(graphCodeChanged:) name:@"graphCodeChanged" object:nil];

    _isSelected = YES;
    
    _isSelectedEyeBtn = YES;
    
    [self setNavigaitionBackItem];
    
    [FNNavigationBarItem setNavgationRightItemWithTitle:@"登录" target:self action:@selector(goLogin)];
    
    [self registerAndCancelNotification:YES];

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    
    _registerView.numberText.delegate = self;
    
    _registerView = [[FNRegisterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _registerView.passText.secureTextEntry = YES;
    
    [_registerView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
    
    [_registerView.agreeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_press"] forState:UIControlStateNormal];
    //获取验证码
    [_registerView.getCodeBtn addTarget:self action:@selector(verifyCode) forControlEvents:UIControlEventTouchUpInside];
    //明文密文切换
    [_registerView.eyeBtn addTarget:self action:@selector(eyeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_registerView.agreeBtn addTarget:self action:@selector(agreeButton) forControlEvents:UIControlEventTouchUpInside];
    //注册
    [_registerView.registerBtn addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    //聚分享条款
    [_registerView.jsBtn addTarget:self action:@selector(jsButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_registerView];
    
    [self autofitNoNet:[FNReachability isReach]];
}
- (void)graphCodeChanged:(NSNotification *)noti
{
    self.graphCodeId = noti.userInfo[@"graphCodeChanged"];
    
}
- (void)verifyCode
{
    if (_registerView.registerBtn.enabled == false)
    {
        _registerView.registerBtn.enabled = true;
    }
    
    if (![_registerView.numberText.text isMobile])
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
        
        _registerView.getCodeBtn.layer.borderColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
        
        [_registerView.getCodeBtn setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
        
        [_registerView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _registerView.getCodeBtn.enabled = false;
        
        return;
    }
   
    
    if(_registerView.graphText.text.length == 0)
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的图形验证码"];
        
        return;
    }
    [FNLoadingView showInView:self.view];
    
    [[[FNLoginBO port02] withOutUserInfo] getSMSWithMobile:_registerView.numberText.text withId:self.graphCodeId value:_registerView.graphText.text block:^(id result) {
        
        [FNLoadingView hideFromView:self.view];
        
        
        if ([result[@"code"] integerValue] == 200)
        {
            
            [self getCode];
        }
        else
        {
            if(result)
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
        }
        
        
    }];
}

- (void)getCode
{
    __block int timeout = 120;
    
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _registerView.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
                
                [_registerView.getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
                
                [_registerView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                
                _registerView.getCodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 354;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_registerView.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                _registerView.getCodeBtn.layer.borderColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
                [_registerView.getCodeBtn setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
                
                _registerView.getCodeBtn.userInteractionEnabled = NO;
                
                _registerView.registerBtn.backgroundColor = MAIN_COLOR_RED_ALPHA;
                
                _registerView.registerBtn.enabled = YES;
                
                [_registerView.registerBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
}

- (void)eyeButton:(id)sender
{
    _isSelectedEyeBtn = !_isSelectedEyeBtn;
    NSString * text =  _registerView.passText.text;

    if (_isSelectedEyeBtn == YES) {
        
        [_registerView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
        
         _registerView.passText.secureTextEntry = YES;
        
    }else
    {
        [_registerView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-icon"] forState:UIControlStateNormal];
         _registerView.passText.secureTextEntry = NO;
         _registerView.passText.text = @" ";
         _registerView.passText.text = text;
    }
    
}

- (void)agreeButton
{
    _isSelected = !_isSelected;
    
    if (_isSelected == YES) {
        [_registerView.agreeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_press"] forState:UIControlStateNormal];

    }else
    {
        [_registerView.agreeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_normal"] forState:UIControlStateNormal];
    }
}

- (void)regist:(UIButton *)button
{
    if (![_registerView.numberText.text isMobile])
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
        
        return;
    }
    else if (_registerView.codeText.text.length == 0)
    {
        [UIAlertView alertViewWithMessage:@"请输入验证码"];
        
        return;
    }
    else if (_registerView.passText.text.length == 0)
    {
        [UIAlertView alertViewWithMessage:@"请输入密码"];
        
        return;
    }
    else if (_registerView.passText.text.length < 6 && _registerView.passText.text.length > 0)
    {
        [UIAlertView alertViewWithMessage:@"密码长度不得小于6位"];
        
        return;
    }
    else if (!_isSelected)
    {
        [UIAlertView alertViewWithMessage:@"请阅读服务条款"];
        
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
       
        [[FNLoginBO port02] registerWithMobile:_registerView.numberText.text pwd:_registerView.passText.text codeID:_registerView.codeText.text code:nil block:^(id result) {
            
            if ([result[@"code"] integerValue] == 200)
            {
                [UIAlertView alertViewWithMessage:@"注册成功"];
                
                // Auto login
                
                [[[FNLoginBO port02] withOutUserInfo] loginWithName:_registerView.numberText.text pwd:_registerView.passText.text block:^(id result) {
                   
                    if ([result[@"code"] integerValue] != 200)
                    {
                        if(result)
                        {
                            [UIAlertView alertViewWithMessage:result[@"desc"]];
                        }else
                        {
                            [self.view makeToast:@"加载失败,请重试"];
                        }
                        
                        return ;
                    }
                    
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            else
            {
                if(result)
                {
                    [UIAlertView alertViewWithMessage:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
            }
            
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        
    });
}

- (void)jsButton
{
    FNWebVC * web = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"regservice" ofType:@"html"]];
    
    web.title = @"聚分享服务条款";
    
    _goToJFShareVC = YES;
    
    [self.navigationController pushViewController:web animated:YES];
}
- (void)goLogin
{
    [self goBack];
    
    _registerView = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
        UIReframeWithY(_registerView, 0);
    }
    else
    {
        UIReframeWithY(_registerView, 50);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"graphCodeChanged" object:nil];

    [self registerAndCancelNotification:NO];
}

@end
