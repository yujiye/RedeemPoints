//
//  FNBonusRechargeVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/8/4.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusRechargeVC.h"
#import "FNHeader.h"
#import "FNBonusBO.h"
#import "FNLoginBO.h"
@interface FNBonusRechargeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton *_rechargeBtn;
    BOOL _isRechargeVC;
}
@property (nonatomic, strong)FNBonusRechargeView *bonusRechargeView;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign)NSInteger bonusTotal;

@end

@implementation FNBonusRechargeVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FNLoadingView showInView:self.view];
    
    [[FNBonusBO port02] getBonusWithBlock:^(id result) {
        
        [FNLoadingView hideFromView:self.view];
        
        if ([result[@"code"] integerValue] != 200)
        {
            return ;
        }
        _bonusTotal = [result[@"amount"] integerValue];
        
        [_tableView reloadData];
    }];
    
    if (_isRechargeVC == YES)
    {
        _bonusRechargeView.cardNumText.text = nil;
        _bonusRechargeView.cardPassText.text = nil;
    }
    _bonusRechargeView.rechargeBtn.enabled = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    self.title = @"积分充值";
    [self tableView];
    [self initHeaderView];
    _rechargeBtn = _bonusRechargeView.rechargeBtn;
}

- (void)initHeaderView
{
    _bonusRechargeView = [[FNBonusRechargeView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bonusRechargeView.cardPassText.delegate = self;
    _bonusRechargeView.cardNumText.delegate = self;
    _tableView.tableHeaderView = _bonusRechargeView;
    __weak __typeof(self) weakSelf = self;
    [_bonusRechargeView goRecargeRecordVC:^(id sender) {
        FNBonusRechargeRecordVC *rechargeRecordVC = [[FNBonusRechargeRecordVC alloc]init];
        [weakSelf.navigationController pushViewController:rechargeRecordVC animated:YES];
    }];
    
    [_bonusRechargeView.rechargeBtn addTarget:self action:@selector(rechargeBonus:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)rechargeBonus:(UIButton *)sender
{
    sender.enabled = NO;
    
    if (![FNLoginBO isLogin])
    {
        
        return ;
    }
    
    if (_bonusRechargeView.cardNumText.text.length == 0 )
    {
        [self.view makeToast:@"请输入充值卡号"];
    }
    else if(_bonusRechargeView.cardPassText.text.length == 0)
    {
        [self.view makeToast:@"请输入充值卡密码"];
    }
    else
    {
        [FNLoadingView showInView:self.view];
        _bonusRechargeView.rechargeBtn.enabled = NO;
        [[FNBonusBO port02] rechargeBonusWithCardName:_bonusRechargeView.cardNumText.text cardPsd:_bonusRechargeView.cardPassText.text block:^(id result) {
            _bonusRechargeView.rechargeBtn.enabled = YES;

            if ([result[@"code"] integerValue] == 500)
            {
                [FNLoadingView hide];
                FNBonusRechargeStatusVC *rechargeStatusVC = [[FNBonusRechargeStatusVC alloc]init];
                _isRechargeVC = YES;
                rechargeStatusVC.rechargeFailStr = result[@"desc"];
                rechargeStatusVC.isFail = YES;
                [self.navigationController pushViewController:rechargeStatusVC animated:YES];
            }
            else if([result[@"code"]integerValue] == 200)
            {
                [FNLoadingView hide];
                _isRechargeVC = YES;
                FNBonusRechargeStatusVC *rechargeStatusVC = [[FNBonusRechargeStatusVC alloc]init];
                rechargeStatusVC.rechargeValue = result[@"value"];
                rechargeStatusVC.bonusTotal = _bonusTotal;
                rechargeStatusVC.isFail = NO;
                [self.navigationController pushViewController:rechargeStatusVC animated:YES];
            }
            else
            {
                [FNLoadingView hide];
                if (![result[@"desc"] isEmpty])
                {
                  [UIAlertView alertViewWithMessage:result[@"desc"]];
                }else
                {
                    [UIAlertView alertViewWithMessage:@"请求错误，请重试"];

                }
            }
        }];
    }
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_4_OR_LESS)
    {
        if (textField == _bonusRechargeView.cardPassText )
        {
            [UIView animateWithDuration:0.25 animations:^{
                _bonusRechargeView.frame = CGRectMake(0, -40, kScreenWidth, kScreenHeight);
            }];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length +string.length;

    if (string.length ==1 && [string isEqualToString:@" "])
    {
        return NO;
    }

    if ((textField == _bonusRechargeView.cardNumText && num >10))
    {
        return NO;
    }
    if (textField == _bonusRechargeView.cardPassText && num > 8)
    {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text rangeOfString:@" "].location != NSNotFound)
    {
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        _bonusRechargeView.cardPassText.text = textField.text;
        _bonusRechargeView.cardNumText.text = textField.text;
    }
    return YES;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
