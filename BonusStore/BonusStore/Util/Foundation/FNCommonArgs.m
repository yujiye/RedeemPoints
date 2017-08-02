//
//  YXCommonArgs.m
//  YueXin
//
//  Created by feinno on 15/7/14.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "FNCommonArgs.h"

@implementation FNCommonArgs : NSObject 


void UIReframeWithW(UIView *view, CGFloat w){
    CGRect rect = view.frame;
    rect.size.width = w;
    view.frame = rect;
}

void UIReframeWithH(UIView *view, CGFloat h){
    CGRect rect = view.frame;
    rect.size.height = h;
    view.frame = rect;
}

void UIReframeWithX(UIView *view, CGFloat x){
    CGRect rect = view.frame;
    rect.origin.x = x;
    view.frame = rect;
}

void UIReframeWithY(UIView *view, CGFloat y){
    CGRect rect = view.frame;
    rect.origin.y = y;
    view.frame = rect;
}

void UIReframeWithWAVG(UIView *view, CGFloat avg)
{
    if (view.superview)
    {
        CGRect superRect = view.superview.frame;
        CGRect rect = view.frame;
        rect.size.width = (superRect.size.width * avg);
        view.frame = rect;
    }
}

void UIReframeWithHAVG(UIView *view, CGFloat avg)
{
    if (view.superview)
    {
        CGRect superRect = view.superview.frame;
        CGRect rect = view.frame;
        rect.size.width = (superRect.size.height * avg);
        view.frame = rect;
    }
}

@end
