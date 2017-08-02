//
//  FNBaseCell.m
//  BonusStore
//
//  Created by Nemo on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseCell.h"

@implementation FNBaseCell

static NSString *identifier;

+ (__kindof FNBaseCell *)dequeueWithTableView:(UITableView *)tableView
{
    identifier = NSStringFromClass([self class]);
    
    FNBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell =  [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

@end
