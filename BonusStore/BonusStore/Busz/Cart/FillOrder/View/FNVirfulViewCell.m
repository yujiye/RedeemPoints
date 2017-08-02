//
//  FNVirfulVIewCell.m
//  BonusStore
//
//  Created by feinno on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//
//static int  kTopCellHeight = 90;
//static int  kFootCellHeight = 50;



#import "FNVirfulViewCell.h"
#import "FNHeader.h"
static CGFloat kCellTopHeight = 90;

static CGFloat kMarginTopX = 10;

@implementation FNVirfulViewCell

+ (instancetype)virfulViewCellWithTableView:(UITableView *)tableView
{
    NSString *reuserId = NSStringFromClass([self class]);
    FNVirfulViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
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
        // 灰线
        UILabel *lineLabel1 =[[UILabel alloc]init];
        lineLabel1.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        lineLabel1.frame = CGRectMake(0,0, kScreenWidth, 1);
        [self.contentView addSubview:lineLabel1];
        //产品图片
        UIImageView *goodsPicture = [[UIImageView alloc]init];
        [self.contentView addSubview:goodsPicture];
        goodsPicture.contentMode = UIViewContentModeScaleAspectFit;
        self.pictureView = goodsPicture;
        [self.pictureView setFrame:CGRectMake(15, 5,80 , 80)];

        // 数量显示的蒙板
        UIImageView *maskView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_mask"]];
        self.maskView = maskView;
        [self.pictureView addSubview:maskView];
        [self.pictureView setFrame:CGRectMake(15, 5,80 , 80)];
        self.maskView.frame = CGRectMake(80 -self.maskView.width, 80- self.maskView.height, self.maskView.width, self.maskView.height);
        
        // 数量
        UILabel *numberLabel =[[UILabel alloc]init];
        self.numberLabel = numberLabel;
        numberLabel.textAlignment = NSTextAlignmentRight;
        [numberLabel  clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor whiteColor]];
        [self.pictureView addSubview:numberLabel];
        self.numberLabel.frame = CGRectMake(80 -self.maskView.width, 80- self.maskView.height +10, self.maskView.width, self.maskView.height);
        self.numberLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
        
        // 产品名称
        UILabel *goodsName = [[UILabel alloc]init];
        [self.contentView addSubview:goodsName];
        [goodsName clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
        goodsName.textAlignment = NSTextAlignmentLeft;
        self.nameLabel = goodsName;
        
        // 产品类型
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
        self.scoreLabel.textAlignment = NSTextAlignmentRight;
        [goodsScore clearBackgroundWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor redColor]];
        
        // 灰线
        UILabel *grayLine1 =[[UILabel alloc]init];
        grayLine1.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        grayLine1.frame = CGRectMake(0, kCellTopHeight -1, kScreenWidth, 1);
        [self.contentView addSubview:grayLine1];
        
        
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"手机号码 ";
        [label clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
        CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        label.frame = CGRectMake(15,(129-labelSize.height)*0.5+kCellTopHeight, labelSize.width, labelSize.height);
        [self.contentView addSubview:label];
        
        CGFloat numberX = CGRectGetMaxX(label.frame)+ 10;

        UILabel * intrLabel = [[UILabel alloc]init];
        intrLabel.backgroundColor = [UIColor redColor];
        [intrLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(140.0, 140.0, 140.0)];
        intrLabel.textAlignment = NSTextAlignmentLeft;
        intrLabel.numberOfLines = 2;
        intrLabel.text = @"此商品为服务性质,不支持7天无理由退货";
        CGSize intrLabelSize = [self sizeWithMaxSize:kScreenWidth -numberX- 15 andFont:[UIFont systemFontOfSize:14] WithString:intrLabel.text];

        intrLabel.frame = CGRectMake(numberX, (128- 40)*0.5+kCellTopHeight - intrLabelSize.height-5, kScreenWidth - numberX -15, intrLabelSize.height);
        [self.contentView addSubview:intrLabel];
        
        UITextField * phoneNumField = [[UITextField alloc]init];
        self.phoneNumField = phoneNumField;
        phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
        phoneNumField.tag = kTextFieldTagMobileNo;
        [self.contentView addSubview:phoneNumField];
        phoneNumField.borderStyle = UITextBorderStyleLine;
        phoneNumField.layer.borderColor= UIColorWithRGB(222.0, 222.0, 222.0).CGColor;
        phoneNumField.layer.borderWidth = 1.0f;
        phoneNumField.frame = CGRectMake(numberX, (128- 40)*0.5+kCellTopHeight, kScreenWidth -numberX- 15, 40);
        
        UILabel * detailLabel = [[UILabel alloc]init];
        [detailLabel clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWithRGB(227.0, 3.0, 3.0)];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.numberOfLines = 2;
        detailLabel.text = @"请务必确保手机号码能正常接收短信,电子劵码稍后以短信的形式发送";
        CGFloat detailY = CGRectGetMaxY(phoneNumField.frame) + 8;
        CGSize detailSize = [self sizeWithMaxSize:kScreenWidth -numberX- 15 andFont:[UIFont systemFontOfSize:12] WithString:detailLabel.text];
        detailLabel.frame = CGRectMake(numberX,detailY, kScreenWidth -numberX -15, detailSize.height);
        [self.contentView addSubview:detailLabel];
        
        UILabel * lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        lineLabel.frame = CGRectMake(0, 129+kCellTopHeight-1, kScreenWidth, 1);
        [self.contentView  addSubview:lineLabel];
        self.contentView.backgroundColor = UIColorWithRGB(248.0, 248.0, 248.0);
        
    }
    return self;
}

