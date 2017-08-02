//
//  FNLoadingView.h
//  BonusStore
//
//  Created by Nemo on 16/5/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNLoadingView : UIView

+ (void)showInView:(UIView *)view;

+ (void)showInView:(UIView *)view text:(NSString *)text;

+ (void)hideFromView:(UIView *)view;

+ (void)hide;

@end

@interface FNLoadingLock : NSObject

@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, strong) NSMutableDictionary *list;

+ (instancetype)shared;

@end
