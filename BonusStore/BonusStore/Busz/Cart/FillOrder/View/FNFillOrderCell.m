//
//  FNFillOrderCell.m
//  BonusStore
//
//  Created by qingPing on 16/4/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FNFillOrderCell.h"
#import "FNHeader.h"

static CGFloat  kMarginTopX = 15;

@implementation FNFillOrderCell
+ (instancetype)fillOrderCellWithTableView:(UITableView *) tableView
{
    NSString *reuserId = NSStringFromClass([self class]);
    FNFillOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
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
        
        UILabel *lineLabel1 =[[UILabel alloc]init];
        lineLabel1.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        lineLabel1.frame = CGRectMake(0,0, kScreenWidth, 1);
        [self.contentView addSubview:lineLabel1];
        // 产品图片
        UIImageView *goodsPicture = [[UIImageView alloc]init];
        [self.contentView addSubview:goodsPicture];
        self.pictureView = goodsPicture;
        goodsPicture.contentMode = UIViewContentModeScaleAspectFit;
        
        // 数量显示的蒙板
        UIImageView *maskView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_mask"]];
        self.maskView = maskView;
        [self.pictureView addSubview:maskView];
        [self.pictureView setFrame:CGRectMake(15, 5,80 , 80)];
        
        self.maskView.frame = CGRectMake(80 -self.maskView.width, 80- self.maskView.height, self.maskView.width, self.maskView.height);
        
        // 库存不足的数量
        UILabel * maskLabel = [[UILabel alloc]init];
        self.maskLabel = maskLabel;
        self.maskLabel.textAlignment = NSTextAlignmentCenter;
        [self.maskLabel clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor]];
        self.maskLabel.frame = CGRectMake(0, 80 -[UIFont systemFontOfSize:12].lineHeight, 80, [UIFont systemFontOfSize:12].lineHeight);
        self.maskLabel.backgroundColor = [UIColor grayColor];
        [self.pictureView addSubview:self.maskLabel];
        // 数量
        UILabel *numberLabel =[[UILabel alloc]init];
        self.numberLabel = numberLabel;
        numberLabel.textAlignment = NSTextAlignmentRight;
        [numberLabel clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor]];
        [self.pictureView addSubview:numberLabel];
        self.numberLabel.frame = CGRectMake(80 -self.maskView.width, 80- self.maskView.height +10, self.maskView.width, self.maskView.height);
        self.numberLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
        
        // 产品名称
        UILabel *goodsName = [[UILabel alloc]init];
        [self.contentView addSubview:goodsName];
        [goodsName clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
        goodsName.textAlignment = NSTextAlignmentLeft;
        self.nameLabel = goodsName;
        // 产品补充说明
        UILabel *goodsDetail = [[UILabel alloc]init];
        [self.contentView addSubview:goodsDetail];
        [goodsDetail clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWithRGB(140.0, 140.0, 140.0)];
        goodsDetail.textAlignment = NSTextAlignmentLeft;
        self.detailLabel = goodsDetail;
        // 产品现在价格
        UILabel *goodsPriceCur = [[UILabel alloc]init];
        [self.contentView addSubview:goodsPriceCur];
        [goodsPriceCur clearBackgroundWithFont:[UIFont systemFontOfSize:18] textColor: [UIColor redColor]];
        goodsPriceCur.textAlignment = NSTextAlignmentLeft;
        self.priceCurLabel = goodsPriceCur;
        // 产品积分
        UILabel *goodsScore = [[UILabel alloc]init];
        self.scoreLabel = goodsScore;
        [self.contentView addSubview:goodsScore];
        [goodsScore clearBackgroundWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor redColor]];
        goodsScore.textAlignment = NSTextAlignmentRight;
        self.contentView.backgroundColor = UIColorWithRGB(248.0, 248.0, 248.0);
        
    }
    return self;
}

- (void)setFillOrderItem:(FNCartItemModel *)fillOrderItem
{
    _fillOrderItem = fillOrderItem;
    // 产品图片
    [self.pictureView sd_setImageWithURL:IMAGE_ID(fillOrderItem.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];

    if (fillOrderItem.isOver == NO) //库存小于填写的
    {
        self.maskView.hidden =YES;
        self.numberLabel.hidden =YES;
        self.maskLabel.hidden = NO;
        if(fillOrderItem.skuCount == 0)
        {
            self.maskLabel.text = @"已售罄";
        }else
        {
        self.maskLabel.text = [NSString stringWithFormat:@"仅剩%zd件",fillOrderItem.skuCount];
        }
        
    }else
    {
        self.maskView.hidden = NO;
        self.numberLabel.hidden = NO;
        self.maskLabel.hidden = YES;
        self.numberLabel.text = [NSString stringWithFormat:@"X%zd",fillOrderItem.count];
    }
  
    CGFloat goodsNameX = CGRectGetMaxX(self.pictureView.frame) + 12;
    // 产品名称
    NSString *goodsNameStr = fillOrderItem.productName;
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.text = goodsNameStr ;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.nameLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setHeadIndent:0];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    self.nameLabel.attributedText = attributedString;
    CGSize goodsNameSize  = [self.nameLabel sizeWithMaxSize:kScreenWidth - goodsNameX- kMarginTopX andFont:[UIFont systemFontOfSize:14] WithString:self.nameLabel.attributedText.string];
    CGFloat nheight = ([UIFont systemFontOfSize:14].lineHeight) * 2;
    self.nameLabel.frame = CGRectMake(goodsNameX, 5, goodsNameSize.width, goodsNameSize.height > nheight ? nheight:goodsNameSize.height );

    // 产品补充说明
    NSString *goodsDetailStr = fillOrderItem.sku.skuName;
    CGSize goodsDetailSize = [goodsDetailStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.detailLabel.text = goodsDetailStr;
    CGFloat goodsDetailY = CGRectGetMaxY(self.nameLabel.frame) + 8;
    [self.detailLabel setFrame:CGRectMake(goodsNameX, goodsDetailY,kScreenWidth - goodsNameX - kMarginTopX, goodsDetailSize.height)];
    
    // 产品当前价格
    CGFloat curPrice ;
    if([NSString isEmptyString:fillOrderItem.curPrice])
    {
        curPrice = [fillOrderItem.cartPrice doubleValue];
    }else
    {
        curPrice = [fillOrderItem.curPrice doubleValue];

    }
    NSString * priceStr = [NSString stringWithFormat:@"¥%.2lf ",curPrice];
    self.priceCurLabel.text = priceStr;
    CGSize goodsPriceCurSize = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self.priceCurLabel setFrame:CGRectMake(goodsNameX,85 - goodsPriceCurSize.height, goodsPriceCurSize.width, goodsPriceCurSize.height)];
    
    // 产品积分
     NSString *scoreStr = [NSString stringWithFormat:@" %zd积分  ",(int)(curPrice * 100)];
    self.scoreLabel.text = scoreStr;
    CGSize goodsScoreSize = [scoreStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self.scoreLabel setFrame:CGRectMake(kScreenWidth -goodsScoreSize.width-15 ,85 - goodsPriceCurSize.height, goodsScoreSize.width, goodsScoreSize.height)];
    
}

@end
