//
//  FNShoppingCartView.m
//  BonusStore
//
//  Created by qingPing on 16/4/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNShoppingCartView.h"
#import "FNHeader.h"
#import <UIKit/UIKit.h>
static CGFloat kShopHeight = 40;
static CGFloat kShopSelectW = 16;
static CGFloat kShopMarginX = 10;
static CGFloat kShopMarginX1 = 12;
static CGFloat kMarginY = 20;

@interface FNShoppingCartView ()

@end

@implementation FNShoppingCartView

+ (instancetype)groupHeaderViewWithTableView:(UITableView *)tableView
{
    NSString *reuseId = NSStringFromClass([self class]);
    FNShoppingCartView *shoppingCartHeadView = [tableView  dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    if ( shoppingCartHeadView == nil )
    {
      shoppingCartHeadView = [[self alloc]initWithReuseIdentifier:reuseId];
    }
    return shoppingCartHeadView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];
    if(self)
    {
        [self.contentView addTarget:self action:@selector(goToMerchantList)];
        
        UILabel * lineLabelWidth = [[UILabel alloc]init];
        lineLabelWidth.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        lineLabelWidth.frame = CGRectMake(0, 0, kScreenWidth, 10);
        [self.contentView addSubview:lineLabelWidth];
        // 商场是否选择的按钮
        UIButton * shopSelecteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selecteBtn = shopSelecteBtn;
        [self.contentView addSubview:shopSelecteBtn];
        [shopSelecteBtn addTarget:self action:@selector(shoppingCartHeadViewTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.selecteBtn setFrame:CGRectMake(0,(kShopHeight-38 )*0.5 +10, 38, 38)];
        
        // 展示图片
        UIImageView *imageView1 = [[UIImageView alloc]init];
        imageView1.frame = CGRectMake(kShopMarginX,(kShopHeight - kShopSelectW) * 0.5+10, kShopSelectW, kShopSelectW);
        self.imageView1 = imageView1;
        [self.contentView addSubview:imageView1];

        //  商场名称
        UILabel *shopNameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:shopNameLabel];
        [shopNameLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(0, 0, 0)];
        self.shopNameLabel = shopNameLabel;
        shopNameLabel.textAlignment = NSTextAlignmentLeft;
        // 活动图标
        UIImageView *freightImg = [[UIImageView alloc]init];
        self.freightImg = freightImg;
        [self.contentView addSubview:self.freightImg];
        
        // 商场活动介绍
        UILabel * discountLabel = [[UILabel alloc]init];
        self.discountLabel = discountLabel;
        [self.contentView addSubview:discountLabel];
        [discountLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(239.0, 48.0, 48.0)];
        discountLabel.textAlignment = NSTextAlignmentLeft;
        
        // 箭头
        UIImageView * arrowImg = [[UIImageView alloc]init];
        self.arrowImg = arrowImg;
        [self.contentView addSubview:arrowImg];
        // 没有宽度的分割线
        UILabel * lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = UIColorWithRGB(222.0, 222.0 ,222.0);
        self.lineLabel = lineLabel;
        [self.contentView addSubview:lineLabel];
    }
    return  self;
}

