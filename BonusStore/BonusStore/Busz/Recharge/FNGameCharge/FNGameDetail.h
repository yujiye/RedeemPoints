//
//  FNGameDetail.h
//  BonusStore
//
//  Created by cindy on 2016/11/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNGameDetail : NSObject 

@property (nonatomic, copy)NSString * thirdGameId; // 游戏id

@property (nonatomic, copy)NSString * corp; //游戏公司 比如“腾讯游戏”

@property (nonatomic, copy)NSString * code; //游戏编码 前端不用管

@property (nonatomic, copy)NSString * startbuy; //购买限制 开始大小 以逗号分隔 如200,100  200是第三方的限制大小,100是聚分享平台的限制大小

@property (nonatomic, copy)NSString * endbuy; //购买限制  结束大小 如200,100  200是第三方的限制大小,100是聚分享平台的限制大小

@property (nonatomic, copy)NSString * contbuy; //固定面额列表 10,20,30 固定面额以逗号分隔

@property (nonatomic, copy)NSString * spacenum;//间隔配属

@property (nonatomic, copy)NSString * buyunit; //购买的单位

@property (nonatomic, copy)NSString * gameunit;//"点券",//游戏中的货币单位

@property (nonatomic, copy) NSString * name;//"DNF点券", //游戏名字

@property (nonatomic, copy)NSString * needparam;//"u=QQ号码|c=充值游戏|",//所需要的参数 u=QQ号码|c=充值游戏|a=大区|s=服务器|

@property (nonatomic, copy)NSString * mprice;  //面值

@property (nonatomic, copy) NSString * point;//  换算比例

@end
