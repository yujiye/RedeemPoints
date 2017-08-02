//
//  FNNomLoginView.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNMacro.h"
@class FNCodeView;

@interface FNNomLoginView : UIView

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) UIView * eyeView;

@property (nonatomic, strong) UITextField * telepNumTextField;

@property (nonatomic, strong) UITextField * passWordText;

@property (nonatomic, strong) UIButton * getCodeBtn;

@property (nonatomic, strong) UIButton * eyeBtn;

@property (nonatomic, strong) UIButton * loginBtn;

@property (nonatomic, strong) UIButton * forgetPassBtn;

@property (nonatomic, strong) UILabel *scanLabel;

@end
