//
//  FNAddressTableViewCell.h
//  BonusStore
//
//  Created by feinno on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNAddressTableViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *introduceLabel ;
@property (nonatomic, weak) UITextField *detailField;
@property (nonatomic, weak) UIButton * btn;
@property (nonatomic, weak) UIImageView *image1;

+ (instancetype)addressTableViewCellWithTableView:(UITableView *) tableView;


@end
