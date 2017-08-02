//
//  FNCateHotCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/18.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCateHotCell.h"

#import "FNHeader.h"

@implementation FNCateHotCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _hotImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 93, 93)];
        
        _hotImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:_hotImage];
        
        _title = [[UILabel alloc]initWithFrame:CGRectMake(_hotImage.x+93+3, 10, self.contentView.width - 110, 60)];
        
        _title.numberOfLines = 0;
        
        _title.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:_title];
        
        _integral = [[UILabel alloc]initWithFrame:CGRectMake(_hotImage.x + 96, 75,kScreenWidth-93 , 30)];
        
        _integral.font = [UIFont systemFontOfSize:14];
        
        _integral.textColor = [UIColor redColor];
        
        [self.contentView addSubview:_integral];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.x + 6,self.contentView.height-2 , self.contentView.width - 12, 1)];
        
        label.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        [self.contentView addSubview:label];
    }
    return self;
}

@end
