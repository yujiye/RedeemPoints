//
//  FNSZSuccessVC.m
//  BonusStore
//
//  Created by cindy on 2017/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZSuccessVC.h"
#import "FNHeader.h"
#import "Mask.h"
@interface FNSZSuccessVC ()<UITableViewDelegate,UITableViewDataSource>
{
    OrderObject *_order;
    UIButton *_finishBtn;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * tipArr;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation FNSZSuccessVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BluetoothAPI sharedManager] disConnectDevice:_model];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
    self.title = @"充值";
    [self setNavigaitionBackItem];
    NSArray *arr  = @[@[@"充值金额:",@"卡片余额:"],@[@"订单编号:",@"充值卡号:",@"深圳通类型:",@"抵用券支付:",@"下单时间:"]];
    self.tipArr = [NSMutableArray arrayWithArray:arr];
    [self.view addSubview:self.tableView];
    
    NSDateFormatter * formatter  =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSArray * contentArr = @[@[[NSString stringWithFormat:@"%.2f元",[self.moneyAmount intValue]/100.0],[NSString stringWithFormat:@"%.2f元",([self.moneyAmount intValue] +[self.beforeRestMoney intValue])/100.0]],@[self.orderNo,self.cardno,@"深圳通普卡",[NSString stringWithFormat:@"%.2f元",[self.moneyAmount intValue]/100.0],nowtimeStr]];
    self.dataArr = [NSMutableArray arrayWithArray:contentArr];
    [self.tableView reloadData];
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.backgroundColor = UIColorWith0xRGB(0xEF3030);
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    _finishBtn.frame = CGRectMake(15, CGRectGetMaxY(self.tableView.frame)+40, kScreenWidth -30, 44);
    [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _finishBtn.titleLabel.font = [UIFont fzltWithSize:18];
    _finishBtn.layer.cornerRadius = 4;
    _finishBtn.layer.masksToBounds = YES;
    [self.view addSubview:_finishBtn];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

//完成
- (void)finishBtnClick:(UIButton *)btn
{
    FNReChargeOrderVC *reChargeVC = [[FNReChargeOrderVC alloc]init];
    [self.navigationController pushViewController:reChargeVC animated:YES];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tipArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr =  self.tipArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = UIColorWith0xRGB(0x4A4A4A);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if(indexPath.section ==0)
    {
        cell.detailTextLabel.textColor = UIColorWith0xRGB(0xEF3030);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    }else
    {
        cell.detailTextLabel.textColor = UIColorWith0xRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
   
    NSArray * titleArr = self.tipArr[indexPath.section];
    cell.textLabel.text = titleArr[indexPath.row];
    NSArray * showArr  = self.dataArr[indexPath.section];
    if (![NSString isEmptyString:showArr[indexPath.row]])
    {
      cell.detailTextLabel.text = showArr[indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headView.backgroundColor = UIColorWith0xRGB(0xDCDADA);
    return headView;
}

- (UITableView *)tableView
{
    if (_tableView ==nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,44*7+20+88) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        UIButton *stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        stateBtn.frame = CGRectMake(0, 0, kScreenWidth, 88);
        [stateBtn setTitleColor:UIColorWith0xRGB(0x333333) forState:UIControlStateNormal];
        stateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [stateBtn setImage:[UIImage imageNamed:@"success_sz"] forState:UIControlStateNormal];
        [stateBtn setTitle:@"    充值成功了哟~" forState:UIControlStateNormal];
        _tableView.tableHeaderView = stateBtn;
        
    }
    return _tableView;
}

-(void)goBack
{
    FNReChargeOrderVC *reChargeVC  = [[FNReChargeOrderVC alloc]init];
    [self.navigationController pushViewController:reChargeVC animated:YES];
}
@end
