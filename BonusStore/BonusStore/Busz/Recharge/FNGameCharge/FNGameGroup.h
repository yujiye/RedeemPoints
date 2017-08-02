//
//  FNGameGroup.h
//  BonusStore
//
//  Created by cindy on 2016/11/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNGameGroup : NSObject

@property (nonatomic, copy)NSString * py;

@property (nonatomic, strong)NSMutableArray * listGame;

+ (NSDictionary *)mj_objectClassInArray;

@end
