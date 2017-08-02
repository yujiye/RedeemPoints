//
//  FNDetailVC.h
//  BonusStore
//
//  Created by feinno on 16/6/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"
#import "FNAddressModel.h"

@interface FNDetailVC : UIViewController

@property (nonatomic, copy) NSString * productId;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, strong) FNAddressModel * addressModel;

@property (nonatomic,assign) BOOL fromOtherApp;

@end
