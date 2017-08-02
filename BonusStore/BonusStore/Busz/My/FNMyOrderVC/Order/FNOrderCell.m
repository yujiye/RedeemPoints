//
//  FNObligationOrderCell.m
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderCell.h"
#import "FNCartBO.h"

static CGFloat PADDING_LEFT     =   15.0;

@interface FNOrderCell ()
{
    UIView *_bg;
    
    CALayer *_line;
    
    
    
    FNButton *_shipBut;
    
    UIView *_footerView;
    
    UIView *_priceFooterView;
    
    void (^_payBlock) (FNOrderState state, NSIndexPath *selectedIndexPath, FNOrderCell *selectedCell);
    
    UIButtonActionBlock _shipBlock;
    
    NSMutableAttributedString *_string;
    
    NSMutableArray *_productsView;      //products container
    
    UIView *_mask;
    
    //after sale
    
    //大于1件
    
    UILabel *_countLabel;           //大于0件的件数
    
    UIImageView *_moreIndicator;    //
    
    BOOL _isSingle;                 //是否是单个商品
    FNReturnReasonView *_returnReasonView;
    
    
}
@property (nonatomic,copy) CancelWaitingPayBlock cancelWaitingPayBlock;


@end

@implementation FNOrderCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        _string = [[NSMutableAttributedString alloc] init];
        
        _productsView = [[NSMutableArray alloc] init];
        
        self.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 128)];
        
        _bg.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_bg];
        
        CALayer *downDownLine = [CALayer layerWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
        
        [_bg.layer addSublayer:downDownLine];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_LEFT, 10, kWindowDemiW, 20)];
        
        _shopLabel.backgroundColor = [UIColor blueColor];
        
        [_shopLabel clearBackgroundWithFont:[UIFont fzltWithSize:15] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [_bg addSubview:_shopLabel];

        _orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth-100, _shopLabel.y, 85, 20)];
        
        _orderStateLabel.textAlignment = NSTextAlignmentRight;
        
        _orderStateLabel.backgroundColor = [UIColor blueColor];
        
        [_orderStateLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_RED_ALPHA];
        
        [_bg addSubview:_orderStateLabel];

        _mask = [[UIView alloc] initWithFrame:CGRectMake(0, _shopLabel.y+_shopLabel.height+10, kWindowWidth, 90)];
        
        _mask.backgroundColor = UIColorWithRGB(248, 248, 248);
        
        [_bg addSubview:_mask];
    
        for (int i = 0; i<3; i++)
        {
            UIImageView *mp = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING_LEFT + 70*i, _mask.frame.origin.y + 15, 62, 62)];
            
            [_bg addSubview:mp];

            [_productsView addObject:mp];
            
            mp.hidden = YES;
        }
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth-100, 0, 40, 20)];
        
        [_countLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [_mask addSubview:_countLabel];
        
        [_countLabel setVerticalCenterWithSuperView:_mask];
        
        _moreIndicator = [[UIImageView alloc]initWithFrame:CGRectMake(kWindowWidth-22, 0, 7, 14)];
        
        _moreIndicator.image = [UIImage imageNamed:@"cart_order"];
        
        [_mask addSubview:_moreIndicator];
        
        [_moreIndicator setVerticalCenterWithSuperView:_mask];
        
        //
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_LEFT + 62 + PADDING_LEFT, _mask.y + 15, kWindowWidth - 105, 20)];
        
        [_nameLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [_bg addSubview:_nameLabel];

        
        _attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.x, _nameLabel.y + _nameLabel.height + 2, _nameLabel.width, 20)];
        
        [_attributeLabel clearBackgroundWithFont:[UIFont fzltWithSize:11] textColor:MAIN_COLOR_GRAY_ALPHA];
        
        [_bg addSubview:_attributeLabel];

        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_attributeLabel.x, _attributeLabel.y + _attributeLabel.height + 2, _attributeLabel.width, 20)];
        
        _priceLabel.textAlignment = NSTextAlignmentRight;
        
        [_priceLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [_bg addSubview:_priceLabel];


        _priceFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, _mask.y+_mask.height, kWindowWidth, 35)];
        
        _priceFooterView.userInteractionEnabled = YES;
        
        _priceFooterView.backgroundColor = [UIColor whiteColor];
        
        [_bg addSubview:_priceFooterView];
        
        _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING_LEFT, _priceLabel.y, kWindowWidth-PADDING_LEFT*2, 20)];
        
        [_totalPriceLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [_priceFooterView addSubview:_totalPriceLabel];
        
        [_totalPriceLabel setVerticalCenterWithSuperView:_priceFooterView];
        
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, _priceFooterView.y+_priceFooterView.height, kWindowWidth, 50)];
        
        _footerView.userInteractionEnabled = YES;
        
        _footerView.backgroundColor = [UIColor whiteColor];
        
        [_bg addSubview:_footerView];
        
        _cancelPayBtn = [FNButton buttonWithType:FNButtonTypeEdge title:@"取消订单"];
        _cancelPayBtn.frame = CGRectMake(kWindowWidth-95 -95,  10, 80, 30);
        
        [_cancelPayBtn setCorner:5];
        _cancelPayBtn.layer.borderColor = UIColorWithRGB(102.0, 102.0, 102.0).CGColor;
        [_cancelPayBtn setTitleColor:UIColorWithRGB(102.0, 102.0, 102.0) forState:UIControlStateNormal];
        
        [_cancelPayBtn addTarget:self action:@selector(cancelWaitingPayOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelPayBtn.titleLabel.font = [UIFont fzltWithSize:14];
        
        [_footerView addSubview:_cancelPayBtn];
        
        _payBut = [FNButton buttonWithType:FNButtonTypeEdge title:@"立即支付"];
        
        _payBut.frame = CGRectMake(kWindowWidth-95,  10, 80, 30);
        
        [_payBut setCorner:5];
        
        [_payBut addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
        
        _payBut.titleLabel.font = [UIFont fzltWithSize:14];
        
        [_footerView addSubview:_payBut];
        
        _shipBut = [FNButton buttonWithType:UIButtonTypeRoundedRect];
        
        _shipBut.frame = CGRectMake(_payBut.x - 120, _payBut.y, 75, 35);
        
        NSString *ship = @"查看物流";
        
        NSMutableAttributedString *orderString = [ship setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) , NSUnderlineColorAttributeName : UIColorWithRGB(32, 87, 200), NSFontAttributeName : [UIFont fzltWithSize:14]} range:NSMakeRange(0, ship.length)];
        
        [_shipBut setAttributedTitle:orderString forState:UIControlStateNormal];
        
        [_shipBut addTarget:self action:@selector(goShip:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:_shipBut];
        
        _cancelPayBtn.hidden = YES;
        
        _payBut.hidden = YES;
        
        _shipBut.hidden = YES;
        
        _footerView.hidden = YES;
        

    }
    return self;
}

