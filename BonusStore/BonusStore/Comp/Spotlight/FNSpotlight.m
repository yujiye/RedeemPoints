//
//  FNSpotlight.m
//  BonusStore
//
//  Created by cindy on 2017/2/15.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSpotlight.h"
#import "FNHeader.h"
@implementation FNSpotlight

+ (void)setSpotlights
{
    NSMutableArray * fourArrM =  [NSMutableArray array];    
    NSArray * imgArr = @[@"main_bonus_interflow",@"main_bonus_recharge",@"main_card_icon",@"main_blank",@"main_blank_sz",@"main_mobile_recharge",@"main_bonus_flowRecharge",@"main_bonus_QCoin",@"main_bonus_gameCard",@"main_bonus_globalFood"];
    NSArray * mainArr = @[@"积分互通",@"积分充值",@"特惠卡券",@"开卡有礼",@"深圳通 ",@"话费充值",@"流量充值",@"Q币充值",@"游戏点卡", @"全球美食"];
    
   [mainArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
       CSSearchableItemAttributeSet *mainSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"what"];
       mainSet.title = obj;
       mainSet.keywords = @[obj];
       mainSet.contentDescription = @"聚分享项目";
       mainSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:imgArr[idx]]);
       NSString *unqIdentifier = [NSString stringWithFormat:@"main=%lu",(unsigned long)idx];
       CSSearchableItem *mainItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:unqIdentifier domainIdentifier:@"解决" attributeSet:mainSet];
       [fourArrM addObject:mainItem];

   }];
    
    //热门搜索的
    NSArray  *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:@"FNSearchName"];
    NSArray *fourArr = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    for (NSDictionary *dict in fourArr)
    {
        FNHotSearchModel * hotSearchModel = [FNHotSearchModel makeEntityWithJSON:dict];
        CSSearchableItemAttributeSet *firstSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"what"];
        firstSet.title = [NSString stringWithFormat:@"热门搜索 %@",hotSearchModel.relaImgkey];
        firstSet.contentDescription = @"聚分享产品";
        firstSet.keywords = @[hotSearchModel.relaImgkey];
        NSString * unqIdentifier = [NSString stringWithFormat:@"search=%@",hotSearchModel.relaImgkey];
        CSSearchableItem *firstItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:unqIdentifier domainIdentifier:@"解决" attributeSet:firstSet];
        [fourArrM addObject:firstItem];

    }
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:fourArrM.copy completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"设置失败%@",error);
            
        }else{
            
            NSLog(@"设置成功");
        }
    }];
    
    
}




@end
