//
//  FNMessageCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNMessageModel.h"
#import "FNBaseCell.h"

@interface FNMessageCell : FNBaseCell

@property (nonatomic, strong) UIImageView * titleImageView;

@property (nonatomic, strong) UILabel * messageTitle;

@property (nonatomic, strong) UILabel * messageContent;//消息内容

@property (nonatomic, strong) FNMessageModel * messageModel;

@property (nonatomic,strong) UIImageView *messageImageView1;

@end
