//
//  FNOrderViewController.m
//  BonusStore
//
//  Created by  on 16/4/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderDetailVC.h"

#import "FNShoppingCartCell.h"
#import "FNOrderVC.h"
#import "FNOrderItem.h"
#import "FNOrderViewCell.h"
#import "FNShipInfoVC.h"
#import "FNCartBO.h"
#import "FNMyBO.h"
#import "FNVirtualCardModel.h"
#import "FNConfirmGetGoodsVC.h"
static CGFloat kMarginTopY = 12;

static CGFloat kMarginTopX = 15;

@interface FNOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource, FNReturnGoodsDelegate>
{
    NSIndexPath *indexPa;
    
    FNOrderArgs *_order;
    
    FNProductArgs * _product;
    
    NSArray *_array;
    
    UIView *_sectionView;
    
    UILabel *_shopNameLabel;
    
    FNReturnReasonView *_returnReasonView;
    
    FNReturnGoodsView *_returnGoodsView;
    
    FNProductDetailArgs *_virtualGoodsDetail;
    
    //footer view
    
    BOOL returnState;
    
    UILabel *_totalPKGSLabel;
    
    UILabel *_totalPriceLabel;
    
    UILabel *_needBonusLabel;
    
    UILabel *_giveBonusLabel;
    
    UILabel *_addressLabel;
    
    UILabel *_addressLabel2;
    
    UILabel *_timeLabel;
    
    //    CALayer *_lineLabel3;
    
    UIView *_addressView;
    
    NSString *statusStr;
    
    UILabel *_returnTimeLabel;
    
    BOOL _isOrderFinished;      //订单是否完成，如果超过退货时间。则显示已完成，否则还是申请退货,默认值：NO
    
    FNButton *_payBut;
    
    __block UIView *_confirmView;   //确认收货view
    
    UILabel *_orderStateLabel;  //右上角订单状态
    NSString * _statusStr;
}

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * virfulCardList;

@end

@implementation FNOrderDetailVC