- (void)setCartGroup:(FNCartGroupModel *)cartGroup
{
    _cartGroup = cartGroup;
    
    if( _cartGroup.selecteStatus == kSelecteBtnAllSelect )
    {
        [self.imageView1 setImage:[UIImage imageNamed:@"cart_choose_press"] ];
       
    }else if( _cartGroup.selecteStatus == kSelecteBtnNoSelect )
    {
        [self.imageView1 setImage:[UIImage imageNamed:@"cart_choose_normal"] ];

    } else
    {
         [self.imageView1 setImage:[UIImage imageNamed:@"cart_choose_half"] ];
  
    }
    self.shopNameLabel.text = cartGroup.sellerName;

    CGSize shopNameSize = [self.shopNameLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    CGFloat shopNameX = CGRectGetMaxX(self.imageView1.frame) + kShopMarginX1 ;
    [self.shopNameLabel setFrame:CGRectMake(shopNameX, (kShopHeight - shopNameSize.height) *0.5 +10 ,shopNameSize.width,shopNameSize.height)];
    
    self.discountLabel.text =nil;
    CGSize discountSize = [self.discountLabel.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    CGFloat discountLabelY = CGRectGetMaxY(self.shopNameLabel.frame)+13;
    self.arrowImg.image = [UIImage imageNamed:@"cart_order"];
    if([NSString isEmptyString:self.discountLabel.text])
    {
        self.arrowImg.frame = CGRectMake(kScreenWidth - 10 - self.arrowImg.image.size.width, 10+ (49-self.arrowImg.image.size.height)*0.5, self.arrowImg.image.size.width, self.arrowImg.image.size.height);
        self.lineLabel.frame = CGRectMake(0, 58, kScreenWidth, 1);

        
    }else
    {
        self.freightImg.image = [UIImage imageNamed:@"freight_bg"];
        self.freightImg.frame = CGRectMake(shopNameX, discountLabelY, self.freightImg.image.size.width, self.freightImg.image.size.height);
        CGFloat discountlabelX = CGRectGetMaxX(self.freightImg.frame);
        [self.discountLabel setFrame:CGRectMake(discountlabelX, discountLabelY,kScreenWidth - discountlabelX - 30, discountSize.height)];
        self.arrowImg.frame = CGRectMake(kScreenWidth - 10 - self.arrowImg.image.size.width, 10+ (70-self.arrowImg.image.size.height)*0.5, self.arrowImg.image.size.width, self.arrowImg.image.size.height);
        self.lineLabel.frame = CGRectMake(0, 79, kScreenWidth, 1);
    }

    
    
}

- (void)shoppingCartHeadViewTouched
{
    if(self.cartGroup.selecteStatus == kSelecteBtnAllSelect || self.cartGroup.selecteStatus ==kSelecteBtnHalfSelect)
    {
        self.cartGroup.selecteStatus = kSelecteBtnNoSelect;
        
    }else if(self.cartGroup.selecteStatus ==kSelecteBtnNoSelect)
    {
        self.cartGroup.selecteStatus= kSelecteBtnAllSelect;
    }
    if([self.delegate respondsToSelector:@selector(groupHeaderViewDidTouched:)])
    {
        [self.delegate groupHeaderViewDidTouched:self];
    }
}

// 无购物时候的view
- (UIView *)viewWithNoShopping
{
    UIView *view = [[UIView alloc]init];
    UIImageView *shoppingView = [[UIImageView alloc]init];
    [shoppingView setImage:[UIImage imageNamed:@"cart_welcome_normal"]];
    shoppingView.frame = CGRectMake((kScreenWidth -224)*0.5, 34, 224, 171);
    [view addSubview:shoppingView];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"客官～您的购物车空空如也";
    [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:18] textColor:UIColorWithRGB(30.0, 30.0, 30.0)];
    CGFloat tipLabelY = CGRectGetMaxY(shoppingView.frame)  + 5;
    CGSize tipLabelSize = [tipLabel.text  sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    tipLabel.frame = CGRectMake((kScreenWidth - tipLabelSize.width) * 0.5, tipLabelY, tipLabelSize.width, tipLabelSize.height);
    [view addSubview:tipLabel];
    
    CGFloat aroundBtnY = CGRectGetMaxY(tipLabel.frame) +5 ;
    UIButton * aroundBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 195) * 0.5, aroundBtnY, 195, 41)];
    [aroundBtn setCorner:5];
    [aroundBtn setBackgroundColor:UIColorWithRGB(239.0, 48.0, 48.0)];
    [aroundBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
    [aroundBtn addTarget:self action:@selector(gotoHomePageView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:aroundBtn];
    
    CGSize aroundBtnSize = [aroundBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:32]}];
    UIView *preferView = [self preferViewWithLineWithSize:CGSizeMake(kScreenWidth, aroundBtnSize.height)];
    CGFloat preferViewY = CGRectGetMaxY(aroundBtn.frame)+ kMarginY;
    preferView.frame =  CGRectMake(0, preferViewY, kScreenWidth, aroundBtnSize.height);
    [view addSubview:preferView];
    
    return view;
}


- (void)gotoHomePageView
{
    if([self.delegate respondsToSelector:@selector(goToHomeViewControllerClick:)])
    {
        [self.delegate goToHomeViewControllerClick:self];
    }
}

- (void)goToMerchantList
{
    if ([self.delegate respondsToSelector:@selector(goToMerchantListControllerClick:)])
    {
        [self.delegate goToMerchantListControllerClick:self];
    }
}


// 猜你喜欢和灰线的view
- (UIView *)preferViewWithLineWithSize:(CGSize)size
{
    UIView *preferView = [[UIView alloc]init];
    preferView.frame =  CGRectMake(0, 0, size.width, size.height);
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor grayColor];
    label1.frame = CGRectMake(kScreenWidth * 0.2, size.height *0.5 -1, kScreenWidth*0.6, 1);
    [preferView addSubview:label1];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"❤️猜你喜欢";
    [label clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(140.0, 140.0, 140.0)];
    label.backgroundColor = MAIN_BACKGROUND_COLOR;
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    label.frame = CGRectMake((kScreenWidth - labelSize.width)*0.5, (size.height-labelSize.height)*0.5, labelSize.width, labelSize.height);
    [preferView addSubview:label];
    
    return preferView;
}


@end
