//
//  FNPayCell.m
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPayCell.h"

@implementation FNPayCell

+ (instancetype)dequeueReusableWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"FNPayCell";
    
    FNPayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[FNPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _checkView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
        
        [_checkView setVerticalCenterWithSuperView:self];

        _checkView.image = [UIImage imageNamed:@"pay_check_n"];
        
        [self addSubview:_checkView];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(_checkView.x + _checkView.width+10, 0, 156, 39)];
        
        [self addSubview:_iconView];
        
        [_iconView setVerticalCenterWithSuperView:self];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.x + _iconView.width+10, 0, kWindowWidth-150, 30)];
        
        [_titleLabel clearBackgroundWithFont:[UIFont fzltWithSize:16] textColor:MAIN_COLOR_GRAY_ALPHA];
        
        [self addSubview:_titleLabel];

        [_titleLabel setVerticalCenterWithSuperView:self];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_checkView setVerticalCenterWithSuperView:self];
    
    [_iconView setVerticalCenterWithSuperView:self];
    
    [_titleLabel setVerticalCenterWithSuperView:self];
}

- (void)setPay:(FNPayWayArgs *)pay
{
    _iconView.image = [UIImage imageNamed:pay.icon];
    
    _titleLabel.text = pay.des;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
