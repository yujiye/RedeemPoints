//
//  FNAlterPassWordVC.m
//  BonusStore
//
//  Created by sugarkawhi on 16/4/10.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNAlterPassWordVC.h"

#import "FNHeader.h"

#import "UIView+Toast.h"

#import "FNMyBO.h"

#import "FNLoginBO.h"

@interface FNAlterPassWordVC ()

{
    FNAlterPassword * pass;
    
    dispatch_source_t _timer;
}

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic,copy)NSString *graphCodeId;
@end

@implementation FNAlterPassWordVC

- (void)viewDidDisappear:(BOOL)animated
{
    if (_timer)
    {
        dispatch_cancel(_timer);
        _timer = nil;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(graphCodeChanged:) name:@"graphCodeChanged" object:nil];
    
    _isSelect = YES;
    
    [self setNavigaitionBackItem];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    pass = [[FNAlterPassword alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self.view addSubview:pass];
    
    [pass.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
    
    [pass.eyeBtn addTarget:self action:@selector(eyeButton) forControlEvents:UIControlEventTouchUpInside];
    
    [pass.confirmBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    
    [pass.getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
    pass.number.text = FNUserAccountInfo[@"loginName"];
}

- (void)graphCodeChanged:(NSNotification *)noti
{
    self.graphCodeId = noti.userInfo[@"graphCodeChanged"];
    
}

- (void)getCode
{
    
    [[[FNLoginBO port02] withOutUserInfo]  getSMSWithMobile:pass.number.text withId:self.graphCodeId value:pass.graphCodeField.text  block:^(id result) {
        if (!result)
        {
            return ;
        }
        
        if ([result[@"code"] integerValue] == 200)
        {
            [self getCodes];
        }
        else
        {
            [UIAlertView alertViewWithMessage:result[@"desc"]];
        }
        
    }];
    
    
}

- (void)getCodes
{
    __block int timeout=120;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                pass.getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
                
                [pass.getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
                
                [pass.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                
                pass.getCodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 354;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [pass.getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                
                pass.getCodeBtn.layer.borderColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
                [pass.getCodeBtn setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
                
                pass.getCodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}

- (void)eyeButton
{
    NSString * text = pass.freshPassWord.text;
    
    _isSelect = !_isSelect;
    if (_isSelect == YES)
    {
        [pass.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-02"] forState:UIControlStateNormal];
        
        pass.freshPassWord.secureTextEntry = YES;
    }
    else
    {
        [pass.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eye-icon"] forState:UIControlStateNormal];
        
        pass.freshPassWord.secureTextEntry = NO;
        
        pass.freshPassWord.text = @" ";
        
        pass.freshPassWord.text = text;
    }
    
}

- (void)update
{
    if (![pass.number.text isMobile])
    {
        [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
        
        return;
    }
    else if (pass.freshPassWord.text.length < 6)
    {
        [UIAlertView alertViewWithMessage:@"密码不得小于6位"];
        
        return;
    }
    else if (!pass.code.text.length)
    {
        [UIAlertView alertViewWithMessage:@"请输入验证码"];
        
        return;
    }
    
    [[FNMyBO port02] updateUserWithMobile:pass.number.text pwd:pass.freshPassWord.text captcha:pass.code.text block:^(id reResult) {
        
        if ([reResult[@"code"] integerValue] == 200)
        {
            [self.view makeToast:@"修改密码成功"];
            [self goBack];
            
            [FNUserAccountArgs removeUserAccountInfo];
            
            isIgnore = YES;

            [FNLoginBO  loginAuthFail];
//             if (![FNLoginBO isLogin])
//             {
//                 return ;
//             }

            
            /*
            [FNLoadingView showInView:self.view];
            
            [[[FNLoginBO port02] withOutUserInfo] loginWithName:pass.number.text pwd:pass.freshPassWord.text block:^(id result) {
                
                [FNLoadingView hideFromView:self.view];
                
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:FNUserAccountInfo];
                
                [info setObject:result[@"token"] forKey:@"token"];
                [info setObject:result[@"ppInfo"] forKey:@"ppInfo"];
                [info setObject:result[@"curTime"] forKey:@"curTime"];
                
                [FNUserAccountArgs setUserAccountInfo:info];
             
            }];
             */
            
        }
        else
        {
            if(reResult)
            {
                [UIAlertView alertViewWithMessage:reResult[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"graphCodeChanged" object:nil ];
}
@end
