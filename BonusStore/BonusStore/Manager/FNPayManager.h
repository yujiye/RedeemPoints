//
//  FNPayManager.h
//  BonusStore
//
//  Created by Nemo on 16/4/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNHeader.h"

@interface FNPayManager : NSObject

+ (void)configAll;

+ (void)payWeChatWithResult:(id)result;

+ (void)payAliWithResult:(id)result;

+ (void)payHebaoWithResult:(id)result;

@end
