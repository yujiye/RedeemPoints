//
//  FNDetailHeaderView.m
//  BonusStore
//
//  Created by feinno on 16/6/16.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNDetailHeaderView.h"
#import "FNHeader.h"



@interface FNDetailHeaderView ()
{
  CGFloat  _height;
  CGFloat oldFont;
}
@end


@implementation FNDetailHeaderView

static NSString *reuseId = @"FNDetailHeaderView";

+ (instancetype)detailHeaderViewWithTableView:(UITableView *)tableView
{
    FNDetailHeaderView *detailHeaderView = [tableView  dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    if ( detailHeaderView == nil )
    {
        detailHeaderView = [[self alloc]initWithReuseIdentifier:reuseId];
    }
    return detailHeaderView;
}

-(void)setProductModel:(FNCartItemModel *)productModel
{
    _productModel = productModel;
    
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
        oldFont = 10;
    }
    else
    {
        oldFont = 12;
    }

    if( productModel.productName !=nil)
    {
        self.nameLabel.text = productModel.productName;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.nameLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:0];
        [paragraphStyle setHeadIndent:0];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
        self.nameLabel.attributedText = attributedString ;
    }
    CGFloat nheight = ([UIFont systemFontOfSize:16].lineHeight) * 2;
    CGSize goodsNameSize  = [self sizeWithMaxSize:kScreenWidth -64 -20 andFont:[UIFont systemFontOfSize:16] WithString:self.nameLabel.attributedText.string];
    self.nameLabel.frame = CGRectMake(15, 10, goodsNameSize.width, goodsNameSize.height );
    
    CGFloat nameY = CGRectGetMaxY(self.nameLabel.frame);
    
    if( productModel.viceName !=nil)
    {
        self.viceNameLabel.text = productModel.viceName;
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:self.viceNameLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:0];
        [paragraphStyle setHeadIndent:0];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString1.length)];
        self.viceNameLabel.attributedText = attributedString1 ;
    }
    CGSize viceNameSize  = [self sizeWithMaxSize:kScreenWidth -64 -20 andFont:[UIFont systemFontOfSize:14] WithString:self.viceNameLabel.attributedText.string];
    self.viceNameLabel.frame = CGRectMake(15, nameY+8, viceNameSize.width, viceNameSize.height );
    self.viceNameLabel.hidden = YES;
 
    self.priceLabel.text = productModel.minCurPrice;
    NSArray *array = [self.priceLabel.text componentsSeparatedByString:@"."];
    if ([array count])
    {
        NSString *string1 = array.firstObject;
        NSString *string2 = array.lastObject;
        NSString *string3 = [NSString stringWithFormat:@"%@.%@",string1,string2];
        NSMutableAttributedString * newstr = [string3 makeStr:string2 withColor:MAIN_COLOR_RED_ALPHA andFont:[UIFont systemFontOfSize:12]];
        self.priceLabel.attributedText =newstr;
    }
  
     CGSize priceLabelSize  = [self sizeWithMaxSize:kScreenWidth -64 -10 andFont:[UIFont systemFontOfSize:18] WithString:self.priceLabel.text];
    self.priceLabel.frame = CGRectMake(15+10, nameY+10 , priceLabelSize.width, 21);
    CGFloat width;
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5)
    {
        width = 50;
    }
    else
    {
        width = 60;
    }
    self.sendLab = [[UILabel alloc]initWithFrame:CGRectMake(self.priceLabel.x+self.priceLabel.width +6, self.priceLabel.y, width, 17)];
    self.sendLab.backgroundColor = MAIN_COLOR_RED_ALPHA;
    self.sendLab.layer.masksToBounds =YES;
    self.sendLab.textAlignment = NSTextAlignmentCenter;
    self.sendLab.textColor = MAIN_COLOR_WHITE;
     NSString * str1 = [NSString stringWithFormat:@"%.0f",floorf([productModel.minCurPrice floatValue])];
    self.sendLab.text = [NSString stringWithFormat:@"送%@积分",str1];
    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
    {
    self.sendLab.font = [UIFont systemFontOfSize:8];
    }
    else
    {
        self.sendLab.font = [UIFont systemFontOfSize:10];
    }
    self.sendLab.layer.cornerRadius = 4.0;
    if ([str1 integerValue] == 0)
    {
        self.sendLab.hidden = YES;
    }
    else
    {
        self.sendLab.hidden = NO;
    }
    [self addSubview:self.sendLab];
    
    NSString *oldPrice = [NSString stringWithFormat:@"¥%@",productModel.maxOrgPrice];
    NSUInteger length = [oldPrice length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:MAIN_COLOR_GRAY_ALPHA range:NSMakeRange(0, length)];
    [self.orgPriceLabel setAttributedText:attri];
    CGFloat orgPriceX ;
    if (self.hidden == YES)
    {
        orgPriceX= CGRectGetMaxX(self.priceLabel.frame)+8;
    }
    else
    {
       orgPriceX = CGRectGetMaxX(self.sendLab.frame)+8;
    }
    
    CGSize orgPriceLabelSize  = [self sizeWithMaxSize:kScreenWidth -64 -10 andFont:[UIFont systemFontOfSize:oldFont] WithString:self.orgPriceLabel.text];
     self.orgPriceLabel.frame = CGRectMake(orgPriceX, self.priceLabel.y +5,orgPriceLabelSize.width ,[UIFont systemFontOfSize:oldFont].lineHeight);
    CGFloat scroreX = CGRectGetMaxX(self.orgPriceLabel.frame)+14;
    if (productModel.minCurPrice)
    {
        NSDecimalNumber *minCurPrice = [NSDecimalNumber decimalWithString:productModel.minCurPrice];
        self.scoreLabel.text = [NSString stringWithFormat:@"%@积分",[minCurPrice multiplyingBy:100]];
    }
    if (self.scoreLabel.text.length > 6)
    {
        self.scoreLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        self.scoreLabel.font = [UIFont systemFontOfSize:18];
    }


    NSMutableAttributedString *needStr2 = [self.scoreLabel.text makeStr:@"积分" withColor:MAIN_COLOR_RED_ALPHA andFont:[UIFont systemFontOfSize:oldFont]];
    self.scoreLabel.attributedText = needStr2;
    self.scoreLabel.frame = CGRectMake(scroreX, self.priceLabel.y, kScreenWidth -scroreX -10, self.priceLabel.height);

    self.lineLabel.frame = CGRectMake(kScreenWidth -64, 10, 1, nheight - 6);
    self.imgView.frame = CGRectMake(kScreenWidth - 44, 10, self.imgView.image.size.width, self.imgView.image.size.height);
    CGFloat imageViewY = CGRectGetMaxY(self.imgView.frame);

    _height = CGRectGetMaxY(self.priceLabel.frame) +10;
    
    self.shareLabel.frame = CGRectMake(kScreenWidth -44, imageViewY, 44, [UIFont systemFontOfSize:12].lineHeight);
    CGFloat clickBtnY = CGRectGetMaxY(self.shareLabel.frame);
    self.clickBtn.frame =  CGRectMake(kScreenWidth -44, 10, 44, clickBtnY);
    _moneyLa.frame=CGRectMake(15,self.priceLabel.y + 5 , 10, 15);
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        // 名称
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = [UIFont systemFontOfSize:16 ];
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];
        
        // 副标题
        self.viceNameLabel = [[UILabel alloc]init];
        self.viceNameLabel.font = [UIFont systemFontOfSize:14 ];
        self.viceNameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.viceNameLabel];
        
        // 现在最低价格
        self.priceLabel = [[UILabel alloc]init];
        [self.priceLabel clearBGWithFontOfArialSize:18 textColor:[UIColor redColor]];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.priceLabel];
        CGFloat _oldFont;
        if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
        {
            _oldFont = 10;
        }
        else
        {
            _oldFont = 12;
        }

        // 原来最高价格
        self.orgPriceLabel = [[UILabel alloc]init];
        [self.orgPriceLabel clearBackgroundWithFont:[UIFont systemFontOfSize:_oldFont ] textColor:MAIN_COLOR_GRAY_ALPHA];
        self.orgPriceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.orgPriceLabel];
        
        // 积分
        self.scoreLabel = [[UILabel alloc]init];
        [self.scoreLabel clearBGWithFontOfArialSize:12 textColor:[UIColor redColor]];
        self.scoreLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.scoreLabel];
        
        self.lineLabel =[[UILabel alloc]init];
        self.lineLabel.backgroundColor = MAIN_COLOR_SEPARATE;
        [self.contentView addSubview:self.lineLabel];
        
        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"product_share"]];
        [self.contentView addSubview:self.imgView];
        
        self.clickBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.clickBtn];
        
        self.shareLabel = [[UILabel alloc]init];
        self.shareLabel.text = @"分享";
        [self.shareLabel clearBackgroundWithFont: [UIFont systemFontOfSize:12] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
        [self.contentView addSubview:self.shareLabel];
        self.contentView.backgroundColor = UIColorWithRGB(248.0, 248.0, 248.0);
        _moneyLa = [[UILabel alloc]init];
        _moneyLa.textColor = MAIN_COLOR_RED_ALPHA;
        _moneyLa.font = [UIFont systemFontOfSize:12];
        _moneyLa.text = @"¥";
        [self addSubview:_moneyLa];

        
    }
    return  self;
}

-(CGFloat)height
{
    return _height;
}

// 设置换行的label 的size
- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setHeadIndent:0];
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
}

@end
