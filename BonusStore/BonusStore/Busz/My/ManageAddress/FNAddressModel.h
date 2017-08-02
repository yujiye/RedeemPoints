//
//  FNAddressModel.h
//  BonusStore
//
//  Created by feinno on 16/5/3.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FNAreaModel;
@interface FNAddressModel : NSObject

@property (nonatomic, assign) int id;  //地址ID

@property (nonatomic, copy) NSString *receiverName; // 收件人

@property (nonatomic, copy) NSString *mobile; //电话号码

@property (nonatomic, assign) int provinceId; //省ID

@property (nonatomic, copy) NSString *provinceName; //  省名

@property (nonatomic, assign) int  cityId;  // 市id

@property (nonatomic, copy) NSString * cityName;  //市名

@property (nonatomic, assign) int countyId; //区县

@property (nonatomic, copy) NSString *countyName;  //区县名

@property (nonatomic, copy) NSString *address;   //具体地址

@property (nonatomic, copy) NSString *postcode;  //邮编

@property (nonatomic, assign) int isDefault;  //是否是默认地址
@end
