//
//  FNUserAccount.h
//  BonusStore
//
//  Created by Nemo on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FNAreaArgs.h"
#import "FNAreaModel.h"

UIKIT_EXTERN NSDictionary *FNUserAccountInfo;

UIKIT_EXTERN NSDictionary *FNUserWechatAccountInfo;

UIKIT_EXTERN BOOL isWechatLogin;

UIKIT_EXTERN NSString *FNTokenRefreshFPS;

UIKIT_EXTERN NSString *FNTokenRefreshLastTimeKey;

@interface FNUserAccountArgs : FNBaseArgs

@property (nonatomic, assign) int id; //地址ID

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *received;

@property (nonatomic, strong) NSString *mobileNo;

@property (nonatomic, strong) FNAreaModel *area;

//user login info
+ (void)setUserAccount:(NSDictionary *)account;

+ (NSDictionary *)getUserAccount;

+ (void)removeUserAccount;

//user info
+ (void)setUserAccountInfo:(NSDictionary *)info;

+ (void)insertValue:(NSString *)value key:(NSString *)key;

+ (void)getUserAccountInfo;

+ (void)removeUserAccountInfo;

+ (BOOL)isUserAccountInfoAvailable;

//wechat login account info
+ (void)setUserWechatAccountInfo:(id)info;

+ (void)getUserWechatAccountInfo;

+ (void)removeUserWechatAccountInfo;

@end

@interface FNPersonArgs : FNBaseArgs

@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSString *loginName;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *favImg;

@property (nonatomic, strong) NSString *birthday;

@property (nonatomic, strong) NSString *sex;

@property (nonatomic, strong) NSString *idCard;

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *tel;

@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *provinceId;

@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, strong) NSString *countyId;

@property (nonatomic, strong) NSString *provinceName;

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) NSString *countyName;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *postcode;

@property (nonatomic, strong) NSString *degree;

@property (nonatomic, strong) NSString *salary;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *serial;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *lastUpdateTime;

@end