- (instancetype)initWithState:(FNOrderState)state
{
    self = [super init];
    
    if (self)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        [self.view addSubview:_tableView];
        
        self.state = state;
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak __typeof(self) weakSelf = self;
    
    [FNLoadingView showInView:self.view];
    _tableView.hidden = YES;
    [[FNCartBO port02] getOrderDetailWithOrderID:self.orderID block:^(id result){
        _tableView.hidden = NO;
        [FNLoadingView hideFromView:self.view];
        
        if (![result isKindOfClass:[FNOrderArgs class]])
        {
            if(result)
            {
                [self.view makeToast:result[@"desc"]];
            }
            else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
            return ;
        }
        
        _order = result;
        
        _array = _order.productList;
        
        
        [weakSelf initHeaaderView];
        
        [_tableView reloadData];
        
        [self countDown];
        
        
        NSInteger productCnt = 0;
        
        for (FNProductArgs *p in _array)
        {
            productCnt += [p.count integerValue];
        }
        
        FNProductArgs *product = _order.productList.firstObject;
        self.virfulCardList = [NSMutableArray array];
        if(self.state == FNOrderStateFinish||self.state == FNOrderStateFinishCommenting)
        {
            [[FNMyBO port02]getVirtualCardListProductId:product.productId orderId:_order.orderId number:[product.count intValue] skuNum:product.sku[@"skuNum"] block:^(id result) {
                if([result[@"code"] intValue ]==200)
                {
                    for ( NSDictionary * dict in result[@"cardList"] )
                    {
                        [self.virfulCardList addObject:[FNVirtualCardModel mj_objectWithKeyValues:dict ]];
                    }
                }
                [self initFinishVirFulLabel];
                
                [self.tableView reloadData];
            }];
        }
        NSString *pkgs = [NSString stringWithFormat:@"总件数%ld件",(long)productCnt];
        _totalPKGSLabel.attributedText = [pkgs setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(3, pkgs.length-4)];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总金额¥%@(含运费¥%.2f)",_order.closingPrice,[_order.postage floatValue]]];
        [string setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(3, [NSString stringWithFormat:@"%@",_order.closingPrice].length+1)];
        [string setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(4+[NSString stringWithFormat:@"%@",_order.closingPrice].length+4, _order.postage.length+1)];
        _totalPriceLabel.attributedText = string;
        
        NSString *needString = [NSString stringWithFormat:@"需 %.0f 积分",[_order.closingPrice floatValue] * 100];
        _needBonusLabel.attributedText = [needString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(2, needString.length-5)];;
        if([_order.tradeCode isEqualToString:@"Z8003"]||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"] ||[_order.tradeCode isEqualToString:@"Z8006"]|| [_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
        {
            _giveBonusLabel.hidden = YES;
            
        }else
        {
            _giveBonusLabel.hidden = NO;
            NSString *giveString = [NSString stringWithFormat:@"下单立赠 %.0f 积分",floor([_order.closingPrice floatValue])];
            _giveBonusLabel.attributedText = [giveString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, giveString.length-7)];
        }

        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(countDown) object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self autoFitInsets];
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [_tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section)
    {
        return 1;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section)
    {
        return nil;
    }
    
    if (!_sectionView)
    {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
        
        _sectionView.backgroundColor = [UIColor whiteColor];
        
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 , kWindowWidth-30, 20)];
        
        [_shopNameLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [_sectionView addSubview:_shopNameLabel];
    }
    
    if (![NSString isEmptyString:[_order sellerName]])
    {
        _shopNameLabel.text = [_order sellerName];
    }
    
    return _sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isVirtualGoods ||[_order.tradeCode isEqualToString:@"Z8003"] ||[_order.tradeCode isEqualToString:@"Z8004"] ||[_order.tradeCode isEqualToString:@"Z8005"] ||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
    {
        return [FNOrderViewCell orderCellHeightWithOrderItem:_order];
    }
    
    if (indexPath.row == _order.productList.count -1 )
    {
        
        return [FNOrderViewCell orderCellHeightWithOrderItem:_order];
    }
    
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isVirtualGoods || [_order.tradeCode isEqualToString:@"Z8003"] ||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"]||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
    {
        if (section == 0)
        {
            return 1;
        }else
        {
            return 1;
        }
    }
    
    return _array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FNOrderViewCell *cell =  [FNOrderViewCell dequeueWithTableView:tableView];
    
    if (!self.isVirtualGoods && ![_order.tradeCode isEqualToString:@"Z8003"] &&![_order.tradeCode isEqualToString:@"Z8004"]&& ![_order.tradeCode isEqualToString:@"Z8005"]&& ![_order.tradeCode isEqualToString:@"Z8006"] && ![_order.tradeCode isEqualToString:@"Z0010"]&&![_order.tradeCode isEqualToString:@"Z8007"])
    {
        cell.product = _array[indexPath.row];
        
        cell.delegate = self;
        
        if (_order.afterSaleList && [_order.afterSaleList isKindOfClass:[NSArray class]] && [_order.afterSaleList count] > indexPath.row)
        {
            NSInteger state = [[_order.afterSaleList[indexPath.row] valueForKey:@"state"] integerValue];
            
            [cell setReturnState:state order:_order];
        }
        else
        {
            if (_isOrderFinished)
            {
                [cell setReturnState:FNOrderStateFinish order:_order];//如果超过退货时间则显示已完成
            }
            else
            {
                [cell setReturnState:-2 order:_order];//显示默认的申请退货按钮
            }
        }
    }
    else
    {
        cell.orderItem = _order;
        cell.returnBut.hidden = YES;
        cell.commentsLabel.hidden = NO;
    }
    
    if(_order.productList.count !=1){
        
        if (indexPath.row != _order.productList.count-1)
        {
            cell.commentsLabel.hidden = YES;
            cell.grayLine1.hidden = YES;
            
        }
        else
        {
            cell.grayLine1.hidden = NO;
            
            cell.commentsLabel.hidden = NO;
        }
        
    }else
    {
        cell.grayLine1.hidden = NO;
        
        cell.commentsLabel.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_order.tradeCode isEqualToString:@"Z8003"] ||[_order.tradeCode isEqualToString:@"Z8004"] ||[_order.tradeCode isEqualToString:@"Z8005"]||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
    {

    
        
    }
    else
    {
        
        FNProductArgs * product = _order.productList[indexPath.row];
        
        FNDetailVC *vc = [[FNDetailVC alloc] init];
        
        vc.productName = product.productName;
        
        vc.productId = product.productId;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

// 订单详情的view
- (void)initHeaaderView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    // 订单编号
    UILabel *codeLabel = [[UILabel alloc]init];
    codeLabel.text = [NSString stringWithFormat:@"订单编号:     %@",self.orderID];;
    [codeLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(30.0, 30.0, 30.0)];
    codeLabel.textAlignment = NSTextAlignmentLeft;
    CGSize codeLabelSize = [codeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    codeLabel.frame = CGRectMake(kMarginTopX, kMarginTopY, codeLabelSize.width, codeLabelSize.height);
    [view addSubview:codeLabel];
    
    _statusStr = nil;
    if (_order.afterSaleList && [_order.afterSaleList isKindOfClass:[NSArray class]] && [_order.afterSaleList count] > 0)
    {
        self.state = [[_order.afterSaleList lastObject][@"state"] integerValue];
    }
    
    switch (self.state)
    {
        case FNOrderStatePaying:
            _statusStr = @"待付款";
            break;
            
        case FNOrderStateShipping:
            _statusStr = @"待发货";
            break;
            
        case FNOrderStateReceiving:
            _statusStr = @"待收货";
            break;
        case FNOrderStateFinishCommenting:
        case FNOrderStateFinish:
            _statusStr = @"已完成";
            break;
            
        case FNOrderStateReturning:
            _statusStr = @"退货中";
            break;
            
        case FNOrderStateReturnFailed:
            _statusStr = @"退货失败";
            break;
            
        case FNOrderStateReturned:
            _statusStr = @"已退货";
            break;
            
        case FNOrderStateAfterSale:
            _statusStr = @"售后";
            break;
            
        case FNOrderStateAutoClosed:
        case FNOrderStateManageCanceled:
        case FNOrderStateCanceled:
            _statusStr = @"已取消";
            break;
            
        default:
            
            //如果服务器返回了一个客户段没有的类型，则进入默认状态
            _statusStr = @"";
            self.state = FNOrderStateDefault;
            
            break;
    }
    // 状态 按钮
    _orderStateLabel = [[UILabel alloc]init];
    _orderStateLabel.text = _statusStr;
    [_orderStateLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor redColor]];
    _orderStateLabel.textAlignment = NSTextAlignmentRight;
    _orderStateLabel.frame = CGRectMake(kScreenWidth -60-kMarginTopX, kMarginTopY, 60, 25);
    [view addSubview:_orderStateLabel];
    
    // 灰线1
    UILabel *lineLabel1 = [[UILabel alloc]init];
    [view addSubview:lineLabel1];
    lineLabel1.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
    CGFloat lineLabelY = CGRectGetMaxY(codeLabel.frame)+12 ;
    lineLabel1.frame = CGRectMake(0, lineLabelY, kScreenWidth, 1);
    
    // 下单时间
    CGFloat orderTimeY = CGRectGetMaxY(lineLabel1.frame) + 12;
    UILabel *orderTimeLabel = [[UILabel alloc]init];
    NSString *orderTimeStr = _virtualGoodsDetail ? _virtualGoodsDetail.createTime : _order.createTime;
    orderTimeLabel.text = [NSString stringWithFormat:@"下单时间:     %@",orderTimeStr];
    [orderTimeLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(30.0, 30.0, 30.0)];
    orderTimeLabel.textAlignment = NSTextAlignmentLeft;
    CGSize orderTimeSize = [orderTimeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    orderTimeLabel.frame = CGRectMake(kMarginTopX, orderTimeY, orderTimeSize.width, orderTimeSize.height);
    [view addSubview:orderTimeLabel];
    
    //  退货剩余时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if( _state == FNOrderStateFinish || _state == FNOrderStateFinishCommenting)
    {
        if (_isVirtualGoods == NO && ![_order.tradeCode isEqualToString:@"Z8003"] &&![_order.tradeCode isEqualToString:@"Z8004"] &&![_order.tradeCode isEqualToString:@"Z8005"]&&![_order.tradeCode isEqualToString:@"Z8006"] &&![_order.tradeCode isEqualToString:@"Z8001"] && ![_order.tradeCode isEqualToString:@"Z0010"]&&![_order.tradeCode isEqualToString:@"Z8007"])
        {
            _returnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, orderTimeLabel.y + orderTimeLabel.height + 5, kScreenWidth - 30, 20)];
            
            _returnTimeLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
            
            [view addSubview:_returnTimeLabel];
            
            df.timeStyle = NSDateFormatterLongStyle;
            
            [self returnGoodsTime];
        }
    }
    
    if (_order.afterSaleList && [_order.afterSaleList isKindOfClass:[NSArray class]] )
    {
        for (NSMutableDictionary *dict in _order.afterSaleList)
        {
            NSInteger  state = [dict[@"state"] integerValue];
            
            if (state == 1)
            {
                returnState = YES;
            }
        }
        
        if (_state == FNOrderStateFinish || _state == FNOrderStateFinishCommenting || returnState == YES)
        {
            
            if (_isVirtualGoods == NO && ![_order.tradeCode isEqualToString:@"Z8003"]&& ![_order.tradeCode isEqualToString:@"Z8004"]&& ![_order.tradeCode isEqualToString:@"Z8005"]&&![_order.tradeCode isEqualToString:@"Z8006"] &&![_order.tradeCode isEqualToString:@"Z0010"]&&![_order.tradeCode isEqualToString:@"Z8007"])
            {
                _returnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, orderTimeLabel.y + orderTimeLabel.height + 5, kScreenWidth - 30, 20)];
                
                _returnTimeLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
                
                [view addSubview:_returnTimeLabel];
                
                df.timeStyle = NSDateFormatterLongStyle;
                
                [self returnGoodsTime];
            }
        }
    }
    
    // 灰线
    UILabel *lineLabel2 = [[UILabel alloc]init];
    [view addSubview:lineLabel2];
    lineLabel2.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    CGFloat lineLabel2Y = 0.0;
    if (_isOrderFinished || !_returnTimeLabel)
    {
        lineLabel2Y = (orderTimeLabel.y + orderTimeLabel.height + 12);
    }
    else
    {
        lineLabel2Y = (_returnTimeLabel.y + _returnTimeLabel.height + 12);
    }
    lineLabel2.frame = CGRectMake(0, lineLabel2Y -1, kScreenWidth, 1);
    CGFloat payInfoLabelY = 0;
    // 收货地址
    if (![_order.tradeCode isEqualToString:@"Z0010"])
    {
    _addressView = self.isVirtualGoods || [_order.tradeCode isEqualToString:@"Z8003"] ||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"] ||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z8007"]? [self virtualGoods] : [self realGoods];
    [view addSubview:_addressView];
    CGFloat addressViewY = CGRectGetMaxY(lineLabel2.frame);
    UIReframeWithY(_addressView, addressViewY);
      payInfoLabelY  =  CGRectGetMaxY(_addressView.frame);

    }else
    {
        payInfoLabelY = CGRectGetMaxY(lineLabel2.frame);

    }
    if (_isVirtualGoods == YES || [_order.tradeCode isEqualToString:@"Z8003"] ||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"]||[_order.tradeCode isEqualToString:@"Z8006"] || [_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
    {
        orderTimeLabel.hidden = NO;
        _returnTimeLabel.hidden = YES;
    }
    
    //添加支付信息
    if( (_state !=FNOrderStatePaying)&&( _state != FNOrderStateCanceled)&&( _state != FNOrderStateDefault) && (_state != FNOrderStateAutoClosed))
    {
        UILabel *payInfoLabel = [[UILabel alloc]init];
        payInfoLabel.frame = CGRectMake(15, payInfoLabelY, kScreenWidth, 44);
        NSString * showPayType = nil;
        if([_order.payChannel integerValue ] == FNPayChannelAllBonus)
        {
            showPayType = @"积分支付";
            
        }else if([_order.payChannel integerValue] ==FNPayChannelAlipay ||[_order.payChannel integerValue] ==FNPayChannelAliwap||[_order.payChannel integerValue] == FNPayChannelAliApp)
        {
            showPayType = @"支付宝支付";
        }else if ([_order.payChannel integerValue] == FNPayChannelTianYiApp ||[_order.payChannel integerValue] == FNPayChannelTianYiWap)
        {
            showPayType = @"积分支付";
        }else if ([_order.payChannel integerValue]==FNPayChannelWeiXinpay||[_order.payChannel integerValue]==FNPayChannelWeiXinWap||[_order.payChannel integerValue]==FNPayChannelWeiXinApp)
        {
            showPayType = @"微信支付";
        }
        else if ([_order.payChannel integerValue]==FNPayChannelCMB||[_order.payChannel integerValue]==FNPayChannelCMB||[_order.payChannel integerValue]==FNPayChannelCMB)
        {
            showPayType = @"一网通支付";
        }else if ([_order.payChannel integerValue]==FNPayChannelBestPayH5 ||[_order.payChannel integerValue]==FNPayChannelBestPayAPP||[_order.payChannel integerValue]==FNPayChannelBestPayPC)
        {
            showPayType = @"翼支付";
        }
        else
        {
            showPayType = @"和包支付";
        }
        NSString *payInfoStr = nil;
        
        if ([_order.payChannel integerValue] == FNPayChannelAllBonus)
        {
            payInfoStr = [NSString stringWithFormat:@"支付信息:     支付%@积分",_order.exchangeScore];
            
        }else
        {
            if ([_order.exchangeScore integerValue] != 0) // 有积分
            {
                NSString * payMoney = [NSString stringWithFormat:@"%.2lf",[_order.closingPrice doubleValue] - [_order.exchangeCash doubleValue]];
                payInfoStr = [NSString stringWithFormat:@"支付信息:     积分%@,%@¥%@",_order.exchangeScore,showPayType,payMoney];
            }else
            {
                payInfoStr = [NSString stringWithFormat:@"支付信息:     %@¥%@",showPayType,_order.closingPrice];
            }
        }
        payInfoLabel.textColor = UIColorWithRGB(248.0, 48.0, 48.0);
        payInfoLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
        NSAttributedString *arr = [payInfoStr makeStr:@"支付信息:" withColor:UIColorWithRGB(30.0, 30.0, 30.0) andFont:[UIFont fontWithName:FONT_NAME_LTH size:14]];
        payInfoLabel.attributedText = arr;
        [view addSubview:payInfoLabel];
        
        
        payInfoLabelY = CGRectGetMaxY(payInfoLabel.frame);
        UILabel *payLineLabel = [[UILabel alloc]init];
        payLineLabel.frame =  CGRectMake(0, payInfoLabelY, kScreenWidth, 1);
        payLineLabel.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
        [view addSubview:payLineLabel];
    }
    
    UIButton * shipBut  = [UIButton buttonWithType:UIButtonTypeSystem];
    shipBut.frame = CGRectMake(0, payInfoLabelY + 1 , kWindowWidth, 0);
    
    if (!self.isVirtualGoods && (_state != FNOrderStatePaying && _state != FNOrderStateShipping && _state != FNOrderStateAutoClosed && _state != FNOrderStateCanceled &&_state !=FNOrderStateManageCanceled && _state != FNOrderStateDefault) && ![_order.tradeCode isEqualToString:@"Z8003"] &&![_order.tradeCode isEqualToString:@"Z8004"]&&![_order.tradeCode isEqualToString:@"Z8005"]&&![_order.tradeCode isEqualToString:@"Z8006"]&& ![_order.tradeCode isEqualToString:@"Z0010"]&&![_order.tradeCode isEqualToString:@"Z8007"])
    {
        __weak __typeof(self) weakSelf = self;
        
        [shipBut setTitle:@"查看物流信息" forState:UIControlStateNormal];
        
        [shipBut setBackgroundColor:[UIColor whiteColor]];
        
        shipBut.frame = CGRectMake(0, payInfoLabelY+1, kWindowWidth, 38);
        
        shipBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        shipBut.hidden = NO;
        [shipBut setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 5, 0)];
        
        [shipBut addSuperView:view ActionBlock:^(id sender) {
            
            FNShipInfoVC * vc =[[FNShipInfoVC alloc]init];
            vc.orderArgs = _order;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
    }else
    {
        shipBut.hidden = YES;
    }

    CGFloat lastLineY = shipBut.y + shipBut.height ;
    
    if ((([_order.tradeCode isEqualToString:@"Z8003"]||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"]||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z8007"]) &&(_state == FNOrderStateShipping || _state == FNOrderStateFinish ||_state == FNOrderStateFinishCommenting ||_state == FNOrderStateManageCanceled))  ||([_order.tradeCode isEqualToString:@"Z8001"] && _state == FNOrderStateShipping) )
    {
        NSString *str  = @"处理中";
        NSString *tip = @"发货状态";
    if([_order.tradeCode isEqualToString:@"Z8001"])
    {
        if (![_order.virRechargeState isKindOfClass:[NSNull class]])
        {
        if ([_order.virRechargeState integerValue] ==3)
        {
            str =  @"处理中";
            
            
        } else if ([_order.virRechargeState integerValue] == 2)
        {
            str  = @"失败";
            
        }else
        {
            str = @"成功";
        }
    }
    } else if ([_order.tradeCode isEqualToString:@"Z8007"])
    {
        tip = @"发货状态";
        if (_state == FNOrderStateFinish ||_state == FNOrderStateFinishCommenting)
        {
            str = @"成功";
        }else
        {
            if (![_order.virRechargeState isKindOfClass:[NSNull class]])
            {
                if ([_order.virRechargeState integerValue] ==3)
                {
                    str =  @"处理中";
                    
                    
                } else if ([_order.virRechargeState integerValue] == 2)
                {
                    str  = @"失败";
                    
                }else
                {
                    str = @"成功";
                }                
            }
        }
    }
    else{
        
        tip = @"充值状态";
        if (_state == FNOrderStateFinish ||_state == FNOrderStateFinishCommenting)
        {
            str = @"充值成功";
        }else
        {
            if (![_order.virRechargeState isKindOfClass:[NSNull class]])
            {
                if ([_order.virRechargeState integerValue] == FNVirRechargeSuccess)
                {
                    str = @"充值成功";
                    
                } else if ([_order.virRechargeState integerValue] == FNVirRechargefail)
                {
                    str  = @"充值失败";
                    
                }else
                {
                    str = @"处理中";
                }

            }
        }
    }
        UILabel *stateLab = [[UILabel alloc]init];
        stateLab.text = [NSString stringWithFormat:@"%@:     %@",tip,str];
        [stateLab clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor: UIColorWithRGB(248.0, 48.0, 48.0)];
        stateLab.textAlignment = NSTextAlignmentLeft;
        NSAttributedString *arr = [stateLab.text makeStr:[NSString stringWithFormat:@"%@:",tip] withColor:UIColorWithRGB(30.0, 30.0, 30.0) andFont:[UIFont fontWithName:FONT_NAME_LTH size:14]];
        stateLab.attributedText = arr;
        CGSize stateLabSize = [stateLab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        stateLab.frame = CGRectMake(kMarginTopX, lastLineY, stateLabSize.width, 44);
        [view addSubview:stateLab];
    
        lastLineY = CGRectGetMaxY(stateLab.frame);
    }
    CALayer *line2 = [CALayer layerWithFrame:CGRectMake(0, lastLineY, kWindowWidth, 10) color:MAIN_BACKGROUND_COLOR];
    [view.layer addSublayer:line2];
    CGFloat viewH = CGRectGetMaxY(line2.frame);
    
    view.frame = CGRectMake(0, 0, kScreenWidth, viewH);
    _tableView.tableHeaderView = view;
}

- (void)returnGoodsTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [df dateFromString:_order.successTime];
    
    NSTimeInterval inter = [[NSDate date] timeIntervalSinceDate:date];
    
    NSTimeInterval interval = 7*24 *60 * 60 - inter;
    
    if (interval <= 1)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnGoodsTime) object:nil];
        
        NSString *time = [NSString stringWithFormat:@"退货时间剩余\n%@",@"0天0小时0分"];
        
        _returnTimeLabel.attributedText = [time setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6, time.length - 6)];
        
        [_payBut setType:FNButtonTypeOpposite];
        
        _payBut.enabled = NO;
        [_payBut setTitle:@"已取消" forState:UIControlStateNormal];
        
        return;
    }
    
    interval--;
    
    NSString *com = nil;
    
    NSInteger d = interval / ( 60.0 * 60.0 * 24.0 );
    
    NSInteger h = interval / ( 60.0 * 60.0 ) - 24.0 * d;
    
    NSInteger m = interval / (60.0) - (24.0 * d * 60.0 + h * 60.0);
    if(d ==0 && h==0 && m==0)
    {
        
        _isOrderFinished = YES;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(returnGoodsTime) object:nil];
        
        NSString *time = [NSString stringWithFormat:@"退货时间剩余\n%@",@"0天0小时0分钟"];
        
        _returnTimeLabel.attributedText = [time setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6, time.length-6)];
        
        [_payBut setType:FNButtonTypeOpposite];
        
        _payBut.enabled = NO;
        
        [_payBut setTitle:@"已取消" forState:UIControlStateNormal];
        
        _returnTimeLabel.hidden = YES;
        
        return;

    }else
    {
        com = [NSString stringWithFormat:@"%ld天%ld时%ld分",d,h,m];

    }
    
    NSString *time = [NSString stringWithFormat:@"退货时间剩余: %@",com];
    _returnTimeLabel.attributedText = [time setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(7, time.length-7)];
    
    if (d >= 1|| h >= 1 || m>=1)
    {
        [self performSelector:@selector(returnGoodsTime) withObject:nil afterDelay:1];
    }
}

