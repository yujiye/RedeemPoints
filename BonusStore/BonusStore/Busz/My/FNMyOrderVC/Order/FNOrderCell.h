//
//  FNObligationOrderCell.h
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseCell.h"
#import "FNHeader.h"
#import "FNOrderArgs.h"
@class FNButton;
@class FNOrderCell;

typedef void (^CancelWaitingPayBlock) (FNOrderArgs *order);

@interface FNOrderCell : UITableViewCell
@property (nonatomic, strong)UIButton *cancelPayBtn; // 取消支付

@property (nonatomic, strong)UILabel *orderStateLabel;

@property (nonatomic, strong)FNButton *payBut;

@property (nonatomic, strong) UILabel *shopLabel;

@property (nonatomic, assign) FNOrderState state;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, assign) int afterOrderType;

@property (nonatomic, strong) UILabel *attributeLabel;

@property (nonatomic, strong) UILabel *priceLabel;          //单个商品价格

@property (nonatomic, strong) UILabel *totalPriceLabel;    //多个商品价格

@property (nonatomic, strong) FNOrderArgs *order;        //订单

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setActionWithPay:(void (^) (FNOrderState state, NSIndexPath *selectedIndexPath, FNOrderCell *selectedCell))pay ship:(UIButtonActionBlock)ship;

- (void)cancelPay:(CancelWaitingPayBlock)cancelBlock;

- (CGFloat)autoFitHeight;


//after sale

@property (nonatomic, strong) UILabel *returningLabel;

@property (nonatomic, strong) UILabel *returnFailBackupLabel;

@property (nonatomic, strong) UILabel *returnApplyLabel;

@property (nonatomic, strong) UILabel *returnRefuseLabel;

@property (nonatomic, strong) UILabel *returnFailReasonLabel;


@end
