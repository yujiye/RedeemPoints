//
//  FNAlterPassword.m
//  BonusStore
//
//  Created by sugarkawhi on 16/4/10.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNAlterPassword.h"
#import "FNHeader.h"
#import "FNCodeView.h"
#import "UITextField+ExtentRange.h"

@interface FNAlterPassword ()<UITextFieldDelegate>

@end

@implementation FNAlterPassword

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _number = [[UITextField alloc]initWithFrame:CGRectMake(29, 20,kScreenWidth - 2 * 29 , 50)];
        
        _number.enabled = NO;
        
        _number.delegate = self;
        
        _number.leftView = paddingView1;
        
        _number.placeholder = @"请输入手机号";
        
        _number.borderStyle =  UITextBorderStyleNone;
        
        _number.backgroundColor = [UIColor whiteColor];
        
        _number.leftViewMode = UITextFieldViewModeAlways;

        _number.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _number.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_number];
        
        CGFloat graphCodeFieldY = CGRectGetMaxY(_number.frame)+4;
        
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _graphCodeField = [[UITextField alloc]initWithFrame:CGRectMake(29, graphCodeFieldY,kScreenWidth - 2 * 29 , 50)];
                
        _graphCodeField.delegate = self;
        
        _graphCodeField.leftView = paddingView2;
        
        _graphCodeField.placeholder = @"请输入图形验证码";
        
        _graphCodeField.borderStyle =  UITextBorderStyleNone;
        
        _graphCodeField.backgroundColor = [UIColor whiteColor];
        
        _graphCodeField.leftViewMode = UITextFieldViewModeAlways;
        
        _graphCodeField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _graphCodeField.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_graphCodeField];

        FNCodeView *codeView = [[FNCodeView alloc]initWithFrame:CGRectMake(kScreenWidth - 134, graphCodeFieldY+5, 100,40 )];
        [self addSubview:codeView];
        CGFloat codeY = CGRectGetMaxY(_graphCodeField.frame) + 4;
        
       
        
        UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _code = [[UITextField alloc]initWithFrame:CGRectMake(29,codeY, kScreenWidth - 2 * 29, 50)];
        
        _code.delegate = self;
        
        _code.leftView = paddingView3;
        
        _code.inputAccessoryView = nil;
        
        _code.placeholder = @"请输入验证码";
    
        _code.borderStyle = UITextBorderStyleNone;
        
        _code.backgroundColor = [UIColor whiteColor];
        
        _code.leftViewMode = UITextFieldViewModeAlways;
        
        _code.keyboardType = UIKeyboardTypeNumberPad;
        
        _code.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _code.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _code.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _code.autocapitalizationType = UITextAutocapitalizationTypeNone;
      
        [self addSubview:_code];
        
    
        
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_getCodeBtn setCorner:20];
        
        _getCodeBtn.layer.borderWidth = 1.5;
        
        _getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
        
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _getCodeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _getCodeBtn.frame =CGRectMake(kScreenWidth - 134-5, codeY+5 , 105,40 );
        
        [_getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
        
        [self addSubview:self.getCodeBtn];
        
        

        NSString * str = @"请输入密码";
        
        NSString * str2 = [NSString stringWithFormat:@"%@(6-16位)",str];
        
        NSMutableAttributedString * newstr = [str2 makeStr:@"(6-16位)" withColor:[UIColor colorWithRed:186.0/255 green:185.0/255 blue:193.0/255 alpha:1] andFont:[UIFont systemFontOfSize:12]];
        
        UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _freshPassWord = [[UITextField alloc]initWithFrame:CGRectMake(29, _code.y + _code.height + 4, kScreenWidth - 2 * 29-40, 50)];
    
        _freshPassWord.delegate = self;
        
        _freshPassWord.secureTextEntry = YES;
        
        _freshPassWord.leftView = paddingView4;
        
        _freshPassWord.attributedPlaceholder = newstr;

        _freshPassWord.backgroundColor = MAIN_COLOR_WHITE;
        
        _freshPassWord.leftViewMode = UITextFieldViewModeAlways;
        
        _freshPassWord.keyboardType = UIKeyboardTypeASCIICapable;

        _freshPassWord.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _freshPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _freshPassWord.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        [self addSubview:_freshPassWord];
  
        _eyeView = [[UIView alloc]initWithFrame:CGRectMake(_freshPassWord.x + _freshPassWord.width, _freshPassWord.y, 40, 50)];
        
        _eyeView.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:_eyeView];
        
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _eyeBtn.frame = CGRectMake(_freshPassWord.x + _freshPassWord.width + 10, _freshPassWord.y + 15, 20, 20);
        
        [self addSubview:_eyeBtn];
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_confirmBtn setCorner:5.0];
        
        [_confirmBtn setBackgroundColor:MAIN_COLOR_RED_BUTTON];
        
        [_confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        
        _confirmBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _confirmBtn.frame = CGRectMake(39, _freshPassWord.y + _freshPassWord.height + 12, kScreenWidth - 2 *39, 40);
        
        [self addSubview:self.confirmBtn];

    }
    return  self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length>0)
    {
        if (textField == _number && _number.text.length >= 11)
        {
            return NO;
        }
        
        if (textField == _freshPassWord && _freshPassWord.text.length >= 16)
        {
            return NO;
        }
        
        if (textField == _code && _code.text.length >= 4)
        {
            return NO;
        }
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _freshPassWord || textField == _code)
    {
        
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
    
}

@end
