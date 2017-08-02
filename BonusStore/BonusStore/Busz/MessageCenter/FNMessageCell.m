//
//  FNMessageCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMessageCell.h"
#import "FNMacro.h"
#import "UIFont+Cate.h"

#import "FNMessageNoti.h"

@interface FNMessageCell ()

@end

@implementation FNMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 56, 56)];
        
        self.titleImageView.layer.cornerRadius = 1.0;
        
        self.titleImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.titleImageView];
        
        // 小红点
        _messageImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(_titleImageView.x + _titleImageView.width-6, _titleImageView.y -6, 12, 12)];
        
        _messageImageView1.layer.cornerRadius = 6.0;
        
        _messageImageView1.layer.masksToBounds = YES;

        [self.contentView addSubview:_messageImageView1];

        self.messageTitle = [[UILabel alloc]initWithFrame:CGRectMake(_titleImageView.x + _titleImageView.width + 15, _titleImageView.y , kScreenWidth - _titleImageView.x - _titleImageView.width, 30)];
        
        self.messageTitle.font = [UIFont fontWithName:FONT_NAME_LTH size:16];
    
        [self.contentView addSubview:self.messageTitle];

        self.messageContent = [[UILabel alloc]initWithFrame:CGRectMake(_messageTitle.x, _messageTitle.y + _messageTitle.height, _messageTitle.width, 25)];
        self.messageContent.textColor = [UIColor lightGrayColor];
        self.messageContent.font = [UIFont systemFontOfSize:13];

        [self.contentView addSubview:self.messageContent];
    }
    return self;
}

- (void)setMessageModel:(FNMessageModel *)messageModel
{
    _messageModel = messageModel;

    self.titleImageView.image = [UIImage imageNamed:_messageModel.titleImage];
    self.messageTitle.text = _messageModel.messageTitle;
    self.messageContent.text = _messageModel.messageContent;
    
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
