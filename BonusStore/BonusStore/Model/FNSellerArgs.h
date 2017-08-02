//
//  FNSellerArgs.h
//  BonusStore
//
//  Created by Nemo on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

@interface FNSellerArgs : FNBaseArgs

@property (nonatomic, strong) NSString *sellerId;

@property (nonatomic, strong) NSString *sellerName;

@property (nonatomic, strong) NSString *buyerComment;

@property (nonatomic, strong) NSArray *productList;

@end
