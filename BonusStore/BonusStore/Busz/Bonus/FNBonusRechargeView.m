//
//  FNBonusRechargeView.m
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusRechargeView.h"

@interface FNBonusRechargeView ()
{
    UIButtonActionBlock _recordBlock;
    UIButtonActionBlock _block;
}

@property (nonatomic, strong)UILabel *cardNumLab;

@property (nonatomic, strong)UILabel *cardPassLab;

@end

@implementation FNBonusRechargeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _cardNumLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 57,36 , 20)];
        _cardNumLab.text = @"卡号" ;
        _cardNumLab.font = [UIFont fzltWithSize:18];
        [self addSubview:_cardNumLab];
        
        _cardNumText = [[UITextField alloc]initWithFrame:CGRectMake(_cardNumLab.x+_cardNumLab.width+40,_cardNumLab.y ,kScreenWidth - 40 - 40 - _cardNumLab.width , 20)];
        _cardNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cardNumText.placeholder = @"请输入充值卡号";
        _cardNumText.keyboardType = UIKeyboardTypeASCIICapable;
        _cardNumText.font = [UIFont fzltWithSize:18];
        [self addSubview:_cardNumText];
        
        UILabel *bottomLab1 = [[UILabel alloc]initWithFrame:CGRectMake(_cardNumLab.x, _cardNumLab.y+_cardNumLab.height+18, kScreenWidth - 40, 1)];
        bottomLab1.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:bottomLab1];
        
        _cardPassLab = [[UILabel alloc]initWithFrame:CGRectMake(_cardNumLab.x, bottomLab1.y+bottomLab1.height+19, _cardNumLab.width, _cardNumLab.height)];
        _cardPassLab.text = @"密码";
        _cardPassLab.font = [UIFont fzltWithSize:18];
        [self addSubview:_cardPassLab];
        
        _cardPassText = [[UITextField alloc]initWithFrame:CGRectMake(_cardNumText.x,_cardPassLab.y ,_cardNumText.width,_cardNumText.height)];
        _cardPassText.keyboardType = UIKeyboardTypeASCIICapable;
        _cardPassText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cardPassText.placeholder = @"请输入充值卡密码";
        _cardPassText.secureTextEntry = YES;
        _cardPassText.font = [UIFont fzltWithSize:18];
        [self addSubview:_cardPassText];
        
        UILabel *bottomLab2 = [[UILabel alloc]initWithFrame:CGRectMake(bottomLab1.x,_cardPassLab.y+_cardPassLab.height+19, kScreenWidth - 40, 1)];
        bottomLab2.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:bottomLab2];

      
        
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeBtn.frame = CGRectMake(bottomLab2.x, bottomLab2.y+1+30, kScreenWidth - 40, 44);
        [_rechargeBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        _rechargeBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
        [_rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = [UIFont fzltWithSize:18];
        [_rechargeBtn setCorner:5.0];

        [self addSubview:_rechargeBtn];
        
        _rechargeRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeRecord.frame =CGRectMake( kScreenWidth/2-50, _rechargeBtn.y + _rechargeBtn.height + 32, 100, 20);
        [_rechargeRecord setTitle:@"查看充值记录" forState:UIControlStateNormal];
        [_rechargeRecord setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
        [_rechargeRecord addSuperView:self ActionBlock:^(id sender) {
            _recordBlock(sender);
        }];
        _rechargeRecord.titleLabel.font = [UIFont fzltWithSize:14];
        [self addSubview:_rechargeRecord];
        
    }
    return self;
}
- (void)goRecargeRecordVC:(UIButtonActionBlock)block
{
    _recordBlock = nil;
    
    _recordBlock = block;
}

-(void)rechargeSuccessOrFaile:(UIButtonActionBlock)block
{
    _block = nil;
    
    _block = block;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if ([_cardNumText.text rangeOfString:@" "].location != NSNotFound)
    {
        _cardNumText.text = [_cardNumText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        _cardNumText.text = _cardNumText.text;
    }
    if ([_cardPassText.text rangeOfString:@" "].location != NSNotFound)
    {
        _cardPassText.text = [_cardPassText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        _cardPassText.text = _cardPassText.text;
    }
    
    [self endEditing:YES];
}



@end
