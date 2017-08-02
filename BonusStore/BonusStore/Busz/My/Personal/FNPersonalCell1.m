//
//  FNPersonalCell1.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPersonalCell1.h"


@implementation FNPersonalCell1

+ (instancetype)headCell:(UITableView *)tableview
{
    static NSString * reuseId = @"headCell";
    
    FNPersonalCell1 * cell = [tableview dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil)
    {
        cell = [[FNPersonalCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _headImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_default"]];
        
        _headImage.frame = CGRectMake(kScreenWidth - 62 - 30,8 , 58, 58);
        
        [self.contentView addSubview:_headImage];

        _headImage.layer.masksToBounds = YES;
        
        _headImage.contentMode = UIViewContentModeScaleAspectFit;
        
        _headImage.layer.cornerRadius = 58 / 2.0f;
       
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
