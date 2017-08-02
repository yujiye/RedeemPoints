//
//  UIImage+Cate.h
//  BonusStore
//
//  Created by Nemo on 15/12/31.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FNConfig.h"

@interface UIImage (Cate)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithDiameter:(CGFloat)diameter color:(UIColor *)color;

+ (UIImage *)imageWithDiameter:(CGFloat)diameter named:(NSString *)name;

+ (UIImage *)imageWithDiameter:(CGFloat)diameter image:(UIImage *)image;


NSURL * IMAGE_ID(NSString *ID);

NSURL * IMAGE_ID_SIZE(NSString *ID, CGFloat size);

@end
