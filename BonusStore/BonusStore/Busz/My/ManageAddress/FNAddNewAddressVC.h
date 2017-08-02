//
//  FNAddNewAddressVC.h
//  BonusStore
//
//  Created by qingPing on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNAddressModel.h"


@interface FNAddNewAddressVC : UIViewController

// 是否是编辑页跳转过来的
@property (nonatomic,assign) BOOL isEdit;

// 是否是添加第一个地址
@property (nonatomic,assign) BOOL isFirstAddress;

@property (nonatomic, strong) FNAddressModel * addressModel;

@end
