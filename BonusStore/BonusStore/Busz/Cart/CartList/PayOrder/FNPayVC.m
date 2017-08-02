
//
//  FNPayVC.m
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPayVC.h"
#import "FNCartBO.h"
#import "FNBonusBO.h"
#import "FNPayFinishVC.h"
#import "Order.h"
#import "AppDelegate.h"
#import "FNHeader.h"
#import "MD5.h"

// 生产
#define releaseURL @"https://webpaywg.bestpay.com.cn/order.action"
// 准生产
#define debugURL @"http://wapchargewg.bestpay.com.cn/order.action"
NSMutableDictionary *FNPayInfo;

UIViewController *FNPayVCExtern;

@interface FNPayVC ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *_array;
    
    NSMutableSet *_selectedSet;
    
    NSUInteger _index;
    
    BOOL _isPayed;
    
    FNPayHeaderView *_header;
    
    __block NSInteger _allBonus;        //用户总积分
}

@end

@implementation FNPayVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    FNLoginIsScan = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    FNPayVCExtern = self;
    
    self.title = @"支付";
    
    [self setNavigaitionBackItem];
    
    self.tableViewDelegate = self;
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.tableView.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    _array = [FNPayWayArgs initData];
    
    _selectedSet = [[NSMutableSet alloc] init];
    
    [[FNCartBO port02] getCartCountWithBlock:nil];
    
    _index = 0;     //默认是0，在支付时，相当于什么也不选择
    
    if ([self.orderIds count] > 1)
    {
        
    }
    else
    {
        [FNLoadingView showInView:self.view];
        [[FNCartBO port02] getOrderDetailWithOrderID:[self.orderIds lastObject] block:^(id result){
            
            [FNLoadingView hideFromView:self.view];
            if (![result isKindOfClass:[FNOrderArgs class]])
            {
                if(result)
                {
                    
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
                
                return ;
            }
            
            FNOrderArgs *order = (FNOrderArgs *)result;
            
            self.allPrice = [NSString stringWithFormat:@"%@",order.closingPrice];
            
            _curBonus = [order.exchangeScore integerValue];
            
            [self isSwitchEnable];
            
            [self initHeader];
            
        }];
    }
    
    
    
    [[FNBonusBO port02] getBonusWithBlock:^(id result) {
        
        if ([result[@"code"] integerValue] != 200)
        {
            if(result)
            {
                [self.view makeToast:result[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
            
            return ;
        }
        
        _allBonus = [result[@"amount"] integerValue];
        
        [self isSwitchEnable];
    }];
    
    FNButton *payBut = [FNButton buttonWithType:FNButtonTypePlain title:@"支付"];
    
    payBut.frame = CGRectMake(0, kWindowHeight-50-NAVIGATION_BAR_HEIGHT, kWindowWidth, 50);
    
    [payBut addSuperView:self.view ActionBlock:^(id sender) {
        
        
        FNPayType type;
        
        CGFloat bonus = 0;
        
        if (_curBonus)
        {
            bonus = _curBonus;
        }
        else
        {
            if( _allBonus >= [[NSDecimalNumber decimalWithString:self.allPrice] multiplyingBy:100].floatValue)
            {
                bonus = [[NSDecimalNumber decimalWithString:self.allPrice] multiplyingBy:100].floatValue;
            }
            else
            {
                bonus = _allBonus;
            }
        }
        
        //如果关闭开关，肯定是0
        if (!_header.switchBut.on)
        {
            bonus = 0;
        }
        
        NSString *cash = [NSString stringWithFormat:@"%.2f",bonus/100.0];
        
        //未选择支付方式，默认index是0
        if (_index == 0 )
        {
            if (_header.switchBut.on )        //仅使用积分
            {
                if (bonus < [[NSDecimalNumber decimalWithString:self.allPrice] multiplyingBy:100].floatValue)     //积分小于价格也要选择支付方式(价格转换成积分在比较)
                {
                    [UIAlertView alertViewWithMessage:@"请选择支付方式"];
                    
                    return ;
                }
            }
            else                            //不使用积分，不选择支付方式
            {
                [UIAlertView alertViewWithMessage:@"请选择支付方式"];
                
                return;
            }
        }
        
        switch (_index)
        {
            case 1:
                type = FNPayTypeWechat;
                if (![WXApi isWXAppInstalled])
                {
                    [UIAlertView alertViewWithMessage:@"您未安装微信客户端，请安装后再试"];
                    
                    return ;
                }
                
                break;
            case 2:
                type = FNPayTypeAlipay;
                if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]])
                {
                    [UIAlertView alertViewWithMessage:@"您未安装支付宝客户端\n请安装后再试"];
                    
                    return;
                }
                break;
            case 3:
                type = FNPayTypeHebao;
                break;
            case 4:
                type = FNPayTypeCMB;
                break;
                
            case 5:
                type = FNPayTypeWing;
                break;
                
            default:
                type = FNPayTypeNone;
                
                break;
        }
        
        __weak __typeof(self) weakSelf = self;
        NSInteger _virtualGoods;
        if (_isVirtualGoods == YES)
        {
            _virtualGoods = 1;
        }
        else
        {
            _virtualGoods = 0;
        }
        
        [FNLoadingView showInView:self.view];
        
        NSDictionary *dict = @{@"orderId":self.orderIds,@"price":self.allPrice,@"isVirtualGoods":@(_virtualGoods),@"isSpecialType":@(_isSpecialType),@"orderType":[NSNumber numberWithInt: self.order.orderType],@"tradeCode":self.tradeCode};
        FNPayInfo =  [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [[FNCartBO port02] payWithOrderList:self.orderIds type:type bonus:bonus cash:cash block:^(id result) {
            
            [FNLoadingView hideFromView:self.view];
            
            if ([result[@"code"] integerValue] != 200)
            {
                if(result)
                {
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
                
                return ;
            }
            
            if (type == FNPayTypeNone && [result[@"code"] integerValue] == 200)
            {
                if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                {
                    FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                    [self.navigationController pushViewController:szPayFinishVC animated:YES];
                    

                }else
                {
                    FNPayFinishVC *vc = [[FNPayFinishVC alloc] init];
                    
                    if (_isVirtualGoods == YES)
                    {
                        vc.isVirtualGoods = YES;
                    }
                    vc.isSpecialType = self.isSpecialType;
                    vc.orderType = self.order.orderType;
                    vc.bonus = self.allPrice;
                    vc.isFinish = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                return;
            }
            
            if ([result[@"payUrl"] isKindOfClass:[NSDictionary class]])
            {
                _isPayed = YES;
                
                switch (type)
                {
                    case FNPayTypeHebao:
                    {
                        FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:result[@"payUrl"][@"action_submit"]]];
                        
                        vc.title = @"移动和包支付";
                        
                        vc.orderId = [self.orderIds lastObject];
                        
                        vc.isWebPay = YES;
                        
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case FNPayTypeWechat:
                        
                        FNPayVCExtern = self;
                        
                        [FNPayManager payWeChatWithResult:result[@"payUrl"]];
                        
                        break;
                        
                    case FNPayTypeAlipay:
                        
                        FNPayVCExtern = self;
                        
                        [FNPayManager payAliWithResult:result[@"payUrl"]];
                        
                        break;
                        
                    case FNPayTypeCMB:
                    {
                        NSString *action = result[@"action"];
                        
                        if (action)
                        {
                            NSMutableString *string = [NSMutableString string];
                            
                            for (NSString *key in result[@"payUrl"])
                            {
                                [string appendString:key];
                                [string appendString:@"="];
                                [string appendString:result[@"payUrl"][key]];
                            }
                            
                            NSData *body = [string dataUsingEncoding:NSUTF8StringEncoding];
                            
                            FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:action] body:body];
                            
                            vc.title = @"招商银行";
                            
                            vc.orderId = [self.orderIds lastObject];
                            
                            vc.isWebPay = YES;
                            
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }
                    }
                        break;
                    case FNPayTypeWing:
                        
                        break;
                        
                    default:
                        break;
                }
            }else
            {
                if (type == FNPayTypeWing)
                {
                    NSString *orderStr = result[@"payUrl"];
                    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
                    NSArray *urls = [dic objectForKey:@"CFBundleURLTypes"];
                    BestpayNativeModel *order = [[BestpayNativeModel alloc]init];
                    order.orderInfo = orderStr;
                    order.launchType = launchTypePay1;
                    order.scheme = [[[urls firstObject] objectForKey:@"CFBundleURLSchemes"] lastObject];
                    
                    //调用sdk的方法
                    [BestpaySDK payWithOrder:order fromViewController:self callback:^(NSDictionary *resultDic) {
                        //支付成功后回调结果
                        if ([resultDic[@"resultCode"] isEqualToString:@"00"])
                        {
                            if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
                            {
                                FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
                                [self.navigationController pushViewController:szPayFinishVC animated:YES];
                                
                            }else
                            {
                                
                                FNPayFinishVC * finish = [[FNPayFinishVC alloc]init];
                                finish.orderType = [FNPayInfo[@"orderType"] intValue];
                                finish.isFinish = YES;
                                
                                finish.bonus = FNPayInfo[@"price"];
                                finish.isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
                                finish.isVirtual = FNPayInfo[@"isVirtualGoods"];// == 1 虚拟
                                
                                if ([finish.isVirtual intValue]== 1)
                                {
                                    finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                                }
                                else
                                {
                                    finish.isVirtualGoods = [FNPayInfo[@"isVirtualGoods"] boolValue];
                                }
                                FNPayInfo = nil;
                                
                                [self.navigationController pushViewController:finish animated:YES];
                            }
                            
                        }else
                        {
                            [UIAlertView alertViewWithMessage:@"支付已取消"];
                            
                            FNPayInfo = nil;
                            for (UIViewController *vc  in self.navigationController.viewControllers)
                            {
                                NSObject *root = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
                                
                                if ([root isKindOfClass:[FNTabBarVC class]])
                                {
                                    FNTabBarVC *tab = (FNTabBarVC *)root;
                                    
                                    [tab goTabIndex:3];
                                    
                                    UINavigationController *my = [tab selectedViewController];
                                    
                                    FNOrderVC *order = [[FNOrderVC alloc]init];
                                    order.stateTag = FNTitleTypeOrderStatePaying;
                                    [my pushViewController:order animated:NO];
                                    
                                }
                                return;
                                
                            }
                        }
                        
                        
                    }];
                    
                    
                }
                
            }
        }];
    }];
    
    [self.tableView reloadData];
    
}

