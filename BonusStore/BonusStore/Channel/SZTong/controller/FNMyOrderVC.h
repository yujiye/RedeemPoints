//
//  FNMyOrderVC.h
//  BonusStore
//
//  Created by cindy on 2017/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
@class CBPeripheral;
@interface FNMyOrderVC : UIViewController

@property (nonatomic , strong) CBPeripheral *model;

@end

@interface FNMyOrderModel : NSObject

@property (nonatomic,copy)NSString * orderStatus;// 状态
@property (nonatomic,copy)NSString * orderTypeName;
@property (nonatomic,copy)NSString * orderStatusName;
@property (nonatomic,copy)NSString * orderNo;
@property (nonatomic,copy)NSString * orderTime;
@property (nonatomic,copy)NSString * payMoney;

@property (nonatomic,copy)NSString * name; //充值入长
@property (nonatomic,copy)NSString * title; //时间
@property (nonatomic,copy)NSString * content; //金额
@property (nonatomic,assign)BOOL showIcon;
@property (nonatomic,assign)FNSZConsumeType szType; //消费类型

@end


@interface FNMyOrderCell : UITableViewCell

+ (instancetype)myOrderCellWithTableView:(UITableView *) tableView;

@property (nonatomic, strong) FNMyOrderModel *myOrderModel;

@end
