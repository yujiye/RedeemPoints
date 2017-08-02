//
//  FNTouchShow.m
//  BonusStore
//
//  Created by cindy on 2017/2/10.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNTouchShow.h"
#import <Social/Social.h>
#import "FNTouchArgs.h"
@implementation FNTouchShow

+ (void)creatShortcutItemWithArr:(NSArray *)arr
{
    NSMutableArray *arrM = [NSMutableArray array];
    for(FNTouchArgs *touchArgs in arr)
    {
        UIApplicationShortcutIcon * icon = nil;
        
        if ([touchArgs.type isEqualToString:@"shareIcon"])
        {
            icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
        }
        else
        {
            icon = [UIApplicationShortcutIcon iconWithTemplateImageName:touchArgs.imageName];
        }
        
        UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:touchArgs.type localizedTitle:touchArgs.title  localizedSubtitle:nil icon:icon userInfo:nil];
        [arrM addObject:item];
    }
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = arrM.copy;
}

@end
