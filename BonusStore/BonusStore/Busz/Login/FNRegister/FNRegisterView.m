//
//  FNRegisterView.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNRegisterView.h"

#import "FNLoginBO.h"

@interface FNRegisterView ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * title;

@property (nonatomic, strong) UIImageView * image;

@property (nonatomic, strong) UIView * view;

@property (nonatomic, strong) UIView * btnView;

@end

@implementation FNRegisterView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        _title = [[UILabel alloc]initWithFrame:CGRectMake(31 , 31, 130, 30)];
        
        _title.text = @"客官～欢迎您呦～";
        
        _title.textColor = [UIColor colorWithRed:113.0/255 green:113.0/255 blue:113.0/255 alpha:1];
        
        _title.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self addSubview:_title];
        
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(29 + 130 + 10,2, 125, 79)];
        _image.image = [UIImage imageNamed:@"register_logo"];
        [self addSubview:_image];
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _numberText = [[UITextField alloc]initWithFrame:CGRectMake(29, 78, kScreenWidth - 2 * 29, 50)];
        
        _numberText.delegate = self;
        
        _numberText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _numberText.leftView = paddingView1;
        
        _numberText.leftViewMode = UITextFieldViewModeAlways;
        
        _numberText.keyboardType = UIKeyboardTypeNumberPad;
        
        _numberText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _numberText.borderStyle = UITextBorderStyleNone;
        
        _numberText.backgroundColor = MAIN_COLOR_WHITE;
        
        _numberText.placeholder = @"请输入手机号码";
        
        [self addSubview:_numberText];
        
        
        CGFloat graphTextY = CGRectGetMaxY(_numberText.frame)+4;
        _graphText = [[UITextField alloc]initWithFrame:CGRectMake(29,graphTextY, kScreenWidth - 2 * 29, 50)];
        
        _graphText.delegate = self;
        
        _graphText.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];

        _graphText.leftView = paddingView2;
        
        _graphText.leftViewMode = UITextFieldViewModeAlways;
                
        _graphText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _graphText.borderStyle = UITextBorderStyleNone;
        
        _graphText.backgroundColor = MAIN_COLOR_WHITE;
        
        _graphText.placeholder = @"请输入图形验证码";
        
        [self addSubview:_graphText];

        FNCodeView *codeView = [[FNCodeView alloc]initWithFrame:CGRectMake(kScreenWidth - 134, graphTextY +5, 100,40 )];
        [self addSubview:codeView];
        
        UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        CGFloat codeTextY =  CGRectGetMaxY(_graphText.frame)+4;
        
        _codeText = [[UITextField alloc]initWithFrame:CGRectMake(29,codeTextY , kScreenWidth - 2 * 29 , 50)];
        
        _codeText.delegate = self;
        
        _codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _codeText.leftView = paddingView3;
        
        _codeText.keyboardType = UIKeyboardTypeNumberPad;
        
        _codeText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _codeText.leftViewMode = UITextFieldViewModeAlways;
        
        _codeText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _codeText.borderStyle = UITextBorderStyleNone;
        
        _codeText.backgroundColor = MAIN_COLOR_WHITE;
        
        _codeText.placeholder = @"请输入验证码";
        
        [self addSubview:_codeText];
        
        _view = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth -  29 -100 -5,codeTextY, 100, _numberText.height)];
        
        _view.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:_view];
        
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_getCodeBtn setCorner:20.0];
        
        _getCodeBtn.layer.borderWidth = 1.5;
        
        _getCodeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
        
        [_getCodeBtn setTitleColor:MAIN_COLOR_RED_ALPHA  forState:UIControlStateNormal];
        
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _getCodeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_view addSubview:self.getCodeBtn];
        
        _getCodeBtn.frame = CGRectMake(0, 5, 100,40 );


        CGFloat codeTY = CGRectGetMinY(_codeText.frame);
        
        NSString * str = @"请输入密码";
        
        NSString * str2 = [NSString stringWithFormat:@"%@(6-16位)",str];
        
        NSMutableAttributedString * newstr = [str2 makeStr:@"(6-16位)" withColor:[UIColor colorWithRed:186.0/255 green:185.0/255 blue:193.0/255 alpha:1] andFont:[UIFont systemFontOfSize:12]];

        UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _passText = [[UITextField alloc]initWithFrame:CGRectMake(29, codeTY + 54, kScreenWidth - 93, 50)];
        
        _passText.delegate = self;
        
        _passText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _passText.leftView = paddingView4;
        
        _passText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _passText.leftViewMode = UITextFieldViewModeAlways;
        
        _passText.attributedPlaceholder = newstr;
        
        _passText.borderStyle = UITextBorderStyleNone;
        
        _passText.keyboardType = UIKeyboardTypeASCIICapable;
        
        _passText.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        _passText.backgroundColor = MAIN_COLOR_WHITE;
        
        _passText.returnKeyType = UIReturnKeyDone;
        
        [self addSubview:_passText];
        
        _btnView = [[UIView alloc]initWithFrame:CGRectMake(_passText.x + _passText.width, _passText.y, 35, 50)];
        
        _btnView.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:_btnView];
        
        _eyeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_btnView addSubview:_eyeBtn];
        
        _eyeBtn.frame = CGRectMake(0,15, 20, 20);
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _registerBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        _registerBtn.backgroundColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1];
        
        _registerBtn.enabled = false;
        
        [_registerBtn setCorner:5.0];
        
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        
        [_registerBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        
        [self addSubview:_registerBtn];
        
        _registerBtn.frame = CGRectMake(39, _passText.y + _passText.height + 12, kScreenWidth - 78, 40);

        _redLab = [[UILabel alloc]initWithFrame:CGRectMake(53,_registerBtn.y + _registerBtn.height + 2 , 84, 20)];
        
        _redLab.text = @"我已阅读并接受";
        
        _redLab.textColor = MAIN_COLOR_BLACK_ALPHA;
        
        _redLab.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        [self addSubview:_redLab];
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [self addSubview:_agreeBtn];
        
        _agreeBtn.frame = CGRectMake(39, _registerBtn.y + _registerBtn.height + 4, 12, 12);
        
        _jsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _jsBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        [_jsBtn setTitle:@"聚分享服务条款" forState:UIControlStateNormal];
        
        [_jsBtn setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
        
        [self addSubview:_jsBtn];
        
        _jsBtn.frame = CGRectMake(_redLab.x + _redLab.width + 1,_registerBtn.y + _registerBtn.height + 2 , _redLab.width, 20);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validMobile:) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)validMobile:(NSNotification *)noti
{
    if (!_numberText.isEditing)
    {
        return;
    }
    
    NSString *string = _numberText.text;
    
    if (string.length >= 11)
    {
        if (![string isMobile] && string && ![string isEqualToString:@""])
        {
            [UIAlertView alertViewWithMessage:@"请输入正确的手机号"];
            
            return;
        }
        
        [[FNLoginBO port02] isRegisterWithMobile:string block:^(id result) {
            
            if ([result[@"code"] integerValue] == 200)
            {
                if ([result[@"value"] boolValue])
                {
                    [UIAlertView alertViewWithMessage:@"用户已存在，请重新输入"];
                    
                    _getCodeBtn.enabled = false;
                    
                    _getCodeBtn.layer.borderColor =[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
                    
                    [_getCodeBtn setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
                    
                    _registerBtn.backgroundColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1];
                    
                    _registerBtn.enabled = false;
                }
    
                return ;
            }
            else
            {
                if(result)
                {
                    [UIAlertView alertViewWithMessage:result[@"description"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
            }
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length+string.length;
    
    if ([NSString isEmptyString:string])
    {
        num--;
    }
    
    if (textField == _numberText )
    {
        if (num > 11)
        {
            return NO;
        }
        else if (num < 11)
        {
            _getCodeBtn.enabled = true;
            
            _getCodeBtn.layer.borderColor = MAIN_COLOR_RED_BUTTON.CGColor;
            
            [_getCodeBtn setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
            
            [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            
            _registerBtn.enabled = true;
            
            _registerBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
            
            return YES;
        }
    }

    if (textField == _passText && num > 16)
    {
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.codeText || textField == self.passText)
    {
        [textField resignFirstResponder];
        
        return YES;
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

@end
