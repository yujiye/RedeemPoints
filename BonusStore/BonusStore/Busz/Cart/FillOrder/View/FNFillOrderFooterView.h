//
//  FNFillOrderFooterView.h
//  BonusStore
//
//  Created by feinno on 16/4/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNCartGroupModel.h"
#import "FNTextField.h"

@class FNFillOrderGroup;

@interface FNFillOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) UILabel *numLabel; //商品总件数
@property (nonatomic, weak) UILabel *priceLabel; // 总价钱 和运费
@property (nonatomic, weak) FNTextField *commentsField; //给卖家留言
@property (nonatomic, weak) FNCartGroupModel *cartGroup;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;//当前cell所在表中的位置

@property (nonatomic,assign)BOOL isVirful;
+ (instancetype)fillOrderFooterViewWithTableView:(UITableView *) tableView;

@end
