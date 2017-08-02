//
//  FNLeftTableCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNLeftTableCell.h"

@implementation FNLeftTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        if (self.leftColorView == nil)
        {
            self.leftColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 48)];
            
            self.leftColorView.backgroundColor = [UIColor redColor];
            
            self.leftColorView.hidden = YES;
            
            [self.contentView addSubview:self.leftColorView];
        }
        
        if (self.nameLabel == nil)
        {
            self.nameLabel = [[UILabel alloc]init];
            
            self.nameLabel.font = [UIFont systemFontOfSize:14];
            
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.nameLabel sizeToFit];
            
            [self.contentView addSubview:self.nameLabel];
            
            [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.contentView);
                make.height.mas_equalTo(@20);
            }];
        }
    }
    return self;
}


- (void)awakeFromNib {
    
}
-(void)setHasBeenSelected:(BOOL)hasBeenSelected
{
    _hasBeenSelected=hasBeenSelected;
    
    if (_hasBeenSelected) {
        
        self.nameLabel.textColor = [UIColor redColor];
        
        self.contentView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        self.leftColorView.hidden=NO;
    }
    else
    {
        self.contentView.backgroundColor = nil;
        
        self.nameLabel.textColor=[UIColor blackColor];
        
        self.leftColorView.hidden=YES;
    }
}

-(void)setCurLeftTagModel:(FNCateParentModel *)curLeftTagModel
{
    _curLeftTagModel = curLeftTagModel;
    
    self.nameLabel.text = _curLeftTagModel.subjectName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


@end
