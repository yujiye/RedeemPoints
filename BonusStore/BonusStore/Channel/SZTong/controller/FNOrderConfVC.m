//
//  FNOrderConfVC.m
//  BonusStore
//
//  Created by cindy on 2017/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNOrderConfVC.h"
#import "FNHeader.h"
#import "Mask.h"
@interface FNOrderConfVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UIButton *_payBtn;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray * choiceArr;
@property (nonatomic,strong)FNSZOrderModel *selectedModel;

@end

@implementation FNOrderConfVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支付订单";
    [self setNavigaitionBackItem];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.choiceArr = [NSMutableArray array];
    [self addheadView];
    [self.view addSubview:self.tableView];
    [self addPayButton];
    _payBtn.enabled = NO;
    OrderReq *orderReq  = [OrderReq new];
    orderReq.token = FNUserAccountInfo[@"token"];
    orderReq.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
    NSDictionary * user = [FNUserAccountArgs getUserAccount];
    orderReq.phoneNo =  [NSString stringWithFormat:@"%@", [user valueForKey:@"mobile"]];
    orderReq.orderNo = self.orderno;
    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
    [[OrderAPI sharedManager]getVoucherList:orderReq success:^(RequestResult *requestResult) {
        [Mask HUDHideInView:self.view];

        if (requestResult.status == 0)
        {
            if(![requestResult.results isKindOfClass:[NSNull class]])
            {
                for (NSDictionary * dict in requestResult.results )
                {
                    [self.choiceArr addObject:[FNSZOrderModel mj_objectWithKeyValues:dict]];
                }
                if (self.choiceArr.count >0)
                {
                  FNSZOrderModel*model = self.choiceArr.firstObject;
                  model.hadChoice = YES;
                self.selectedModel = model;
                }
                _payBtn.enabled = YES;
                [self.tableView reloadData];
            }
        }
    } failure:^(RequestResult *requestResult) {
        [Mask HUDHideInView:self.view];
        [self.view makeToast:@"加载详情失败"];
        _payBtn.enabled = NO;

    }];
}
- (void)addheadView
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 112)];
    UIImageView * imgView =[[UIImageView alloc]initWithFrame:CGRectMake(33, (112-76)*0.5, 76, 76)];
    imgView.layer.borderColor = UIColorWith0xRGB(0xDCDADA).CGColor;
    imgView.layer.borderWidth = 1;
    imgView.layer.masksToBounds = YES;
    imgView.layer.cornerRadius = 76*0.5;
    imgView.image =[UIImage imageNamed:@"showCoupon_order_cof"];
    [headView addSubview:imgView];
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(148, 36, kScreenWidth -148-15, 18)];
    moneyLabel.textColor = UIColorWith0xRGB(0xEF3030);
    moneyLabel.font = [UIFont systemFontOfSize:18];
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.money intValue]/100.0];
    [headView addSubview:moneyLabel];
    
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(148, 58, kScreenWidth -148-15, 22)];
    tipLabel.textColor = UIColorWith0xRGB(0x4A4A4A);
    tipLabel.font = [UIFont systemFontOfSize:18];
    tipLabel.text = @" 深圳通充值";
    [headView addSubview:tipLabel];
    [self.view addSubview:headView];
}
//充值
- (void)payBtnClick
{
    OrderReq *orderRep = [OrderReq new];
    orderRep.orderMoney = self.money;
    orderRep.orderNo = self.orderno;
    NSDictionary * user = [FNUserAccountArgs getUserAccount];
    orderRep.phoneNo = [NSString stringWithFormat:@"%@" , [user valueForKey:@"mobile"]];
    orderRep.token = [NSString stringWithFormat:@"%@" , FNUserAccountInfo[@"token"]];
    orderRep.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
    orderRep.voucherId = [NSString stringWithFormat:@"%@" , self.selectedModel.mcId];
    orderRep.voucherMoney = self.money;
    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];

    [[OrderAPI sharedManager] toPayOrder:orderRep success:^(RequestResult *requestResult) {
        [Mask HUDHideInView:self.view];

        FNSZBLSearchListVC *myOderVC = [[FNSZBLSearchListVC alloc]init];
        myOderVC.stateEntry = FNSZStateEntryRecharge;
        myOderVC.moneyAmount = self.money;
        myOderVC.orderno = self.orderno;
        [self.navigationController pushViewController:myOderVC animated:YES];

    } failure:^(RequestResult *requestResult) {
        [Mask HUDHideInView:self.view];
    }];

}
- (void)addPayButton
{
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.backgroundColor = UIColorWith0xRGB(0xEF3030);
    _payBtn.enabled = NO;
    [_payBtn setTitle:@"充值" forState:UIControlStateNormal];
    _payBtn.frame = CGRectMake(15, kScreenHeight -64-44 -10, kScreenWidth -30, 44);
    [_payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _payBtn.titleLabel.font = [UIFont fzltWithSize:18];
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    [self.view addSubview:_payBtn];

}

- (UITableView *)tableView
{
    if (_tableView ==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 112, kScreenWidth,kScreenHeight-64 -44-112 -10) style:UITableViewStyleGrouped];
       _tableView.delegate = self;
       _tableView.dataSource = self;
       _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView =[[UIView alloc]init];
        _tableView.showsVerticalScrollIndicator = NO;
       _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moneyCount.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNSZOrderConfCell *szOrderConfCell  =[FNSZOrderConfCell szOrderConfCellWithTableView:tableView];
  
    if (self.choiceArr.count != 0)
    {
     FNSZOrderModel * szOrderModel =  self.choiceArr[indexPath.row];
        NSArray * arr = [szOrderModel.couponEndDate componentsSeparatedByString:@" "];
        if (![NSString isEmptyString:arr.firstObject])
        {
         szOrderConfCell.timeLabel.text = [NSString stringWithFormat:@"有效期至%@",arr.firstObject];
        }
        if (szOrderModel.hadChoice )
        {
            szOrderConfCell.imgView.image = [UIImage imageNamed:@"order_sz_selected"];
        }else
        {
            szOrderConfCell.imgView.image = [UIImage imageNamed:@"order_sz_noselected"];
            
        }
    }
    szOrderConfCell.moneyLab.text = [NSString stringWithFormat:@"%d元",[self.money intValue]/100];
    return szOrderConfCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    for (FNSZOrderModel * model in self.choiceArr)
    {
        model.hadChoice = NO;
    }
    FNSZOrderModel * seleModel =  self.choiceArr[indexPath.row];
    
    seleModel.hadChoice = YES;
    
    self.selectedModel = seleModel;
    
    [self.tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    UILabel * backLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    backLab.backgroundColor = UIColorWith0xRGB(0xDCDADA);
    [sectionView addSubview:backLab];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth-30, 44)];
    label.textColor = UIColorWith0xRGB(0x666666);
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"请选择充值券";
    [sectionView addSubview:label];
    return sectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@interface FNSZOrderConfCell ()


