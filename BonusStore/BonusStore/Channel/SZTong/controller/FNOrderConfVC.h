//
//  FNOrderConfVC.h
//  BonusStore
//
//  Created by cindy on 2017/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNOrderConfVC : UIViewController

@property (nonatomic,copy)NSString * money;
@property (nonatomic,copy)NSString * moneyCount;
@property (nonatomic,copy)NSString *orderno;

@end

@interface FNSZOrderConfCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong) UILabel *moneyLab;


+ (instancetype)szOrderConfCellWithTableView:(UITableView *) tableView;

@end

@interface FNSZOrderModel : NSObject

@property (nonatomic, copy)NSString *couponBeginDate;
@property (nonatomic, copy)NSString *couponDesc;
@property (nonatomic, copy)NSString *couponEndDate;
@property (nonatomic, copy)NSString *couponId;
@property (nonatomic, copy)NSString *couponIssueAmt;
@property (nonatomic, copy)NSString *couponName;
@property (nonatomic, copy)NSString *couponState;
@property (nonatomic, copy)NSString *couponType;
@property (nonatomic, copy)NSString *createDate;
@property (nonatomic, copy)NSString *creater;
@property (nonatomic, copy)NSString *expireFlag;
@property (nonatomic, copy)NSString *mcId;
@property (nonatomic, copy)NSString *memberId;
@property (nonatomic, copy)NSString *mobileNo;
@property (nonatomic, copy)NSString *source;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *updateDate;
@property (nonatomic, copy)NSString *updater;
@property (nonatomic, copy)NSString *voucherId;
@property (nonatomic, copy)NSString *effeTime;
@property (nonatomic, assign)BOOL hadChoice;

@end
