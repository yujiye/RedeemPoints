//
//  FNSZDetailVC.m
//  BonusStore
//
//  Created by cindy on 2017/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZDetailVC.h"
#import "FNHeader.h"
#import "Mask.h"
@interface FNSZDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_stateBtn;
    OrderObject *_order;
}
@property(nonatomic, strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * tipArr; //
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UIButton * doneBtn;
@property (nonatomic,strong)UILabel  * tipLab;
@property (nonatomic,strong)UILabel  * refundLab;

@end

@implementation FNSZDetailVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    OrderReq *orderReq  = [OrderReq new];
    orderReq.token = FNUserAccountInfo[@"token"];
    orderReq.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
    NSDictionary * user = [FNUserAccountArgs getUserAccount];
    orderReq.phoneNo =  [NSString stringWithFormat:@"%@", [user valueForKey:@"mobile"]];
    orderReq.orderNo = self.orderno;
    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
    [[OrderAPI sharedManager]requestOrderDetail:orderReq success:^(RequestResult *requestResult) {
        
        if (requestResult.status == 0){
            _order = [OrderObject parseObject:nil from:requestResult.resultInfo cover:NO];
            switch ([_order.orderStatus intValue]) {
                case FNSZRechargeStateFail:
                {
                    [_stateBtn setTitle:@"  充值失败" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_cancel"] forState:UIControlStateNormal];
                    _doneBtn.hidden = NO;
                    [_doneBtn setTitle:@"再次充值" forState:UIControlStateNormal];
                    _tipLab.hidden = NO;
                    _refundLab.hidden = NO;
                }
                    break;
                case FNSZRechargeStateUnusual:
                {
                    [_stateBtn setTitle:@"  订单异常" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_cancel"] forState:UIControlStateNormal];
                    _doneBtn.hidden = NO;
                    [_doneBtn setTitle:@"验卡" forState:UIControlStateNormal];
                    _tipLab.hidden = YES;
                    _refundLab.hidden = YES;
                }
                    break;
                case FNSZRechargeStateOrderCancel:
                {
                    [_stateBtn setTitle:@"  订单取消" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_success"] forState:UIControlStateNormal];
                    _doneBtn.hidden = YES;
                    _tipLab.hidden = YES;
                    _refundLab.hidden = YES;
                }
                    break;
                case FNSZRechargeStateSuccess:
                {
                    [_stateBtn setTitle:@"  充值成功" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_success"] forState:UIControlStateNormal];
                }
                    
                    break;
                case FNSZRechargeStatePaySuc:
                {
                    [_stateBtn setTitle:@"  待充值" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_cancel"] forState:UIControlStateNormal];
                    _doneBtn.hidden = NO;
                    _tipLab.hidden = NO;
                    _refundLab.hidden = NO;
                }
                    
                    break;
                    
                case FNSZRechargeStateRefundIn:
                {
                    [_stateBtn setTitle:@"  退券中" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_refundIn"] forState:UIControlStateNormal];
                }
                    
                    break;
                case FNSZRechargeStateRefundDone:
                {
                    [_stateBtn setTitle:@"  退券成功" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_success"] forState:UIControlStateNormal];
                    
                }
                    break;
                    
                default:
                    break;
            }
            self.dataArr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%.2f元",[_order.orderMoney intValue]/100.0] , _order.orderNo,_order.sztCardNo,@"深圳通普卡",[NSString stringWithFormat:@"%.2f元",[_order.voucherMoney intValue]/100.0],_order.orderTime,nil];
            [Mask HUDHideInView:self.view];
            if (_overRecharge)
            {
                [self.view makeToast:@"单张深圳通每天仅限充值3次"];

            }
            [self.tableView reloadData];
            
        }else
        {
            [Mask HUDHideInView:self.view];
            [self.view makeToast:@"查询详情失败"];
            _refundLab.hidden = YES;
            _doneBtn.hidden = YES;
            
        }
        
    } failure:^(RequestResult *requestResult) {
        [Mask HUDHideInView:self.view];
        [self.view makeToast:@"查询详情失败"];
        _refundLab.hidden = YES;
        _doneBtn.hidden = YES;
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
    self.title = @"订单详情";
    [self setNavigaitionBackItem];
    [self addAndLayoutSubViews];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.tipArr = [NSMutableArray arrayWithObjects:@"充值金额:",@"订单编号:",@"充值卡号:",@"深圳通类型:",@"抵用券支付:",@"下单时间:" ,nil];
    [self.view addSubview:self.tableView];
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tipArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"identifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorWith0xRGB(0x4A4A4A);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row ==0)
    {
        cell.detailTextLabel.textColor = UIColorWith0xRGB(0xEF3030);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        cell.detailTextLabel.textColor = UIColorWith0xRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    cell.textLabel.text = self.tipArr[indexPath.row];
    cell.detailTextLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (UITableView *)tableView
{
    if (_tableView ==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,90 + 44 * self.tipArr.count) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        _stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stateBtn.frame = CGRectMake(0, 0, kScreenWidth, 80);
        [_stateBtn setTitleColor:UIColorWith0xRGB(0x666666) forState:UIControlStateNormal];
        _stateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _stateBtn.enabled = NO;
        [headView addSubview:_stateBtn];
        UILabel * backLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, kScreenWidth, 10)];
        backLab.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        [headView addSubview:backLab];
        _tableView.tableHeaderView = headView;
        
    }
    return _tableView;
}
//重新支付
- (void)reBuyBtnclick:(UIButton *)btn
{
    btn.enabled = NO;

    if([_order.orderStatus intValue] == FNSZRechargeStateUnusual)
    {
        // 验卡
        FNSZBLSearchListVC  *myOderVC = [[FNSZBLSearchListVC alloc]init];
        myOderVC.stateEntry = FNSZStateEntryCheckCard;
        myOderVC.moneyAmount = _order.orderMoney;
        myOderVC.orderno = self.orderno;
        btn.enabled = YES;
        [self.navigationController pushViewController:myOderVC animated:YES];
    }else
    {
    
    OrderReq *orderRep = [OrderReq new];
    orderRep.orderMoney = _order.orderMoney;
    orderRep.orderNo = self.orderno;
    NSDictionary * user = [FNUserAccountArgs getUserAccount];
    orderRep.phoneNo = [NSString stringWithFormat:@"%@" , [user valueForKey:@"mobile"]];
    orderRep.token = [NSString stringWithFormat:@"%@" , FNUserAccountInfo[@"token"]];
    orderRep.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
    orderRep.voucherId = [NSString stringWithFormat:@"%@" , _order.voucherId];
    orderRep.voucherMoney = _order.voucherMoney;
    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
    [[OrderAPI sharedManager] toPayOrder:orderRep success:^(RequestResult *requestResult) {
        btn.enabled = YES;

        [Mask HUDHideInView:self.view];

        FNSZBLSearchListVC *myOderVC = [[FNSZBLSearchListVC alloc]init];
        myOderVC.stateEntry = FNSZStateEntryDetail;
        myOderVC.moneyAmount = _order.orderMoney;
        myOderVC.orderno = self.orderno;
        [self.navigationController pushViewController:myOderVC animated:YES];
        
    } failure:^(RequestResult *requestResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.enabled = YES;
            [Mask HUDHideInView:self.view];
        });
    }];
    }
    
   
}
// 申请退款
- (void)applyForRefundClick:(id)sender
{
    [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"您确定要退回当前充值券" cancelTitle:@"是的" actionBlock:^(NSInteger bIndex) {
        
        if (bIndex == 0)
        {

            OrderReq *orderRep = [[OrderReq alloc] init];
            orderRep.orderNo =  _order.orderNo;
            NSDictionary * user = [FNUserAccountArgs getUserAccount];
            orderRep.phoneNo = [NSString stringWithFormat:@"%@" , [user valueForKey:@"mobile"]];
            orderRep.token = [NSString stringWithFormat:@"%@" , FNUserAccountInfo[@"token"]];
            orderRep.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
            [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
            [[OrderAPI sharedManager] requestRefundOrder:orderRep success:^(RequestResult *requestResult) {
                [Mask HUDHideInView:self.view];
                if (requestResult.status ==0)
                {
                    [_stateBtn setTitle:@"  退券成功" forState:UIControlStateNormal];
                    [_stateBtn setImage:[UIImage imageNamed:@"sz_success"] forState:UIControlStateNormal];
                    _doneBtn.hidden = YES;
                    _tipLab.hidden = YES;
                    _refundLab.hidden = YES;

                }else
                {
                    [self.view makeToast:@"退款失败"];
                }
            }];
        }
        
    } otherTitle:@"取消", nil];
   
}
- (void)addAndLayoutSubViews
{
    _tipLab = [[UILabel alloc]initWithFrame:CGRectMake(15, kScreenHeight -45-15-64, kScreenWidth -30, 45)];
    _tipLab.hidden = YES;
    _tipLab.numberOfLines = 0;
    _tipLab.text = @"温馨提示:\n有效期内的充值券,退券后将自动返还至深圳通充值页\n已过有效期充值券,退券后该券将不再显示";
    _tipLab.textColor = UIColorWith0xRGB(0x666666);
    _tipLab.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_tipLab];
    
    CGFloat needHeight = CGRectGetMinY(_tipLab.frame) - 44*6-90;
    CGFloat marginY1 = 15;
    if (IS_IPHONE_5)
    {
        marginY1 = 5;
    }
    CGFloat marginY =  (needHeight - 44-14 -5)*0.5;
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.backgroundColor = UIColorWith0xRGB(0xEF3030);
    [_doneBtn setTitle:@"充值" forState:UIControlStateNormal];
    _doneBtn.frame = CGRectMake(15, 44*6+90+marginY, kScreenWidth -30, 44);
    [_doneBtn addTarget:self action:@selector(reBuyBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.titleLabel.font = [UIFont fzltWithSize:16];
    _doneBtn.layer.cornerRadius = 4;
    _doneBtn.layer.masksToBounds = YES;
    _doneBtn.hidden = YES;
    [self.view addSubview:_doneBtn];
    _refundLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 44*6+90+marginY+44+marginY1, kScreenWidth -30, 14)];
    _refundLab.hidden = YES;
    _refundLab.textAlignment = NSTextAlignmentCenter;
    _refundLab.textColor = UIColorWith0xRGB(0x898989);
    _refundLab.font = [UIFont systemFontOfSize:12];
    _refundLab.text = @"重试不需要再次付款,或申请退款";
    NSMutableAttributedString *refundStr = [_refundLab.text  makeStr:@"申请退款" withColor: UIColorWith0xRGB(0xEF3030) andFont:[UIFont systemFontOfSize:14]];
    _refundLab.attributedText = refundStr;
    [_refundLab addTarget:self action:@selector(applyForRefundClick:)];
    [self.view addSubview:_refundLab];
}

- (void)goBack
{
    if (self.stateEntry == FNSZStateEntryDetail)
    {
        FNReChargeOrderVC *rechargeVC = [[FNReChargeOrderVC alloc]init];
        [self.navigationController pushViewController:rechargeVC animated:YES];
        
    }else
    {
        
        for (NSInteger i = 0; i <self.navigationController.viewControllers.count; i++) {
            UIViewController *VC = self.navigationController.viewControllers[i];
            
        if ([VC isKindOfClass:[FNShowCouponVC class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KRemoveTestPIc" object:nil userInfo:@{@"position":@(i)}];
                [self.navigationController popToViewController:VC animated:NO];
                return;
            }
        }
        

    }
    
}

@end
