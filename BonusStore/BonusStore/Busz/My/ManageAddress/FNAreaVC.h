//
//  FNAreaVC.h
//  BonusStore
//
//  Created by Nemo on 16/5/24.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

UIKIT_EXTERN NSMutableDictionary *FNAreaInfo;

@interface FNAreaVC : FNBaseVC

@property (nonatomic, assign) BOOL isProvice;

@property (nonatomic, strong) NSString *provinceId;

@property (nonatomic, strong) NSString *cityId;

@end
