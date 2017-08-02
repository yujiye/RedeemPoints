//
//  FNServiceChoiceVC.h
//  BonusStore
//
//  Created by cindy on 2016/11/30.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNSearchAreaVC.h"

typedef void (^SeaverModelClickBlock) (FNSeaverModel *seaverModel);

@interface FNServiceChoiceVC : UIViewController

@property (nonatomic, strong) NSMutableArray *serviceArr;

@property (nonatomic, copy) NSString *tipString;

- (void)setBlockSeaverModelClick:(SeaverModelClickBlock )block;


@end
