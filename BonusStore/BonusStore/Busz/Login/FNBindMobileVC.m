//
//  FNBindMobileVC.m
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBindMobileVC.h"

#import "FNLoginVC.h"

#import "FNLoginBO.h"

#import "FNCartBO.h"

@interface FNBindMobileVC ()<UITextFieldDelegate>
{
    FNLoginView * _quickLoginView;
    
    void (^FNGoMainBlock) (void);
    
    void (^FNGoSelectedVCBlock) (void);     //跳转到指定vc
    
    UIButton *_agreeBtn;
    
    dispatch_source_t _timer;
    
    BOOL _goToJFShareVC;
}

@property (nonatomic, strong) UIButton * shortCutBtn;

@property (nonatomic, strong) UIButton * normalBtn;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString * graphCodeId;

@end

@implementation FNBindMobileVC

- (void)viewDidDisappear:(BOOL)animated
{
    if (_timer && _goToJFShareVC != YES)
    {
        dispatch_cancel(_timer);
        
        _timer = nil;
    }
    _goToJFShareVC = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定手机号";
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(graphCodeChanged:) name:@"graphCodeChanged" object:nil];

    [self setNavigaitionBackItem];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    _isSelect = YES;
    
    
    UIImageView *_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, self.view.width-10, 50)];
    
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    _iconView.image = [UIImage imageNamed:@"bind_mobile_logo"];
    
    [self.view addSubview:_iconView];

    UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.y + _iconView.height, self.view.width-10, 30)];
    
    _titleLabel.text = @"为了您的账户安全\n请及时绑定手机号";
    
    _titleLabel.numberOfLines = 2;
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_titleLabel clearBackgroundWithFont:[UIFont fzltWithSize:12] textColor:MAIN_COLOR_GRAY_ALPHA];
    
    [_iconView addSubview:_titleLabel];
    
    [self createView];
    
  
}

- (void)graphCodeChanged:(NSNotification *)noti
{
    self.graphCodeId = noti.userInfo[@"graphCodeChanged"];
    
}

- (void)createView
{
    //快捷登录
    _quickLoginView = [[FNLoginView alloc]initWithFrame:CGRectMake(0,110,kScreenWidth, kScreenHeight - 30 - 20)];
    
    [_quickLoginView.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [_quickLoginView.getCodeBtn addTarget:self action:@selector(verifyCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_quickLoginView.loginBtn addTarget:self action:@selector(bindMobile) forControlEvents:UIControlEventTouchUpInside];
    
    _quickLoginView.codeTextField.delegate = self;
    
    _quickLoginView.loginBtn.enabled = false;
    
    [self.view addSubview:_quickLoginView];
    
    CGFloat codeY = CGRectGetMaxY(_quickLoginView.codeTextField.frame);
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _agreeBtn.frame = CGRectMake(35, codeY+15, 12, 12);
   
    [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_press"] forState:UIControlStateNormal];
    
    [_agreeBtn addTarget:self action:@selector(agreeButton) forControlEvents:UIControlEventTouchUpInside];

    [_quickLoginView addSubview:_agreeBtn];

    
    UILabel *_redLab = [[UILabel alloc]initWithFrame:CGRectMake(53,codeY+15, 84, 12)];
    
    _redLab.text = @"我已阅读并接受";
    
    _redLab.textColor = MAIN_COLOR_BLACK_ALPHA;
    
    _redLab.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
    
    [_quickLoginView addSubview:_redLab];

    
    UIButton *protocolBut = [UIButton buttonWithType:UIButtonTypeSystem];
    
    protocolBut.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
    
    [protocolBut setTitle:@"聚分享服务条款" forState:UIControlStateNormal];
    
    [protocolBut setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
    
    [protocolBut addTarget:self action:@selector(goProtocolBut) forControlEvents:UIControlEventTouchUpInside];
    
    [_quickLoginView addSubview:protocolBut];
    
    _quickLoginView.loginBtn.frame = CGRectMake(39, codeY+30+12, kScreenWidth -2*39,44);

    protocolBut.frame = CGRectMake(_redLab.x + _redLab.width + 1,codeY+15, _redLab.width, 12);

}

// 获取验证码
- (void)verifyCode
{
    
    if (_quickLoginView.telepNumTextField.text.length != 0)
    {
        if (![_quickLoginView.telepNumTextField.text isMobile])
        {
            [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
            
            return;
        }
        if(_quickLoginView.graphTextField.text.length==0)
        {
            [UIAlertView alertViewWithMessage:@"请输入正确的图形验证码"];
            return;
        }
        [FNLoadingView showInView:self.view];
        
        [[[FNLoginBO port02] withOutUserInfo]  getSMSWithMobile:_quickLoginView.telepNumTextField.text withId:self.graphCodeId value:_quickLoginView.graphTextField.text block:^(id result)
         {
            
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
    
    __block int timeout =120;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //接收事件
   _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){
            
            dispatch_source_cancel(_timer);//停止
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _quickLoginView.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
                
                [_quickLoginView.getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
                [_quickLoginView.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                
                _quickLoginView.getCodeBtn.userInteractionEnabled = YES;
                
                _quickLoginView.loginBtn.enabled = false;
                
                _quickLoginView.loginBtn.backgroundColor = UIColorWithRGB(167.0, 170.0, 166.0);
                
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
- (void)bindMobile
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
    else if (!_isSelect)
    {
        [UIAlertView alertViewWithMessage:@"请阅读服务条款"];
        
        return;
    }

    
    __weak __typeof(self) weakSelf = self;
    
    [FNLoadingView showInView:self.view];
    
    [[[FNLoginBO port02] withOutUserInfo] bindMobile:_quickLoginView.telepNumTextField.text captcha:_quickLoginView.codeTextField.text block:^(id result) {
        
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
    if (FNGoMainBlock)
    {
        FNGoMainBlock();
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        [FNUserAccountArgs removeUserWechatAccountInfo];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _quickLoginView.codeTextField)
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

- (void)agreeButton
{
    _isSelect = !_isSelect;
    
    if (_isSelect == YES) {
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_press"] forState:UIControlStateNormal];
        
    }else
    {
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_normal"] forState:UIControlStateNormal];
    }
}

- (void)goProtocolBut
{
    FNWebVC * web = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"regservice" ofType:@"html"]];
    
    web.title = @"聚分享服务条款";
    
    _goToJFShareVC = YES;
    
    [self.navigationController pushViewController:web animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"graphCodeChanged" object:nil];
}

@end
