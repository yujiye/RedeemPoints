//
//  FNSearchResultView.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/27.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSearchResultView.h"


@implementation FNSearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hotBtn.frame = CGRectMake(0, 0,kScreenWidth/3-1 , 44);
        _hotBtn.titleLabel.font = [UIFont fzltWithSize:15];
        [_hotBtn setTitle:@"热门" forState:UIControlStateNormal];
        [_hotBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        [self addSubview:_hotBtn];
        
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/3-1, 8, 1, 28)];
        line1.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:line1];
        
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _priceBtn.frame = CGRectMake(line1.x+1, _hotBtn.y, _hotBtn.width, _hotBtn.height);
        _priceBtn.titleLabel.font = [UIFont fzltWithSize:15];
        [_priceBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [self addSubview:_priceBtn];
        CGFloat priceLabX;
        if (IS_IPHONE_5)
        {
            priceLabX = 20;
        }
        else
        {
            priceLabX = 31;
        }
        
        _priceImg = [[UIImageView alloc]initWithFrame:CGRectMake(_priceBtn.width - priceLabX - 14, 15, 14, 15)];
        _priceImg.image = [UIImage imageNamed:@"price_default"];
        [_priceBtn addSubview:_priceImg];
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(_priceBtn.x+_priceBtn.width, line1.y, line1.width, line1.height)];
        line2.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:line2];
        
        _updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateBtn.frame = CGRectMake(line2.x+1, _priceBtn.y, _priceBtn.width, _priceBtn.height);
        _updateBtn.titleLabel.font = [UIFont fzltWithSize:15];
        [_updateBtn setTitle:@"最新" forState:UIControlStateNormal];
        [_updateBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        [self addSubview:_updateBtn];
        
    }
    return self;
}



@end
