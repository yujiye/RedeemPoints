//
//  FNTouchArgs.h
//  BonusStore
//
//  Created by cindy on 2017/2/10.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FNTouchArgs;

@interface FNTouchArgs : NSObject

@property (nonatomic, copy) NSString *imageName; // 图片
@property (nonatomic, copy) NSString *title;  //标题
@property (nonatomic, copy) NSString *type;   // 标示
+ (NSArray *)widgetArr;

@end
