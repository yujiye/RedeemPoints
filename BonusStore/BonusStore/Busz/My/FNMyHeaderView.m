//
//  FNMyHeaderView.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMyHeaderView.h"

@implementation FNMyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _myOrderLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 30)];
        _myOrderLab.text = @"我的订单";
        _myOrderLab.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        [self addSubview:_myOrderLab];
        
        _checkAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkAllBtn.frame = CGRectMake(kScreenWidth - 80-15-15, 10, 80, 25);
        [_checkAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [_checkAllBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _checkAllBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:13];
        [self addSubview:_checkAllBtn];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _myOrderLab.y+_myOrderLab.height+5, kScreenWidth, 1)];
        line.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:line];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(_checkAllBtn.x+_checkAllBtn.width , 13, 10, 18)];
        img.image = [UIImage imageNamed:@"cart_order"];
        [self addSubview:img];
        
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(20, _myOrderLab.y+_myOrderLab.height+10,( kScreenWidth - 120)/5, 40);
        [_payBtn setImage:[UIImage imageNamed:@"order_pay_btn"] forState:UIControlStateNormal];
        [self addSubview:_payBtn];
        _payBadges = [[UILabel alloc]initWithFrame:CGRectMake(_payBtn.width-22, 0, 16, 16)];
        _payBadges.backgroundColor = MAIN_COLOR_RED_BUTTON;
        _payBadges.font = [UIFont systemFontOfSize:11];
        _payBadges.layer.masksToBounds = YES;
        _payBadges.textColor = MAIN_COLOR_WHITE;
        _payBadges.hidden = YES;
        _payBadges.layer.cornerRadius = 8.0;
        _payBadges.textAlignment = NSTextAlignmentCenter;
        [_payBtn addSubview:_payBadges];
        
        CGFloat fontSizt;
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
        {
            fontSizt = 11;
        }
        else
        {
            fontSizt = 13;
        }
        
        UILabel *payLab = [[UILabel alloc]initWithFrame:CGRectMake(15, _payBtn.y+_payBtn.height -5, (kScreenWidth - 15*6)/5, 25)];
        payLab.text = @"待付款";
        payLab.font = [UIFont fontWithName:FONT_NAME_LTH size:fontSizt];
        payLab.textColor = [UIColor lightGrayColor];
        payLab.textAlignment= NSTextAlignmentCenter;
        [self addSubview:payLab];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(_payBtn.x+_payBtn.width + 20,_payBtn.y , _payBtn.width, _payBtn.height);
        [_sendBtn setImage:[UIImage imageNamed:@"order_sender_btn"] forState:UIControlStateNormal];
        [self addSubview:_sendBtn];
        
        _senderBadges = [[UILabel alloc]initWithFrame:CGRectMake(_sendBtn.width-22, 0, 16, 16)];
        _senderBadges.hidden = YES;
        _senderBadges.backgroundColor = MAIN_COLOR_RED_BUTTON;
        _senderBadges.font = [UIFont systemFontOfSize:11];
        _senderBadges.layer.masksToBounds = YES;
        _senderBadges.textColor = MAIN_COLOR_WHITE;
        _senderBadges.layer.cornerRadius = 8.0;
        _senderBadges.textAlignment = NSTextAlignmentCenter;
        [_sendBtn addSubview:_senderBadges];
     
        
        UILabel *sendLab = [[UILabel alloc]initWithFrame:CGRectMake(payLab.x + payLab.width+ 15, payLab.y, payLab.width, payLab.height)];
        sendLab.text=@"待发货";
        sendLab.font = [UIFont fontWithName:FONT_NAME_LTH size:fontSizt];
        sendLab.textColor = [UIColor lightGrayColor];
        sendLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:sendLab];
        
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveBtn.frame = CGRectMake(_sendBtn.x+_sendBtn.width + 20,_sendBtn.y , _sendBtn.width, _sendBtn.height);
        [_receiveBtn setImage:[UIImage imageNamed:@"order_ship_btn"] forState:UIControlStateNormal];
        [self addSubview:_receiveBtn];
        _receiveBadges = [[UILabel alloc]initWithFrame:CGRectMake(_receiveBtn.width-22, 0, 16, 16)];
        _receiveBadges.backgroundColor = MAIN_COLOR_RED_BUTTON;
        _receiveBadges.font = [UIFont systemFontOfSize:11];
        _receiveBadges.layer.masksToBounds = YES;
        _receiveBadges.textColor = MAIN_COLOR_WHITE;
        _receiveBadges.layer.cornerRadius = 8.0;
        _receiveBadges.hidden = YES;
        _receiveBadges.textAlignment = NSTextAlignmentCenter;
        [_receiveBtn addSubview:_receiveBadges];
        
        UILabel *receiveLab = [[UILabel alloc]initWithFrame:CGRectMake(sendLab.x + sendLab.width+ 15, sendLab.y, sendLab.width, sendLab.height)];
        receiveLab.text=@"待收货";
        receiveLab.font = [UIFont fontWithName:FONT_NAME_LTH size:fontSizt];
        receiveLab.textColor = [UIColor lightGrayColor];
        receiveLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:receiveLab];
        
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.frame = CGRectMake(_receiveBtn.x+_receiveBtn.width + 20,_receiveBtn.y , _receiveBtn.width, _receiveBtn.height);
        [_finishBtn setImage:[UIImage imageNamed:@"order_finish_btn"] forState:UIControlStateNormal];
        [self addSubview:_finishBtn];
        
        UILabel *finishLab = [[UILabel alloc]initWithFrame:CGRectMake(receiveLab.x + receiveLab.width+ 15, receiveLab.y, receiveLab.width, receiveLab.height)];
        finishLab.text=@"已完成";
        finishLab.font = [UIFont fontWithName:FONT_NAME_LTH size:fontSizt];
        finishLab.textColor = [UIColor lightGrayColor];
        finishLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:finishLab];
        
        _afterSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _afterSaleBtn.frame = CGRectMake(_finishBtn.x+_finishBtn.width + 20,_finishBtn.y , _finishBtn.width, _finishBtn.height);
        [_afterSaleBtn setImage:[UIImage imageNamed:@"order_aftersale_btn"] forState:UIControlStateNormal];
        [self addSubview:_afterSaleBtn];

        UILabel *afterSaleLab = [[UILabel alloc]initWithFrame:CGRectMake(finishLab.x + finishLab.width+ 15, finishLab.y, finishLab.width, finishLab.height)];
        afterSaleLab.text=@"售后服务";
        afterSaleLab.font = [UIFont fontWithName:FONT_NAME_LTH size:fontSizt];
        afterSaleLab.textColor = [UIColor lightGrayColor];
        afterSaleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:afterSaleLab];
        
        _checkAllBtn.tag = FNTitleTypeOrderStateAll;
        _payBtn.tag = FNTitleTypeOrderStatePaying;
        _sendBtn.tag = FNTitleTypeOrderStateShipping;
        _receiveBtn.tag = FNTitleTypeOrderStateReceiving;
        _finishBtn.tag = FNTitleTypeOrderStateFinish;
        _afterSaleBtn.tag = FNTitleTypeOrderStateAfterSale;
        
    }
    return self;
}

- (void)setBadges
{
    if ([_senderBadges.text integerValue]>99)
    {
        CGSize size =  [_senderBadges.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont fzltWithSize:12]}];
        
        _senderBadges.frame = CGRectMake(_sendBtn.width-22, 0,size.width, size.height);
        [_senderBadges setCorner:7.0];
    }
    if ([_receiveBadges.text integerValue]>99)
    {
        CGSize size =  [_receiveBadges.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont fzltWithSize:12]}];
        
        _receiveBadges.frame = CGRectMake(_receiveBtn.width-22, 0,size.width, size.height);
        [_receiveBadges setCorner:7.0];
    }
    if ([_payBadges.text integerValue]>99)
    {
        CGSize size =  [_payBadges.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont fzltWithSize:12]}];
        
        _payBadges.frame = CGRectMake(_payBtn.width-22, 0,size.width, size.height);
        [_payBadges setCorner:7.0];
    }

    
}

@end
