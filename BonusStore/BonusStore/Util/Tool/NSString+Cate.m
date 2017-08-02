//
//  NSString+Cate.m
//  BonusStore
//
//  Created by feinno on 16/1/24.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "NSString+Cate.h"

@implementation NSString (Cate)
//判断字符串是否为空
+(BOOL)isEmptyString:(NSString *)valueStr
{
    if ([valueStr isKindOfClass:[NSString class]]) {
        if (valueStr == nil || [valueStr isEqualToString:@""] || [valueStr isEqualToString:@"(null)"]|| [valueStr isEqualToString:@"(NULL)"]||[valueStr isEqualToString:@"<null>"]||[valueStr isEqualToString:@"null"]) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
    
}

- (BOOL)isEmpty
{
    return [NSString isEmptyString:self];
}

- (NSString *)urlEncodeString
{
    NSString *encodedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)self, nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}

- (BOOL)isMobile
{
    NSString *pattern = @"^((13[0-9])|(17[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    return [pred evaluateWithObject:self];
}

-(CGSize)contentSizeWithMaxWidth:(CGFloat)maxWidth{
    return [self contentSizeWithMaxWidth:maxWidth attributes:nil];
}
-(CGSize)contentSizeWithMaxWidth:(CGFloat)maxWidth attributes:(NSDictionary *)attributes{
    CGSize contentSize = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                            options:
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                         attributes:attributes
                                            context:nil].size;
    return contentSize;
    
}
-(void)ssd{
    NSString *st = @"";
    NSString *St = @"";
    [st compare:St options:NSOrderedAscending];
}

-(NSComparisonResult)strCompare:(NSString *)str{
    
    return [self compare:str options:NSOrderedAscending];
    
}

- (NSMutableAttributedString *)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self];
    
    [string addAttributes:attrs range:range];
    
    return string;
}


/**
 *  设置属性字符串
 */
- (NSMutableAttributedString *)makeStr:(NSString *)attributeStr withColor:(UIColor *)textColor andFont:(UIFont *)textFont
{
    NSRange range = [self rangeOfString:attributeStr];
    NSMutableAttributedString * attributedString =[[NSMutableAttributedString alloc]initWithString:self];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: textColor,NSFontAttributeName:textFont} range:range];
    return attributedString;
    
}
+ (NSMutableAttributedString *)attributedStr:(NSMutableAttributedString *)attributedString makeStr:(NSString *)needAttStr withColor:(UIColor *)textColor andFont:(UIFont *)textFont
{
    NSRange range = [attributedString.string rangeOfString:needAttStr];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: textColor,NSFontAttributeName:textFont} range:range];
    return attributedString;
}
@end
