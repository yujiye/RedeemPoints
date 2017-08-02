//
//  FNProductArgs.h
//  BonusStore
//
//  Created by Nemo on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNBaseArgs.h"

@interface FNProductArgs : FNBaseArgs


@property (nonatomic, strong) NSString *sellerId;

@property (nonatomic,assign)int orderType;

@property (nonatomic, strong)NSString *closingPrice;

@property (nonatomic, strong)NSString *payChannel;

@property (nonatomic, strong) NSString *sellerName;

@property (nonatomic,copy)NSString * tradeCode;

@property (nonatomic, strong) NSString *productId;//

@property (nonatomic, strong) NSString *productName;

@property (nonatomic, strong) NSString *viceName;

@property (nonatomic, strong) NSString *productDesc;

@property (nonatomic, strong) NSString *productAttribute;

@property (nonatomic, strong) NSString *skuNum;

@property (nonatomic, strong) NSDictionary *sku;

@property (nonatomic, strong) NSString *skuName;

@property (nonatomic, strong) NSNumber *count;

@property (nonatomic, strong) NSNumber *curPrice;//

@property (nonatomic, strong) NSNumber *minCurPrice;

@property (nonatomic, strong) NSNumber *orgPrice;//

@property (nonatomic, strong) NSString *imgKey;

@property (nonatomic, strong) NSNumber *postage;//

@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *maxCurPrice;

@end

@interface FNProductDetailArgs : FNBaseArgs

@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, strong) NSNumber *orderstate;

@property (nonatomic, strong) NSString *mobileNo;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *comment;

@property (nonatomic, strong) NSString *closingPrice;

@property (nonatomic, strong) NSString *exchangeScore;

@property (nonatomic, strong) NSNumber *payChanel;

@property (nonatomic, strong) NSString *couponCode;

@property (nonatomic, strong) NSNumber *curTime;

@property (nonatomic, strong) FNProductArgs *productList;

@end

@interface FNHotSearchModel : FNBaseArgs

@property (nonatomic, copy)NSString *moduleId;

@property (nonatomic, copy)NSString *relaId;

@property (nonatomic, copy)NSString *relaImgkey;

@property (nonatomic, copy)NSString *productRuleId;

@property (nonatomic, copy)NSString *relaSort;

@property (nonatomic, copy)NSString *createTime;

@property (nonatomic, copy)NSString *updateTime;

@end


@interface FNAdvertOfConfig : FNBaseArgs

@property (nonatomic, copy)NSString *imgKey;

@property (nonatomic, assign)NSInteger advertId;

@property (nonatomic, copy)NSString *slotName;

@property (nonatomic, copy)NSString *remark;

@property (nonatomic, copy)NSString *jump;

@property (nonatomic, assign)NSInteger isOnline;

@property (nonatomic, assign)NSInteger sort;

@property (nonatomic, copy)NSString *startTime;

@property (nonatomic, copy)NSString *endTime;

@property (nonatomic, copy)NSString *createTime;

@end

@interface FNMainModelConfigOfProduct : FNBaseArgs

@property (nonatomic, copy)NSString *relaId;

@property (nonatomic, copy)NSString *relaImgkey;

@property (nonatomic, copy)NSString *relaSort;

@property (nonatomic, copy)NSString *updateTime;

@property (nonatomic, copy)NSString *orgPrice;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *moduleId;

@property (nonatomic, copy)NSString *productRuleId;

@property (nonatomic, strong) NSNumber *curPrice;

@property (nonatomic, copy)NSString *createTime;

@end


