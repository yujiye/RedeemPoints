//
//  FNButton.h
//  BonusStore
//
//  Created by Nemo on 16/4/19.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

typedef NS_ENUM(NSUInteger, FNButtonType)
{
    FNButtonTypePlain,
    FNButtonTypeOpposite,
    FNButtonTypeEdge
};

NS_ASSUME_NONNULL_BEGIN

@interface FNButton : UIButton

+ (instancetype)buttonWithType:(FNButtonType)type title:(NSString *)title;

- (void)setType:(FNButtonType)type;

@end

NS_ASSUME_NONNULL_END