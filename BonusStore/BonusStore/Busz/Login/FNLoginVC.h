//
//  FNLoginVC.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

UIKIT_EXTERN BOOL FNLoginIsScan;

@interface FNLoginVC : UIViewController

- (void)goMainWithBlock:(void (^) (void))block;

- (void)goSelectedVCWithBlock:(void (^) (void))block;

@property (nonatomic, assign)BOOL isAuthFail;       //是否鉴权失败

@end
