//
//  FNSZBLSearchListVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/25.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZBLSearchListVC.h"
#import "FNSZBLCell.h"
#import "Mask.h"

@interface FNSZBLSearchListVC ()<UITableViewDelegate, UITableViewDataSource >
{
    UITableView *_tableView;
    
    NSMutableArray *_array;
    
    FNButton *_searchBut;
    
    UIImageView *_blueToothView;
    
    UIView *_headerView;
    
    UIView *_footerView;
    
    UILabel *_failedLabel;
    
    NSInteger _allSection;
    
}

@end

@implementation FNSZBLSearchListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([CentralManager sharedManager].cbcm.state != CBCentralManagerStatePoweredOn)
    {
        
    }
    [self setNavigaitionBackItem];
    
    [self setNavigaitionSZTHelpItem];
    
    self.title = @"搜蓝牙设备";
    
    _array = [[NSMutableArray alloc] init];
    
    [self setBeginUI];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)beginSearch
{
    
    _searchBut.enabled = NO;
    [_searchBut setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
    if ([CentralManager sharedManager].cbcm.state != CBCentralManagerStatePoweredOn) {
        [UIAlertView alertWithTitle:@"提示" message:@"打开蓝牙来允许“聚分享”连接到蓝牙盒子" cancelTitle:@"取消" actionBlock:^(NSInteger bIndex) {
            _searchBut.enabled = YES;
            if (bIndex == 1) {
                NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        } otherTitle:@"确定", nil];
    }else{
        
        _failedLabel.hidden = YES;
        _allSection = 8;
        [self performSelector:@selector(timeDown) withObject:nil afterDelay:1.0];
        _blueToothView.frame = CGRectMake((SCREEN_WIDTH - 125) / 2, 60, 125, 44);
        _blueToothView.image = [UIImage imageNamed:@"szt_bluetooth_search"];
        UIReframeWithY(_searchBut, _blueToothView.bottom + 80);
        _array = [NSMutableArray array];
        
        [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在连接蓝牙盒子,请稍后..." AndDetailsLabelText:nil AndDimBackground:NO];
        
        [[BluetoothAPI sharedManager] startScan:^(RequestResult *result) {
            
          
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeDown) object:nil];

            _array = (NSMutableArray *)result.results;
            _array = [self deleteSameObj:_array];
            if (_array.count > 1) {
                NSLog(@"...");
            }
            
                    dispatch_async(dispatch_get_main_queue(), ^{
            
                        [Mask HUDHideInView:self.view];
                        
                        _searchBut.hidden = YES;
            
                        _blueToothView.hidden = YES;
                        
                        _failedLabel.hidden = YES;
                        
                        _searchBut.enabled = YES;
                        
                        [self setResultUI];
                        
                        [_tableView reloadData];
                        
                    });

        }];

    }

}

- (void)timeDown
{
    if(_allSection < 2)
    {
      [Mask HUDHideInView:self.view];
      [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeDown) object:nil];
        [FNLoadingView hide];
        [self setFailedUI];
        return;
    }
    _allSection--;
    [self performSelector:@selector(timeDown) withObject:nil afterDelay:1.0];

}

- (void)setBeginUI
{
    _blueToothView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 125) / 2, 60, 125, 44)];
    
    _blueToothView.image = [UIImage imageNamed:@"szt_bluetooth_search"];
    
    [self.view addSubview:_blueToothView];
    
    _searchBut = [FNButton buttonWithType:FNButtonTypePlain title:@"搜索蓝牙设备"];
    
    _searchBut.backgroundColor = UIColorWith0xRGB(0xEF3030);
    
    _searchBut.frame = CGRectMake(15, _blueToothView.bottom + 80, kWindowWidth-30, 45);
    
    [_searchBut setCorner:5];
    
    _searchBut.titleLabel.font = [UIFont fzltBoldWithSize:16];
    
    [_searchBut addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_searchBut];
}

- (void)setResultUI
{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        
        _headerView  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
        
        _headerView.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        
        _tableView.tableHeaderView = _headerView;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 12, 100, 14)];
        
        titleLabel.text = @"发现新设备";
        
        titleLabel.textColor = UIColorWith0xRGB(0x333333);
        
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        [_headerView addSubview:titleLabel];
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        
        _footerView.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, kScreenWidth - 60, 12)];
        
        titleLabel.text = @"选择设备进行深圳通充值";
        
        titleLabel.textColor = UIColorWith0xRGB(0x999999);
        
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [_footerView addSubview:titleLabel];
        
        UIButton *reSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        reSearchBtn.frame = CGRectMake(15, titleLabel.bottom + 44, kScreenWidth - 30, 45);
        
        reSearchBtn.backgroundColor = UIColorWith0xRGB(0xEF3030);
        
        [reSearchBtn setTitle:@"重新搜索" forState:UIControlStateNormal];
        
        reSearchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        [reSearchBtn setCorner:6.0];
        
        [reSearchBtn addTarget:self action:@selector(research:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:reSearchBtn];
        
        _tableView.tableFooterView = _footerView;
        
        [self.view addSubview:_tableView];
        
    }
    
    _tableView.hidden = NO;
    
}

