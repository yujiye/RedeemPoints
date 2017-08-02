//
//  FNAddressCell.m
//  BonusStore
//
//  Created by feinno on 16/5/3.
//  Copyright © 2016年 Nemo. All rights reserved.
//



#import "FNAddressCell.h"
#import "FNHeader.h"



@implementation FNAddressCell

+ (instancetype)addressCellWithTableView:(UITableView *) tableView
{
    NSString *reuserId = NSStringFromClass([self class]);
    FNAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell == nil)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * backGroudLabel = [[UILabel alloc]init];
        backGroudLabel.backgroundColor = MAIN_BACKGROUND_COLOR;
        backGroudLabel.frame = CGRectMake(0, 0, kScreenWidth, 10);
        [self.contentView addSubview:backGroudLabel];
        
        UILabel *introduceLabel = [[UILabel alloc]init];
        introduceLabel.textAlignment = NSTextAlignmentLeft;
        [introduceLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(61.0, 61.0, 61.0)];
        self.introduceLabel = introduceLabel;
        [self.contentView addSubview:introduceLabel];
        
        UILabel *isDefaultLabel = [[UILabel alloc]init];
        self.isDefaultLabel = isDefaultLabel;
        isDefaultLabel.textAlignment = NSTextAlignmentLeft;
        [isDefaultLabel clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWithRGB(61.0, 61.0, 61.0)];
        [self.contentView addSubview:isDefaultLabel];
        
        UILabel *detailLabel = [[UILabel alloc]init];
        self.detailLabel = detailLabel;
        detailLabel.textAlignment = NSTextAlignmentLeft;
        [detailLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(61.0, 61.0, 61.0)];
        [self.contentView addSubview:detailLabel];
        
        UILabel * grayLabel = [[UILabel alloc]init];
        grayLabel.backgroundColor = MAIN_BACKGROUND_COLOR;
        grayLabel.frame = CGRectMake(0, 70+10, kScreenWidth, 1);
        [self.contentView addSubview:grayLabel];
        
        for(int i=0; i<2; i++)
        {
            UILabel * lineLabel = [[UILabel alloc]init];
            lineLabel.backgroundColor = MAIN_BACKGROUND_COLOR;
            lineLabel.frame = CGRectMake(kScreenWidth*0.33*(i+1), 76+10, 1, 22);
            [self.contentView addSubview:lineLabel];
        }
        
        UIButton * editBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.tag = kButtonTypeEdit;
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setTitleColor:UIColorWithRGB(61.0, 61.0, 61.0) forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        editBtn.frame = CGRectMake(0, 70+10, kScreenWidth *0.33, 33);
        [self.contentView addSubview:editBtn];
        
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = kButtonTypedelete;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitleColor:UIColorWithRGB(61.0, 61.0, 61.0) forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        deleteBtn.frame = CGRectMake( kScreenWidth *0.33, 70+10, kScreenWidth *0.33, 33);
        [self.contentView addSubview:deleteBtn];
        
        UIButton * defaultBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        self.defaultBtn= defaultBtn;
        defaultBtn.tag = kButtonTypeDefault;
        [defaultBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        [defaultBtn setTitleColor:UIColorWithRGB(61.0, 61.0, 61.0) forState:UIControlStateNormal];
        defaultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        defaultBtn.frame = CGRectMake( kScreenWidth *0.33 * 2, 70+10, kScreenWidth *0.33, 33);
        [self.contentView addSubview:defaultBtn];
        
    }
    return self;
}

-(void)setAddressModel:(FNAddressModel *)addressModel
{
    _addressModel = addressModel;
    self.introduceLabel.text = [NSString stringWithFormat:@"%@  %@",addressModel.receiverName , addressModel.mobile];
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@%@%@",addressModel.provinceName,addressModel.cityName,addressModel.countyName,addressModel.address];;
    self.isDefaultLabel.textColor = [UIColor redColor];
    self.isDefaultLabel.text = @"默认地址" ;
    if(addressModel.isDefault == 1)
    {
        CGSize introduceSize = [self.introduceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.introduceLabel.frame = CGRectMake(15, 14+10, introduceSize.width, introduceSize.height);
        CGSize defaultSize = [self.isDefaultLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        self.isDefaultLabel.frame = CGRectMake(kScreenWidth -10-defaultSize.width, 14+10, defaultSize.width, defaultSize.height);
        self.isDefaultLabel.hidden = NO;
        self.defaultBtn.enabled = NO;
        [self.defaultBtn setTitleColor:MAIN_BACKGROUND_COLOR forState:UIControlStateNormal];
        
    }else
    {
        self.introduceLabel.frame = CGRectMake(15, 14+10, kScreenWidth-30, 14);
        self.isDefaultLabel.hidden = YES;
        self.defaultBtn.enabled =YES;
        [self.defaultBtn setTitleColor:UIColorWithRGB(61.0, 61.0, 61.0) forState:UIControlStateNormal];
    }
    
    self.detailLabel.frame = CGRectMake(15,42+10, kScreenWidth-30, 14);
}


- (void)buttonClick:(UIButton *)btn
{
    
    if([self.delegate respondsToSelector:@selector(addressCellBtnClick:flag:)])
    {
        [self.delegate addressCellBtnClick:self flag:btn.tag];
    }
}
@end
