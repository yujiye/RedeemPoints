//
//  FNForgetPassView.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNMacro.h"

@interface FNForgetPassView : UIView

@property (nonatomic, strong) UITextField * number;

@property (nonatomic,strong)UITextField * graphCode;

@property (nonatomic, strong) UITextField * getCodeText;

@property (nonatomic, strong) UIButton * getCodeBtn;

@property (nonatomic, strong) UITextField * nePassText;

@property (nonatomic, strong) UIButton * eyeBtn;

@property (nonatomic, strong) UIButton * resetBtn;
@end
