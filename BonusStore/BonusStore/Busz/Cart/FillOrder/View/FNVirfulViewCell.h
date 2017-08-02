//
//  FNVirfulVIewCell.h
//  BonusStore
//
//  Created by feinno on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNTextField.h"
#import "FNCartItemModel.h"
typedef enum : NSUInteger {
    kTextFieldTagNum,
    kTextFieldTagMobileNo,
    kTextFieldTagComment,
} kTextFieldTag;
@class FNVirfulViewCell;

@protocol FNVirfulViewCellDelegate <NSObject>

@optional
// 根据button的tag 值判断加减
- (void)virfulViewCellBtnClick:(FNVirfulViewCell *)cell flag:(NSInteger)flag;
// 数量值的改变事件
- (void)virfulViewCell:(FNVirfulViewCell *)cell numberChangeWithTextField:(FNTextField*)textField;

@end

@interface FNVirfulViewCell : UITableViewCell

@property (nonatomic, weak) UIImageView *pictureView;  // 产品图片
@property (nonatomic, weak) UILabel *nameLabel; // 产品名称
@property (nonatomic, weak) UILabel *detailLabel; // 产品类型
@property (nonatomic, weak) UILabel *priceCurLabel;  // 产品现在价格
@property (nonatomic, weak) UILabel *scoreLabel;  // 产品现在所用积分
@property (nonatomic, weak) UILabel *phoneNumLabel;   // ”手机号码“
@property (nonatomic, weak) UILabel *introLabel;   // ”产品说明“
@property (nonatomic, weak) UITextField *phoneNumField; // 手机号码输入框
@property (nonatomic, weak) UILabel *intro2Label;
@property (nonatomic, weak)UIImageView *maskView; // 蒙板View
@property (nonatomic, weak)UILabel *numberLabel; //数量

@property (nonatomic, strong) NSIndexPath *cellIndexPath;//当前cell所在表中的位置

@property (nonatomic, weak) FNCartItemModel *cartItemModel; // cell的数据
@property (nonatomic,weak)id<FNVirfulViewCellDelegate>delegate;// 加减号的代理

+ (instancetype)virfulViewCellWithTableView:(UITableView *)tableView;

@end
