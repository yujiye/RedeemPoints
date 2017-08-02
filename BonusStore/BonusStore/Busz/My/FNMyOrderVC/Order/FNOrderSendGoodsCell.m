//
//  FNOrderSendGoodsCell.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderSendGoodsCell.h"

static CGFloat Left       = 15;

static CGFloat Top        = 12;


static CGFloat Height1    = 40;

static CGFloat ImageWidth = 63;

static CGFloat LabelWidth = 120;

static CGFloat LabelHeight= 20;

static CGFloat FontSize  = 14;

@interface FNOrderSendGoodsCell ()

@property (nonatomic, strong) UIView * view;

@end


@implementation FNOrderSendGoodsCell

+ (instancetype)sendGoodsTableView:(UITableView *)tabelView
{
    static NSString * reuseId = @"sendCell";
    
    FNOrderSendGoodsCell * cell = [tabelView dequeueReusableCellWithIdentifier:reuseId];
    
    if (cell == nil) {
        cell = [[FNOrderSendGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        
        _titleName = [[UILabel alloc]initWithFrame:CGRectMake(Left, Top, LabelWidth, LabelHeight)];
        
        _titleName.font = [UIFont fontWithName:FONT_NAME_LTH size:FontSize];
        
        [self.contentView addSubview:_titleName];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, Height1, kScreenWidth, 1)];
        line.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        [self.contentView addSubview:line];
        
        _status = [[UILabel alloc]init];
        
        _status.textColor = MAIN_COLOR_RED_BUTTON;
        
        _status.font = [UIFont fontWithName:FONT_NAME_LTH size:FontSize];
        
        [self.contentView addSubview:_status];
        
        [_status mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(self.contentView.mas_top).offset(Top);
            
            make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
            
            make.width.mas_equalTo(Height1+Left);
            
            make.height.mas_equalTo(LabelHeight);
            
        }];
        
        NSInteger j = 0;
        
        _array = @[@"1",@"2",@"3"];
        
        if (_array.count > 3) {
            
           j = 3;
            
        }else {
            
            j = _array.count;
            
        }
        
        for (int i = 0; i < 3; i ++) {
            
            _image.image = [UIImage imageNamed:@"cart_goodsPic"];
        
            _image = [[UIImageView alloc]initWithFrame:CGRectMake( (ImageWidth + 12 ) * i + Left , Height1 + Left, ImageWidth, ImageWidth)];
            
            [self.contentView addSubview:_image];
        }
        
        
        _view = [[UIView alloc]init];
        
        _view.backgroundColor = MAIN_COLOR_WHITE;
        
        [self.contentView addSubview:_view];
        
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(self.contentView.mas_right).offset(0);
            
            make.top.mas_equalTo(line.mas_bottom).offset(0);
            
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
            
            make.width.mas_equalTo(120);
            
        }];
        
        
        NSString * str = @"5";
        
        NSString * str2 = [NSString stringWithFormat:@"共 %@ 件",str];
        
        NSMutableAttributedString * newstr = [str2 makeStr:@"%@" withColor:MAIN_COLOR_RED_BUTTON andFont:[UIFont systemFontOfSize:12]];
        
        _num = [[UILabel alloc]init];
        
        _num.attributedText = newstr;
        
        
        [_view addSubview:_num];
        
        [_num mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(_image.mas_centerY).offset(0);
            
            make.right.mas_equalTo(_view.mas_right).offset(- 58);
            
            make.width.mas_equalTo(Height1 + Left);
            
            make.height.mas_equalTo(LabelHeight);
        }];
        
        _rightImage = [[UIImageView alloc]init];
        
        _rightImage.image = [UIImage imageNamed:@"main_rank_more"];
        
        [_view addSubview:_rightImage];
        
        [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_image.mas_centerY).offset(0);
            make.right.mas_equalTo(_view.mas_right).offset(-8);
            make.height.mas_equalTo(LabelHeight);
            make.width.mas_equalTo(8);
        }];
    
    }
    return self;
}

- (void)setModel:(FNOrderSendGoods *)model
{
    _model = model;
    
    self.titleName.text = _model.title;
    self.status.text = _model.status;
    self.image.image = [UIImage imageNamed:@"cart_goodsPic"];
    self.num.text = _model.num;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
