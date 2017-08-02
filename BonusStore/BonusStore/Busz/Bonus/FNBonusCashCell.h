//
//  FNBonusCashCell.h
//  BonusStore
//
//  Created by sugarwhi on 16/6/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "FNHeader.h"

#import "FNMacro.h"

@class FNBonusCashCell ;

@class FNTextField;

@protocol FNBonusCashCellDelegate <NSObject>

@optional

- (void)cashCellBtnClick:(FNBonusCashCell *)cell flag:(NSInteger)flag;

- (void)cashNumCell:(FNBonusCashCell *)cell numberChangeWithTextField:(UITextField *)textField;

@end

@interface FNBonusCashCell : UITableViewCell

@property (nonatomic, strong) UILabel * inteLabel;

@property (nonatomic, strong) UILabel * titleLable;

@property (nonatomic, strong) UILabel * telephoneLabel;//积分兑出手机号

@property (nonatomic, strong) FNTextField * cashTextField;

@property (nonatomic, strong) UIView * buttonView;

@property (nonatomic, strong) UIButton * addBtn;

@property (nonatomic, strong) UIButton * cutBtn;

@property (nonatomic, strong) UIButton * codeBtn;

@property (nonatomic, weak)id<FNBonusCashCellDelegate>textFielddelegate;

+ (instancetype)cashTableviewCell:(UITableView *)tableView;

@end
