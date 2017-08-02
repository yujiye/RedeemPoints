//
//  FNReturnReasonView.h
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"

typedef void (^ReasonBlock)(NSString *reason);

@interface FNReturnReasonView : UIView

@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) FNTextField *field;

@property (nonatomic, copy) ReasonBlock reasonBlock;

- (void)setProto:(UIButtonActionBlock)block;

- (void)setConfirm:(UIButtonActionBlock)confirm cancel:(UIButtonActionBlock)cancel;

@end