// 收货地址
- (UIView *)realGoods
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 100)];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(15, kMarginTopY , 70, 20)];
    tip.text = @"收货地址:   ";
    [tip clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(30.0, 30.0, 30.0)];
    
    [view addSubview:tip];
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 0 , kWindowWidth - 105, 25)];
    
    NSString *string = [_order address] ? [_order address] : [_order mobile];
    
    _addressLabel.numberOfLines = 2;
    
    _addressLabel.font = [UIFont systemFontOfSize:14];
    
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@",_order.receiverName,_order.mobile];
    
    _addressLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(92, _addressLabel.y+_addressLabel.height, kScreenWidth - 105, 50)];
    
    _addressLabel2.font = [UIFont fzltWithSize:14];
    _addressLabel2.text = string;
    
    _addressLabel2.numberOfLines = 0;
    
    [view addSubview:_addressLabel2];
    
    [view addSubview:_addressLabel];
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(kWindowWidth-100, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fzltWithSize:14]} context:nil].size;
    
    UIReframeWithH(_addressLabel2, ceilf(size.height)+10);
    
    UIReframeWithH(view, _addressLabel.y+_addressLabel.height+_addressLabel2.height+5);
    UILabel *lineLabel3 = [[UILabel alloc]init];
    [view addSubview:lineLabel3];
    lineLabel3.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    lineLabel3.frame = CGRectMake(0, view.height , kScreenWidth, 1);
    
    return view;
}

