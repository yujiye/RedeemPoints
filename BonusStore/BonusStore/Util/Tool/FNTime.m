//
//  FNTime.m
//  BonusStore
//
//  Created by Nemo on 16/5/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNTime.h"

@implementation FNTime

+ (NSString *)makeShowTime:(NSString *)time
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    
    
    NSDate *day =  [NSDate date];
    NSDate *ago = [df dateFromString:time];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* agoCom = [calendar components:unitFlags fromDate:ago];
    NSDateComponents* dayCom = [calendar components:unitFlags fromDate:day];
    
    NSString *value = nil;
    NSArray *tr = [time componentsSeparatedByString:@" "];
    
    value = [[tr objectAtIndex:0] substringToIndex:7];
    
    if (dayCom.day-agoCom.day && dayCom.hour-agoCom.hour)
    {
        value = [NSString stringWithFormat:@"%ld天%ld小时",dayCom.day - agoCom.day, 24 - agoCom.hour];
    }
    else if (dayCom.day-agoCom.day && (dayCom.hour - agoCom.hour == 0))
    {
        value = [NSString stringWithFormat:@"%ld天",dayCom.day - agoCom.day];
    }
    else if (dayCom.hour - agoCom.hour)
    {
        value = [NSString stringWithFormat:@"%ld小时",dayCom.hour - agoCom.hour];
    }
    else
    {
        value = @"";
    }
    
    return value;
}

@end
