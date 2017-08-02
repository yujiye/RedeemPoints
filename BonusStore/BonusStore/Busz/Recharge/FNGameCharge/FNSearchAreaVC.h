//
//  FNSearchAreaVC.h
//  BonusStore
//
//  Created by cindy on 2016/11/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FNGameAreaModel;

typedef void (^AreaModelClickBlock) (FNGameAreaModel *gameAreaModel);

@interface FNSearchAreaVC : UIViewController

@property (nonatomic, strong) NSMutableArray *gameArr;

@property (nonatomic, copy) NSString *tipString;

- (void)setBlockAreaModelClick:(AreaModelClickBlock )block;

@end


@interface FNGameAreaModel : NSObject

@property (nonatomic ,copy)NSString *gameAreaName; // 区名字

@property (nonatomic ,copy)NSString *gameAreaId; // 区ID

@property (nonatomic,strong)NSMutableArray *gameSeaverList; //服务器列表

+ (NSDictionary *)mj_objectClassInArray;

@end


@interface FNSeaverModel : NSObject

@property (nonatomic ,copy)NSString *gameSeaverName; // 服务器名字

@property (nonatomic ,copy)NSString *gameSeaverId; // 服务器ID

@end
