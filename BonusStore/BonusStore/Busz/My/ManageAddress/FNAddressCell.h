//
//  FNAddressCell.h
//  BonusStore
//
//  Created by feinno on 16/5/3.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNAddressModel.h"
typedef enum : NSUInteger {
    kButtonTypeEdit = 1,
    kButtonTypedelete = 2,
    kButtonTypeDefault = 3,
} kButtonType;
@class FNAddressCell;

@protocol FNAddressCellDelegate <NSObject>

@optional
- (void)addressCellBtnClick:(FNAddressCell *)cell flag:(NSInteger)flag;

@end


@interface FNAddressCell : UITableViewCell

@property (nonatomic,weak) id <FNAddressCellDelegate>delegate;//  编辑，删除，设为默认的代理
@property (nonatomic, strong) FNAddressModel * addressModel;
@property (nonatomic, weak) UILabel *introduceLabel;
@property (nonatomic, weak) UILabel *isDefaultLabel;
@property (nonatomic, weak)  UILabel *detailLabel;
@property (nonatomic, weak) UIButton * defaultBtn;

+ (instancetype)addressCellWithTableView:(UITableView *) tableView;

@end
