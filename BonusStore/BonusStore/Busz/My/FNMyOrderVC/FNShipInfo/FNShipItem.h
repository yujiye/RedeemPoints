//
//  FNLogisInformationItem.h
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNShipItem : NSObject
@property (nonatomic,copy)NSString * logText;
@property (nonatomic ,copy)NSString * logNumber;
@property (nonatomic, copy)NSString *logInformation;

+(NSMutableArray *)logisInformationItems;
@end
