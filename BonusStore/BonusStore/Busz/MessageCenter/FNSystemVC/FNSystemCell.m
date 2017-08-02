//
//  FNSystemCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSystemCell.h"

@interface FNSystemCell ()

@property (nonatomic,assign)CGFloat height;

@end

@implementation FNSystemCell

+ (instancetype)systemTableView:(UITableView *)tabelView
{
    static NSString * reuserId = @"systemCell";
    
    FNSystemCell * cell = [tabelView dequeueReusableCellWithIdentifier:reuserId];
    
    if (cell == nil)
    {
        cell = [[FNSystemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, kScreenWidth, 20)];
        
        _title.font = [UIFont fontWithName:FONT_NAME_LTH size:16];
        
        [self.contentView addSubview:_title];
        
        _content = [[UILabel alloc]init];
        
        _content.numberOfLines = 0;
    
        _content.textColor = [UIColor colorWithRed:190.0/255 green:195.0/255 blue:190.0/255 alpha:1];
        
        _content.font = [UIFont fontWithName:FONT_NAME_LTH size:13];
        
        [self.contentView addSubview:_content];
    }
    return self;
}

- (void)setModel:(FNMessageArgs *)model
{
    _model = model;
    
    _title.text = model.title;
    _content.text = model.content;
    
    CGFloat titleHeight = [self textHeight:model.title];
    CGFloat height = [self textHeight:model.content]; //1.计算文本高度
    _content.frame = CGRectMake(15, titleHeight + 20, kScreenWidth - 30, height);
}


- (void)awakeFromNib {
}

-(CGFloat)textHeight:(NSString *)string{
    
    CGRect rect =[string boundingRectWithSize:CGSizeMake(394, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    return rect.size.height;//返回高度
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
