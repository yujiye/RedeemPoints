//
//  FNBonusRechargeRecordCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
@interface FNBonusRechargeRecordCell : UITableViewCell

@property (nonatomic, strong) UILabel *rechargeNumLab;

@property (nonatomic, strong) UILabel *rechargeTimeLab;

@property (nonatomic, strong) UILabel *rechargePassLab;

@property (nonatomic, strong) UILabel *rechargeTypeLab;

+ (instancetype)bonusRechargeRecordCell:(UITableView *)tableView;

@end
