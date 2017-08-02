//
//  FNAboutHeadView.m
//  BonusStore
//
//  Created by sugarkawhi on 16/4/10.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNAboutHeadView.h"

#import "FNMacro.h"

@implementation FNAboutHeadView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {

        self.jsImageView = [[UIImageView alloc]init];
        
        self.jsImageView.frame = CGRectMake(0, 0, kScreenWidth, 282);
        
        self.jsImageView.image = [UIImage imageNamed:@"js_image"];
        
        [self.contentView addSubview:self.jsImageView];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
