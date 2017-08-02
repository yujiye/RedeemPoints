//
//  FNLoginView.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

@interface FNLoginView : UIView

@property (nonatomic, strong) UITextField * telepNumTextField;// 手机号码

@property (nonatomic, strong) UITextField * graphTextField;// 图形验证
@property (nonatomic, strong) UIButton * getGraphBtn; //获取图形验证

@property (nonatomic, strong) UITextField * codeTextField; //验证短信

@property (nonatomic, strong) UIButton * getCodeBtn; //获取验证码

@property (nonatomic, strong) UIButton * loginBtn; //登录

@property (nonatomic, strong) UILabel *scanLabel;

@end
