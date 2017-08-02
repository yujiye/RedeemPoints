//
//  FNSearchNameVC.h
//  BonusStore
//
//  Created by cindy on 2016/11/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FNGameDetail;

typedef void (^SearchNameClickBlock) (FNGameDetail *sender);

@interface FNSearchNameVC : UIViewController

- (void)setSearchNameClickBlock:(SearchNameClickBlock)searchNameClickBlock;

@end
