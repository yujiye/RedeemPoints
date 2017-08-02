//
//  FNUpdateManager.m
//  BonusStore
//
//  Created by Nemo on 16/3/30.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNUpdateManager.h"

@implementation FNUpdateManager

+ (void)checkUpdate
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APP_ITUNES_ID]];
    
    NSString *content =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSRange substr = [content rangeOfString:@"\"version\":\""];
    
    NSRange range1 = NSMakeRange(substr.location+substr.length,10);
    
    NSRange substr2 =[content rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:range1];
    
    NSRange range2 = NSMakeRange(substr.location+substr.length, substr2.location-substr.location-substr.length);
    
    NSString *newVersion =[content substringWithRange:range2];
    
    if(![nowVersion isEqualToString:newVersion])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"版本有更新"delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新",nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@?ls=1&mt=8", APP_ITUNES_ID]];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