- (void)research:(UIButton *)sender
{
    
    [_searchBut setTitle:@"搜索蓝牙设备" forState:UIControlStateNormal];
    dispatch_async(dispatch_get_main_queue(), ^{
        _failedLabel.hidden = YES;
        
    });
    if ([CentralManager sharedManager].cbcm.state != CBCentralManagerStatePoweredOn) {
        [UIAlertView alertWithTitle:@"提示" message:@"打开蓝牙来允许“聚分享”连接到蓝牙盒子" cancelTitle:@"取消" actionBlock:^(NSInteger bIndex) {
            _searchBut.enabled = YES;
            if (bIndex == 1) {
                NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        } otherTitle:@"确定", nil];
    }else{
        
        [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在连接蓝牙盒子,请稍后..." AndDetailsLabelText:nil AndDimBackground:NO];
        _allSection = 8;
        [self performSelector:@selector(timeDown) withObject:nil afterDelay:1.0];
        
        [[BluetoothAPI sharedManager] startScan:^(RequestResult *result) {
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeDown) object:nil];
            
            _array = (NSMutableArray *)result.results;
            
            _array = [self deleteSameObj:_array];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Mask HUDHideInView:self.view];
                
                [_tableView reloadData];
                
                sender.enabled = YES;
                
            });
            
        }];
        
    }
}

- (void)setFailedUI
{
    CGRect rect = CGRectMake((kScreenWidth - 80) / 2, 97, 80, 80);
    _blueToothView.image = [UIImage imageNamed:@"szt_search_faield"];
    _blueToothView.frame = rect;
    if (!_failedLabel) {
        _failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _blueToothView.bottom + 16, kScreenWidth, 55)];
        [self.view addSubview:_failedLabel];
    }
    _tableView.hidden = YES;
    _blueToothView.hidden = NO;
    _failedLabel.hidden = NO;
    _searchBut.hidden = NO;
    _failedLabel.numberOfLines = 0;
    _failedLabel.text = @"很抱歉,搜索失败\n未搜索到蓝牙盒子,请确保设备已开启";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_failedLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _failedLabel.text.length)];
    _failedLabel.attributedText = attributedString;
    _failedLabel.textAlignment = NSTextAlignmentCenter;
    _failedLabel.font = [UIFont systemFontOfSize:14.0];
    _failedLabel.textColor = UIColorWith0xRGB(0x333333);
    _searchBut.enabled = YES;
    [_searchBut setTitle:@"重新搜索" forState:UIControlStateNormal];
    UIReframeWithY(_searchBut, _failedLabel.bottom + 68);
}
    
    
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNSZBLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];

    if (cell == nil) {
        
        cell = [[FNSZBLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
        
    }
    
    CBPeripheral *model = _array[indexPath.row];
    
    cell.nameLael.text = model.name;

    cell.identiferLabel.text = [NSString stringWithFormat:@"%@" , model.identifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *model = _array[indexPath.row];
    
    if (_stateEntry == FNSZStateEntryRecharge||_stateEntry ==FNSZStateEntryDetail || _stateEntry == FNSZStateEntryCheckCard) {
        
        FNSZBLRechargeVC *vc = [[FNSZBLRechargeVC alloc] init];
        
        vc.stateEntry = self.stateEntry;
        
        vc.model = model;
        
        vc.orderno = _orderno;
        
        vc.moneyAmount = _moneyAmount;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (_stateEntry == FNSZStateEntryBalance  ){
        
        FNSZBLRechargeVC *vc = [[FNSZBLRechargeVC alloc] init];
        
        vc.model = model;
        
        vc.stateEntry = self.stateEntry;

        vc.orderno = _orderno;
        
        vc.moneyAmount = _moneyAmount;

        vc.path = @"path";
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)goBack
{
    if (self.stateEntry == FNSZStateEntryDetail || self.stateEntry ==FNSZStateEntryCheckCard)
    {
        for (NSInteger i = 0; i <self.navigationController.viewControllers.count; i++) {
            UIViewController *VC = self.navigationController.viewControllers[i];
            
            if ([VC isKindOfClass:[FNSZDetailVC class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KRemoveTestPIc" object:nil userInfo:@{@"position":@(i)}];
                [self.navigationController popToViewController:VC animated:NO];
                return;
            }
        }
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

- (NSMutableArray *)deleteSameObj:(NSArray *)array
{
    NSMutableArray *idtiArray = [NSMutableArray array];
    NSMutableArray *modelArray = [NSMutableArray array];
    for (CBPeripheral *model in array) {
        if ([idtiArray containsObject:model.identifier]) {
            
        }else{
            [modelArray addObject:model];
            [idtiArray addObject:model.identifier];
        }
    }
    return modelArray;
}

@end
