//
//  FNSZRechargeVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/18.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZRechargeVC.h"

@interface FNSZRechargeVC ()

@end

@implementation FNSZRechargeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"深圳通充值";
    
    [self setNavigaitionHelpItem];

    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  10, kWindowWidth-60, 50)];
    
    [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    tipLabel.textColor = MAIN_COLOR_WHITE;
    
    tipLabel.textAlignment = NSTextAlignmentRight;
    
    tipLabel.text = @"购买充值券";
    
    [self.view addSubview:tipLabel];
    
    
    
    UILabel *cashLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  tipLabel.bottom+10, kWindowWidth-60, 50)];
    
    [cashLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    cashLabel.textColor = MAIN_COLOR_WHITE;
    
    cashLabel.textAlignment = NSTextAlignmentRight;
    
    cashLabel.text = @"总额：￥9.90";
    
    [self.view addSubview:cashLabel];
    
    UIButton *rechargeBut = [FNButton buttonWithType:FNButtonTypePlain title:@"立即支付"];
    
    rechargeBut.frame = CGRectMake(15, cashLabel.bottom+30, kWindowWidth-30, 45);
    
    [rechargeBut setCorner:5];
    
    rechargeBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
    
    [rechargeBut addSuperView:self.view ActionBlock:^(id sender) {
        
        
        
    }];
    
    
    UILabel *useLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  rechargeBut.bottom+10, kWindowWidth-60, 50)];
    
    [useLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    useLabel.textColor = MAIN_COLOR_WHITE;
    
    useLabel.textAlignment = NSTextAlignmentRight;
    
    useLabel.text = @"已有券，去使用";
    
    [self.view addSubview:useLabel];
    
    
    
}

- (void)goUse
{
    FNWebVC *vc = [[FNWebVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
