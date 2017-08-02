//
//  FNMainBtn.m
//  BonusStore
//
//  Created by cindy on 2016/11/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainBtn.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

@implementation FNMainBtn


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        CGFloat Y ;
//        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
//        {
//            Y = 10;
//        }else
//        {
//           Y = 12;
//        }
        CGFloat margin = (screenWidth - 45* 5)/10.0;
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, 0, 45,45)];
        self.imgView = imgView;
        [self addSubview:self.imgView];
        CGFloat titleLabY = CGRectGetMaxY(self.imgView.frame)+ 5;
//        CGFloat font;
//        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
//        {
//            font = 10;
//        }else
//        {
//            font = 11;
//        }
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,titleLabY , self.bounds.size.width, 11)];
        self.titleLab = titleLab;
        titleLab.font = [UIFont systemFontOfSize:10];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLab];
    }
    return self;
}

@end
