//
//  UIImage+Cate.m
//  BonusStore
//
//  Created by Nemo on 15/12/31.
//  Copyright © 2015年 nemo. All rights reserved.
//

#import "UIImage+Cate.h"

@implementation UIImage (Cate)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithDiameter:(CGFloat)diameter color:(UIColor *)color
{
    UIImage *image = [self imageWithColor:color];
    
    return [self imageWithDiameter:diameter image:image];
}

+ (UIImage *)imageWithDiameter:(CGFloat)diameter named:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    
    return [self imageWithDiameter:diameter image:image];
}

+ (UIImage *)imageWithDiameter:(CGFloat)diameter image:(UIImage *)image
{
    CGRect frame = CGRectMake(0, 0, diameter, diameter);
    
    UIImage *newly = nil;
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:diameter];
        
        [path addClip];
        
        [image drawInRect:frame];
        
        CGContextSetFillColorWithColor(context, [[UIColor colorWithWhite:0.1 alpha:0.3] CGColor]);
        
        CGContextFillEllipseInRect(context, frame);
        
        newly = UIGraphicsGetImageFromCurrentImageContext();
        
        CGContextRestoreGState(context);
    }
    UIGraphicsEndImageContext();
    
    return image;
}

//NSURL * IMAGE_CHANNELID(NSInteger channelID, NSString *key)
//{
//    if (channelID == 63)
//    {
//        return [NSURL URLWithString:key];
//    }
//    
//    return IMAGE_ID(key);
//}

NSURL * IMAGE_ID(NSString *ID)
{
//    if([ID hasPrefix:@"http"])
//    {
//        return [NSURL URLWithString:ID];
//    }else
//    {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",URL_BASE,URL_IMAGE_BASE,ID]];
//    }
}


NSURL * IMAGE_ID_SIZE(NSString *ID, CGFloat size)
{
    NSArray *com = [ID componentsSeparatedByString:@"."];
    
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:URL_IMAGE_BASE];
    
    [string appendString:com[0]];
    
    [string appendFormat:@"_%fx%f.%@",size,size,com[1]];

    return [NSURL URLWithString:string];
}

@end
