//
//  FNFillOrderCell.h
//  BonusStore
//
//  Created by qingPing on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FNFillOrderItem;
#import "FNCartItemModel.h"
@interface FNFillOrderCell : UITableViewCell

@property (nonatomic, weak) UIImageView *pictureView; // 产品图片
@property (nonatomic, weak) UILabel *nameLabel; // 产品名称
@property (nonatomic, weak) UILabel *detailLabel; // 产品补充说明
@property (nonatomic, weak) UILabel *priceCurLabel;  // 产品打折后价格
@property (nonatomic,weak) UILabel *pricePreLabel; //  产品原价格
@property (nonatomic,weak) UILabel *lineLabel; // 产品原价格上的线
@property (nonatomic, weak) UILabel *scoreLabel;  // 产品现在所用积分
@property (nonatomic,weak) UILabel *usdLabel;   // 运费或者手机号码
@property (nonatomic,weak)UILabel *numIntroLabel; // "购买数量"框
@property (nonatomic, weak) UILabel *numberLabel;  // 产品数量

@property (nonatomic,weak)UIImageView *maskView; // 蒙板View
@property (nonatomic,weak)UILabel *maskLabel ;// 库存不足时候的label 

@property (nonatomic, weak) FNCartItemModel *fillOrderItem;

+ (instancetype)fillOrderCellWithTableView:(UITableView *) tableView;
@end
