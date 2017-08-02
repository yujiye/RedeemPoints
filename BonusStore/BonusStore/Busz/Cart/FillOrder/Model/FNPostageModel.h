//
//  FNPostageModel.h
//  BonusStore
//
//  Created by feinno on 16/5/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseArgs.h"

@interface FNPostageModel : FNBaseArgs

@property (nonatomic,assign)int sellerId;// 商家id

@property (nonatomic,strong)NSString * postage; // 运费

@end
