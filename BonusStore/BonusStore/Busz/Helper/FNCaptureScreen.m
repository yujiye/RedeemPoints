//
//  FNCaptureScreen.m
//  BonusStore
//
//  Created by Nemo on 16/7/2.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCaptureScreen.h"
#import "FNMacro.h"

NSString *FNCaptureScreenPath;

@implementation FNCaptureScreen

+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width, view.bounds.size.height), YES, 0);
    
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGFloat width = view.bounds.size.width * 2.0;
    
    CGFloat oy = 0;
    
    if (IS_IPHONE_6P || [[FNDevice machineModel] isEqualToString:@"iPhone 6 Plus"])
    {
        width = 1920;
        
        oy += 60;
    }
    
    CGRect rect = CGRectMake(0, 130+oy, width, view.frame.size.height);
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(viewImage.CGImage, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= @"screenShow.png";
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    [imageViewData writeToFile:savedImagePath atomically:YES];
    
    CGImageRelease(imageRefRect);
    
    UIImage *bgImage2 = [UIImage imageWithContentsOfFile:savedImagePath];//[[UIImage alloc]initWithContentsOfFile:savedImagePath];
    return bgImage2;
}

+ (void)makeCaptureToImageByCG:(UIView *)captureView{
    @autoreleasepool {
        size_t width = captureView.bounds.size.width;
        size_t height = captureView.bounds.size.height;
        
        unsigned char *imageBuffer = (unsigned char *)malloc(width*height*4);
        CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef imageContext =
        CGBitmapContextCreate(imageBuffer, width, height, 8, width*4, colourSpace,
                              kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
        
        CGContextTranslateCTM(imageContext, 0.0, height);
        CGContextScaleCTM(imageContext, 1.0, -1.0);
        
        CGColorSpaceRelease(colourSpace);
        
        [captureView.layer renderInContext:imageContext];
        captureView.layer.contents = nil;

        
        CGImageRef outputImage = CGBitmapContextCreateImage(imageContext);
        
        UIImage *captureImage = [UIImage imageWithCGImage:outputImage];
        
        NSData *data = UIImagePNGRepresentation(captureImage);
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *capPath = [path stringByAppendingPathComponent:@"capImage.png"];
        
        FNCaptureScreenPath = capPath;
        
        [data writeToFile:capPath atomically:YES];
        
        CGImageRelease(outputImage);
        CGContextRelease(imageContext);
        free(imageBuffer);
    }
}

@end
