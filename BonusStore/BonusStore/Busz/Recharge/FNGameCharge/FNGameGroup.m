//
//  FNGameGroup.m
//  BonusStore
//
//  Created by cindy on 2016/11/28.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNGameGroup.h"
#import "FNGameDetail.h"
@implementation FNGameGroup

+ (NSDictionary *)mj_objectClassInArray
{
    return  @{@"listGame" : [FNGameDetail class] };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  
    [aCoder encodeObject:_py forKey:@"py"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _py = [aDecoder decodeObjectForKey:@"py"];
    
    }
    return self;
}
@end
