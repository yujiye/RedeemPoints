//
//  FNMyHeaderView.h
//  BonusStore
//
//  Created by sugarwhi on 16/9/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
@interface FNMyHeaderView : UIView

@property (nonatomic, strong)UILabel *myOrderLab;

@property (nonatomic, strong)UIButton *checkAllBtn;

@property (nonatomic, strong)UIButton *payBtn;

@property (nonatomic, strong)UIButton *sendBtn;

@property (nonatomic, strong)UIButton *receiveBtn;

@property (nonatomic, strong)UIButton *finishBtn;

@property (nonatomic, strong)UIButton *afterSaleBtn;

@property (nonatomic, strong)UILabel *payBadges;

@property (nonatomic, strong)UILabel *senderBadges;

@property (nonatomic, strong)UILabel *receiveBadges;

- (void)setBadges;

@end
