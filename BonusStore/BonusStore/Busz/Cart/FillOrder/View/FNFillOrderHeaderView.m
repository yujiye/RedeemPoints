//
//  FNFillOrderHeaderView.m
//  BonusStore
//
//  Created by feinno on 16/4/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNFillOrderHeaderView.h"
#import "FNHeader.h"
@implementation FNFillOrderHeaderView

+ (instancetype)fillOrderHeaderViewWithTableView:(UITableView *) tableView
{
    NSString *reuseId = NSStringFromClass([self class]);
    FNFillOrderHeaderView *fillOrderHeaderView = [tableView  dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    if ( fillOrderHeaderView == nil )
    {
        fillOrderHeaderView = [[self alloc]initWithReuseIdentifier:reuseId];
    }
    return fillOrderHeaderView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        UILabel * grayline = [[UILabel alloc]init];
        grayline.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        grayline.frame = CGRectMake(0, 0, kScreenWidth, 10);
        [self.contentView addSubview:grayline];
        
        UIView * whiteView = [[UIView alloc]init];
        whiteView.backgroundColor =[UIColor whiteColor];
        whiteView.frame = CGRectMake(0, 10, 15, 40);
        [self.contentView addSubview:whiteView];
        
        UILabel * label = [[UILabel alloc]init];
        self.nameLabel = label;
        [self.nameLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
        label.frame = CGRectMake(15, 10, kScreenWidth, 40);
        label.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)setCartGroup:(FNCartGroupModel *)cartGroup
{
    _cartGroup = cartGroup;
    self.nameLabel.text = cartGroup.sellerName;
    
}

@end
