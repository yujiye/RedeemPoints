//
//  FNMainItemCell.m
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainItemCell.h"

@interface FNMainItemCell ()

@end

@implementation FNMainItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.width, self.width)];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _iconView.y+_iconView.height , self.width - 20, 30)];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = UIColorWith0xRGB(0x4A4A4A);
        [self.contentView addSubview:_titleLabel];
        
        _bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,self.height -14-10, _iconView.width*(3/5.0)-15, 14)];
        _bonusLabel.textColor = UIColorWith0xRGB(0xEF3030);
        _bonusLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView  addSubview:_bonusLabel];

        CGFloat priceWid =  self.width - 10- _bonusLabel.width;
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width- priceWid -10,self.height- 10-11, priceWid , 11)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = UIColorWith0xRGB(0x666666);
        _priceLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}



@end
