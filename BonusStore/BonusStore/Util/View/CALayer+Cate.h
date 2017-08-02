//
//  CALayer+Cate.h
//  BonusStore
//
//  Created by Nemo on 15/12/31.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FNHeader.h"

@interface CALayer (Cate)

//  Default color is (94, 94, 94).
+ (instancetype)layerWithFrame:(CGRect)frame;

+ (instancetype)layerWithFrame:(CGRect)frame color:(UIColor *)color;

@end
