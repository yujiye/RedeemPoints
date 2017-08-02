//
//  FNTouchHandle.h
//  BonusStore
//
//  Created by cindy on 2017/2/10.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

@interface FNTouchHandle : NSObject

+ (void)creatShortcutItem ;

+ (void)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem;

@end
