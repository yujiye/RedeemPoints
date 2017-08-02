//
//  FNBonusRechargeStatusView.m
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusRechargeStatusView.h"

@interface FNBonusRechargeStatusView ()
{
    UIButtonActionBlock _rechargeBtnBlock;
}

@end

@implementation FNBonusRechargeStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _statusImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-89/2, 35, 89, 89)];
        [self addSubview:_statusImg];
        
        _statusLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _statusImg.y+_statusImg.height+20, kScreenWidth, 25)];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.font = [UIFont fzltWithSize:18];
        [self addSubview:_statusLab];
        
        _successPromptLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _statusLab.y+_statusLab.height+46, kScreenWidth, 20)];
        _successPromptLab.textAlignment = NSTextAlignmentCenter;
        _successPromptLab.font = [UIFont fzltWithSize:20];
        _successPromptLab.textColor = MAIN_COLOR_BLACK_ALPHA;
        [self addSubview:_successPromptLab];
        
        _succSurplusLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _successPromptLab.y+_successPromptLab.height+11, kScreenWidth, 20)];
        _succSurplusLab.textColor = [UIColor lightGrayColor];
        _succSurplusLab.textAlignment = NSTextAlignmentCenter;
        _succSurplusLab.font = [UIFont fzltWithSize:14];
        [self addSubview:_succSurplusLab];
        
        _rechargeOrSpendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeOrSpendBtn.frame = CGRectMake(20, _statusLab.y+_statusLab.height+120, kScreenWidth - 40, 40);
        [_rechargeOrSpendBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        [_rechargeOrSpendBtn setCorner:5.0];
        
        [_rechargeOrSpendBtn addSuperView:self ActionBlock:^(id sender) {
            _rechargeBtnBlock(sender);
        }];
        
        _rechargeOrSpendBtn.backgroundColor = MAIN_COLOR_RED_BUTTON;
        [self addSubview:_rechargeOrSpendBtn];
        
        _failLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _statusLab.y+_statusLab.height+27, kScreenWidth, 25)];
        _failLab.textColor = [UIColor lightGrayColor];
        _failLab.font = [UIFont fzltWithSize:14];
        _failLab.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_failLab];
    }
    return self;
}

- (void)rechargeAction:(UIButtonActionBlock)block
{
    _rechargeBtnBlock = nil;
    
    _rechargeBtnBlock = block;
}

- (void)rechargeSuccess
{
    _statusImg.image = [UIImage imageNamed:@"rechargeBonus_success"];
    _successPromptLab.hidden = NO;
    _succSurplusLab.hidden = NO;
    _statusLab.text = @"充值成功";
    _statusLab.textColor = MAIN_COLOR_RED_ALPHA;
    _failLab.hidden = YES;
    [_rechargeOrSpendBtn setTitle:@"立即花积分" forState:UIControlStateNormal];
}

- (void)rechargeFail
{
    _statusImg.image = [UIImage imageNamed:@"rechargeBonus_fail"];
    _successPromptLab.hidden = YES;
    _succSurplusLab.hidden = YES;
    _failLab.hidden = NO;
    
    _statusLab.text = @"充值失败";
    _statusLab.textColor = MAIN_COLOR_BLACK_ALPHA;
    [_rechargeOrSpendBtn setTitle:@"重新充值" forState:UIControlStateNormal];

}


@end
