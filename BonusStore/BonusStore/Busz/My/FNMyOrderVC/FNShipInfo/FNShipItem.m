//
//  FNLogisInformationItem.m
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNShipItem.h"

@implementation FNShipItem

+(NSMutableArray *)logisInformationItems
{
    NSMutableArray * arrM = [NSMutableArray array];
    for(int i=0 ;i<4;i++)
    {
        FNShipItem *item = [[FNShipItem alloc]init];
        item.logText = @"物流商          圆通快递";
        item.logNumber =@"物流单号       123343454545";
        item.logInformation =
               @"如果您在实作上有遭遇到键盘遮蔽编辑区域的问题，可以参考使用解决小键盘挡住的问题一文，透过功能，在键盘出现时同时移动编辑区域来解决遮蔽的问题如果您在实作上有遭遇到键盘遮蔽编辑区域的问题，可以参考使用解决小键盘挡住的问题一文，透过功能，在键盘出现时同时移动编辑区域来解决遮蔽的问题如果您在实作上有遭遇到键盘遮蔽编辑区域的问题，可以参考使用解决小键盘挡住的问题一文，透过功能，在键盘出现时同时移动编辑区域来解决遮蔽的问题如果您在实作上有遭遇到键盘遮蔽编辑区域的问题，可以参考使用解决小键盘挡住的问题一文，透过功能，在键盘出现时同时移动编辑区域来解决遮蔽的问题如果您在实作上有遭遇到键盘遮蔽编辑区域的问题，可以参考使用解决小键盘挡住的问题一文，透过功能，在键盘出现时同时移动编辑区域来解决遮蔽的问题end";
        [arrM  addObject:item];
    }
    return arrM;
}

@end
