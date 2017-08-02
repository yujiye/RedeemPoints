//
//  FNVirfulOrderVC.h
//  BonusStore
//
//  Created by feinno on 16/5/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNCartGroupModel.h"
@interface FNVirfulOrderVC : UIViewController

@property (nonatomic,strong) NSMutableArray * fillOrderDataSource;  //all product info

@property (nonatomic,assign)int  maxCount;

@end
