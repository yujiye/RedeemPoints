//
//  FNMyOrderVC.m
//  BonusStore
//
//  Created by cindy on 2017/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNMyOrderVC.h"
#import "UIView+Cate.h"
#import "Mask.h"
@interface FNMyOrderVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel * cardLabel ; //卡号
@property (nonatomic,strong) UILabel * stateLabel; //卡的状态
@property (nonatomic,strong)UILabel * restLabel ; // 余额
@property (nonatomic , strong) NSMutableArray *dataArray;

@end

@implementation FNMyOrderVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BluetoothAPI sharedManager] disConnectDevice:_model];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"卡片余额";
    [self setNavigaitionBackItem];
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    headView.backgroundColor = UIColorWith0xRGB(0xFF5858);
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (100-76)*0.5, 76, 76)];
    imgView.image = [UIImage imageNamed:@"showCoupon_order_cof"];
    [headView addSubview:imgView];
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(106, 14, kScreenWidth -106-15, 14)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.text = @"深圳通普卡";
    [headView addSubview:tipLabel];
    
    _cardLabel= [[UILabel alloc]initWithFrame:CGRectMake(106, 34, kScreenWidth -106-15, 14)];
    _cardLabel.textColor = [UIColor whiteColor];
    _cardLabel.font = [UIFont systemFontOfSize:14];
    _cardLabel.text = @"卡号:";
    [headView addSubview:_cardLabel];
    
    _stateLabel= [[UILabel alloc]initWithFrame:CGRectMake(106, CGRectGetMaxY(_cardLabel.frame)+5, kScreenWidth -106-15, 12)];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.font = [UIFont systemFontOfSize:12];
    _stateLabel.text = @"地铁状态:";
    [headView addSubview:_stateLabel];
    _restLabel= [[UILabel alloc]initWithFrame:CGRectMake(106, CGRectGetMaxY(_stateLabel.frame)+5, kScreenWidth -106-15, 14)];
    _restLabel.textColor = [UIColor whiteColor];
    _restLabel.font = [UIFont systemFontOfSize:14];
    _restLabel.text = @"余额:";
    [headView addSubview:_restLabel];
    
    UILabel * backLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 10)];
    backLab.backgroundColor = UIColorWith0xRGB(0xDCDADA);
    [headView addSubview:backLab];
    [self.view addSubview:headView];
    
    [[BluetoothAPI sharedManager] didConnectDevice:_model];
    if ([BluetoothAPI sharedManager].state == CBPeripheralStateConnected)
    {
        [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
        
        [[CardAPI sharedManager]startoffLineChecking:nil success:^(RequestResult *requestResult) {
            
            if (requestResult.status == 4)
            {
                NSArray *list = [requestResult.resultInfo objectForKey:@"recordList"];
                NSString * restMoney =  [requestResult.resultInfo objectForKey:@"overMoney"];
                NSString * cardStatus = [requestResult.resultInfo objectForKey:@"cardStatus"];
                NSString * cardNo = [requestResult.resultInfo objectForKey:@"cardNo"];
                _cardLabel.text =[NSString stringWithFormat:@"卡号：%@",cardNo];
                _stateLabel.text =[NSString stringWithFormat:@"地铁状态：%@",cardStatus];
                _restLabel.text = [NSString stringWithFormat:@"余额:%.2f元",[restMoney intValue]/100.0];
                for (CommonObject * common in list )
                {
                    FNMyOrderModel *model = [[FNMyOrderModel alloc]init];
                    model.szType = FNSZConsumeTypeSell;
                    model.title = common.title;
                    model.content = common.content;
                    model.name = common.name;
                    [self.dataArray addObject:model];
                }
                [Mask HUDHideInView:self.view];
                
                [self.tableView reloadData];
            }else
            {
                [Mask HUDHideInView:self.view];
                
            }
            
        } failure:^(RequestResult *requestResult) {
            [Mask HUDHideInView:self.view];
            
        }];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNMyOrderCell *myOrderCell  =[FNMyOrderCell myOrderCellWithTableView:tableView];
    myOrderCell.myOrderModel = self.dataArray[indexPath.row];
    return myOrderCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (void)goBack
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

- (UITableView *)tableView
{
    if (_tableView ==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, kScreenWidth,kScreenHeight-64-110) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

@end

@implementation FNMyOrderModel



@end

@interface FNMyOrderCell()

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *moneyLab;
@property (nonatomic,strong)UILabel *stateLabel;
@property (nonatomic,strong)UIImageView *stateImg;
@property (nonatomic,strong)UILabel *titLab;
@property (nonatomic,strong)UIImageView *imgView;

@end

@implementation FNMyOrderCell


+ (instancetype)myOrderCellWithTableView:(UITableView *) tableView
{
    NSString *reuserId = NSStringFromClass([self class]);
    FNMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell == nil)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth -7-14, (60-12)*0.5, 7, 12)];
        _imgView.image = [UIImage imageNamed:@"main_rank_more"];
        [self.contentView addSubview:_imgView];
        
        _titLab = [[UILabel alloc] initWithFrame:CGRectMake( 15, 12, 80, 14)];
        _titLab.textColor = UIColorWith0xRGB(0x4A4A4A);
        _titLab.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_titLab];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, kScreenWidth - 15-35-60 , 14)];
        _timeLabel.textColor = UIColorWith0xRGB(0x999999);
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_timeLabel];
        
        _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth -35-100 , 12, 100, 14)];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.textColor = UIColorWith0xRGB(0xEF3030);
        _moneyLab.font = [UIFont systemFontOfSize:18.0];
        [self.contentView  addSubview:_moneyLab];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth -35-60 , 35, 60, 14)];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.textColor = UIColorWith0xRGB(0x666666);
        _stateLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView  addSubview:_stateLabel];
        
        _stateImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_stateLabel.frame)-7, 35+7-3.5, 7, 7)];
        _stateImg.backgroundColor = UIColorWith0xRGB(0xEF3030);
        _stateImg.layer.cornerRadius = 3.5;
        _stateImg.layer.masksToBounds = YES;
        [self.contentView addSubview:_stateImg];
        
    }
    return self;
}