- (void)setState:(FNOrderState)state
{
    _state = state;
   
    switch (state)
    {
        case FNOrderStatePaying:
            _payBut.enabled = [self isPayEnableWithOrder:_order];
            
            if (!_payBut.enabled)
            {
                _orderStateLabel.text = @"已取消";
                [_payBut setType:FNButtonTypeOpposite];
                _cancelPayBtn.hidden = YES;
                [_payBut setTitle:@"已取消" forState:UIControlStateNormal];
            }
            else
            {
                _orderStateLabel.text = @"待付款";
                [_payBut setType:FNButtonTypeEdge];
                _cancelPayBtn.hidden = NO;
                [_payBut setTitle:@"立即支付" forState:UIControlStateNormal];
            }
            
            [self setFooterViewHidden:NO];
            _shipBut.hidden = YES;
            break;
            
        case FNOrderStateShipping:
            _orderStateLabel.text = @"待发货";
            _shipBut.hidden = YES;
            [self setFooterViewHidden:YES];
            
            break;
            
        case FNOrderStateReceiving:
        {
            _orderStateLabel.text = @"待收货";
            [_payBut setType:FNButtonTypeEdge];
            _shipBut.hidden = NO;
            _cancelPayBtn.hidden = YES;
            [_payBut setTitle:@"确认收货" forState:UIControlStateNormal];
            [self setFooterViewHidden:NO];
        }
            break;

        case FNOrderStateFinishCommenting:
            
        case FNOrderStateFinish:
            _orderStateLabel.text = @"已完成";
            [self setFooterViewHidden:YES];
            break;
            
            
        case FNOrderStateAutoClosed:
        case FNOrderStateManageCanceled:
        case FNOrderStateCanceled:
            _orderStateLabel.text = @"已取消";
            [self setFooterViewHidden:YES];
            break;
            
        case FNOrderStateAfterSale:
            _orderStateLabel.text = @"售后";
            break;
            
        default:
            break;
    }
}

- (void)setFooterViewHidden:(BOOL)hidden
{
    _payBut.hidden = hidden;
    
    _shipBut.hidden = hidden;
    
    _footerView.hidden = hidden;
}

- (void)setActionWithPay:(void (^) (FNOrderState state, NSIndexPath *selectedIndexPath, FNOrderCell *selectedCell))pay ship:(UIButtonActionBlock)ship
{
    _payBlock = nil;
    
    _shipBlock = nil;
    
    _payBlock = pay;
    
    _shipBlock = ship;
}

- (void)goPay:(UIButton *)sender
{
    _payBlock(_state, _indexPath, self);
}

