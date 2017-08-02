//
//  FNRegisterView.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"


@interface FNRegisterView : UIView

@property (nonatomic, strong) UITextField * numberText;

@property (nonatomic, strong) UITextField * graphText;

@property (nonatomic, strong) UITextField * codeText;

@property (nonatomic, strong) UIButton * getCodeBtn;

@property (nonatomic, strong) UITextField * passText;

@property (nonatomic, strong) UIButton * eyeBtn;

@property (nonatomic, strong) UIButton * agreeBtn;

@property (nonatomic, strong) UILabel * redLab;

@property (nonatomic, strong) UIButton * jsBtn;

@property (nonatomic, strong) UIButton * registerBtn;

@property (nonatomic, assign) BOOL isSelected;

@end
