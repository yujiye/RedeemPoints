//
//  FNMyBonusCell.m
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMyBonusCell.h"

@interface FNMyBonusCell ()
{
    CALayer *_line;
}

@end

@implementation FNMyBonusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.width/2.0, 20)];
        
        _desLabel.font = [UIFont fzltWithSize:14];
        
        _desLabel.textColor = UIColorWithRGB(61, 61, 61);
        
        [self addSubview:_desLabel];

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_desLabel.x, _desLabel.y + _desLabel.height, self.width/2.0, 20)];
        
        _timeLabel.font = [UIFont fzltWithSize:11];
        
        _timeLabel.textColor = UIColorWithRGB(140, 140, 140);
        
        [self addSubview:_timeLabel];

        _bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth/2.0 + 5, 5, kWindowWidth/2.0-20, 40)];
        
        [_bonusLabel setVerticalCenterWithSuperView:self];
        
        _bonusLabel.font = [UIFont fzltWithSize:20];
        
        [self addSubview:_bonusLabel];
        
        _bonusLabel.textAlignment = NSTextAlignmentRight;
        
        _line = [CALayer layerWithFrame:CGRectMake(0, 44, kWindowWidth, 0.5)];
        
        [self.layer addSublayer:_line];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _line.frame = CGRectMake(0, 48-0.5, kWindowWidth, 0.5);
    
    UIReframeWithY(_timeLabel, _desLabel.y + _desLabel.height);
    
    [_bonusLabel setVerticalCenterWithSuperView:self];


}

@end
