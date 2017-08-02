//
//  FNForgetPassVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNForgetPassVC.h"
#import "FNLoginBO.h"

@interface FNForgetPassVC ()<UITextFieldDelegate>
{
    FNForgetPassView *_forgetView;
    
    dispatch_source_t _timer;
    
    BOOL _timeState;
    BOOL _isUnRegistered;
}

@property (nonatomic, assign)BOOL isSelected;
@property (nonatomic,copy)NSString *graphCodeId;
@end

@implementation FNForgetPassVC

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_timer)
    {
        dispatch_cancel(_timer);
        _timer = nil;
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(graphCodeChanged:) name:@"graphCodeChanged" object:nil];

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [self setNavigaitionBackItem];
    
    _isSelected = YES;
    
    [self registerAndCancelNotification:YES];

    _forgetView = [[FNForgetPassView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _forgetView.nePassText.secureTextEntry = YES;
    _forgetView.number.delegate = self;
    _forgetView.getCodeText.delegate = self;
    _forgetView.nePassText.delegate = self;

    
    [_forgetView.getCodeBtn addTarget:self action:@selector(verifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_forgetView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
    
    [_forgetView.eyeBtn addTarget:self action:@selector(eyeButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_forgetView.resetBtn addTarget:self action:@selector(confirmReset) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_forgetView];
    
    [self autofitNoNet:[FNReachability isReach]];
}

- (void)graphCodeChanged:(NSNotification *)noti
{
    self.graphCodeId = noti.userInfo[@"graphCodeChanged"];
    
}
- (void)verifyCode
{
    if (![_forgetView.number.text isMobile])
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
        
        return;
    }
    
    
    [[FNLoginBO port02] isRegisterWithMobile:_forgetView.number.text block:^(id result) {
        
        //200 means user has been in db.
        
        if ([result[@"code"] integerValue] == 200)
        {
            if ([result[@"value"] boolValue])
            {
                _forgetView.getCodeBtn.layer.borderColor =MAIN_COLOR_RED_BUTTON.CGColor;
                [_forgetView.getCodeBtn setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
                _forgetView.getCodeBtn.enabled = true;
                [[[FNLoginBO port02] withOutUserInfo] getSMSWithMobile:_forgetView.number.text withId:self.graphCodeId value:_forgetView.graphCode.text block:^(id result){
                    
                    if ([result[@"code"] integerValue] == 200)
                    {
                        
                        [self getCode];
                        
                    }else
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
                    
                }];
            }
            else
            {
                _isUnRegistered = YES;
                [UIAlertView alertViewWithMessage:@"该用户未注册，请先注册"];
                _forgetView.getCodeBtn.layer.borderColor =[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
                [_forgetView.getCodeBtn setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
                _forgetView.getCodeBtn.enabled = false;
                
                _forgetView.resetBtn.backgroundColor =[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1];
                [_forgetView.resetBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
                _forgetView.resetBtn.enabled = false;
                
            }

            
        }
    }];

    
}
- (void)getCode
{
    __block int timeout = 120; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _forgetView.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
                
                [_forgetView.getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
                
                [_forgetView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                
                _forgetView.getCodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 354;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_forgetView.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                _forgetView.getCodeBtn.layer.borderColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
                [_forgetView.getCodeBtn setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
                
                _forgetView.getCodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
        }
        
    });
    
    dispatch_resume(_timer);
}

- (void)eyeButton
{
    _isSelected = !_isSelected;
    
    if (_isSelected == YES) {
        [_forgetView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
        
        _forgetView.nePassText.secureTextEntry = YES;
        
    }else
    {
        [_forgetView.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-icon"] forState:UIControlStateNormal];
        
        _forgetView.nePassText.secureTextEntry = NO;
    }
}

- (void)confirmReset
{
    if (![_forgetView.number.text isMobile])
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
        
        return;
    }
    else if (_forgetView.nePassText.text.length == 0)
    {
        [UIAlertView alertViewWithMessage:@"请输入新密码"];
        
        return;
    }
    else if (_forgetView.getCodeText.text.length == 0)
    {
        [UIAlertView alertViewWithMessage:@"请输入验证码"];
        
        return;
    }
    
    [[FNLoginBO port02] resetPwdWithMobile:_forgetView.number.text pwd:_forgetView.nePassText.text captcha:_forgetView.getCodeText.text block:^(id result) {
       
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
        
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"修改成功" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } otherTitle:nil];
    
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        UIReframeWithY(_forgetView, 0);
    }
    else
    {
        UIReframeWithY(_forgetView, 50);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSInteger num = textField.text.length+string.length;
    
    if (textField == _forgetView.number && num ==0)
    {
        _forgetView.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_BUTTON.CGColor;
        
        [_forgetView.getCodeBtn setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
        
        [_forgetView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _forgetView.getCodeBtn.enabled = true;
        
        _forgetView.resetBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
        
        [_forgetView.resetBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        
        _forgetView.resetBtn.enabled = true;
        
        return YES;
    }
    if (_isUnRegistered == YES && textField == _forgetView.number && _forgetView.number.text.length == 0)
    {
        _forgetView.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_BUTTON.CGColor;
        
        [_forgetView.getCodeBtn setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
        
        [_forgetView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _forgetView.getCodeBtn.enabled = true;
        
        _forgetView.resetBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
        
        [_forgetView.resetBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        
        _forgetView.resetBtn.enabled = true;
        _isUnRegistered = NO;

    }
    
    if (textField == _forgetView.number && num >11 )
    {
        return NO;
    }
    
    if (textField == _forgetView.getCodeText && num > 4)
    {
        return NO;
    }
    
    if (textField == _forgetView.nePassText && num >16)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    
    if (_isUnRegistered == YES && textField == _forgetView.number && _forgetView.number.text.length == 0)
    {
        _forgetView.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_BUTTON.CGColor;
        
        [_forgetView.getCodeBtn setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
        
        [_forgetView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _forgetView.getCodeBtn.enabled = true;
        
        _forgetView.resetBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
        
        [_forgetView.resetBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        
        _forgetView.resetBtn.enabled = true;
        _isUnRegistered = NO;
    }

    return YES;
}

- (void)dealloc
{
    [self registerAndCancelNotification:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"graphCodeChanged" object:nil];

}

@end