- (void)isSwitchEnable
{
    [self initHeader];
    [self selectPayChannelIndex:0];
    
    if (_allBonus <= 0 && _curBonus <= 0)
    {
        _header.switchBut.on = NO;
        
        _header.switchBut.enabled = NO;
        
    }
    else
    {
        if (_curBonus>0)
        {
            _header.switchBut.on = YES;
            
            _header.switchBut.enabled = NO;
            
            
        }
        else
        {
            _header.switchBut.on = YES;
            
            _header.switchBut.enabled = YES;
            
        }
    }
    
    
    [self.tableView reloadData];
}

- (void)goBack
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:@"只差一步完成购买" delegate:self cancelButtonTitle:@"待会再买" otherButtonTitles:@"继续付款", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        for (UIViewController *vc  in self.navigationController.viewControllers)
        {
            NSObject *root = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
            
            if ([root isKindOfClass:[FNTabBarVC class]])
            {
                FNTabBarVC *tab = (FNTabBarVC *)root;
                
                [tab goTabIndex:3];
                
                UINavigationController *my = [tab selectedViewController];
                FNOrderVC *order = [[FNOrderVC alloc]init];
                
                order.stateTag = FNTitleTypeOrderStatePaying;
                [my pushViewController:order animated:NO];
                
            }
            return;
            
        }
    }
}


