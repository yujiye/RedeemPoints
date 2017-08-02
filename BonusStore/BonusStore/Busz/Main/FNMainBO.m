//
//  FNMainBO.m
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainBO.h"
#import "FNCacheManager.h"

@implementation FNMainBO

+ (void)getFocusImageListWithBlock:(FNNetFinish)block
{
    NSDictionary *para = @{@"type":@(FNFocusListTypeApp)};
    
    [[FNNetManager shared] getURL:@"active/imgList" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dict in result[@"slotImageList"])
            {
                [array addObject:[FNImageArgs makeEntityWithJSON:dict]];
            }
            
            block(array);
            
            return ;
        }
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort block:(FNNetFinish)block
{
    [self getProductListWithPage:page sort:sort perCount:MAIN_PER_PAGE subjectID:0 block:block];
}

+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort perCount:(NSInteger)perCount block:(FNNetFinish)block
{
    [self getProductListWithPage:page sort:sort perCount:perCount subjectID:0 block:block];
}

+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort subjectID:(NSInteger)subjectID  block:(FNNetFinish)block
{
    [self getProductListWithPage:page sort:sort perCount:MAIN_PER_PAGE subjectID:subjectID block:block];
}

//SellerID The same with subjectID.分类调用
+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort perCount:(NSInteger)perCount subjectID:(NSInteger)subjectID block:(FNNetFinish)block
{
    NSString *s = nil;
    switch (sort) {
        case FNSortTypeTimeDesc:
            s = @"create_time DESC";
            break;
        case FNSortTypeClickDesc:
            s = @"click_rate DESC";
            break;
        case FNSortTypePriceDesc:
            s = @"cur_price DESC";
            break;
        case FNSortTypePriceAsc:
            s = @"cur_price ASC";
            break;
        default:
            break;
    }
    
    NSDictionary *para = @{@"perCount":@(perCount),
                           @"curPage":@(page),
                           @"sort":s,
                           @"subjectId":(subjectID != -1) ? @(subjectID) : @""};
    
    [[FNNetManager shared] postURL:@"product/list" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *array = [NSMutableArray array];
            
            /*
             缓存－部分机器有显示问题，暂时屏蔽
             if (subjectID == 0 && page == 1)
             {
             [FNCacheManager save:result path:FN_CACHE_PATH_MAIN_LIST];
             [FNCacheManager save:result path:FN_CACHE_PATH_MAIN_LIST_CHART];
             }
             */
            
            for (NSDictionary *dict in result[@"productList"])
            {
                [array addObject:[FNProductArgs makeEntityWithJSON:dict]];
            }
            
            block(array);
            
            return ;
        }
        
        if (block)
        {
            block(result);
        }
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}
+(void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort sellerID:(NSInteger)sellerID  block:(FNNetFinish)block
{
    [self getProductListWithPage:page sort:sort perCount:MAIN_PER_PAGE sellerID:sellerID block:block];
}

+ (void)getProductListWithPage:(NSInteger)page sort:(FNSortType)sort perCount:(NSInteger)perCount sellerID:(NSInteger)sellerID block:(FNNetFinish)block
{
    NSString *s = nil;
    switch (sort) {
        case FNSortTypeTimeDesc:
            s = @"create_time DESC";
            break;
        case FNSortTypeClickDesc:
            s = @"click_rate DESC";
            break;
        case FNSortTypePriceDesc:
            s = @"cur_price DESC";
            break;
        case FNSortTypePriceAsc:
            s = @"cur_price ASC";
            break;
        default:
            break;
    }
    
    NSDictionary *para = @{@"perCount":@(perCount),
                           @"curPage":@(page),
                           @"sort":s,
                           @"sellerId":@(sellerID)};
    
    [[FNNetManager shared] postURL:@"product/list" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *array = [NSMutableArray array];
            
            /*
             缓存－部分机器有显示问题，暂时屏蔽
             if (subjectID == 0 && page == 1)
             {
             [FNCacheManager save:result path:FN_CACHE_PATH_MAIN_LIST];
             [FNCacheManager save:result path:FN_CACHE_PATH_MAIN_LIST_CHART];
             }
             */
            
            for (NSDictionary *dict in result[@"productList"])
            {
                [array addObject:[FNProductArgs makeEntityWithJSON:dict]];
            }
            
            block(array);
            
            return ;
        }
        
        if (block)
        {
            block(result);
        }
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

// 商品基本信息
+ (void)getProductDetailWithProductId:(NSString *)productId block:(FNNetFinish)block
{
    NSDictionary *para = @{@"productId":productId};
    
    [[FNNetManager shared] getURL:@"product/productinfo" paras:para finish:^(id result)
    {

        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getSKUItemWithProductID:(NSInteger)ID block:(FNNetFinish)block
{
    NSDictionary *para = @{@"productid":@(ID)};
    
    [[FNNetManager shared] getURL:@"product/productinfo" paras:para finish:^(id result) {
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getMessageListWithBlock:(FNNetFinish)block
{
    NSDictionary *para = @{@"type":@(FNMsgTypeiOS)};
    
    [[FNNetManager shared] getURL:@"active/messageList" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200 && [result[@"messages"] isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array = [NSMutableArray array];
            
            NSComparator comparator = ^(FNMessageArgs *obj1, FNMessageArgs *obj2)
            {
                NSNumber *ID1 = [obj1 id];
                
                NSNumber *ID2 = [obj2 id];
                
                if ([ID1 integerValue] > [ID2 integerValue])
                {
                    return NSOrderedDescending;
                }
                
                if ([ID1 integerValue] > [ID2 integerValue])
                {
                    return NSOrderedAscending;
                }
                
                return NSOrderedSame;
            };
            
            for (NSDictionary *dict in result[@"messages"])
            {
                [array addObject:[FNMessageArgs makeEntityWithJSON:dict]];
            }
            
            [array sortUsingComparator:comparator];
            
            FNMessageArgs *msg = [array lastObject];
            
            [FNMessageNoti saveLatestMessageID:msg.id];
            
            block(array);
            
            return ;
        }
        
        block(result);
        
    } fail:^(NSError *error) {
        
        block(nil);
        
    }];
}

+ (void)getOrderPayListWithUserName:(NSString *)username sellerDetailList:(NSArray *)sellerDetailList totalSum:(NSString *)totalSum tradeCode:(NSString *)tradeCode block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:FNUserAccountInfo[@"userId"] forKey:@"userId"];
    
    [para setValue:username forKey:@"userName"];

    [para setValue:totalSum forKey:@"totalSum"];
    
    [para setValue:tradeCode forKey:@"tradeCode"];
    
    [para setValue:sellerDetailList forKey:@"sellerDetailList"];
    
    [[FNNetManager shared] postURL:@"order/payOrderCreates" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200 )
        {
            
            NSMutableArray * array = [NSMutableArray array];
            
            [array addObjectsFromArray:result[@"orderIdList"]];
        block(result);
        }
    
    } fail:^(NSError *error) {
        block(nil);
    }];
}

+ (void)getSearchProductListWithPage:(NSInteger)page descType:(NSInteger)descType perCount:(NSInteger)perCount keyword:(NSString *)keyword block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:@(page) forKey:@"curPage"];
    [para setValue:@(descType) forKey:@"type"];
    [para setValue:@(perCount) forKey:@"perCount"];
    [para setValue:keyword forKey:@"keyword"];
        
    [[FNNetManager shared]postURL:@"product/search" paras:para finish:^(id result) {
    
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dict in result[@"productSearchList"])
            {
                [array addObject:[FNProductArgs makeEntityWithJSON:dict]];
            }
            block(array);
            
            return ;
        }
        if (block)
        {
            block(result);
        }
    } fail:^(NSError *error) {
        block(nil);
    }];
}


