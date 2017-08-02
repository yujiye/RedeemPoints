//
//  YXCommonArgs.h
//  YueXin
//
//  Created by feinno on 15/7/14.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FNCommonArgs : NSObject

void UIReframeWithW(UIView *view, CGFloat w);

void UIReframeWithH(UIView *view, CGFloat h);

void UIReframeWithX(UIView *view, CGFloat x);

void UIReframeWithY(UIView *view, CGFloat y);

void UIReframeWithWAVG(UIView *view, CGFloat avg);

void UIReframeWithHAVG(UIView *view, CGFloat avg);

@end
