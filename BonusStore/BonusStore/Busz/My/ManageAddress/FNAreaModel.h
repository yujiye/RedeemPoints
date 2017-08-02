//
//  FNAreaModel.h
//  BonusStore
//
//  Created by feinno on 16/5/3.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNAreaModel : NSObject

@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, assign) NSInteger countyId;
@property (nonatomic, copy) NSString * provinceName;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, copy) NSString * countyName;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *postCode;

@property (nonatomic, assign) int isDefault;
@end
