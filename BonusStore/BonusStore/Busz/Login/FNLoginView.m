//
//  FNLoginView.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNLoginView.h"

@interface FNLoginView ()<UITextFieldDelegate>

@end

@implementation FNLoginView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _telepNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(29, 0, kScreenWidth - 2 * 29 ,50 )];
        _telepNumTextField.delegate = self;
        
        _telepNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _telepNumTextField.placeholder = @"请输入手机号";
        
        _telepNumTextField.leftView = paddingView1;
        
        _telepNumTextField.leftViewMode = UITextFieldViewModeAlways;
        
        _telepNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _telepNumTextField.backgroundColor = MAIN_COLOR_WHITE;
        
        _telepNumTextField.borderStyle = UITextBorderStyleNone;
        
        self.telepNumTextField.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:self.telepNumTextField];
        
        CGFloat telY = CGRectGetMaxY(_telepNumTextField.frame);
        
        UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        self.graphTextField = [[UITextField alloc]initWithFrame:CGRectMake(29,telY + 4 , kScreenWidth - 2 * 29, 50)];
        
        _graphTextField.backgroundColor = MAIN_COLOR_WHITE;
        
        _graphTextField.delegate = self;
        
        self.graphTextField.placeholder = @"请输入图形验证码";
        
        
        _graphTextField.leftView = paddingView3;
        
        _graphTextField.leftViewMode = UITextFieldViewModeAlways;
                
        
        self.graphTextField.borderStyle = UITextBorderStyleNone;
        
        self.graphTextField.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:self.graphTextField];

        
        FNCodeView *codeView = [[FNCodeView alloc]initWithFrame:CGRectMake(kScreenWidth - 134, telY + 4+5, 100,40 )];
        [self addSubview:codeView];    
        
        CGFloat codeY = CGRectGetMaxY(_graphTextField.frame);
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        self.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(29,codeY + 4 , kScreenWidth - 2 * 29, 50)];
        
        _codeTextField.backgroundColor = MAIN_COLOR_WHITE;
        
        _codeTextField.delegate = self;
        
        self.codeTextField.placeholder = @"请输入短信验证码";
        
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _codeTextField.leftView = paddingView2;
        
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        
        _codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.codeTextField.borderStyle = UITextBorderStyleNone;
        
        self.codeTextField.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:self.codeTextField];
  
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 134-5, codeY + 4, 105,50 )];
        view.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:view];
        
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _getCodeBtn.frame = CGRectMake(0,5, 105, 40);
        
        _getCodeBtn.layer.borderWidth = 1.5;
        
        _getCodeBtn.layer.borderColor = [UIColor redColor].CGColor;
        
        [_getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
        
        [_getCodeBtn setCorner:20];
        
        _getCodeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [view addSubview:self.getCodeBtn];

        
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _loginBtn.titleLabel.font = [UIFont fzltWithSize:15];
        
        _loginBtn.frame = CGRectMake(39, _codeTextField.y + _codeTextField.height + 20,kScreenWidth - 2 * 39 , 40);
        
        [_loginBtn setCorner:5];
        
        _loginBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        
        [_loginBtn setBackgroundColor:UIColorWithRGB(167.0, 170.0, 166.0)];
        
        [self addSubview:self.loginBtn];

        _scanLabel = [UILabel labelWithFrame:CGRectMake(0, _loginBtn.y + _loginBtn.height + 20, kWindowWidth, 30)];
        
        [_scanLabel clearBackgroundWithFont:[UIFont fzltWithSize:18] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        _scanLabel.text = @"仅需一步即可完成支付";
        
        _scanLabel.textColor = MAIN_COLOR_RED_ALPHA;
        
        _scanLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_scanLabel];
        
        _scanLabel.hidden = YES;
        
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length ==1 && [string isEqualToString:@" "])
    {
        return NO;
    }
    if (string.length>0)
    {
        if (textField == _telepNumTextField && _telepNumTextField.text.length >= 11)
        {
            return NO;
        }
        
    }
    
    return YES;
}

@end
