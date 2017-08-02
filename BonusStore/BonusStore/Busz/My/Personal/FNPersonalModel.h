//
//  FNPersonalModel.h
//  BonusStore
//
//  Created by sugarwhi on 16/5/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNBaseArgs.h"

@interface FNPersonalModel : FNBaseArgs

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *favImg;

@property (nonatomic, strong) NSString *favImgPath;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, strong) NSString *birthday;

@property (nonatomic, strong) NSString *mobile;

- (NSString *)getGender;

- (NSString *)getGenderBySex:(NSInteger)sex;

@end