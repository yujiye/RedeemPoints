//
//  FNBonusCashCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/6/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusCashCell.h"

@interface FNBonusCashCell ()<UITextFieldDelegate>

@end

@implementation FNBonusCashCell

+ (instancetype)cashTableviewCell:(UITableView *)tableView
{
    NSString * reuseId = @"cashCell";
    
    FNBonusCashCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil)
    {
        cell = [[FNBonusCashCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier])
    {
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(22, 10, 134, 40)];
        
        _titleLable.font = [UIFont fontWithName:FONT_NAME_LTH size:15];
        
        [self.contentView addSubview:_titleLable];
        
        _inteLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 95, 10, 80, 40)];
        
        _inteLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [self.contentView addSubview:_inteLabel];
        
        _telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 40 - 140,10 , 140, 40)];
        
        _telephoneLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _telephoneLabel.textColor = MAIN_COLOR_RED_ALPHA;
        
        [self.contentView addSubview:_telephoneLabel];
        
        _buttonView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 15 - 160, 10, 160, 40)];
        
        [self.contentView addSubview:_buttonView];
        
        _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _cutBtn.tag = kNumberBtnTypeMinus;
        
        [_cutBtn addTarget:self action:@selector(cutButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _cutBtn.frame = CGRectMake(0, 0, 40, 40);
        
        [_cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
        
        [_cutBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        
        [_buttonView addSubview:_cutBtn];
        
        _cashTextField = [[FNTextField alloc]init];
        
        _cashTextField.borderStyle = UITextBorderStyleLine;
        
        _cashTextField.layer.borderWidth = 1.0;
        
        _cashTextField.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
        
        [_cashTextField addTarget:self action:@selector(numberChange) forControlEvents:UIControlEventValueChanged];
        
        _cashTextField.textAlignment = NSTextAlignmentCenter;
        
        _cashTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _cashTextField.textColor = MAIN_COLOR_RED_ALPHA;
        
        _cashTextField.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        _cashTextField.frame = CGRectMake(_cutBtn.x + _cutBtn.width - 2, 0, 80, 40);
        
        [_buttonView addSubview:_cashTextField];
      
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _addBtn.tag = kNumberBtnTypeAdd;
        
        [_addBtn addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
        
        [_addBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        
        _addBtn.frame = CGRectMake(_cashTextField.x+_cashTextField.width-1, 0, 40, 40);
        
        [_buttonView addSubview:_addBtn];
     
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _codeBtn.layer.cornerRadius = 20;
        
        _codeBtn.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
        
        _codeBtn.layer.borderWidth = 1.5;
        
        [_codeBtn setTitleColor:MAIN_COLOR_RED_BUTTON forState:UIControlStateNormal];
        
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _codeBtn.frame = CGRectMake(kScreenWidth - 15 - 133, 5, 133, 50);
        
        _codeBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:15];
        
        [self.contentView addSubview:_codeBtn];
        
    }
    return self;
}
/**
 *  积分值的变化
 */
- (void)numberChange
{
    if ([self.textFielddelegate respondsToSelector:@selector(cashNumCell:numberChangeWithTextField:)])
    {
        [self.textFielddelegate cashNumCell:self numberChangeWithTextField:self.cashTextField];
    }
}

/**
 *  减号方法
 *
 *  @param sender button的类型
 */
- (void)cutButton:(UIButton *)sender
{
    if ([self.textFielddelegate respondsToSelector:@selector(cashCellBtnClick:flag:)])
    {
        [self.textFielddelegate cashCellBtnClick:self flag:sender.tag];
    }
}

/**
 *  加号
 *
 *  @param sender button的类型
 */
- (void)addButton:(UIButton *)sender
{
    if ([self.textFielddelegate respondsToSelector:@selector(cashCellBtnClick:flag:)])
    {
        [self.textFielddelegate cashCellBtnClick:self flag:sender.tag];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}


@end
