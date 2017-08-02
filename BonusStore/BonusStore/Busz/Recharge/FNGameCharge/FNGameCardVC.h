//
//  FNGameCardVC.h
//  BonusStore
//
//  Created by cindy on 2016/11/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNTextField.h"
@interface FNGameCardVC : UIViewController

@end


@interface FNGameCell : UITableViewCell

@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIView * inputView;

@property (nonatomic, strong) UIButton *minuBtn;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) FNTextField *numberField;

@property (nonatomic, strong)NSIndexPath *IndexPath;

@property (nonatomic, copy) void(^ subtractClick)(NSIndexPath *indexPath, UITextField *textF) ;
@property (nonatomic, copy) void(^ plusClick)(NSIndexPath *indexPath, UITextField *textF) ;
@property (nonatomic, copy) void(^ textValueChangeClick)(NSIndexPath *indexPath, UITextField *textF) ;

+ (instancetype)gameCellWithTableView:(UITableView *) tableView;

@end