- (void)setMyOrderModel:(FNMyOrderModel *)myOrderModel
{
    _myOrderModel = myOrderModel;
    switch (_myOrderModel.szType) {
        case FNSZConsumeTypeNone:
        {
            _titLab.text = @"充值";
            switch ([_myOrderModel.orderStatus intValue]) {
                case FNSZRechargeStateFail:
                    _stateLabel.text = @"充值失败";
                    break;
                    
                case FNSZRechargeStateUnusual:
                    _stateLabel.text = @"订单异常";
                    break;
                    
                case FNSZRechargeStateOrderCancel:
                    
                    _stateLabel.text = @"订单取消";
                    break;
                    
                case FNSZRechargeStateSuccess:
                    _stateLabel.text = @"充值成功";
                    break;
                case FNSZRechargeStatePaySuc:
                    _stateLabel.text = @"待充值";
                    break;
                    
                case FNSZRechargeStateRefundIn:
                    _stateLabel.text = @"退款中";
                    break;
                case FNSZRechargeStateRefundDone:
                    _stateLabel.text = @"退券成功";
                    break;
                default:
                    break;
            }
            if(_myOrderModel.showIcon == YES)
            {
                // 充值失败，待充值，退券中表示订单未完成
                if ([_myOrderModel.orderStatus intValue] == FNSZRechargeStateFail||[_myOrderModel.orderStatus intValue] ==FNSZRechargeStateRefundIn||[_myOrderModel.orderStatus intValue] ==FNSZRechargeStatePaySuc ||
                    [_myOrderModel.orderStatus intValue] == FNSZRechargeStateUnusual)
                {
                    _stateImg.hidden = NO;
                    
                }else
                {
                    _stateImg.hidden = YES;
                    
                }
            }else
            {
                _stateImg.hidden = YES;
                
            }
            _moneyLab.text = [NSString stringWithFormat:@"%.2f元",[_myOrderModel.payMoney intValue]/100.0];
            NSArray * sepArr = [_myOrderModel.orderTime componentsSeparatedByString:@"."];
            NSString * needStr = sepArr.lastObject;
            if (![NSString isEmptyString:needStr])
            {
                _timeLabel.text = sepArr.firstObject;
            }else
            {
                _timeLabel.text = _myOrderModel.orderTime;
                
            }
            
        }
            break;
        case FNSZConsumeTypeSell:
        {
            _titLab.text = _myOrderModel.name;
            _stateImg.hidden = YES;
            _moneyLab.text = [NSString stringWithFormat:@"%@元",_myOrderModel.content];
            if([_myOrderModel.content rangeOfString:@"-"].location != NSNotFound)
            {
                _moneyLab.textColor = UIColorWith0xRGB(0x9B9B9B);
            }else
            {
                _moneyLab.textColor = UIColorWith0xRGB(0xEF3030);
            }
            _moneyLab.frame = CGRectMake(kScreenWidth -15-100 , 23, 100, 14);
            _imgView.hidden = YES;
            _timeLabel.text = _myOrderModel.title;
            
        }
            break;
            
        default:
            break;
    }
    
}





@end
