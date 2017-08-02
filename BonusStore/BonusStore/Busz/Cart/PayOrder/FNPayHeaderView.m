 //
//  FNPayHeaderView.m
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPayHeaderView.h"

static CGFloat PADDING_LEFT     =   15;

@interface FNPayHeaderView ()
{
    UILabel *_priceLabel;
    
    UILabel *_bonusLabel;
    
    UILabel *_lastLabel;
    
    UILabel *_rewardLabel;
    
    void (^FNPayHeaderSwitchBlock) (UISwitch *sender);
}

@end


@implementation FNPayHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = UIColorWithRGB(234, 235, 236);

        UIView *firstSecView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 55)];
        
        firstSecView.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:firstSecView];
        
        UILabel *priceTip = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_LEFT, 5, kWindowDemiW, 30)];
        
        priceTip.text = @"订单金额：";
        
        [priceTip clearBackgroundWithFont:[UIFont fzltWithSize:15] textColor:[UIColor blackColor]];
        
        [firstSecView addSubview:priceTip];
        
        [priceTip setVerticalCenterWithSuperView:firstSecView];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowDemiW, priceTip.y, kWindowDemiW-5, 30)];
        
        _priceLabel.textAlignment = NSTextAlignmentRight;
        
        [_priceLabel clearBackgroundWithFont:[UIFont fzltWithSize:20] textColor:[UIColor redColor]];
        
        [firstSecView addSubview:_priceLabel];
        
        [_priceLabel setVerticalCenterWithSuperView:firstSecView];
        
        UIView *secSecView = [[UIView alloc] initWithFrame:CGRectMake(0, firstSecView.y + firstSecView.height + 10, kWindowWidth, 55)];
        
        secSecView.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:secSecView];
        
        CALayer *secLine = [CALayer layerWithFrame:CGRectMake(0, secSecView.height-0.5, kWindowWidth, 0.5)];
        
        [secSecView.layer addSublayer:secLine];
        
        _bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_LEFT, 0, kWindowWidth-80, 30)];
        
        [_bonusLabel clearBackgroundWithFont:[UIFont fzltWithSize:15] textColor:[UIColor blackColor]];
        
        [secSecView addSubview:_bonusLabel];
        
        [_bonusLabel setVerticalCenterWithSuperView:secSecView];
        
        
        _switchBut = [[UISwitch alloc] initWithFrame:CGRectMake(kWindowWidth-65, 0, 65, 30)];
        
        _switchBut.on = YES;
        
        _switchBut.enabled = NO;
        
        [_switchBut addTarget:self action:@selector(payBonus:) forControlEvents:UIControlEventValueChanged];
        
        [secSecView addSubview:_switchBut];
        
        [_switchBut setVerticalCenterWithSuperView:secSecView];

        
        UIView *thirdSecView = [[UIView alloc] initWithFrame:CGRectMake(0, secSecView.y + secSecView.height, kWindowWidth, 55)];
        
        thirdSecView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:thirdSecView];
        
        _lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_LEFT, 4, kWindowWidth-PADDING_LEFT*2, 25)];
        
        [_lastLabel clearBackgroundWithFont:[UIFont fzltWithSize:15] textColor:[UIColor blackColor]];
        
        [thirdSecView addSubview:_lastLabel];
        
        _rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_LEFT, _lastLabel.y + _lastLabel.height-3, _lastLabel.width, 35)];
        
        [_rewardLabel clearBackgroundWithFont:[UIFont fzltWithSize:12] textColor:[UIColor blackColor]];
        
        [thirdSecView addSubview:_rewardLabel];
        if(_isSpecialType == YES)
        {
            _rewardLabel.hidden = YES;
        }else
        {
            _rewardLabel.hidden = NO;

        }

        CALayer *thirdLine = [CALayer layerWithFrame:CGRectMake(0, thirdSecView.height-0.5, kWindowWidth, 0.5)];
        
        [thirdSecView.layer addSublayer:thirdLine];

    }
    return self;
}