- (void)cancelWaitingPayOrder:(UIButton *)btn
{
    if (self.cancelWaitingPayBlock)
    { 
       self.cancelWaitingPayBlock(self.order);
    }
}

- (void)cancelPay:(CancelWaitingPayBlock)cancelBlock
{
    self.cancelWaitingPayBlock = cancelBlock;
}


- (void)goShip:(UIButton *)sender
{
    _shipBlock(sender);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isSingle)
    {
        _priceFooterView.hidden = YES;
        UIReframeWithY(_footerView, _mask.y+_mask.height);
    }
    else
    {
        _priceFooterView.hidden = NO;
        UIReframeWithY(_priceFooterView, _shopLabel.y+_shopLabel.height+100);
        UIReframeWithY(_footerView, _priceFooterView.y+_priceFooterView.height);
    }
    
    [self autoFitHeight];
}

- (CGFloat)autoFitHeight
{

    CGFloat _height;
    
    _height = 220;
    
    if (_isSingle)
    {
        _height -= 35;
    }

    if (_state == FNOrderStateShipping || _state == FNOrderStateFinish || _state == FNOrderStateFinishCommenting || _state == FNOrderStateAfterSale || _state == FNOrderStateAutoClosed || _state == FNOrderStateCanceled ||_state == FNOrderStateManageCanceled)
    {
        _height -= 55;
    }

    UIReframeWithH(self, _height);

    
    UIReframeWithH(_bg, _height);
    
    return _height;
}

- (void)setOrder:(FNOrderArgs *)order
{
    _order = order;
    
    NSArray *products = order.productList;
    NSString *string = [NSString stringWithFormat:@"共%lu件",(unsigned long)products.count];
    
    [_string replaceCharactersInRange:NSMakeRange(0, _string.length) withString:string];

    [_string setAttributes:@{ NSForegroundColorAttributeName : MAIN_COLOR_RED_ALPHA} range:NSMakeRange(1, string.length-2)];
    
    _countLabel.attributedText = _string;
    
    
    _isSingle = (products.count == 1) ? YES : NO;
    
    _priceFooterView.hidden = _isSingle;
    
    for (int i = 0; i<3; i++)
    {
        UIImageView *view = _productsView[i];

        if (i>(products.count-1))
        {
            view.hidden = YES;
            
            continue;
        }
     
            [view sd_setImageWithURL:IMAGE_ID([(FNProductArgs *)products[i] imgKey]) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
    
        view.hidden = NO;
    }
    
    if (_isSingle)
    {
        _countLabel.hidden = YES;
        
        _nameLabel.hidden = NO;
        
        _attributeLabel.hidden = NO;
        
        _priceLabel.hidden = NO;
               
       
    }
    else
    {
        _countLabel.hidden = NO;
        
        _nameLabel.hidden = YES;
        
        _attributeLabel.hidden = YES;
        
        _priceLabel.hidden = YES;
    }

    NSString *total = [NSString stringWithFormat:@"共计¥%@（含运费¥%@）",order.closingPrice,order.postage];
    
    [_string replaceCharactersInRange:NSMakeRange(0, _string.length) withString:total];
    
    NSInteger priceLen = [NSString stringWithFormat:@"%@",order.closingPrice].length;
    
    NSInteger postLen = [NSString stringWithFormat:@"%@",order.postage].length;
    
    [_string setAttributes:@{ NSForegroundColorAttributeName : MAIN_COLOR_RED_ALPHA} range:NSMakeRange(2, priceLen+1)];
    [_string setAttributes:@{ NSForegroundColorAttributeName : MAIN_COLOR_RED_ALPHA} range:NSMakeRange(2+priceLen+5, postLen+1)];

    if (_isSingle)
    {
        _priceLabel.attributedText = _string;
        
        _moreIndicator.hidden = YES;
    }
    else
    {
        _totalPriceLabel.attributedText = _string;
        
        _moreIndicator.hidden = NO;
    }
    
    // Is virtual or not
    _shipBut.hidden = YES;

}

#pragma mark - After sale

- (void)setReturningFooter
{
    _returningLabel.text = @"2个退货申请等待商家确认";
}

- (BOOL)isPayEnableWithOrder:(FNOrderArgs *)order
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [df dateFromString:order.createTime];
    
    NSTimeInterval inter = [[NSDate date] timeIntervalSinceDate:date];
    
    NSTimeInterval interval = 0;
    
    switch ([order.orderState integerValue])
    {
        case FNOrderStatePaying:
            interval = order.timeOutLimit * 60 - inter;
            break;
        case FNOrderStateReceiving:
            interval = 24 * 15 * 60 * 60 - inter;
            break;
        case FNOrderStateAfterSale:
            interval = 24 * 7 * 60 * 60 - inter;
            break;
            
        default:
            break;
    }
    
    if(interval >0)
    {
        return YES;
    }else
    {
        return NO;
    }
}

@end
