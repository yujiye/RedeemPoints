//
//  FNGetCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNGetCell.h"

#import "UIFont+Cate.h"

@implementation FNGetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _name = [[UILabel alloc]init];
        
        _name.frame = CGRectMake(15, 16 , 100, 16);
        
        _name.font = [UIFont fontWithName:FONT_NAME_LTH_BOLD size:16];
        
        [self.contentView addSubview:_name];
        
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _button.frame = CGRectMake(kScreenWidth - 30 ,20 ,15 , 8);
        
        [_button setImage:[UIImage imageNamed:@"main_rank_more"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:_button];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
