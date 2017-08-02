//
//  FNAlertViewVC.m
//  BonusStore
//
//  Created by cindy on 2017/1/10.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNAlertView.h"
#import "FNHeader.h"
@interface FNAlertView ()
// 蒙版
@property (nonatomic, strong) UIView *coverView;
// 弹框
@property (nonatomic, strong) UIView *alertView;
// 点击确定回调的block
@property (nonatomic, copy) FNAlertBlock block;

@property (nonatomic, weak)UILabel *lblMessage;
@property (nonatomic,weak)UILabel *contentLab;
@property (nonatomic,weak) UIButton * btnConfirm;


@end

@implementation FNAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    //创建蒙版
    UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    self.coverView = coverView;
    [self addSubview:coverView];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    
    //创建提示框view
    UIView * alertView = [[UIView alloc] init];
    alertView.backgroundColor = self.alertBackgroundColor;
    //设置圆角半径
    alertView.layer.cornerRadius = 6.0;
    self.alertView = alertView;
    [self addSubview:alertView];
    alertView.center = coverView.center;
    alertView.frame = CGRectMake(kScreenWidth* 0.25*0.5, (kScreenHeight - 64 -kScreenWidth* 0.75 * 1.6/ 3)*0.5 , kScreenWidth* 0.75, kScreenWidth* 0.75 * 1.6/ 3);
   //创建message label
    UILabel * lblMessage = [[UILabel alloc] init];
    lblMessage.textColor = self.messageColor;
    [alertView addSubview:lblMessage];
    self.lblMessage = lblMessage;
    lblMessage.font =[UIFont systemFontOfSize:16];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    CGFloat margin = 12;
    CGFloat msgX = margin;
    CGFloat msgY = 3;
    CGFloat msgW = alertView.bounds.size.width - 2 * margin;
    CGFloat msgH = 40;
    lblMessage.frame = CGRectMake(msgX, msgY, msgW, msgH);
    
    // 创建content
    UILabel * contentLab = [[UILabel alloc]init];
    self.contentLab = contentLab;
    contentLab.textColor = self.contentColor;
    [alertView addSubview:contentLab];
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.font = [UIFont systemFontOfSize:14];
    contentLab.frame = CGRectMake(msgX, CGRectGetMaxY(lblMessage.frame), msgW, 30);
    
    UILabel * lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.frame = CGRectMake(msgX, CGRectGetMaxY(contentLab.frame)+5, msgW, 1);
    [alertView addSubview:lineLabel];
   CGFloat btnMargin = (alertView.bounds.size.height -CGRectGetMaxY(lineLabel.frame)- 44)*0.5;
        
    //确定按钮
    UIButton * btnConfirm = [[UIButton alloc] init];
    [alertView addSubview:btnConfirm];
    self.btnConfirm = btnConfirm;
    btnConfirm.enabled = YES;
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
    [btnConfirm setBackgroundColor:self.btnConfirmBackgroundColor];
    btnConfirm.frame = CGRectMake(msgX, alertView.bounds.size.height - 44 - btnMargin, msgW, 44);
    [btnConfirm addTarget:self action:@selector(didClickBtnConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



+(instancetype)alertViewControllerWithMessage:(NSString *)message content:(NSString *)content block:(FNAlertBlock) block
{
    FNAlertView * alertView = [[FNAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64)];
    alertView.lblMessage.text = message;
    alertView.contentLab.text = content;
    alertView.block = block;
    return alertView;

}

// 点击确定
-(void)didClickBtnConfirm
{
    [self removeFromSuperview];
    self.block();

}


- (UIColor *)alertBackgroundColor{
    
    if (_alertBackgroundColor == nil) {
        _alertBackgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    }
    return _alertBackgroundColor;
}

// 确定按钮背景色
-(UIColor *)btnConfirmBackgroundColor{
    
    if (_btnConfirmBackgroundColor == nil) {
        _btnConfirmBackgroundColor = [UIColor redColor];
    }
    return _btnConfirmBackgroundColor;
}

// message字体颜色
-(UIColor *)messageColor{
    
    if (_messageColor == nil) {
        _messageColor = [UIColor blackColor];
    }
    return _messageColor;
}

- (UIColor *)contentColor
{
    if (_contentColor == nil)
    {
        _contentColor = [UIColor grayColor];
    }
    return _contentColor;
}


@end

