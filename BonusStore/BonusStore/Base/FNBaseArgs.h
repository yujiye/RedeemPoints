//
//  FNBaseArgs.h
//  BonusStore
//
//  Created by Nemo on 16/3/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNBaseArgs : NSObject

+ (__kindof NSObject *)makeEntityWithJSON:(NSDictionary *)json;

@end
