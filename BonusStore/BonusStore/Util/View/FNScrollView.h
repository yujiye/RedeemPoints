//
//  FNScrollView.h
//  BonusStore
//
//  Created by Nemo on 17/5/5.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNCommon.h"

@interface FNScrollView : UIScrollView

- (void)touchStateChangeBlock:(void (^) (FNTouchState state))block;

@end
