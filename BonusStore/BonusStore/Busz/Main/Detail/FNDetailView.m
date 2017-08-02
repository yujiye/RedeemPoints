//
//  FNDetailView.m
//  BonusStore
//
//  Created by sugarwhi on 16/6/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNDetailView.h"

@interface FNDetailView()<UITextFieldDelegate>

@property (nonatomic, strong)UILabel *separationLine;

@property (nonatomic, strong)UIImageView * imageV;
@end

@implementation FNDetailView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame])
    {
        _productImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, -10,88 , 88)];
        
        _productImage.layer.masksToBounds = YES;
        
        _productImage.layer.cornerRadius = 10.0;
        
        _productImage.layer.borderWidth = 1.0;
        
        _productImage.layer.borderColor = MAIN_BACKGROUND_COLOR.CGColor;
        
        _productImage.backgroundColor = MAIN_COLOR_WHITE;
        
        [self addSubview:_productImage];
        
        _productPrice = [[UILabel alloc]initWithFrame:CGRectMake(_productImage.x + _productImage.width + 10, 12,kScreenWidth - _productImage.width - 70 , 20)];
        _productPrice.textColor = MAIN_COLOR_RED_ALPHA;
        
        _productPrice.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        [self addSubview:_productPrice];
        
        _skuLabel = [[UILabel alloc]initWithFrame:CGRectMake(_productPrice.x, _productPrice.y+_productPrice.height ,kScreenWidth - _productImage.width - 70 , 20)];
        
        _skuLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        [self addSubview:_skuLabel];
        
        _choseLabel = [[UILabel alloc]initWithFrame:CGRectMake(_skuLabel.x, _skuLabel.y+_skuLabel.height , kScreenWidth - _productImage.width - 20 , 20)];
        
        _choseLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
    
        [self addSubview:_choseLabel];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _closeBtn.frame = CGRectMake(kScreenWidth - 30, 8,20,20);
        
        _closeBtn.layer.masksToBounds = YES;
        
        _closeBtn.layer.cornerRadius = 10.0;
        
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"close_detail"] forState:UIControlStateNormal];
        
        [self addSubview:_closeBtn];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _productImage.height,kScreenWidth , self.height - _productImage.height-44)];
        
        _scrollView.contentSize = CGSizeMake(0,self.height - _productImage.height-44);
        
        _scrollView.backgroundColor = MAIN_COLOR_WHITE;
        
        _scrollView.alwaysBounceVertical = YES;

        _scrollView.showsVerticalScrollIndicator = YES;
        
        [self addSubview:_scrollView];
        
        _separationLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 88, kScreenWidth, 1)];
    
        _separationLine.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        [self addSubview:_separationLine];
        
        _specificationsL = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 40, 20)];
        
        _specificationsL.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_scrollView addSubview:_specificationsL];
        
        _sizeLabel = [[UILabel alloc]init];
        
        _sizeLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_scrollView addSubview:_sizeLabel];
        
        _sendToLabel = [[UILabel alloc]init];
        
        _sendToLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_scrollView addSubview:_sendToLabel];
        
        _buyNumLabel = [[UILabel alloc]init];
        
        _buyNumLabel.text = @"购买数量:";
        
        _buyNumLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        
        [_scrollView addSubview:_buyNumLabel];
        
        _buttonView = [[UIView alloc]init];
        
        _buttonView.backgroundColor = MAIN_COLOR_WHITE;
        
        [_scrollView addSubview:_buttonView];
        
        _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _cutBtn.frame = CGRectMake(0, 0, 32, 32);
        
        _cutBtn.tag = kNumberBtnTypeMinus;
        
        [_cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
        
        [_cutBtn addTarget:self action:@selector(cutButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonView addSubview:_cutBtn];
        
        _numText = [[UITextField alloc]initWithFrame:CGRectMake(31, 0, 58, 32)];
        
        _numText.borderStyle = UITextBorderStyleLine;
        
        _numText.layer.borderWidth = 1.0;
        
        _numText.textAlignment = NSTextAlignmentCenter;
        
        _numText.enabled = false;
        
        _numText.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        _numText.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;

        [_buttonView addSubview:_numText];

        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _addBtn.tag = kNumberBtnTypeAdd;
        
        _addBtn.frame = CGRectMake(_buttonView.x + 32 + _numText.width - 2 , 0, 32, 32);
        
        [_addBtn addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
        
        [_buttonView addSubview:_addBtn];

        _sendLabel = [[UILabel alloc]init];
        
        _sendLabel.textAlignment = NSTextAlignmentCenter;
        
        _sendLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:10];
        
        _sendLabel.textColor =MAIN_COLOR_BLACK_ALPHA;
        
        _sendLabel.layer.borderWidth = 1.0;
        
        _sendLabel.layer.cornerRadius = 5.0;
        
        _sendLabel.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
    
        [_scrollView addSubview:_sendLabel];
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(_sendLabel.x + 120-25,11 ,20 ,8 )];
        
        _imageV.image = [UIImage imageNamed:@"bonus_indicator_n"];
        
        [_sendLabel addSubview:_imageV];
        
        _determineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _determineBtn.backgroundColor = MAIN_COLOR_RED_ALPHA;
        
        [_determineBtn setTitle:@"确定" forState:UIControlStateNormal];
        
        [_determineBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        
        _determineBtn.frame = CGRectMake(0, self.height - 44, kScreenWidth, 44);
        
        [self addSubview:_determineBtn];
        
        _sizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _sizeButton.layer.borderWidth = 1.0;
        
        _sizeButton.layer.cornerRadius = 5.0;
        
        _sizeButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        _sizeButton.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
        
        [_sizeButton setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        
        [_scrollView addSubview:_sizeButton];
        
    }
    return self;
}

- (void)cutButton:(UIButton *)sender
{
    if ([self.textFieldDelegate respondsToSelector:@selector(numBtnClick:flag:)])
    {
        [self.textFieldDelegate numBtnClick:self flag:sender.tag];
    }
}

- (void)addButton:(UIButton *)sender
{
    if ([self.textFieldDelegate respondsToSelector:@selector(numBtnClick:flag:)])
    {
        [self.textFieldDelegate numBtnClick:self flag:sender.tag];
    }
}


@end
