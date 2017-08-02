//
//  FNOrderViewCell.m
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//
static int  kTopCellHeight = 90;
#import "FNOrderViewCell.h"
#import "FNHeader.h"
@implementation FNOrderViewCell


// 重写init方法,完成对子控件的初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        // 1. 创建子控件 // 2. 只需要执行一次的代码
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lineLabel1 =[[UILabel alloc]init];
        lineLabel1.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        lineLabel1.frame = CGRectMake(0,0, kScreenWidth, 1);
        [self.contentView addSubview:lineLabel1];
        //产品图片
        UIImageView *goodsPicture = [[UIImageView alloc]init];
        [self.contentView addSubview:goodsPicture];
        self.goodsPicture = goodsPicture;
        
        // 产品名称
        UILabel *goodsName = [[UILabel alloc]init];
        [self.contentView addSubview:goodsName];
        [goodsName clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
        goodsName.textAlignment = NSTextAlignmentLeft;
        self.goodsName = goodsName;
        
        // 产品补充说明
        UILabel *goodsDetail = [[UILabel alloc]init];
        [self.contentView addSubview:goodsDetail];
        [goodsDetail clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWithRGB(140.0, 140.0, 140.0)];
        goodsDetail.textAlignment = NSTextAlignmentLeft;
        self.goodsDetail = goodsDetail;
        
        // 产品现在价格
        UILabel *goodsPrice = [[UILabel alloc]init];
        [self.contentView addSubview:goodsPrice];
        [goodsPrice clearBackgroundWithFont:[UIFont systemFontOfSize:18] textColor: [UIColor redColor]];
        goodsPrice.textAlignment = NSTextAlignmentLeft;
        self.goodsPrice = goodsPrice;
        // 加一个灰线
        UILabel *grayLine =[[UILabel alloc]init];
        grayLine.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        grayLine.frame = CGRectMake(0, kTopCellHeight -1, kScreenWidth, 1);
        [self.contentView addSubview:grayLine];
        
        //  给卖家留言栏
        UILabel * commentsLabel = [[UILabel alloc]init];
        self.commentsLabel = commentsLabel;
        [commentsLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGBA(152.0 , 152.0 , 152.0,0.7)];
        self.commentsLabel.numberOfLines = 0;
        [self.contentView addSubview:commentsLabel];
        
        UILabel *grayLine1 =[[UILabel alloc]init];
        self.grayLine1 = grayLine1;
        grayLine1.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        [self.contentView addSubview:grayLine1];
        
        self.returnBut = [FNButton buttonWithType:FNButtonTypeEdge title:@"申请退货"];
        [self.returnBut setCorner:5];
        self.returnBut.titleLabel.textAlignment = NSTextAlignmentRight;
        self.returnBut.titleLabel.font = [UIFont fzltWithSize:14];
        
        [self.returnBut addTarget:self action:@selector(returnGoods) forControlEvents:UIControlEventTouchUpInside];
        self.returnBut.frame = CGRectMake(kWindowWidth-75, 90-33, 60, 25);
        
        [self.contentView addSubview:self.returnBut];
        self.returnBut.hidden = YES;
        
        _returnStateLabel = [[UILabel alloc]init];
        
        _returnStateLabel.frame = CGRectMake(kWindowWidth-75, 90-30, 60, 25);
        _returnStateLabel.textAlignment = NSTextAlignmentRight;
        [_returnStateLabel clearBackgroundWithFont: [UIFont fzltWithSize:14] textColor:MAIN_COLOR_RED_BUTTON];
        
        [self.contentView addSubview:_returnStateLabel];
    }
    return self;
}
static CGFloat kMarginTopX = 15;

