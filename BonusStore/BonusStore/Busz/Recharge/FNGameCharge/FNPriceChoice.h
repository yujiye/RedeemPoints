//
//  FNPriceChoice.h
//  BonusStore
//
//  Created by cindy on 2016/11/30.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PriceChoiceClickBlock) (NSString *sender);

@interface FNPriceChoice : UIViewController

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSString * price;

- (void)setPriceChoiceClick:(PriceChoiceClickBlock)block;

@end