@end
@implementation FNSZOrderConfCell


+ (instancetype)szOrderConfCellWithTableView:(UITableView *) tableView
{
    NSString *reuserId = NSStringFromClass([self class]);
    FNSZOrderConfCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
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
        UIImageView * backView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth -60, 54)];
        backView.image = [UIImage imageNamed:@"order_cell_sz"];
        [self.contentView addSubview:backView];
        
       _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15+30, self.height / 2 - 9, 18, 18)];
        [self.contentView addSubview:_imgView];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right + 15, 12, 80, 14)];
        titLab.textColor = UIColorWith0xRGB(0x4A4A4A);
        titLab.font = [UIFont systemFontOfSize:14.0];
        titLab.text = @"现金充值券";
        [self.contentView addSubview:titLab];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imgView.right + 15, 32, backView.width - 91 - 20, 11)];
        _timeLabel.textColor = UIColorWith0xRGB(0x999999);
        _timeLabel.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_timeLabel];
        
       _moneyLab = [[UILabel alloc] initWithFrame:CGRectMake( backView.width -91 , 0, 91, 54)];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.textColor = UIColorWith0xRGB(0xFFFFFF);
        _moneyLab.font = [UIFont systemFontOfSize:18.0];
        [backView addSubview:_moneyLab];

    }
    return self;
}

@end

@implementation FNSZOrderModel



@end
