//
//  FNMobileRechargeHeaderView.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//
#import "FNHeader.h"

#import "FNMobileRechargeHeaderView.h"

@implementation FNMobileRechargeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        _telTextField = [[FNTextField alloc]initWithFrame:CGRectMake(16, 5, kScreenWidth-32-24- 17-10, 50)];
        _telTextField.keyboardType = UIKeyboardTypeNumberPad;
        _telTextField.placeholder = @"请输入手机号";
        _telTextField.clearButtonMode = UITextFieldViewModeAlways;
        _telTextField.font = [UIFont systemFontOfSize:20];
        [self addSubview:_telTextField];
        
        _addressBtnView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 40-15, _telTextField.y,40 , 40)];
        [self addSubview:_addressBtnView];
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressBtn.frame = CGRectMake(0, 10, 24, 24);
        [_addressBtn setBackgroundImage:[UIImage imageNamed:@"address_btn"] forState:UIControlStateNormal];
        [_addressBtnView addSubview:_addressBtn];
        
        _phoneNumName = [[UILabel alloc]initWithFrame:CGRectMake(16,_telTextField.y+_telTextField.height , kScreenWidth - 32, 25)];
        _phoneNumName.font = [UIFont systemFontOfSize:12];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, _phoneNumName.y+ _phoneNumName.height+2, kScreenWidth, 1)];
        _line.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:_line];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


@end
