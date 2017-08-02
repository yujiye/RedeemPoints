//
//  FNImageArgs.h
//  BonusStore
//
//  Created by Nemo on 16/4/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

NS_ASSUME_NONNULL_BEGIN

@interface FNImageArgs : FNBaseArgs

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *height;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *imgKey;

@property (nonatomic, strong) NSString *isDelete;

@property (nonatomic, strong) NSString *jump;

@property (nonatomic, strong) NSString *lastUpdateTime;

@property (nonatomic, strong) NSString *width;

@property (nonatomic, strong) NSString *url;        //for product detail

@property (nonatomic, strong) NSString *pushDate;   //推送时间


@end

NS_ASSUME_NONNULL_END