- (void)setCartItemModel:(FNCartItemModel *)cartItemModel
{
    _cartItemModel = cartItemModel ;

    //产品图片
    [self.pictureView sd_setImageWithURL:IMAGE_ID(cartItemModel.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];

    CGFloat goodsNameX = CGRectGetMaxX(self.pictureView.frame) + 12;
    self.numberLabel.text = [NSString stringWithFormat:@"X%zd",cartItemModel.count];

    // 产品名称
    NSString *goodsNameStr = cartItemModel.productName;
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
    CGSize goodsDetailSize = [cartItemModel.sku.skuName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.detailLabel.text = cartItemModel.sku.skuName;
    CGFloat goodsDetailY = CGRectGetMaxY(self.nameLabel.frame) + 10;
    [self.detailLabel setFrame:CGRectMake(goodsNameX, goodsDetailY,goodsDetailSize.width, goodsDetailSize.height)];
    
    
    // 产品当前价格
    NSString * priceStr =[NSString stringWithFormat:@"¥ %@",cartItemModel.cartPrice ? cartItemModel.cartPrice : cartItemModel.curPrice] ;
    self.priceCurLabel.text = priceStr;
    CGSize goodsPriceCurSize = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self.priceCurLabel setFrame:CGRectMake(goodsNameX,85 - goodsPriceCurSize.height, goodsPriceCurSize.width, goodsPriceCurSize.height)];
    // 产品积分
    CGFloat scoreX = CGRectGetMaxX(self.priceCurLabel.frame) + 12;
    NSString *curPrice = cartItemModel.cartPrice ? cartItemModel.cartPrice : cartItemModel.curPrice;
    NSString *scoreStr = [NSString stringWithFormat:@"%d积分",(int) ([curPrice  floatValue]* 100)];
    self.scoreLabel.text = scoreStr;
    CGSize goodsScoreSize = [scoreStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self.scoreLabel setFrame:CGRectMake(scoreX ,85 - goodsScoreSize.height, kScreenWidth - 15- scoreX, goodsScoreSize.height)];
    self.phoneNumField.text = cartItemModel.mobleNo;

}

/**
 *  减号按钮的方法
 *  @param sender   button的类型，点击的是加号还是减号
 */
- (void)minusBtnAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(virfulViewCellBtnClick:flag:)])
    {
        [self.delegate virfulViewCellBtnClick:self flag:sender.tag];
    }
}

/**
 *  加号按钮的方法
 *
 *  @param sender   button的类型，点击的是加号还是减号
 */
- (void)addBtnAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(virfulViewCellBtnClick:flag:)])
    {
        [self.delegate virfulViewCellBtnClick:self flag:sender.tag];
    }
}

// 设置换行的label 的size
- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}




@end
