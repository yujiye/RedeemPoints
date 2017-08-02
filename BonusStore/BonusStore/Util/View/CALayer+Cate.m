//
//  CALayer+Cate.m
//  BonusStore
//
//  Created by Nemo on 15/12/31.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import "CALayer+Cate.h"

@implementation CALayer (Cate)


+ (instancetype)layerWithFrame:(CGRect)frame
{
    return [CALayer layerWithFrame:frame color:UIColorWith0xRGB(0xcccccc)];
}

+ (instancetype)layerWithFrame:(CGRect)frame color:(UIColor *)color
{
    CALayer *layer = [CALayer layer];
    
    layer.frame = frame;
    
    layer.backgroundColor = [color CGColor];
    
    return layer;
}

@end
