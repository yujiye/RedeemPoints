//
//  FNAddressTableViewCell.m
//  BonusStore
//
//  Created by feinno on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//
#import "FNAddressTableViewCell.h"
#import "FNHeader.h"


@interface FNAddressTableViewCell ()


@end

@implementation FNAddressTableViewCell

+(instancetype)addressTableViewCellWithTableView:(UITableView *) tableView

{
    static NSString *reuserId = @"addressTableViewCell";
    FNAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell == nil)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *introduceLabel = [[UILabel alloc]init];
        self.introduceLabel = introduceLabel;
        introduceLabel.textAlignment = NSTextAlignmentLeft;
        [introduceLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(61.0, 61.0, 61.0)];
        [self.contentView addSubview:introduceLabel];
        CGSize introduceLabelSize = [@"     详细地址:" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        introduceLabel.frame = CGRectMake(0, 0,introduceLabelSize.width , 44);
        
        UITextField *detailField = [[UITextField alloc]init];
        self.detailField = detailField;
        detailField.textAlignment = NSTextAlignmentLeft;
        detailField.textColor = UIColorWithRGB(61.0, 61.0, 61.0);
        detailField.font = [UIFont systemFontOfSize:14];
        detailField.frame = CGRectMake(introduceLabelSize.width  + 10, 0, kScreenWidth -introduceLabelSize.width -10, 44);
        self.detailField.enablesReturnKeyAutomatically = YES;

        [self.contentView addSubview:detailField];
        
        UIButton *btn = [[UIButton alloc]init];
        self.btn = btn;
        btn.hidden = YES;
        btn.frame = CGRectMake(kScreenWidth *0.25, 0, kScreenWidth *0.75, 44);
        [self.contentView addSubview:btn];
        
        UIImageView *image1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_order"]];
        self.image1 = image1;
        image1.frame = CGRectMake(kScreenWidth - 15 - image1.frame.size.width, (44-image1.frame.size.height) *0.5, image1.frame.size.width, image1.frame.size.height);
        self.image1.hidden = YES;
        [self.contentView addSubview:image1];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = MAIN_COLOR_SEPARATE;
        lineLabel.frame = CGRectMake(0, 43, kScreenWidth, 1);
        [self.contentView addSubview:lineLabel];
        
        
   }
    return self;
}

@end

