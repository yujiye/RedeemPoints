//
//  FNFlowRechargeModel.h
//  BonusStore
//
//  Created by cindy on 2016/11/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNFlowRechargeModel : NSObject

@property(nonatomic,copy) NSString *flowName; //名称

@property(nonatomic,copy) NSString *pieceValue; //单价

@property(nonatomic,copy) NSString *flowno; //流量卡券编码

+(NSMutableArray *)mobileArray;

@end
