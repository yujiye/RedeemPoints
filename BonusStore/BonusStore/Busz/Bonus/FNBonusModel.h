//
//  FNBonusModel.h
//  BonusStore
//
//  Created by sugarwhi on 16/5/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNBaseArgs.h"

#import "FNCommon.h"

@interface FNBonusModel : FNBaseArgs

@property (nonatomic, copy) NSString * userId;

@property (nonatomic, assign) NSInteger  amount;

@end


@interface FNBonusDetailedModel :FNBaseArgs

@property (nonatomic, strong) NSNumber *amount;

@property (nonatomic, strong) NSNumber *inOrOut;

@property (nonatomic, strong) NSNumber *tradeId;

@property (nonatomic, strong) NSString *tradeTime;

@property (nonatomic, strong) NSNumber *trader;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSNumber *userId;

//@property (nonatomic, assign) FNBonusType  type;

- (NSString *)getBonusType;

- (NSString *)getBonusTypeDescWithType:(FNBonusType)type;

@end

@interface FNBounsRechargeListModel : FNBaseArgs

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, strong) NSNumber *cardName;

@property (nonatomic, strong) NSNumber *pieceValue;

@property (nonatomic, copy) NSString *rechargeType;

@property (nonatomic, copy) NSString *rechargeTime;

@end
