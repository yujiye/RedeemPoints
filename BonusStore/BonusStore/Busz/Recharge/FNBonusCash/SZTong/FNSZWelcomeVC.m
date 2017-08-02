//
//  FNSZWelcomeVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/18.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZWelcomeVC.h"

@interface FNSZWelcomeVC ()

@end

@implementation FNSZWelcomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"深圳通充值";
    
    [self setNavigaitionHelpItem];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 44, 45)];
    
    logo.image = [UIImage imageNamed:@"finish_logo"];
    
    [self.view addSubview:logo];
    
    [logo setHorizonCenterWithSuperView:self.view];
    
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  10, kWindowWidth-60, 50)];
    
    [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    tipLabel.textColor = MAIN_COLOR_WHITE;
    
    tipLabel.textAlignment = NSTextAlignmentRight;
    
    tipLabel.text = @"购买充值券";
    
    [self.view addSubview:tipLabel];

    
//    UIButton *rechargeBut = [FNButton buttonWithType:FNButtonTypePlain title:@"立即支付"];
//    
//    rechargeBut.frame = CGRectMake(15, cashLabel.bottom+30, kWindowWidth-30, 45);
//    
//    [rechargeBut setCorner:5];
//    
//    rechargeBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
//    
//    [rechargeBut addSuperView:self.view ActionBlock:^(id sender) {
//        
//        
//        
//    }];
//    
//    
//    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  10, kWindowWidth-60, 50)];
//    
//    [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
//    
//    tipLabel.textColor = MAIN_COLOR_WHITE;
//    
//    tipLabel.textAlignment = NSTextAlignmentRight;
//    
//    tipLabel.text = @"还没有充值券？";
//    
//    [self.view addSubview:tipLabel];
//
//    
//    UIButton *rechargeBut = [FNButton buttonWithType:FNButtonTypePlain title:@"立即支付"];
//    
//    rechargeBut.frame = CGRectMake(15, cashLabel.bottom+30, kWindowWidth-30, 45);
//    
//    [rechargeBut setCorner:5];
//    
//    rechargeBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
//    
//    [rechargeBut addSuperView:self.view ActionBlock:^(id sender) {
//        
//        
//        
//    }];
//    
//    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  10, kWindowWidth-60, 50)];
//    
//    [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
//    
//    tipLabel.textColor = MAIN_COLOR_WHITE;
//    
//    tipLabel.textAlignment = NSTextAlignmentRight;
//    
//    tipLabel.text = @"购买充值券";
//    
//    [self.view addSubview:tipLabel];

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
