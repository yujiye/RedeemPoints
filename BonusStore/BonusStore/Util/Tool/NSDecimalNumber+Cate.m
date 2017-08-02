//
//  NSDecimalNumber+Cate.m
//  BonusStore
//
//  Created by Nemo on 16/9/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "NSDecimalNumber+Cate.h"

@implementation NSDecimalNumber (Cate)

+ (NSDecimalNumber *)decimalWithString:(NSString *)string
{
    return [NSDecimalNumber decimalNumberWithString:string];
}

+ (NSDecimalNumber *)decimalBy:(CGFloat)num
{
    return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",num]];
}

- (NSDecimalNumber *)addBy:(CGFloat)add
{
    return [self decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",add]]];
}

- (NSDecimalNumber *)subtractBy:(CGFloat)sub
{
    return [self decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",sub]]];
}

- (NSDecimalNumber *)multiplyingBy:(CGFloat)multi
{
    return [self decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",multi]]];
}

- (NSDecimalNumber *)dividingBy:(CGFloat)divid
{
    return [self decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",divid]]];
}

@end
