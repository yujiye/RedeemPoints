//
//  NSDecimalNumber+Cate.h
//  BonusStore
//
//  Created by Nemo on 16/9/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDecimalNumber (Cate)

+ (NSDecimalNumber *)decimalWithString:(NSString *)string;

+ (NSDecimalNumber *)decimalBy:(CGFloat)num;

- (NSDecimalNumber *)addBy:(CGFloat)add;

- (NSDecimalNumber *)subtractBy:(CGFloat)sub;

- (NSDecimalNumber *)multiplyingBy:(CGFloat)multi;

- (NSDecimalNumber *)dividingBy:(CGFloat)divid;

@end
