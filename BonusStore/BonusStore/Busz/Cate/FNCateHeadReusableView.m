//
//  FNCateHeadReusableView.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/18.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCateHeadReusableView.h"

#import "Masonry.h"

@implementation FNCateHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat font;
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
        {
            font = 12;
        }
        else
        {
            font = 14;
        }
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 17, 120, 14)];
        
        _titleLable.textAlignment = NSTextAlignmentLeft;
        
        _titleLable.font = [UIFont fontWithName:FONT_NAME_LTH size:font];
        
        [self addSubview:_titleLable];
        
        _checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _checkBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        CGFloat btnH = [UIFont systemFontOfSize:14].lineHeight;
        
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"body_Btn_all"] forState:UIControlStateNormal];
        
        [self addSubview:_checkBtn];
        
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(17);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(btnH);
            make.width.mas_equalTo(0);
        }];
        
       
        _checkAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _checkAllBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:font];
        
        [_checkAllBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [self addSubview:_checkAllBtn];
        
        [_checkAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_checkBtn.mas_left).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(4);
            make.width.mas_equalTo(98);
            make.height.mas_equalTo(40);
        }];
        _hotCheckBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _hotCheckBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:font];
        
        [_hotCheckBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [self addSubview:_hotCheckBtn];
        
        [_hotCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_checkBtn.mas_left).offset(0);
            make.top.mas_equalTo(self.mas_top).offset(4);
            make.width.mas_equalTo(98);
            make.height.mas_equalTo(40);
        }];

    }
    return self;
}

@end
