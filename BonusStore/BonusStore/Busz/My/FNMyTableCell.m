//
//  FNMyTableCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMyTableCell.h"

#import "Masonry.h"

@implementation FNMyTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CALayer *line = [CALayer layerWithFrame:CGRectMake(0, 0, kWindowWidth, 1) color:MAIN_BACKGROUND_COLOR];
        
        [self.layer addSublayer:line];
        
        self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 24, 24)];
        
        [self.contentView addSubview:self.leftImage];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.leftImage.x+self.leftImage.width+15,self.leftImage.y+1 , 200, 21)];
        
        self.nameLabel.font = [UIFont fzltWithSize:16];
        
        [self.contentView addSubview:self.nameLabel];
        
        UIImageView *indicator = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 20, self.leftImage.y+5, 6, 12)];
        
        [self.contentView addSubview:indicator];
        
        indicator.image = [UIImage imageNamed:@"main_rank_more"];

    }
    return self;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
