//
//  FNUBSManager.h
//  BonusStore
//
//  Created by Nemo on 16/10/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

//Baidu UBS

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNUBSManager : NSObject

+ (void)configAll;

+ (void)ubsEvent:(NSString *)event;

+ (void)pageStart:(NSString *)page;

+ (void)pageEnd:(NSString *)page;

@end