- (UIView *)virtualGoods
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    UILabel * addressLabel = [[UILabel alloc]init];
    [addressLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(30.0, 30.0, 30.0)];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.frame = CGRectMake(15, 0, kScreenWidth -30, 43);
    addressLabel.text = [NSString stringWithFormat:@"手机号码:     %@",_order.mobile];

    if([_order.tradeCode isEqualToString:@"Z8005"]){
    
        addressLabel.text = [NSString stringWithFormat:@" QQ号码:     %@",_order.mobile];

    }else if ([_order.tradeCode isEqualToString:@"Z8006"])
    {
         addressLabel.text = [NSString stringWithFormat:@"游戏账号:     %@",_order.mobile];
    }else if ([_order.tradeCode isEqualToString:@"Z8007"])
    {
        addressLabel.text = [NSString stringWithFormat:@"手机号:     %@",_order.mobile];

    }
    
    [view addSubview:addressLabel];
    
    // 灰线
    UILabel *lineLabel3 = [[UILabel alloc]init];
    [view addSubview:lineLabel3];
    lineLabel3.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    lineLabel3.frame = CGRectMake(0, 44, kScreenWidth, 1);
    return view;
}

// 设置换行的label 的size
- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

-(void)setState:(FNOrderState)state
{
    _state = state;
    
    switch (_state) {
        case FNOrderStatePaying:
            
            [self initPayingView];
            
            [self initFooterView];
            
            break;
            
        case FNOrderStateShipping:
            
        case FNOrderStateCanceled:
            
        case FNOrderStateReturned:
            
        case FNOrderStateAfterSale:
            
            _tableView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-NAVIGATION_BAR_HEIGHT);
            
            break;
            
        case FNOrderStateFinish:
            
            [self initFinishVirFulLabel];
            
        case FNOrderStateAll:
        {
            _tableView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-NAVIGATION_BAR_HEIGHT);
        }
            break;
            
        case FNOrderStateReceiving:
            
            [self initReceivingView];
            
            break;
            
        default:
            
            break;
    }
}


