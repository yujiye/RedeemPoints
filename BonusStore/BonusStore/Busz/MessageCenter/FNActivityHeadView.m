//
//  FNActivityHeadView.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNActivityHeadView.h"
@implementation FNActivityHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _time = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, kScreenWidth, 12)];
        _time.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        _time.textAlignment = NSTextAlignmentCenter;
        _time.textColor = MAIN_COLOR_BLACK_ALPHA;
        [self addSubview:_time];
    }
    return self;
}


@end
