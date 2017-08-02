//
//  FNMainItemTableSubCell.m
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainItemCollectionSubCell.h"
#import "FNHeader.h"

@interface FNMainItemCollectionSubCell ()
{
    FNSelectedItem _block;
}

@end

@implementation FNMainItemCollectionSubCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-10, frame.size.height-40)];
        
        _iconView.contentMode = UIViewContentModeScaleAspectFit;

        _iconView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.y + _iconView.height + 8, frame.size.width-10, 20)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.backgroundColor = [UIColor blueColor];
        
        [_titleLabel clearBackgroundWithFont:[UIFont fzltWithSize:8] textColor:MAIN_COLOR_GRAY_ALPHA];
        
        [_iconView addSubview:_titleLabel];
        
        
        CALayer *line = [CALayer layerWithFrame:CGRectMake(frame.size.width+5, -5.5, 1, frame.size.height)];
        
        [self.layer addSublayer:line];
    }
    
    return self;
}

- (void)setProduct:(FNProductArgs *)product
{
    NSString *p = [NSString stringWithFormat:@"积分价：%.0f",product.curPrice.floatValue * 100];
    
    _titleLabel.attributedText = [p setAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fzltWithSize:11]} range:NSMakeRange(4, p.length-4)];
    
    [self.iconView sd_setImageWithURL:IMAGE_ID(product.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
}

@end
