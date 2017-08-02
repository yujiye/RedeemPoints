//
//  FNDetailSkuModel.h
//  BonusStore
//
//  Created by sugarwhi on 16/6/16.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNDetailSkuModel : NSObject

@property (nonatomic, strong) NSArray *skuArr;

//颜色
@property (nonatomic, strong) NSDictionary *keyDictColor;

@property (nonatomic, strong) NSString *IDForColorDesc;

@property (nonatomic, strong) NSString *valueForColorDesc;

//颜色详情
@property (nonatomic, strong) NSMutableArray *valuesColorArr;

@property (nonatomic, strong) NSString *IDForColorValue;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSString *isReplace;

@property (nonatomic, strong) NSString *valueValues;

//尺码
@property (nonatomic, strong) NSMutableArray *sizeArr;

@property (nonatomic, strong) NSDictionary *keyDictSize;

@property (nonatomic, strong) NSString *IDForSizeDesc;

@property (nonatomic, strong) NSString *valueForSizeDesc;

@property (nonatomic, strong) NSString *sizeValue;

@end

