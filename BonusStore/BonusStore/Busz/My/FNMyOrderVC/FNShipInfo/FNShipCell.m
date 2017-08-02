//
//  FNLogisInformationCell.m
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNShipCell.h"
#import "FNHeader.h"
@implementation FNShipCell

+ (instancetype)shipCellWithTableView:(UITableView *) tableView
{
     NSString *reuserId = NSStringFromClass([self class]);
    FNShipCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell == nil)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
       self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel * shipLabel = [[UILabel alloc]init];
        self.shipLabel = shipLabel;
        self.shipLabel.numberOfLines = 0;
        [self.shipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
        self.shipLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.shipLabel];
        
        UILabel * timeLabel = [[UILabel alloc]init];
        self.timeLabel = timeLabel;
        [timeLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLabel];
        UILabel * lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = MAIN_COLOR_SEPARATE;
        self.lineLabel = lineLabel;
        [self.contentView addSubview:lineLabel];
    }
    return self;
}

- (void)setTraceModel:(FNTraceModel *)traceModel
{
    _traceModel = traceModel;
    self.shipLabel.text = traceModel.context;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.shipLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.shipLabel.text.length)];
    self.shipLabel.attributedText = attributedString;
    CGSize labelSize = [FNShipCell sizeWithMaxSize:kScreenWidth -40  andFont:[UIFont systemFontOfSize:14] WithString:attributedString.string];
    self.shipLabel.frame = CGRectMake(20, 8, kScreenWidth -40,labelSize.height);
    
    self.timeLabel.text = traceModel.time;
    CGFloat timeY = CGRectGetMaxY(self.shipLabel.frame) + 8;
    self.timeLabel.frame = CGRectMake(20, timeY, kScreenWidth -40, [UIFont systemFontOfSize:14].lineHeight);
    
    CGFloat lineLabelY = CGRectGetMaxY(self.timeLabel.frame) + 8;

   self.lineLabel.frame = CGRectMake(0, lineLabelY -1, kScreenWidth, 1);
}


+ (CGFloat)cellHeightWithModel:(FNTraceModel *) traceModel
{
    CGFloat height = [UIFont systemFontOfSize:14].lineHeight;
    return height + 24 + [self sizeWithMaxSize:kScreenWidth -40 andFont:[UIFont systemFontOfSize:14] WithString:traceModel.context].height;
}

// 设置换行的label 的size
+ (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:5];
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
}


@end
