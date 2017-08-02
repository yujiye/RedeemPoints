//
//  FNShipModel.h
//  BonusStore
//
//  Created by feinno on 16/5/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface FNShipModel : NSObject

@property (nonatomic, assign) NSInteger id ;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSMutableArray *traceJson;

@end

@interface FNTraceModel : NSObject

@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * ftime;
@property (nonatomic, copy) NSString * context;
@end