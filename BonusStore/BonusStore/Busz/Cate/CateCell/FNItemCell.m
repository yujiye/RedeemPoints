//
//  FNItemCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNItemCell.h"

@interface FNItemCell ()

@property (nonatomic, strong) UILabel * moneyLabel;

@end

@implementation FNItemCell

+ (instancetype)sellerItemTableView:(UITableView *)tableView
{
    static NSString *sellerId = @"sellerCell";
    FNItemCell *cell = [tableView dequeueReusableCellWithIdentifier:sellerId];
    if (cell == nil)
    {
        cell = [[FNItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sellerId];
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imageName = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 108, 108)];
        
        self.imageName.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:self.imageName];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(15 +_imageName.x + _imageName.width, 30, kScreenWidth - self.imageName.width - 15 - 10 -15, 40)];
        
        self.title.numberOfLines = 0;
        
        self.title.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:self.title];

        CGFloat moneyH = [UIFont systemFontOfSize:16].lineHeight;
        
        self.money = [[UILabel alloc]initWithFrame:CGRectMake(_imageName.x + 15 +_imageName.width, 15 + _title.y+40, 110, moneyH)];
        
        self.money.textColor = [UIColor redColor];
        
        self.money.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:self.money];
        
        self.integration = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 15-90, _money.y, 90,moneyH )];
        
        self.integration.textAlignment = NSTextAlignmentRight;
        
        self.integration.font = [UIFont systemFontOfSize:12];
        
        self.integration.textColor = MAIN_COLOR_GRAY_ALPHA;
        
        [self.contentView addSubview:self.integration];

        UILabel * separator = [[UILabel alloc]initWithFrame:CGRectMake(_imageName.x+_imageName.width, 116, kScreenWidth - _imageName.width-30,1 )];
        
        separator.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        [self.contentView addSubview:separator];
      
        
    }
    return self;
}

- (void)setModel:(FNItemModel *)model
{
    _model = model;

    self.title.text = _model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
