//
//  FNMyBO.m
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMyBO.h"

#import "MJExtension.h"

#import "FNAddressModel.h"

#import "FNProvinceModel.h"

#import "FNPersonalModel.h"

#import "FNShipModel.h"

#import "FNAddressModel.h"
NSDictionary *FNMyUpdateInfo;

NSInteger FNMyIsEnforceUpdate;

@implementation FNMyBO

// 获取虚拟订单的卡密列表
+(void)getVirtualCardListProductId:(NSString *)productId orderId:(NSString *)orderId number:(int)number skuNum:(NSString *)skuNum block:(FNNetFinish)block
{
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    
    [para setValue:productId forKey:@"productId"];
    
    [para setValue:orderId forKey:@"orderId"];
    
    [para setValue:@(number) forKey:@"num"];
    
    [para setValue:skuNum forKey:@"skuNum"];
    
    [[FNNetManager shared] postURL:@"order/getVirtualCard" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
 
}

@end

@implementation FNMyBO (Extension)

+ (void)getPersonalWithBlock:(FNNetFinish)block
{
    
    NSDictionary * para = nil;
    
    [[FNNetManager shared] getURL:@"personal" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)updateUser:(FNPersonalModel *)user block:(FNNetFinish)block
{
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    
    [para setValue:user.userName forKey:@"userName"];
    
    [para setValue:user.favImg forKey:@"favImg"];
    
    [para setValue:user.birthday forKey:@"birthday"];
    
    [para setValue:@(user.sex) forKey:@"sex"];
    
    [[FNNetManager shared] postURL:@"buyer/update" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)updateUserWithMobile:(NSString *)mobile pwd:(NSString *)pwd captcha:(NSString *)captcha block:(FNNetFinish)block
{
    NSDictionary *para = @{@"newPwd":pwd,
                           @"captchaDesc":captcha,
                           @"mobile":mobile};

    [[FNNetManager shared] postURL:@"buyer/changePwd" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getUserInfoWithBlock:(FNNetFinish)block
{
    NSDictionary *para = nil;
    
    [[FNNetManager shared] postURL:@"buyer/query" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
           NSMutableArray * array = [NSMutableArray array];

            [array addObject:[FNPersonalModel makeEntityWithJSON:result[@"buyer"]]];
            
            block(array);
            
            return ;
        }
    
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

//使用时需设置 isWX；
+ (void)getWXUserInfoWithOpenId:(NSString *)openId token:(NSString *)token block:(FNNetFinish)block
{
    NSDictionary *para = @{@"openid":openId,
                           @"access_token":token};

    [[FNNetManager shared] getURL:@"userinfo" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

// 新增收货地址
+ (void)addAddrWithUser:(FNAddressModel *)addressModel block:(FNNetFinish)block
{
    NSDictionary *para = @{@"receiverName":addressModel.receiverName,
                           @"mobile":addressModel.mobile,
                           @"provinceId":@(addressModel.provinceId),
                           @"provinceName":addressModel.provinceName,
                           @"cityId":@(addressModel.cityId),
                           @"cityName": addressModel.cityName,
                           @"countyId": @(addressModel.countyId),
                           @"countyName":addressModel.countyName,
                           @"address": addressModel.address,
                           @"isDefault":@(addressModel.isDefault),
                           @"postCode":@"100100"
                           };
    
    [[FNNetManager shared] postURL:@"address/add" paras:para  finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

// 删除地址
+ (void)delAddrWithAddrID:(int)addressId block:(FNNetFinish)block
{
    NSDictionary *para = @{@"addrId":@(addressId)};

    [[FNNetManager shared] postURL:@"address/delete" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

//修改收货地址
+ (void)updateAddrWithUser:(FNAddressModel *)addressModel block:(FNNetFinish)block
{
    NSDictionary *para = @{
                           @"addrId":@(addressModel.id),
                           @"receiverName":addressModel.receiverName,
                           @"mobile":addressModel.mobile,
                           @"provinceId":@(addressModel.provinceId),
                           @"provinceName":addressModel.provinceName,
                           @"cityId":@(addressModel.cityId),
                           @"cityName": addressModel.cityName,
                           @"countyId": @(addressModel.countyId),
                           @"countyName":addressModel.countyName,
                           @"address": addressModel.address,
                           @"isDefault":@(addressModel.isDefault),
                           @"postCode":@"100100"

                           };
    [[FNNetManager shared] postURL:@"address/update" paras:para  finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

// 设置为默认地址
+ (void)setDefaultAddressWithId:(int)AddressId block:(FNNetFinish)block
{
    NSDictionary *para =  @{ @"id":@(AddressId) };
    
    [[FNNetManager shared] postURL:@"address/setDefaultAddress" paras:para finish:^(id result) {
        
        block (result);
        
        } fail:^(NSError *error) {
            
        block (nil);
    }];
}

static NSMutableArray * array;

static NSString *name;

// 查询全国省份列表
+ (void)getProVincesListWithBlock:(FNNetFinish)block
{
    [[FNNetManager shared]postURL:@"address/getprovinces" paras:nil  finish:^(id result) {
        
        array = [NSMutableArray array];

        if([result[@"code"] integerValue] == 200)
        {
        for ( NSDictionary * dict in result[@"provicnceList"])
            {
                NSMutableDictionary *pro = [NSMutableDictionary dictionaryWithDictionary:dict];
                
                [[FNMyBO port02] getCitysListWithProvinceId:[dict[@"id"] integerValue] block:^(id result) {
                    
                    [pro setObject:result[@"cityList"] forKey:@"cityList"];
                    
                    [array addObject:pro];
                    
                            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                            
                            path = [path stringByAppendingPathComponent:@"area.plist"];
                            
                            [array writeToFile:path atomically:YES];

                }];
            }
            block(array);
            return ;
        }
    } fail:^(NSError *error) {
       
        block(nil);
       
    }];
}

//获得某个省份下的城市列表
+ (void)getCitysListWithProvinceId:(NSInteger)provinceId block:(FNNetFinish)block
{
    NSDictionary *para = @{ @"provinceId":@(provinceId)};
    
    [[FNNetManager shared] postURL:@"address/getcitys" paras:para finish:^(id result) {
        
        block(result);
        
     } fail:^(NSError *error) {
         
        block(nil);
        
    }];
}

// 获得某个城市下的乡镇列表
+ (void)getCountysListWithCityId:(NSInteger)cityId block:(FNNetFinish)block
{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    path = [path stringByAppendingPathComponent:@"area.plist"];
    
    NSArray *area = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *pro in area)
    {
        for (NSDictionary *city in pro[@"cityList"])
        {
            NSString *ci = city[@"id"];
     
            NSDictionary *para = @{ @"cityId":ci};
     
            [[FNNetManager shared] postURL:@"address/getcountys" paras:para finish:^(id result) {
               
                NSMutableArray *zz = [NSMutableArray array];

                NSMutableDictionary *info = result[@"countyList"];
                
                [zz addObject:info];
                
                
                for (NSDictionary *pro in area)
                {
                    for (NSDictionary *city in pro[@"cityList"])
                    {
                        NSString *ci = city[@"id"];
                        
                        NSDictionary *para = @{ @"cityId":ci};

                    }
                }
                
                        
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                
                NSString *name = [NSString stringWithFormat:@"%@_%@%@.plist",pro[@"name"],city[@"name"],city[@"id"]];
                
                path = [path stringByAppendingPathComponent:name];
                
                [zz writeToFile:path atomically:YES];

                
                block(result);
            } fail:^(NSError *error) {
                
                block(nil);
            }];
     
        }
    }
}

// 获得地址列表
+ (void)getAddrListWithBlock:(FNNetFinish)block
{

    [[FNNetManager shared] postURL:@"address/list" paras:nil finish:^(id result) {
      
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

// 获取物流信息
+ (void)getExpressWithOrderID:(NSString *)orderID expressId:(NSString *)expressId expressNo:(NSString *)expressNo  block:(FNNetFinish)block
{
    NSDictionary *para = @{@"orderId":orderID,
                           @"expressNo":expressNo,
                           @"expressId":expressId
                           };
    
    [[FNNetManager shared] postURL:@"order/queryExpress" paras:para finish:^(id result) {
        block(result);
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}


+ (void)getUpdateWithBlock:(FNNetFinish)block
{
    NSDictionary *para = @{@"appType":@(FNAPPTypeiOS),
                           @"version":APP_ARGUS_VERSION};
    
    [[FNNetManager shared] getURL:@"active/getAppUpgradeInfoStr" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            FNMyUpdateInfo = result[@"upgradeInfo"];

            FNMyIsEnforceUpdate = [FNMyUpdateInfo[@"upgradeType"] integerValue];//1普通升级 2强制升级

        }
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)uploadImage:(NSString *)image block:(FNNetFinish)block
{
    [[FNNetManager shared] uploadImageWithUrl:@"system/upload" image:image finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
    }];
}


@end
