//
//  FNCartGroupModel.m
//  BonusStore
//
//  Created by feinno on 16/4/29.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNCartGroupModel.h"
#import "FNCartItemModel.h"
@implementation FNCartGroupModel

+ (NSDictionary *)mj_objectClassInArray
{
    
    return  @{@"productList" : [FNCartItemModel class] };
}
@end
