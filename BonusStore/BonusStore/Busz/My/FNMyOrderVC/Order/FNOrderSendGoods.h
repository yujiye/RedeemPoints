//
//  FNOrderSendGoods.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNOrderSendGoods : NSObject

@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * image;

@property (nonatomic, copy) NSString * num;

@property (nonatomic, copy) NSString * status;

@property (nonatomic, strong) NSArray * array;

+ (NSMutableArray *)goods;

@end