-(void)setProduct:(FNProductArgs *)product
{
    _product = product;
    //产品图片
    [self.goodsPicture setFrame:CGRectMake(13, 15, 63, 63)];
    [self.goodsPicture sd_setImageWithURL:IMAGE_ID(product.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
    CGFloat goodsNameX = CGRectGetMaxX(self.goodsPicture.frame) + 12;
    NSString *goodsNameStr = product.productName;
    // 产品名称
    if([NSString isEmptyString:goodsNameStr])
    {
        goodsNameStr = @"聚分享产品";
    }
    self.goodsName.text = goodsNameStr;
   CGSize  goodsNameSize = [goodsNameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [self.goodsName setFrame:CGRectMake(goodsNameX, 13,kScreenWidth - goodsNameX - kMarginTopX , goodsNameSize.height)];
  
    // 产品补充说明
    NSString *goodsDetailStr = nil;
    if([NSString isEmptyString:product.sku[@"skuName"]])
    {
        goodsDetailStr = [NSString stringWithFormat:@" x%@",product.count];
    }else
    {
        goodsDetailStr = [NSString stringWithFormat:@"%@   x%@",product.sku[@"skuName"],product.count];
    }
    
    CGSize goodsDetailSize = [goodsDetailStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.goodsDetail.text = goodsDetailStr;
    CGFloat goodsDetailY = CGRectGetMaxY(self.goodsName.frame) + 10;
    [self.goodsDetail setFrame:CGRectMake(goodsNameX, goodsDetailY,kScreenWidth - goodsNameX - kMarginTopX, goodsDetailSize.height)];
    
    // 产品当前价格
    NSString * priceStr = [NSString stringWithFormat:@"¥%.2f",[product.curPrice floatValue]];
    NSMutableAttributedString *needStr = [priceStr makeStr:@"¥" withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    self.goodsPrice.attributedText = needStr;
    CGSize goodsPriceCurSize = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    CGFloat goodsPriceCurY = CGRectGetMaxY(self.goodsDetail.frame) + 8;
    [self.goodsPrice setFrame:CGRectMake(goodsNameX,goodsPriceCurY, goodsPriceCurSize.width, goodsPriceCurSize.height)];
    
}
// 设置换行的label 的size
-(CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
//// 设置换行的label 的size
+(CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (void)setOrderItem:(FNOrderArgs *)orderItem
{
    _orderItem = orderItem;
    FNProductArgs *virutualItem = orderItem.productList[0];
    
    //产品图片
    [self.goodsPicture setFrame:CGRectMake(13, 15, 63, 63)];
    
    [self.goodsPicture sd_setImageWithURL:IMAGE_ID(virutualItem.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];

    CGFloat goodsNameX = CGRectGetMaxX(self.goodsPicture.frame) + 12;
    // 产品名称
    NSString *goodsNameStr = virutualItem.productName;
    CGSize goodsNameSize = [goodsNameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.goodsName.text = goodsNameStr;
    [self.goodsName setFrame:CGRectMake(goodsNameX, 13,kScreenWidth - goodsNameX - kMarginTopX , goodsNameSize.height)];
    
    NSString *goodsDetailStr = nil;
    // 产品补充说明
    if([NSString isEmptyString:virutualItem.sku[@"skuName"]] )
    {
        goodsDetailStr = [NSString stringWithFormat:@"X%@",virutualItem.count];
        
    }else{
     goodsDetailStr = [NSString stringWithFormat:@"%@%@",virutualItem.sku[@"skuName"],virutualItem.count];
    }
    [goodsDetailStr stringByReplacingOccurrencesOfString:@"null" withString:@""];
    CGSize goodsDetailSize = [goodsDetailStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.goodsDetail.text = goodsDetailStr;
    CGFloat goodsDetailY = CGRectGetMaxY(self.goodsName.frame) + 10;
    [self.goodsDetail setFrame:CGRectMake(goodsNameX, goodsDetailY,kScreenWidth - goodsNameX - kMarginTopX, goodsDetailSize.height)];
    
    // 产品当前价格
    NSString * priceStr = [NSString stringWithFormat:@"¥%@   ",virutualItem.curPrice];
    NSMutableAttributedString *needStr = [priceStr makeStr:@"¥" withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    self.goodsPrice.attributedText = needStr;
    CGSize goodsPriceCurSize = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    CGFloat goodsPriceCurY = CGRectGetMaxY(self.goodsDetail.frame)+8;
    [self.goodsPrice setFrame:CGRectMake(goodsNameX,goodsPriceCurY, goodsPriceCurSize.width, goodsPriceCurSize.height)];
    
    NSString * usdLabelStr = [NSString stringWithFormat:@"购买数量:   %@ 张",virutualItem.count];
    self.usdLabel.text = usdLabelStr;
    CGSize usdLabelSize = [usdLabelStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self.usdLabel setFrame:CGRectMake(kScreenWidth- usdLabelSize.width -30 , goodsPriceCurY, usdLabelSize.width, usdLabelSize.height)];
    
    NSString *commentStr = nil ;
    if([NSString isEmptyString:orderItem.comment])
    {
        commentStr = @"备注: ";
    }else
    {
        commentStr = [NSString stringWithFormat:@"备注: %@",orderItem.comment];
        
    }
    self.commentsLabel.text = commentStr;
    CGSize commentSize = [self sizeWithMaxSize:kScreenWidth-20 andFont:[UIFont systemFontOfSize:14] WithString:commentStr];
    self.commentsLabel.frame = CGRectMake(15, kTopCellHeight+10, commentSize.width , commentSize.height);
    CGFloat commentY = CGRectGetMaxY(self.commentsLabel.frame) +10 ;
    self.grayLine1.frame = CGRectMake(0, commentY-1, kScreenWidth, 1);
    
}

- (void)setReturnState:(FNOrderState)state order:(FNOrderArgs *)order
{
    _orderItem = order;
    
    if ([_orderItem.orderState intValue ]== FNOrderStateFinish ||[_orderItem.orderState intValue ]==FNOrderStateFinishCommenting || [_orderItem.orderState intValue] == FNOrderStateReturned || [_orderItem.orderState intValue] ==FNOrderStateReturning || [_orderItem.orderState intValue] == FNOrderStateReturnFailed)
    {
        self.returnBut.hidden = NO;
        
        switch (state)
        {
            case FNOrderStateReturning:
                _returnStateLabel.text = @"退货中";
                _returnBut.hidden = YES;
                _returnStateLabel.hidden = NO;
                break;
                
            case FNOrderStateReturned:
                _returnStateLabel.text = @"已退货";
                _returnBut.hidden = YES;
                _returnStateLabel.hidden = NO;
                
                break;
                
            case FNOrderStateReturnFailed:
                _returnStateLabel.text = @"退货失败";
                _returnBut.hidden = YES;
                _returnStateLabel.hidden = NO;
                
                break;
            case FNOrderStateFinish:
                
            case FNOrderStateFinishCommenting:
                _returnStateLabel.text = @"已完成";
                _returnBut.hidden = YES;
                _returnStateLabel.hidden = NO;
                
                break;
            default:
                if ([order.tradeCode isEqualToString:@"Z8003"]||[order.tradeCode isEqualToString:@"Z8004"]||[order.tradeCode isEqualToString:@"Z8005"]||[order.tradeCode isEqualToString:@"Z8006"]||[order.tradeCode isEqualToString:@"Z0010"]||[order.tradeCode isEqualToString:@"Z8007"])
                {
                    _returnBut.hidden = YES;
                }
                else
                {
                    _returnBut.hidden = NO;
                    _returnStateLabel.hidden = YES;
                }
                
                break;
        }
    }else
    {
        self.returnBut.hidden = YES;
        
        _returnStateLabel.hidden = YES;
    }
    
    NSString *commentStr = nil ;
    if([NSString isEmptyString:_orderItem.comment])
    {
        commentStr = @"备注: ";
    }else
    {
        commentStr = [NSString stringWithFormat:@"备注: %@",_orderItem.comment];
    }
    
    self.commentsLabel.text = commentStr;
    CGSize commentSize = [self sizeWithMaxSize:kScreenWidth-20 andFont:[UIFont systemFontOfSize:14] WithString:commentStr];
    self.commentsLabel.frame = CGRectMake(15, kTopCellHeight +10, commentSize.width , commentSize.height);
    CGFloat commentY = CGRectGetMaxY(self.commentsLabel.frame) +10 ;
    self.grayLine1.frame = CGRectMake(0, commentY-1, kScreenWidth, 1);

}

- (void)returnGoods
{
    
    if ([self.delegate respondsToSelector:@selector(returnGoodsAction:)])
    {
        [self.delegate returnGoodsAction:self];
    }
    
}
+(CGFloat )orderCellHeightWithOrderItem:(FNOrderArgs *)orderItem
{
    NSString * commentStr = [NSString stringWithFormat:@"备注: %@",orderItem.comment];
    CGSize commentSize =[self sizeWithMaxSize:kScreenWidth-20 andFont:[UIFont systemFontOfSize:14] WithString:commentStr];
    
    return kTopCellHeight +commentSize.height+20;
}


+(CGFloat )orderCellHeightWithVirutualItem:(FNProductDetailArgs *)virutualItem
{
    NSString * commentStr = [NSString stringWithFormat:@"备注: %@",virutualItem.comment];
    CGSize commentSize =[self sizeWithMaxSize:kScreenWidth-20 andFont:[UIFont systemFontOfSize:14] WithString:commentStr];
    return kTopCellHeight +commentSize.height+20;
}

@end
