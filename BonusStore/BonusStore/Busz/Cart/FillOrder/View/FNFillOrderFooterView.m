//
//  FNFillOrderFooterView.m
//  BonusStore
//
//  Created by feinno on 16/4/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNFillOrderFooterView.h"
#import "FNHeader.h"
#import "FNCartItemModel.h"
#import "NSString+Cate.h"
#import "FNVirfulViewCell.h"
@interface FNFillOrderFooterView ()
{
    NSInteger _currentNum;
    CGFloat _totalPrice;
}
@end

@implementation FNFillOrderFooterView

+ (instancetype)fillOrderFooterViewWithTableView:(UITableView *) tableView
{
    NSString *reuseId = NSStringFromClass([self class]);
    FNFillOrderFooterView *fillOrderFooterView = [tableView  dequeueReusableHeaderFooterViewWithIdentifier:reuseId];
    if ( fillOrderFooterView == nil )
    {
        fillOrderFooterView = [[self alloc]initWithReuseIdentifier:reuseId];
    }
    return fillOrderFooterView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        UILabel * numLabel = [[UILabel alloc]init];
        [numLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
        self.numLabel = numLabel;
        numLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:numLabel];

        UILabel * priceLabel = [[UILabel alloc]init];
        self.priceLabel = priceLabel;
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        [priceLabel  clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithRed:52.0/255 green:52.0/255 blue:52.0/255 alpha:1]];
        priceLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:priceLabel];

        //  给卖家留言栏
        FNTextField *commentsField = [[FNTextField alloc]init];
        self.commentsField = commentsField;
        self.commentsField.isToolBar = NO;
        self.commentsField.tag = kTextFieldTagComment;
        self.commentsField.returnKeyType = UIReturnKeyDone;
        self.commentsField.enablesReturnKeyAutomatically = YES;
        [self.contentView addSubview:commentsField];
        self.commentsField.borderStyle = UITextBorderStyleLine;
        self.commentsField.layer.borderColor = UIColorWithRGB(222.0, 222.0, 222.0).CGColor;
        self.commentsField.layer.borderWidth = 1.0;
        self.commentsField.frame = CGRectMake(0, 42, kScreenWidth  , 40);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setCartGroup:(FNCartGroupModel *)cartGroup
{
    _cartGroup = cartGroup;
    
    for ( FNCartItemModel * item in cartGroup.productList)
    {
        _currentNum +=  item.count;

        if (![NSString isEmptyString:item.curPrice])
        {
       
            _totalPrice += [item.curPrice doubleValue] *1.0* item.count;
        }else
        {
            
            _totalPrice += [item.cartPrice doubleValue] *1.0* item.count;
        }
    }
    NSString * currentNum = [NSString stringWithFormat:@"共 %zd 件商品",_currentNum];
     NSMutableAttributedString *currentAttri= [currentNum  makeStr:[NSString stringWithFormat:@"%zd",_currentNum] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    self.numLabel.attributedText = currentAttri;
    CGSize labelSize = [currentNum sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.numLabel.frame = CGRectMake(15, 1, labelSize.width, 39);
    CGFloat priceX = CGRectGetMaxX(self.numLabel.frame)+15;
    
    NSMutableAttributedString *needStr2= nil;
    if(_isVirful)
    {
        NSString * str1 = [NSString stringWithFormat:@"共计:¥%.2f",_totalPrice];

        needStr2 = [str1  makeStr:[NSString stringWithFormat:@"¥%.2lf",_totalPrice] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    }else
    {

        CGFloat postage = [cartGroup.postage  floatValue];
        NSString * str1 = [NSString stringWithFormat:@"共计:¥%.2f",_totalPrice+ postage];
      NSString * str2 = [NSString stringWithFormat:@"(含运费:¥%.2lf)",postage];
    needStr2 = [str1  makeStr:[NSString stringWithFormat:@"¥%.2lf",_totalPrice+postage] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
      [needStr2 appendAttributedString:[str2 makeStr:[NSString stringWithFormat:@"¥%.2lf",postage] withColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]]];
    }
    
    
    self.priceLabel .frame = CGRectMake(priceX, 1, kScreenWidth -priceX-15, 39);
    self.priceLabel.attributedText = needStr2;
   
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 10, 30)];
    self.commentsField.leftView = paddingView2;
    self.commentsField.leftViewMode = UITextFieldViewModeAlways;
    if(![NSString isEmptyString: cartGroup.buyerComment])
    {
        self.commentsField.text = cartGroup.buyerComment;
    }else
    {
        NSString * commentStr = @"给卖家留言(60字以内):";
        NSMutableAttributedString *commentAttribute = [commentStr makeStr:@"给卖家留言(60字以内):" withColor: UIColorWithRGBA(152.0, 152.0 ,152.0, 0.7) andFont:[UIFont systemFontOfSize:14]];
        self.commentsField.attributedPlaceholder = commentAttribute;
        

        
    }
    
    _totalPrice = 0;
    _currentNum =0;
}


@end