- (void)initFooterView
{
    NSArray * arr = @[@"cart_pay_1",@"cart_pay_2",@"cart_pay_3",@"cart_pay_4"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, -5, kWindowWidth, 95)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"可选择的支付方式: ";
    [nameLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(74.0, 74.0, 74.0)];
    CGFloat nameLabelH = [UIFont systemFontOfSize:14].lineHeight;
    nameLabel.frame = CGRectMake(15, 21, kScreenWidth *0.5-30, nameLabelH);
    [view addSubview:nameLabel];
    
    CGFloat btnY = CGRectGetMaxY(nameLabel.frame)+10;
    CGFloat btnW = 34;
    CGFloat btnMargin = (kScreenWidth*0.5 -30 - 4*34)*0.33;
    for(int i =0;i<4;i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake((btnW+btnMargin)*i+15, btnY, btnW, btnW);
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [view addSubview:btn];
    }
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor grayColor];
    lineLabel.frame = CGRectMake(kScreenWidth *0.5 - 10, 21, 1, 56);
    [view addSubview:lineLabel];
    
    CGFloat price = 0;
    
    for (FNProductArgs *p in _array)
    {
        price += ([p.curPrice floatValue] * [p.count integerValue]) + [p.postage floatValue];
    }
    
    UILabel *packageLabel = [[UILabel alloc]init];
    packageLabel.text = [NSString stringWithFormat:@"总件数0件"]; //@"  总金额: ¥220.00  ";
    [packageLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    [view addSubview:packageLabel];
    CGSize packageLabelSize = [packageLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    packageLabel.frame = CGRectMake(lineLabel.x+10, 17, kWindowDemiH-10, packageLabelSize.height);
    _totalPKGSLabel = packageLabel;
    
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.text = [NSString stringWithFormat:@"总金额：%.2f(含运费¥00.00)",price]; //@"  总金额: ¥220.00  ";
    [priceLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    [view addSubview:priceLabel];
    CGSize priceLabelSize = [priceLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    priceLabel.frame = CGRectMake(lineLabel.x+10,  CGRectGetMaxY(packageLabel.frame)+5, priceLabelSize.width+10, priceLabelSize.height);
    NSMutableAttributedString *needStr = [priceLabel.text makeStr:@"总金额:" withColor:UIColorWithRGB(74.0, 74.0, 74.0) andFont:[UIFont systemFontOfSize:11]];
    needStr = [NSString attributedStr:needStr makeStr:@"¥" withColor:UIColorWithRGB(30.0, 30.0, 30.0) andFont:[UIFont systemFontOfSize:11]];
    priceLabel.attributedText = needStr;
    _totalPriceLabel = priceLabel;
    
    NSString *needString = [NSString stringWithFormat:@"需 %.2f 积分",price];
    CGFloat needY = CGRectGetMaxY(priceLabel.frame)+5;
    UILabel * needLabel =[[UILabel alloc]init];
    [view addSubview:needLabel];
    CGSize  needLabelSize = [needString sizeWithAttributes:@{NSFontAttributeName:[UIFont fzltWithSize:11]}];
    needLabel.frame = CGRectMake(lineLabel.x+10, needY, kWindowDemiW-20, needLabelSize.height);
    [needLabel clearBackgroundWithFont:[UIFont fzltWithSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    needLabel.attributedText = [needString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(2, needString.length-5)];;
    _needBonusLabel = needLabel;
    NSString *giveString = [NSString stringWithFormat:@"下单立赠 %.2f 积分",price];
    CGFloat giveY = CGRectGetMaxY(needLabel.frame)+5;
    UILabel * giveLabel =[[UILabel alloc]init];
    [view addSubview:giveLabel];
    CGSize  giveSize = [needString sizeWithAttributes:@{NSFontAttributeName:[UIFont fzltWithSize:11]}];
    giveLabel.frame = CGRectMake(lineLabel.x+10, giveY, kWindowDemiW-20, giveSize.height);
    [giveLabel clearBackgroundWithFont:[UIFont fzltWithSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    giveLabel.attributedText = [giveString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(5, giveString.length-7)];;
    _giveBonusLabel = giveLabel;
    if([_order.tradeCode isEqualToString:@"Z8003"]||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"] ||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
    {
        _giveBonusLabel.hidden = YES;
        
    }else
    {
        _giveBonusLabel.hidden = NO;
    }
    
    _tableView.tableFooterView = view;
}

- (void)initFinishVirFulLabel
{
    if(_isVirtualGoods||( [_order.tradeCode isEqualToString:@"Z8003"]||[_order.tradeCode isEqualToString:@"Z8004"] ||[_order.tradeCode isEqualToString:@"Z8005"]||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z8001"]||[_order.tradeCode isEqualToString:@"Z8007"]))
    {
        UIView * view = [[UIView alloc]init];
        UILabel * backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        backLabel.backgroundColor = MAIN_BACKGROUND_COLOR;
        [view addSubview:backLabel];
        for (int i =0 ; i <self.virfulCardList.count; i++)
        {
            FNVirtualCardModel * model = self.virfulCardList[i];
            UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10+87*i, kWindowWidth, 43)];
            UILabel * passLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10+88*i+44, kWindowWidth, 43)];
            [cardLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
            [passLabel clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];

            NSString * cardStr  =[NSString stringWithFormat:@"兑换券:    %@",model.cardNumber];
            NSString * passStr  =[NSString stringWithFormat:@"密码:     %@",model.password];
            NSMutableAttributedString *needStr = [cardStr  makeStr:[NSString stringWithFormat:@"%@",model.cardNumber] withColor:UIColorWithRGB(140.0, 140.0, 140.0) andFont:[UIFont systemFontOfSize:14]];
            NSMutableAttributedString *passAtt =  [passStr  makeStr:[NSString stringWithFormat:@"%@",model.password] withColor:UIColorWithRGB(140.0, 140.0, 140.0) andFont:[UIFont systemFontOfSize:14]];
            
            cardLabel.attributedText = needStr;
            passLabel.attributedText = passAtt;
            [view addSubview:passLabel];
            [view addSubview:cardLabel];
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44*i+43+10, kScreenWidth, 1)];
            lineLabel.backgroundColor =MAIN_COLOR_SEPARATE;
            [view addSubview:lineLabel];
        }
        
        view.frame = CGRectMake(0, 0, kScreenWidth, 88*self.virfulCardList.count+10);
        view.backgroundColor =[UIColor whiteColor];
        _tableView.tableFooterView = view;
    }
    
}

- (void)initPayingView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-50-NAVIGATION_BAR_HEIGHT, kWindowWidth, 50)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 , 120, 40)];
    
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
    _timeLabel.numberOfLines = 2;
    
    [_timeLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    [view addSubview:_timeLabel];
    
    NSString *time = [NSString stringWithFormat:@"付款时间剩余\n"];
    
    _timeLabel.attributedText = [time setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6, time.length-6)];
    
    [_timeLabel setVerticalCenterWithSuperView:view];
    
    _payBut = [FNButton buttonWithType:FNButtonTypeEdge title:@"立即支付"];
    
    _payBut.frame = CGRectMake(kWindowWidth - 115, 0, 100, 33);
    
    [_payBut setVerticalCenterWithSuperView:view];
    
    [_payBut setCorner:5];
    
    __weak __typeof(self) weakSelf = self;
    
    [_payBut addSuperView:view ActionBlock:^(id sender) {
        
        FNPayVC *vc = [[FNPayVC alloc] init];
        
        vc.order = _order;
        vc.tradeCode = _order.tradeCode;
        if([_order.tradeCode isEqualToString:@"Z8003"] ||[_order.tradeCode isEqualToString:@"Z8004"]||[_order.tradeCode isEqualToString:@"Z8005"]||[_order.tradeCode isEqualToString:@"Z8006"]||[_order.tradeCode isEqualToString:@"Z0010"]||[_order.tradeCode isEqualToString:@"Z8007"])
        {
            vc.isSpecialType = YES;
            
        }else
        {
            vc.isSpecialType = NO;
        }
        
        vc.orderIds = @[self.orderID];
        
        vc.allPrice = [NSString stringWithFormat:@"%@",_order.closingPrice];
        
        vc.curBonus = [_order.exchangeScore integerValue];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    _tableView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-NAVIGATION_BAR_HEIGHT-50);
    
}

- (void)initReceivingView
{
    if (_confirmView)
    {
        return;
    }
    _confirmView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight-84-NAVIGATION_BAR_HEIGHT, kWindowWidth, 84)];
    
    _confirmView.backgroundColor = [UIColor clearColor];
    
    _confirmView.userInteractionEnabled = YES;
    
    [self.view addSubview:_confirmView];
    
    CALayer *lineT = [CALayer layerWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
    
    [_confirmView.layer addSublayer:lineT];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , kWindowWidth, 30)];
    
    tip.numberOfLines = 2;
    
    tip.text = [NSString stringWithFormat:@"请务必收到全部商品后再确认哦～\n发货15天后自动确认收货"];
    
    tip.textAlignment = NSTextAlignmentCenter;
    
    [tip setBackgroundColor:MAIN_BACKGROUND_COLOR font:[UIFont fzltWithSize:12] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    [_confirmView addSubview:tip];
    
    FNButton *confirmBut = [FNButton buttonWithType:FNButtonTypePlain title:@"确认收货"];
    
    confirmBut.frame = CGRectMake(0, 84-50, kWindowWidth, 50);
    
    [confirmBut addSuperView:_confirmView ActionBlock:^(id sender) {
        
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"确认收货" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {
                [FNLoadingView showInView:self.view];
                [[FNCartBO port02] confirmWithOrderID:self.orderID block:^(id result){
                    [FNLoadingView hideFromView:self.view];
                    
                    if ([result[@"code"] integerValue] == 200)
                    {
                    
                        FNConfirmGetGoodsVC * confirmVC = [[FNConfirmGetGoodsVC  alloc]init];
                        confirmVC.state = 1;
                        confirmVC.orderID = _order.orderId;
                        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        [tempMarr removeObject:self];
                        [tempMarr insertObject:confirmVC atIndex:tempMarr.count];
                        [self.navigationController setViewControllers:tempMarr animated:YES];
                        // 通知页面刷新
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setValue:@(self.titleState) forKey:@"getGoodsState"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"clickGetGoods" object:nil userInfo:dic];
                        
                    }
                    else
                    {
                        [UIAlertView alertViewWithMessage:@"确认失败，请重试"];
                    }
                }];
            }
        } otherTitle:@"取消", nil];
        
    }];
    
    _tableView.frame = CGRectMake(0, 0, kScreenWidth,kScreenHeight-NAVIGATION_BAR_HEIGHT-84);
}

