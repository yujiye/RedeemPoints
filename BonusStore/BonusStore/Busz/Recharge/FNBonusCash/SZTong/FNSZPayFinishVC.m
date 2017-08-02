//
//  FNSZPayFinishVC.m
//  BonusStore
//
//  Created by Nemo on 17/4/18.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNSZPayFinishVC.h"

@interface FNSZPayFinishVC ()

@end

@implementation FNSZPayFinishVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"深圳通充值";
    
    [self setNavigaitionHelpItem];
    
    UIImageView *finishLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 44, 45)];
    
    finishLogo.image = [UIImage imageNamed:@"finish_logo"];
    
    [self.view addSubview:finishLogo];
    
    [finishLogo setHorizonCenterWithSuperView:self.view];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,  finishLogo.bottom+10, kWindowWidth-60, 50)];
    
    [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    tipLabel.textColor = MAIN_COLOR_WHITE;
    
    tipLabel.textAlignment = NSTextAlignmentRight;
    
    tipLabel.text = @"恭喜您，购券成功\n请前往进行深圳通充值";
    
    [self.view addSubview:tipLabel];
    
    
    UIButton *rechargeBut = [FNButton buttonWithType:FNButtonTypePlain title:@"立即充值"];
    
    rechargeBut.frame = CGRectMake(15, tipLabel.bottom+30, kWindowWidth-30, 45);
    
    [rechargeBut setCorner:5];
    
    rechargeBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
    
    [rechargeBut addSuperView:self.view ActionBlock:^(id sender) {
        

        
    }];
    
    
    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(tipLabel.x, rechargeBut.bottom+10, tipLabel.width, 25)];
    
    [detailLabel addTarget:self action:@selector(goDetail)];
    
    [detailLabel clearBackgroundWithFont:[UIFont systemFontOfSize:11] textColor:MAIN_COLOR_BLACK_ALPHA];
    
    detailLabel.textColor = MAIN_COLOR_WHITE;
    
    detailLabel.textAlignment = NSTextAlignmentCenter;
    
    detailLabel.text = @"查看购券详情";
    
    [self.view addSubview:detailLabel];
}

- (void)goDetail
{
    
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