- (void)payBonus:(UISwitch *)sender
{
    if(sender.on == NO)
    {
        NSString *render = [NSString stringWithFormat:@"可用聚分享0"];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:render];
        string = [render makeStr:@"0" withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
        NSString * render1 = [NSString stringWithFormat:@"积分支付¥0.00"];
       [string appendAttributedString:[render1 makeStr:@"¥0.00" withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]]];
        _bonusLabel.attributedText = string;
        
        NSString *leftString = [NSString stringWithFormat:@"您还需支付：¥%.2f", [_price floatValue] ];
        NSMutableAttributedString *lastMoney = [[NSMutableAttributedString alloc] initWithString:leftString];
        lastMoney = [leftString makeStr:[NSString stringWithFormat:@"¥%.2f", [_price floatValue] ] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
        
        _lastLabel.attributedText = lastMoney;
        if(_isSpecialType == NO)
        {
            _rewardLabel.hidden = NO;
        NSString *result = [NSString stringWithFormat:@"支付完成后您将获得%.0f积分",floor([_price floatValue])];
        NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:leftString];
        resultString = [result makeStr:[NSString stringWithFormat:@"%.0f",[_price floatValue]] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:12]];
        _rewardLabel.attributedText = resultString;
        }else
        {
            _rewardLabel.hidden = YES;
        }

    }
    else
    {
        NSDecimalNumber *needBouns = 0;
        if (_bonus > [[_price multiplyingBy:100] integerValue])
        {
            needBouns = [_price multiplyingBy:100];
        }
        else
        {
            needBouns = [NSDecimalNumber decimalBy:_bonus];
        }
        
        NSString *render = [NSString stringWithFormat:@"可用聚分享%@积分支付¥%@",needBouns,[needBouns dividingBy:100]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:render];
        string = [render makeStr:needBouns.stringValue withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
        [NSString attributedStr:string makeStr:[NSString stringWithFormat:@"¥%@",[needBouns dividingBy:100]] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
        _bonusLabel.attributedText = string;
        
        CGFloat leftMoney = 0.0;
        if (![_price isEqualToNumber:[needBouns dividingBy:100]])
        {
            leftMoney = [_price floatValue] - [[needBouns dividingBy:100] floatValue];
        }
        NSString *leftString = [NSString stringWithFormat:@"您还需支付：¥%.2f",leftMoney];
        NSMutableAttributedString *lastMoney = [[NSMutableAttributedString alloc] initWithString:leftString];
        lastMoney = [leftString makeStr:[NSString stringWithFormat:@"¥%.2f",leftMoney] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
        
        _lastLabel.attributedText = lastMoney;
        if (leftMoney <100)
        {
            leftMoney =0;
        }
        
        if (_isSpecialType == NO)
        {
            _rewardLabel.hidden = NO;

        NSString *result = [NSString stringWithFormat:@"支付完成后您将获得%.0f积分",floor([_price floatValue])];
        NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:leftString];
        resultString = [result makeStr:[NSString stringWithFormat:@"%.0f",[_price floatValue]] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:12]];
        _rewardLabel.attributedText = resultString;
        }else
        {
            _rewardLabel.hidden = YES;
        }
    }
    
    FNPayHeaderSwitchBlock(sender);
}

- (void)switchStateBlock:(void (^)(UISwitch *))block
{
    FNPayHeaderSwitchBlock = nil;
    
    FNPayHeaderSwitchBlock = block;
}


- (void)setPrice:(NSDecimalNumber *)price
{
    _price = price;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",price];
}

- (void)setBonus:(NSInteger)bonus
{
    _bonus = bonus;
    NSDecimalNumber *needBouns = 0;
    if (_bonus > [[_price multiplyingBy:100] integerValue])
    {
        needBouns = [_price multiplyingBy:100.0];
    }else
    {
        needBouns = [NSDecimalNumber decimalBy:_bonus];
    }
  
    NSString *render = [NSString stringWithFormat:@"可用聚分享%@积分支付¥%@",needBouns,[needBouns dividingBy:100]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:render];
    string = [render makeStr:[NSString stringWithFormat:@"%@",needBouns] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
    [NSString attributedStr:string makeStr:[NSString stringWithFormat:@"¥%@",[needBouns dividingBy:100]] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
    _bonusLabel.attributedText = string;
    
    CGFloat leftMoney = 0.0;
    if (![_price isEqualToNumber:[needBouns dividingBy:100]])
    {
        leftMoney = [_price floatValue] - [[needBouns dividingBy:100] floatValue];
    }
    NSString *leftString = [NSString stringWithFormat:@"您还需支付：¥%.2f",leftMoney];
    NSMutableAttributedString *lastMoney = [[NSMutableAttributedString alloc] initWithString:leftString];
    lastMoney = [leftString makeStr:[NSString stringWithFormat:@"¥%.2f",leftMoney] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:15]];
    
    _lastLabel.attributedText = lastMoney;
    if (_isSpecialType == NO)
    {
        _rewardLabel.hidden = NO;

    NSString *result = [NSString stringWithFormat:@"支付完成后您将获得%.0f积分",floor([_price floatValue])];
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:leftString];
    resultString = [result makeStr:[NSString stringWithFormat:@"%.0f",[_price floatValue]] withColor:[UIColor redColor] andFont:[UIFont fzltWithSize:12]];
    _rewardLabel.attributedText = resultString;
    }else
    {
        _rewardLabel.hidden = YES;
    }

}

@end