- (void)countDown
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [df dateFromString:_order.createTime];
    
    NSDate * curDate = [NSDate date];
    
    NSTimeInterval inter = [curDate timeIntervalSinceDate:date];
    
    NSTimeInterval interval = self.timeOutLimit * 60  - inter;
    
    interval--;
    
    NSString *com = nil;
    
    if (interval <= 0)
    {
         com = @"0时0分0秒";
        
        [_payBut setType:FNButtonTypeOpposite];
        
        _payBut.enabled = NO;
        
        [_payBut setTitle:@"已取消" forState:UIControlStateNormal];
        
        NSString *time = [NSString stringWithFormat:@"付款时间剩余\n%@",@"0时0分0秒"];
        
        _timeLabel.attributedText = [time setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6, time.length-6)];
        
        if(self.state == FNOrderStatePaying)
        {
            _statusStr = @"已取消";
            _orderStateLabel.text = _statusStr;
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(countDown) object:nil];

        return;
    }else
    {
        
        NSInteger h = interval / ( 60.0 * 60.0 );
        
        NSInteger m = interval / (60.0) - h * 60.0;
        
        NSInteger sec = interval - (h *60*60 + m* 60.0);
        
        if (h==0 && m==0 && sec<0 )
        {
         
             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(countDown) object:nil];
        }else
        {
            com = [NSString stringWithFormat:@"%ld时%ld分钟%ld秒",h,m,sec];
            NSString *time = [NSString stringWithFormat:@"付款时间剩余\n%@",com];
            
            _timeLabel.attributedText = [time setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(6, time.length-6)];
            
            [self performSelector:@selector(countDown) withObject:nil afterDelay:0];
 
        }
 
    }
    
}

