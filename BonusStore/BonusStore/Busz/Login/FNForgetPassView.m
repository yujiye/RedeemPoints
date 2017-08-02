//
//  FNForgetPassView.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNForgetPassView.h"

@interface FNForgetPassView ()

@end

@implementation FNForgetPassView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _number = [[UITextField alloc]initWithFrame:CGRectMake(29, 20, kScreenWidth - 2 * 29 , 50)];
        
        _number.placeholder = @"请输入注册手机号";
        
        _number.leftView = paddingView1;
        
        _number.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _number.leftViewMode = UITextFieldViewModeAlways;
        
        _number.keyboardType = UIKeyboardTypeNumberPad;
        
        _number.borderStyle = UITextBorderStyleNone;
        
        _number.backgroundColor = MAIN_COLOR_WHITE;
        
        _number.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_number];
        
        CGFloat graphCodeY =  CGRectGetMaxY(_number.frame)+4;
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _graphCode = [[UITextField alloc]initWithFrame:CGRectMake(29, graphCodeY, kScreenWidth - 2 * 29 , 50)];
        
        _graphCode.placeholder = @"请输入图形验证码";
        
        _graphCode.leftView = paddingView2;
        
        _graphCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _graphCode.leftViewMode = UITextFieldViewModeAlways;
        
        
        _graphCode.borderStyle = UITextBorderStyleNone;
        
        _graphCode.backgroundColor = MAIN_COLOR_WHITE;
        
        _graphCode.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_graphCode];
        
        FNCodeView *codeView = [[FNCodeView alloc]initWithFrame:CGRectMake(kScreenWidth - 134, graphCodeY+5, 100,40 )];
        [self addSubview:codeView];
        
        
        CGFloat getCodeY = CGRectGetMaxY(_graphCode.frame)+4;
        UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _getCodeText = [[UITextField alloc]initWithFrame:CGRectMake(29, getCodeY,  kScreenWidth - 2 * 29, 50)];
        
        _getCodeText.placeholder = @"请输入短信验证码";
        
        _getCodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _getCodeText.leftView = paddingView3;
        
        _getCodeText.leftViewMode = UITextFieldViewModeAlways;
        
        _getCodeText.keyboardType = UIKeyboardTypeNumberPad;
        
        _getCodeText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _getCodeText.borderStyle = UITextBorderStyleNone;
        
        _getCodeText.backgroundColor = MAIN_COLOR_WHITE;
        
        _getCodeText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_getCodeText];
        
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 29-100-5, getCodeY, 100, 50)];
        
        view.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:view];
        
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _getCodeBtn.frame = CGRectMake(0, 5, 100, 40);
        
        [_getCodeBtn setCorner:20.0];
        
        _getCodeBtn.layer.borderWidth = 1.5;
        
        _getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
        
        [_getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
        
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _getCodeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [view addSubview:self.getCodeBtn];

        
        CGFloat textY = CGRectGetMaxY(_getCodeText.frame);

        NSString * str = @"请设置密码";
        
        NSString * str2 = [NSString stringWithFormat:@"%@(6-16位)",str];
        
        NSMutableAttributedString * newstr = [str2 makeStr:@"(6-16位)" withColor:[UIColor colorWithRed:186.0/255 green:185.0/255 blue:193.0/255 alpha:1] andFont:[UIFont systemFontOfSize:12]];
        
        UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _nePassText = [[UITextField alloc]initWithFrame:CGRectMake(29, textY + 4 , kScreenWidth - 88, 50)];
        
         _nePassText.leftView = paddingView4;
        
        _nePassText.attributedPlaceholder = newstr;
        
        _nePassText.backgroundColor = MAIN_COLOR_WHITE;
        
        _nePassText.borderStyle = UITextBorderStyleNone;
        
        _nePassText.leftViewMode = UITextFieldViewModeAlways;
        
        _nePassText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _nePassText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_nePassText];
        
        UIView * eyeBtnView = [[UIView alloc]initWithFrame:CGRectMake(_nePassText.x + _nePassText.width, _nePassText.y, 30, 50)];
        
        eyeBtnView.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:eyeBtnView];

        _eyeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _eyeBtn.frame = CGRectMake(0, 15, 20, 20);
        
        [eyeBtnView addSubview:_eyeBtn];
        
        _resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_resetBtn setCorner:5];
        
        [_resetBtn setBackgroundColor:MAIN_COLOR_RED_BUTTON];
        
        [_resetBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        
        [_resetBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        
        _resetBtn.frame = CGRectMake(39, _nePassText.y + _nePassText.height + 20,kScreenWidth - 39 *2 , 40);
        
        [self addSubview:_resetBtn];

    }
    return self;
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _getCodeText || textField == _nePassText)
    {
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
    
}

@end
