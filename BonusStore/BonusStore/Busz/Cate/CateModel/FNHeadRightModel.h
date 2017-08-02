//
//  FNHeadRightModel.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FNBaseArgs.h"

@interface FNHeadRightModel : FNBaseArgs

@property(copy, nonatomic) NSNumber *pid;

@property(copy, nonatomic) NSNumber *isLeaf;

@property(copy, nonatomic) NSString *img_key;

@property(copy, nonatomic) NSString *subjectId;

@property(copy, nonatomic) NSString *subjectName;

@end