- (void)initHeader
{
    if (!_header)
    {
        _header = [[FNPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 185)];
        _header.isSpecialType = self.isSpecialType ;
        self.tableView.tableHeaderView = _header;
    }
    
    _header.price =  [NSDecimalNumber decimalNumberWithString:self.allPrice];
    
    _header.bonus = _curBonus ? _curBonus : _allBonus;
    
    __weak __typeof(self) weakSelf = self;
    
    [_header switchStateBlock:^(UISwitch *sender) {
        
        [weakSelf.tableView reloadData];
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE_5)
    {
        return 54;
    }
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNPayCell *cell = [FNPayCell dequeueReusableWithTableView:tableView];
    
    FNPayWayArgs *arg = _array[indexPath.row];
    
    if ([_selectedSet containsObject:arg])
    {
        cell.checkView.image = [UIImage imageNamed:@"pay_check_s"];
        
        if (!_header.switchBut.on)
        {
            _index = indexPath.row + 1;
        }
        else
        {
            if (_header.bonus > [[NSString stringWithFormat:@"%.2f",([self.allPrice floatValue] * 100)] floatValue])
            {
                _index = 0; //更改开关状态，把支付渠道设为默认
            }
            else
            {
                _index = indexPath.row + 1;
            }
        }
    }
    else
    {
        cell.checkView.image = [UIImage imageNamed:@"pay_check_n"];
    }
    
    [cell setPay:arg];
    
    
    if (_header.switchBut.on && [[NSString stringWithFormat:@"%.2f",_header.bonus/100.0] floatValue] >= [_header.price floatValue])
    {
        cell.checkView.hidden = YES;
    }
    else
    {
        cell.checkView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_header.switchBut.on && [[NSString stringWithFormat:@"%.2f",_header.bonus/100.0] floatValue] >= [_header.price floatValue])
    {
        return;
    }
    
    [self selectPayChannelIndex:indexPath.row];
    
    [tableView reloadData];
}

- (void)selectPayChannelIndex:(NSInteger)index
{
    _index = index + 1;
    
    FNPayWayArgs *arg = _array[index];
    
    [_selectedSet removeAllObjects];
    
    if (![_selectedSet containsObject:arg])
    {
        [_selectedSet addObject:arg];
    }
}

- (void)dealloc
{
    FNLoginIsScan = NO;
}


@end
