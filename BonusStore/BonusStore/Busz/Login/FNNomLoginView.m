//
//  FNNomLoginView.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//


#import "FNNomLoginView.h"

@interface FNNomLoginView ()<UITextFieldDelegate>

@end

@implementation FNNomLoginView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _telepNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(29, 0, kScreenWidth - 2 * 29,50 )];
        
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
        
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _passWordText = [[UITextField alloc]initWithFrame:CGRectMake(29, telY + 4, kScreenWidth - 29 * 2 - 40,50 )];
        
        _passWordText.delegate = self;
        
        _passWordText.placeholder = @"请输入密码";
        
        _passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _passWordText.leftView = paddingView2;
        
        _passWordText.leftViewMode = UITextFieldViewModeAlways;
        
        _passWordText.backgroundColor = MAIN_COLOR_WHITE;
        
        _passWordText.borderStyle = UITextBorderStyleNone;
        
        _passWordText.returnKeyType = UIReturnKeyDone;
        
        self.passWordText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_passWordText];
        
        _eyeView = [[UIView alloc]initWithFrame:CGRectMake(_passWordText.x + _passWordText.width, _passWordText.y, 40, 50)];
        
        _eyeView.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:_eyeView];
    
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _eyeBtn.frame = CGRectMake(_eyeView.x + 10, _passWordText.y + 10, 20, 20);
        
        [self addSubview:_eyeBtn];

        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _loginBtn.frame = CGRectMake(39, _passWordText.y + _passWordText.height + 20, kScreenWidth - 2* 39, 40);
        
        _loginBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        
        _loginBtn.backgroundColor  =[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1];
        
        [_loginBtn setCorner:5];
        
        [self addSubview:self.loginBtn];
        
        _forgetPassBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _forgetPassBtn.frame = CGRectMake(( kScreenWidth - 147) /2, _loginBtn.y + _loginBtn.height + 3, 147, 50);
        
        _forgetPassBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _forgetPassBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        [_forgetPassBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        
        [_forgetPassBtn setTitleColor:[UIColor colorWithRed:29.0/255 green:31.0/255 blue:32.0/255 alpha:1] forState:UIControlStateNormal];
        
        [self addSubview:_forgetPassBtn];
        
        _scanLabel = [UILabel labelWithFrame:CGRectMake(0, _forgetPassBtn.y + _forgetPassBtn.height + 20, kWindowWidth, 30)];
        
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
    NSInteger num = textField.text.length + string.length;
    if (string.length ==1 && [string isEqualToString:@" "])
    {
        return NO;
    }
    if (textField == _telepNumTextField && num == 0)
    {
        _loginBtn.backgroundColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1];
        
        _loginBtn.enabled = false;
        
        return YES;
    }
    if (textField == _telepNumTextField && num <= 11)
    {
        _loginBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
        
        _loginBtn.enabled = true;
        
        return YES;
    }
    
    if (textField == _telepNumTextField && num >11)
    {
        return NO;
    }
    
    if (textField == _passWordText && num > 16)
    {
        if ([string isEqualToString:@""])
        {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}


@end
