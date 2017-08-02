//
//  FNAlterPassword.h
//  BonusStore
//
//  Created by sugarkawhi on 16/4/10.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "FNHeader.h"

#import "FNMacro.h"

@interface FNAlterPassword : UIView

@property (nonatomic, strong) UITextField * number;
@property (nonatomic, strong)UITextField * graphCodeField;

@property (nonatomic, strong) UIView *eyeView;

@property (nonatomic, strong) UIButton * eyeBtn;

@property (nonatomic, strong) UITextField * code;//验证码

@property (nonatomic, strong) UIButton * getCodeBtn;//获取验证码

@property (nonatomic, strong) UITextField * freshPassWord;

@property (nonatomic, strong) UIButton * confirmBtn;//确认修改

@end
