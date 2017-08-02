//
//  FNLogisInformationCell.h
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNShipModel.h"

@interface FNShipCell : UITableViewCell

@property (nonatomic,weak) UILabel *shipLabel;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UILabel *lineLabel;
@property (nonatomic,strong) FNTraceModel * traceModel;

+ (instancetype)shipCellWithTableView:(UITableView *) tableView;

+ (CGFloat)cellHeightWithModel:(FNTraceModel *) traceModel;

@end
