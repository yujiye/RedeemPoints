//
//  FNPersonalCell2.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPersonalCell2.h"

@interface FNPersonalCell2 ()

@property (nonatomic, strong) UILabel * man;

@property (nonatomic, strong) UILabel * woman;

@end

@implementation FNPersonalCell2

+ (instancetype)sexCell:(UITableView *)tabelView
{
    static NSString * reuseId = @"sexCell";
    
    FNPersonalCell2 * cell = [tabelView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil)
    {
        cell = [[FNPersonalCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,10 , kScreenWidth - 30, 30)];
        
        _sexLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];

        _sexLabel.textColor = MAIN_COLOR_BLACK_ALPHA;
        
        _sexLabel.textAlignment = NSTextAlignmentRight ;
        
        [self.contentView addSubview:_sexLabel];
        
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
