//
//  FNFlowRechargeModel.m
//  BonusStore
//
//  Created by cindy on 2016/11/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNFlowRechargeModel.h"

@implementation FNFlowRechargeModel
+ (NSMutableArray *)mobileArray
{
    NSMutableArray * mobileArr = [NSMutableArray array];
    FNFlowRechargeModel * model1 = [[FNFlowRechargeModel alloc]init];
    model1.flowName = @"30M";
    model1.pieceValue = @"5";
    model1.flowno = @"30";
    [mobileArr addObject:model1];
    
    FNFlowRechargeModel * model2 = [[FNFlowRechargeModel alloc]init];
    model2.flowName = @"70M";
    model2.pieceValue = @"10";
    model2.flowno = @"70";
    [mobileArr addObject:model2];
    
    FNFlowRechargeModel * model3 = [[FNFlowRechargeModel alloc]init];
    model3.flowName = @"150M";
    model3.pieceValue = @"20";
    model3.flowno = @"150";
    [mobileArr addObject:model3];
    
    FNFlowRechargeModel * model4 = [[FNFlowRechargeModel alloc]init];
    model4.flowName = @"500M";
    model4.pieceValue = @"30";
    model4.flowno = @"500";
    [mobileArr addObject:model4];

    FNFlowRechargeModel * model8 = [[FNFlowRechargeModel alloc]init];
    model8.flowName = @"1G";
    model8.pieceValue = @"50";
    model8.flowno = @"1024";
    [mobileArr addObject:model8];
    
    FNFlowRechargeModel * model9 = [[FNFlowRechargeModel alloc]init];
    model9.flowName = @"2G";
    model9.pieceValue = @"70";
    model9.flowno = @"2048";
    [mobileArr addObject:model9];
    
    FNFlowRechargeModel * model10 = [[FNFlowRechargeModel alloc]init];
    model10.flowName = @"3G";
    model10.pieceValue = @"100";
    model10.flowno = @"3072";
    [mobileArr addObject:model10];
    
    FNFlowRechargeModel * model11 = [[FNFlowRechargeModel alloc]init];
    model11.flowName = @"4G";
    model11.pieceValue = @"130";
    model11.flowno = @"4096";
    [mobileArr addObject:model11];
    
    FNFlowRechargeModel * model12 = [[FNFlowRechargeModel alloc]init];
    model12.flowName = @"6G";
    model12.pieceValue = @"180";
    model12.flowno = @"6144";
    [mobileArr addObject:model12];
    
    FNFlowRechargeModel * model13 = [[FNFlowRechargeModel alloc]init];
    model13.flowName = @"11G";
    model13.pieceValue = @"280";
    model13.flowno = @"11264";
    [mobileArr addObject:model13];
    
    return mobileArr;
}
@end
