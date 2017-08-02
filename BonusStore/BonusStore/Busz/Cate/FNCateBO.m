//
//  FNCateBO.m
//  BonusStore
//
//  Created by Nemo on 16/3/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCateBO.h"

@implementation FNCateBO

+ (void)getCateListWithBlock:(FNNetFinish)block
{
    [self getCateListWithParentID:0 block:block];
}

+ (void)getCateListWithParentID:(NSInteger)parentID block:(FNNetFinish)block
{
    NSDictionary *para = @{@"subjectId":[NSString stringWithFormat:@"%ld",(long)parentID]};
  
    [[FNNetManager shared] postURL:@"product/subjectListRelaProduct" paras:para finish:^(id result)
    {

        if ([result[@"code"]integerValue] == 200)
        {
            NSMutableArray * array = [NSMutableArray array];
            
            FNCateParentModel * model = [[FNCateParentModel alloc]init];
            model.subjectName = @"热门推荐";
            model.subjectId = @"1000";
            
            [array addObject:model];
            
            for ( NSDictionary * dict in result[@"classList"] )
            {
                FNCateParentModel * model = [FNCateParentModel makeEntityWithJSON:dict];
                
                if ([model.subjectId integerValue] != 1010 ) {
                    [array addObject:model];
                }
            }
            block(array);
            return ;
        }
        block(result);
    } fail:^(NSError *error) {
        block(nil);
    }];
    
}

+ (void)getProductListWithCateID:(NSInteger)ID page:(NSInteger)page block:(FNNetFinish)block
{
    NSDictionary * para = @{@"subjectId":@(ID),
                            @"page":@(0)
                            };

    [[FNNetManager shared] postURL:@"product/subjectListRelaProduct" paras:para finish:^(id result) {
    
        block(result);
    } fail:^(NSError *error) {
        block(nil);
    }];
}

@end
