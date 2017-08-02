//
//  FNBonusRechargeRecordCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusRechargeRecordCell.h"

@implementation FNBonusRechargeRecordCell

+ (instancetype)bonusRechargeRecordCell:(UITableView *)tableView
{
    static NSString *reuserId = @"rechargeRecord";
    
    FNBonusRechargeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    
    if (cell == nil)
    {
        cell = [[FNBonusRechargeRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _rechargeNumLab = [[UILabel alloc]init];
         _rechargeNumLab.frame = CGRectMake(15, 17, kScreenWidth - 30-5-150,20);
        _rechargeNumLab.textAlignment = NSTextAlignmentLeft;
        _rechargeNumLab.numberOfLines = 0;
        _rechargeNumLab.font = [UIFont fzltWithSize:18];
        _rechargeNumLab.textColor = MAIN_COLOR_RED_ALPHA;
        [self addSubview:_rechargeNumLab];
        
        _rechargeTimeLab = [[UILabel alloc]init];
        _rechargeTimeLab.frame = CGRectMake(_rechargeNumLab.x+_rechargeNumLab.width+5, _rechargeNumLab.y, kScreenWidth - 30 -5-_rechargeNumLab.width, 20);
        _rechargeTimeLab.numberOfLines = 0;
        _rechargeTimeLab.textAlignment = NSTextAlignmentRight;
        _rechargeTimeLab.textColor = [UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1];
        _rechargeTimeLab.font = [UIFont fzltWithSize:12];
        [self addSubview:_rechargeTimeLab];
        
        _rechargePassLab = [[UILabel alloc]init];
        _rechargePassLab.frame = CGRectMake(_rechargeNumLab.x, _rechargeNumLab.y+20 + 5,_rechargeNumLab.width, 30);
        _rechargePassLab.numberOfLines = 0;
        _rechargePassLab.textColor = [UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];
        _rechargePassLab.font = [UIFont fzltWithSize:12];
        [self addSubview:_rechargePassLab];
        
        _rechargeTypeLab = [[UILabel alloc]init];
        _rechargeTypeLab.frame = CGRectMake(_rechargeNumLab.x+_rechargeNumLab.width+5, _rechargePassLab.y, kScreenWidth - 30 - 5 - _rechargePassLab.width,20);
        _rechargeTypeLab.textAlignment = NSTextAlignmentRight;
        _rechargeTypeLab.numberOfLines = 0;
        _rechargeTypeLab.textColor = [UIColor colorWithRed:121.0/255 green:121.0/255 blue:121.0/255 alpha:1];;
        _rechargeTypeLab.font = [UIFont fzltWithSize:14];
        [self addSubview:_rechargeTypeLab];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
