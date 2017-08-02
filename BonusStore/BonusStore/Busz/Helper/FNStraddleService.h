//
//  FNStraddleService.h
//  BonusStore
//
//  Created by Nemo on 16/4/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNCommon.h"

extern FNStraddleType FNStraddleServiceType;

/**
 *  When you interaction with others app, you may use this class.
 */
@interface FNStraddleService : NSObject

+ (void)setStraddleType:(FNStraddleType)type;

@end
