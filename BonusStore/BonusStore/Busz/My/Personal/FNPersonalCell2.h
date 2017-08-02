//
//  FNPersonalCell2.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

@interface FNPersonalCell2 : UITableViewCell

//@property (nonatomic, strong) UIButton * manBtn;

@property (nonatomic, strong) UILabel * sexLabel;

@property (nonatomic, strong) UILabel * rightLab;

+ (instancetype)sexCell:(UITableView *)tabelView;

@end
