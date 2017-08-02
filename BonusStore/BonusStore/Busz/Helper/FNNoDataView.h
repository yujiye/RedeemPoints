//
//  FNNoDataView.h
//  BonusStore
//
//  Created by Nemo on 16/5/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

@interface FNNoDataView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame type:(FNNoDataType)type;

- (void)setActionBlock:(UIButtonActionBlock)block;

//直接设置类型
- (void)setType:(FNNoDataType)type;

//通过接口返回结果来判断设置类型
- (void)setTypeWithResult:(id)result;

@end
