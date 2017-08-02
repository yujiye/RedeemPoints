//
//  FNAreaArgs.h
//  BonusStore
//
//  Created by Nemo on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

@interface FNAreaArgs : FNBaseArgs

@property (nonatomic, strong) NSString *provinceId;

@property (nonatomic, strong) NSString *provinceName;

@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) NSString *countyId;

@property (nonatomic, strong) NSString *countyName;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *postCode;

@property (nonatomic, assign) int isDefault;

@end
