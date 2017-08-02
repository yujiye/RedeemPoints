//
//  FNReturnGoodsView.m
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNReturnGoodsView.h"

@interface FNReturnGoodsView ()
{
    UIButtonActionBlock _block;
}

@end

@implementation FNReturnGoodsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self addTarget:self action:@selector(hide)];
        
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, kAverageValue(kWindowHeight-300), kWindowWidth-110, 300)];
        
        [bg setCorner:5];
        
        bg.backgroundColor = [UIColor whiteColor];
        
        [bg setHorizonCenterWithSuperView:self];
        
        [self addSubview:bg];
        
        UIButton *closeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        
        closeBut.frame = CGRectMake(bg.width+20, bg.y-20, 45, 45);
        
        [closeBut setBackgroundImage:[UIImage imageNamed:@"product_return_close"] forState:UIControlStateNormal];
        
        __weak __typeof(self) weakSelf = self;
        
        [closeBut addSuperView:self ActionBlock:^(id sender) {
            
            [weakSelf hide];
            
        }];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, bg.width, 140)];
        
        imageView.image = [UIImage imageNamed:@"cart_welcome_normal"];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [bg addSubview:imageView];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.y + imageView.height + 5, bg.width, 50)];
        
        tip.numberOfLines = 2;
        
        tip.text = @"您的退货申请已提交，\n请等待审核";
        
        tip.textAlignment = NSTextAlignmentCenter;
        
        [tip clearBackgroundWithFont:[UIFont fzltWithSize:15] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [bg addSubview:tip];
        
        FNButton *indexBut = [FNButton buttonWithType:FNButtonTypePlain title:@"再逛逛"];
        
        indexBut.frame = CGRectMake(30, tip.y + tip.height + 12, bg.width-60, 40);
        
        [indexBut setCorner:5];
        
        [indexBut addSuperView:bg ActionBlock:^(id sender) {
            
            _block(sender);
            
        }];
    }
    return self;
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;

}

- (void)goMainWithBlock:(UIButtonActionBlock)block
{
    _block = nil;
    
    _block = block;
}

@end
