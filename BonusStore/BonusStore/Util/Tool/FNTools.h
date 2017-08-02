//
//  YXTools.h
//  YueXin
//
//  Created by feinno on 15/7/16.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FNTools : NSObject

+ (NSString *)md5FromHash:(NSString *)str;

+ (NSString *)md5FromData:(NSData *)data;

+ (NSString *)md5FromFile:(NSString *)file;

+ (UIColor *)getColor:(NSString *)hexColor;

+ (BOOL)predicateWithMobile:(NSString *)mobile;


+ (NSString *)base64StringFromText:(NSString *)text;

+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;


+ (NSString *)timeWithDate:(NSDate *)date;

+ (NSString *)timeWithInterval:(NSTimeInterval)interval;

+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

+ (NSData *)stringFromDes:(NSString *)des;


@end
