//
//  FNShoppingCartCell.h
//  BonusStore
//
//  Created by qingPing on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.


typedef enum : NSUInteger {
    kNumberBtnTypeAdd,
    kNumberBtnTypeMinus,
} kNumberBtnType;

#import "FNHeader.h"
#import "FNCartItemModel.h"
@class FNShoppingCartCell;
@class FNTextField;

@protocol FNShoppingCartCellDelegate <NSObject>
@optional
// 根据button的tag 值判断加减
- (void)shoppingCartCellBtnClick:(FNShoppingCartCell *)cell flag:(NSInteger)flag;

// 商品选择按钮改变的事件
- (void)shoppingCartCellTouched:(FNShoppingCartCell *)shoppingCartCell;

// 数量值的改变事件
- (void)shoppingCartCell:(FNShoppingCartCell *)cell numberChangeWithTextField:(FNTextField*)textField;

@end

@interface FNShoppingCartCell : UITableViewCell

@property (nonatomic,weak) FNCartItemModel * cartItem; // cell的数据

@property (nonatomic, weak) UIButton *selecteBtn; //产品是否选中
@property (nonatomic,weak)UIImageView *imageView1; // 展示选择图片
@property (nonatomic, weak) UIImageView *pictureView; // 产品图片
@property (nonatomic, weak) UILabel *nameLabel; // 产品名称
@property (nonatomic, weak) UILabel *detailLabel; // 产品补充说明
@property (nonatomic, weak) UILabel *priceLabel;  // 产品价格
@property (nonatomic, weak) UILabel *scoreLabel;  // 产品积分
@property (nonatomic, weak)  FNTextField *numberField;  // 产品数量
@property (nonatomic,weak) UIButton *minuBtn; // 减号按钮
@property (nonatomic,weak) UIButton *addBtn;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;//当前cell所在表中的位置


@property (nonatomic,weak)id<FNShoppingCartCellDelegate>delegate;// 加减号的代理

+ (instancetype)shoppingCartCellWithTableView:(UITableView *) tableView;

@end
