//
//  FNSZBLCell.m
//  BonusStore
//
//  Created by Nemo on 17/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZBLCell.h"
#import "FNHeader.h"
@interface FNSZBLCell ()

@end

@implementation FNSZBLCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setMainUI];
        
    }
    
    return self;
    
}

- (void)setMainUI
{
    _nameLael = [[UILabel alloc] initWithFrame:CGRectMake(26, 18, kScreenWidth / 3, 14)];
    
    _nameLael.textColor = UIColorWith0xRGB(0x333333);
    
    _nameLael.font = [UIFont systemFontOfSize:14.0];
    
    _nameLael.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_nameLael];
    
    _identiferLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLael.right + 20, _nameLael.top, kScreenWidth / 3 * 2 - 80, 14)];
    
    _identiferLabel.textColor = UIColorWith0xRGB(0x333333);
    
    _identiferLabel.font = [UIFont systemFontOfSize:14.0];
    
    _identiferLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_identiferLabel];
   
}

@end