+ (void)getHotSearchListWithModuleId:(NSString *)moduleId block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:moduleId forKey:@"moduleId"];
    [para setValue:@(1) forKey:@"curPage"];
    [para setValue:@(20) forKey:@"perCount"];
    [[FNNetManager shared]postURL:@"moduleConfig/queryModuleConfigDetail" paras:para finish:^(id result) {
        
        if ([result[@"code"] integerValue] == 200)
        {

            NSArray  *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *fileName = [[path objectAtIndex:0]stringByAppendingPathComponent:@"FNSearchName"];
            [NSKeyedArchiver archiveRootObject:result[@"ModuleConfigDetailList"] toFile:fileName];
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dict in result[@"ModuleConfigDetailList"])
            {
                [array addObject:[FNHotSearchModel makeEntityWithJSON:dict]];
            }
            
            
            block(array);
            return ;
        }
        if (block)
        {
            block(result);
        }
    } fail:^(NSError *error) {
        block(nil);
    }];
}

+ (void)getModelConfigOfProductListWithModuleId:(NSString *)moduleId curPage:(NSInteger)curPage perCount:(NSInteger)perCount block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:moduleId forKey:@"moduleId"];
    [para setValue:@(curPage) forKey:@"curPage"];
    [para setValue:@(perCount) forKey:@"perCount"];
    [[FNNetManager shared]postURL:@"moduleConfig/queryModuleConfigDetail" paras:para finish:^(id result) {
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSDictionary *dict in result[@"ModuleConfigDetailList"])
            {
                [array addObject:[FNMainModelConfigOfProduct makeEntityWithJSON:dict]];
            }
           [FNCacheManager save:result path:FN_CACHE_PATH_MAIN_CONFIG_MODEL_PRODUCT_LIST];
            block(array);
            return ;
        }
        if (block)
        {
            block(result);
        }
    } fail:^(NSError *error) {
        block(nil);
    }];

}

//advertId = 6配置商品区  advertId = 7配置广告位图片 advertId = 8配置积分兑换区
//type  前端需要传递的各自的类型  WEB为1，APP&H5为2
+ (void)getProductListWithAdvertId:(NSInteger)advertId block:(FNNetFinish)block
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:@(advertId) forKey:@"advertId"];
    [para setValue:@(2) forKey:@"type"];
    NSString *path;
    switch (advertId) {
        case 5:
            path = FN_CACHE_PATH_MAIN_CONGIF_FOCUS_LIST;
            break;
        case 6:
            path = FN_CACHE_PATH_MAIN_CONFIG_PRODUCT_LIST;
            break;
        case 7:
            path = FN_CACHE_PATH_MAIN_CONFIG_ADVERT_LIST;
            break;
        case 8:
            path = FN_CACHE_PATH_MAIN_CONFIG_CASH_LIST;
            break;
        default:
            break;
    }
    
    [[FNNetManager shared]postURL:@"slotImage/queryAdvertSlotImageList" paras:para finish:^(id result){
        if ([result[@"code"] integerValue] == 200)
        {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dict in result[@"AdvertSlotImageList"])
            {
                [array addObject:[FNAdvertOfConfig makeEntityWithJSON:dict]];
            }
            [FNCacheManager save:result path:path];
            
            block(array);
            return ;
        }
        if (block)
        {
            block(result);
        }
    } fail:^(NSError *error) {
        block(nil);
    }];
}


@end
