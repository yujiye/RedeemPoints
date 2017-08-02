//
//  FNMainDetailCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainDetailCell.h"

@implementation FNMainDetailCell

+ (instancetype)mainDetailCellTableView:(UITableView *)tableView
{
    
    NSString *reuseId = @"mainDetailCell";
    FNMainDetailCell *cell= [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil)
    {
        cell = [[FNMainDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 11, kScreenWidth - 30, 20)];
        _shopNameLab.font = [UIFont systemFontOfSize:13];
        _shopNameLab.textColor = [UIColor lightGrayColor];
        [self addSubview:_shopNameLab];
        
        _leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, _shopNameLab.y+_shopNameLab.height+10, 18, 18)];
        _leftImg.layer.masksToBounds = YES;
        _leftImg.image = [UIImage imageNamed:@"freight_bg"];
        _leftImg.layer.cornerRadius = 4.0;
        _leftImg.hidden = YES;
        [self addSubview:_leftImg];
        
        _freightLab = [[UILabel alloc]initWithFrame:CGRectMake(_leftImg.x+_leftImg.width + 6, _leftImg.y-2, kScreenWidth - 30 - 6-_leftImg.width, 25)];
        _freightLab.textColor = MAIN_COLOR_RED_ALPHA;
        _freightLab.font = [UIFont systemFontOfSize:15];
        _freightLab.hidden = YES;
        [self addSubview:_freightLab];
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

@end
