//
//  NSString+Cate.h
//  BonusStore
//
//  Created by feinno on 16/1/24.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Cate)

+(BOOL)isEmptyString:(NSString *)valueStr;

- (BOOL)isEmpty;

- (NSString *)urlEncodeString;

- (BOOL)isMobile;

-(CGSize)contentSizeWithMaxWidth:(CGFloat)maxWidth;

-(CGSize)contentSizeWithMaxWidth:(CGFloat)maxWidth attributes:(NSDictionary *)attributes;

-(NSComparisonResult)strCompare:(NSString *)str;

- (NSMutableAttributedString *)setAttributes:(NSDictionary *)attrs range:(NSRange)range;


/**
 *  设置属性字符串
 *  @param attributeStr 需要设置的字符串
 *  @param textColor    颜色
 *  @param textFont     字体大小
 *  @return 需要的属性字符串
 */
-(NSMutableAttributedString *)makeStr:(NSString *)attributeStr withColor:(UIColor *)textColor andFont:(UIFont *)textFont;
/**
 *  给属性字符串中的某个值设置新属性
 *  @param attributedString 原属性字符串
 *  @param needAttStr       需要设置的字符串
 *  @param textColor        颜色
 *  @param font             字体大小
 *  @return 需要的属性字符串
 */
+(NSMutableAttributedString *)attributedStr:(NSMutableAttributedString*)attributedString makeStr:(NSString *)needAttStr withColor:(UIColor *)textColor andFont:(UIFont *)textFont;
@end