- (void)returnGoodsAction:(FNOrderViewCell *)returnGoods
{
    
    returnGoods.indexPath = [self.tableView indexPathForCell:returnGoods];
    
    FNProductArgs *product = returnGoods.orderItem.productList[returnGoods.indexPath.row];
    
    _returnReasonView = [[FNReturnReasonView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_returnReasonView];
    
    __weak __typeof(_returnReasonView) weakReson = _returnReasonView;
    
    __weak __typeof(self) weakSelf = self;
    
    [_returnReasonView setConfirm:^(id sender) {
        
        [weakReson removeFromSuperview];
        
        _order.userComment = _returnReasonView.field.text;
        
        _order.reason = _returnReasonView.reason;
        
        [[FNCartBO port02] refundWithOrder:_order productId:product.productId skuNum:product.sku[@"skuNum"] block:^(id result) {
            
            if ([result[@"code"] integerValue] == 200)
            {
                FNReturnGoodsView *view = [[FNReturnGoodsView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
                
                [[UIApplication sharedApplication].keyWindow addSubview:view];
                
                [view goMainWithBlock:^(id sender) {
                    
                    [view removeFromSuperview];
                    
                    [weakSelf goMain];
                }];
                _orderStateLabel.text = @"退货中";
                
                returnGoods.returnBut.hidden = YES;
                returnGoods.returnStateLabel.hidden = NO;
                
                returnGoods.returnStateLabel.text = @"退货中";
            }
            else
            {
                if(result)
                {
                    [UIAlertView alertViewWithMessage:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
            }
            
        }];
        
    } cancel:^(id sender) {
        
        [weakReson removeFromSuperview];
    }];
    
    [_returnReasonView setProto:^(id sender) {
        
        [weakReson removeFromSuperview];
        
        FNWebVC *vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"tuihuan" ofType:@"html"]];
        
        vc.title = @"退货政策";
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
}

@end
