//
//  FNShoppingCartCell.m
//  BonusStore
//
//  Created by qingPing on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNShoppingCartCell.h"
#import <Foundation/NSString.h>

static CGFloat kCellHeight = 134;
static CGFloat kCellTopHeight = 90;
static CGFloat kPictureWidth = 80;
static CGFloat kSelecteWidth = 16;

static CGFloat kMarginTopX = 10;
static CGFloat kMarginTopX1 = 12;
static CGFloat kMarginTopX2 = 8;
static CGFloat kBtnWidth = 33;
static CGFloat kNumberWidth = 48;
static CGFloat kNumberHeight = 34;

@interface FNShoppingCartCell()

@end

@implementation FNShoppingCartCell


+ (instancetype)shoppingCartCellWithTableView:(UITableView *) tableView
{
    NSString *reuserId = NSStringFromClass([self class]);
    FNShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell == nil)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}

- (void)setCartItem:(FNCartItemModel *)cartItem
{
    _cartItem = cartItem;
    
    if(_cartItem.isSelecte == YES)
    {
       [self.selecteBtn setImage:[[UIImage imageNamed:@"cart_choose_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else
    {
       [self.selecteBtn setImage:[[UIImage imageNamed:@"cart_choose_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    [self.pictureView sd_setImageWithURL:IMAGE_ID(cartItem.imgKey) placeholderImage:[UIImage imageNamed:@"main_item_default"]];

    
    // 产品名称
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.text = cartItem.productName;
    
    CGFloat goodsNameX = CGRectGetMaxX(self.pictureView.frame) + kMarginTopX2;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.nameLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setHeadIndent:0];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    self.nameLabel.attributedText = attributedString;
    CGSize goodsNameSize  = [self sizeWithMaxSize:kScreenWidth - goodsNameX - kMarginTopX andFont:[UIFont systemFontOfSize:14] WithString:self.nameLabel.attributedText.string];
    CGFloat nheight = ([UIFont systemFontOfSize:14].lineHeight) * 2;
    self.nameLabel.frame = CGRectMake(goodsNameX, (kCellTopHeight - kPictureWidth) * 0.5, goodsNameSize.width, goodsNameSize.height > nheight ? nheight:goodsNameSize.height );

    // 产品补充说明
    self.detailLabel.text = cartItem.sku.skuName;
    CGFloat goodsDetailH = [UIFont systemFontOfSize:12].lineHeight;
    CGFloat goodsDetailY = CGRectGetMaxY(self.nameLabel.frame)  + kMarginTopX ;
    [self.detailLabel setFrame:CGRectMake(goodsNameX,goodsDetailY ,kScreenWidth - goodsNameX - kMarginTopX, goodsDetailH)];
    // 产品价格
    NSString *priceStr = [NSString stringWithFormat:@" ¥%.2f  ",[cartItem.cartPrice floatValue]];
    NSMutableAttributedString *needStr = [priceStr makeStr:@"¥" withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    self.priceLabel.attributedText = needStr;
    CGSize goodsPriceSize = [priceStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    CGFloat goodsPriceY = CGRectGetMaxY(self.pictureView.frame) - goodsPriceSize.height;
    [self.priceLabel setFrame:CGRectMake(goodsNameX,goodsPriceY, goodsPriceSize.width, goodsPriceSize.height)];
    
    // 以后边边距为准
    NSDecimalNumber *minCurPrice = [NSDecimalNumber decimalWithString:cartItem.cartPrice];
    NSString *scoreStr = [NSString stringWithFormat:@" %@积分  ",[minCurPrice multiplyingBy:100]];
    NSMutableAttributedString *needStr1 = [scoreStr makeStr:@"积分" withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    self.scoreLabel.attributedText = needStr1;
    CGSize goodsScoreSize = [scoreStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [self.scoreLabel setFrame:CGRectMake(kScreenWidth  -goodsScoreSize.width - kMarginTopX,goodsPriceY, goodsScoreSize.width, goodsScoreSize.height)];
   
    self. numberField.text = [NSString stringWithFormat:@"%zd",cartItem.count];
    if([self.numberField.text integerValue] > 1)
    {
        [self.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];

    }else
    {
        [self.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
    }
    if(cartItem.skuCount >99)
    {
    if ([self.numberField.text integerValue]==99)
    {
        [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_disSelecte"] forState:UIControlStateNormal];

    }else
    {
        [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];


    }
    }else
    {
        if ([self.numberField.text integerValue] == cartItem.skuCount)
        {
            [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_disSelecte"] forState:UIControlStateNormal];
            
        }else
        {
            [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
            
            
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 产品是否选中
        UIButton *selecteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:selecteBtn];
        self.selecteBtn = selecteBtn;
    
        [self.selecteBtn setFrame:CGRectMake(0,(kCellTopHeight - 38) * 0.5, 38, 38)];
        [selecteBtn addTarget:self action:@selector(shoppingCartCellTouched) forControlEvents:UIControlEventTouchUpInside];
        // 展示图片
        UIImageView *imageView1 = [[UIImageView alloc]init];
        imageView1.frame = CGRectMake(kMarginTopX,(kCellTopHeight - kSelecteWidth) * 0.5, kSelecteWidth, kSelecteWidth);
        self.imageView1 = imageView1;
        [self.contentView addSubview:imageView1];
        
        //产品图片
        UIImageView *goodsPicture = [[UIImageView alloc]init];
        [self.contentView addSubview:goodsPicture];
        self.pictureView = goodsPicture;
        goodsPicture.contentMode = UIViewContentModeScaleAspectFit;

        CGFloat pictureX = CGRectGetMaxX(self.imageView1.frame) + kMarginTopX1;
        [self.pictureView setFrame:CGRectMake(pictureX,(kCellTopHeight - kPictureWidth)*0.5, kPictureWidth, kPictureWidth)];
        // 产品名称
        UILabel *goodsName = [[UILabel alloc]init];
        [self.contentView addSubview:goodsName];
        [goodsName clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0 ,52.0)];
        self.nameLabel = goodsName;
        self.nameLabel.numberOfLines = 2;
        goodsName.textAlignment = NSTextAlignmentLeft;
        
        // 产品补充说明
        UILabel *goodsDetail = [[UILabel alloc]init];
        [self.contentView addSubview:goodsDetail];
        [goodsDetail clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWithRGB(52.0, 52.0 ,52.0)];
        goodsDetail.textAlignment = NSTextAlignmentLeft;
        self.detailLabel = goodsDetail;
        
        // 产品价格
        UILabel *goodsPrice = [[UILabel alloc]init];
        [self.contentView addSubview:goodsPrice];
        [goodsPrice clearBGWithFontOfArialSize:14 textColor:[UIColor redColor]];
        goodsPrice.textAlignment = NSTextAlignmentLeft;
        self.priceLabel= goodsPrice;
        // 产品积分
        UILabel *goodsScore = [[UILabel alloc]init];
        [self.contentView addSubview:goodsScore];
        [goodsScore clearBGWithFontOfArialSize:14 textColor:[UIColor redColor]];
        goodsScore.textAlignment = NSTextAlignmentRight;
        self.scoreLabel = goodsScore;
        UILabel * label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.frame = CGRectMake(0, 90, kScreenWidth, 44);
        [self.contentView addSubview:label];
        
        // 加减号
        UIView *addMinutView = [self addBottonsView];
        [self.contentView addSubview:addMinutView];
        addMinutView.frame = CGRectMake(kScreenWidth - kMarginTopX -kBtnWidth*2-kNumberWidth ,(kCellHeight- kCellTopHeight -kNumberHeight)*0.5-1 + kCellTopHeight, kBtnWidth*2+kNumberWidth, kNumberWidth);
        // 细分割线
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, kCellHeight-1,kScreenWidth ,1 ) ];
        lineView1.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        [self.contentView addSubview:lineView1];
        self.contentView.backgroundColor = UIColorWithRGB(248.0, 248.0, 248.0);
        
    }
    return self;
}

- (UIView *)addBottonsView
{
    UIView *btnView = [[UIView alloc]init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minuBtn = btn;
    [btnView addSubview: self.minuBtn];
    self.minuBtn.tag = kNumberBtnTypeMinus;
    [self.minuBtn addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.minuBtn.frame = CGRectMake(0,1, kBtnWidth, kNumberHeight);
    [self.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];

    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn = addBtn;
    [btnView addSubview: addBtn];
    addBtn.tag = kNumberBtnTypeAdd;
    [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(kNumberWidth+kBtnWidth-2, 1, kBtnWidth, kNumberHeight);
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];

    // 数量
    FNTextField *numberField =  [[FNTextField alloc]init];
    self.numberField = numberField;
    [btnView addSubview: numberField];
    [numberField addTarget:self action:@selector(numberLabelTextChange) forControlEvents:UIControlEventEditingChanged];
    numberField.keyboardType = UIKeyboardTypeNumberPad ;
    numberField.frame = CGRectMake(kBtnWidth -1, 1, kNumberWidth, kNumberHeight);
    numberField.textAlignment = NSTextAlignmentCenter;
    [self.numberField setBackground:[UIImage imageNamed:@"cart_textFeild"]];
    
    
    return btnView;
    
}
/**
 *  每种商品是否被选择的点击事件
 */
-(void)shoppingCartCellTouched
{
    self.cartItem.isSelecte = !self.cartItem.isSelecte;
    
    if([self.delegate respondsToSelector:@selector(shoppingCartCellTouched:)])
    {
        [self.delegate shoppingCartCellTouched:self];
    }
}
/**
 *  监听商品数量输入框值的改变
 */
-(void)numberLabelTextChange
{
    if ([self.delegate respondsToSelector:@selector(shoppingCartCell:numberChangeWithTextField:)])
    {
        [self.delegate shoppingCartCell:self numberChangeWithTextField:self.numberField];
    }
}
/**
 *  减号按钮的方法
 *  @param sender   button的类型，点击的是加号还是减号
 */
- (void)minusBtnAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(shoppingCartCellBtnClick:flag:)])
    {
        [self.delegate shoppingCartCellBtnClick:self flag:sender.tag];
    }
}

/**
 *  加号按钮的方法
 *
 *  @param sender   button的类型，点击的是加号还是减号
 */
- (void)addBtnAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(shoppingCartCellBtnClick:flag:)])
    {
        [self.delegate shoppingCartCellBtnClick:self flag:sender.tag];
    }
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
