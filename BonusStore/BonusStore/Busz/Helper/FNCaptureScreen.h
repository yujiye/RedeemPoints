//
//  FNCaptureScreen.h
//  BonusStore
//
//  Created by Nemo on 16/7/2.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FNHeader.h"

UIKIT_EXTERN NSString *FNCaptureScreenPath;

@interface FNCaptureScreen : NSObject

+ (UIImage *)getImageFromView:(UIView *)view;

+ (void)makeCaptureToImageByCG:(UIView *)captureView;

@end
