//
//  FNAccessABVC.m
//  DataFlowSDK
//
//  Created by sugarwhi on 16/7/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNAccessABVC.h"
#include "FNHeader.h"
@interface FNAccessABVC ()

@end

@implementation FNAccessABVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    [self setNavigaitionBackItem];
    self.title = @"手机充值";
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-20, kScreenHeight/4-60-30, 30, 30)];
    image.image = [UIImage imageNamed:@"address_btn"];
    [self.view addSubview:image];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, image.frame.origin.y + + 30+5,kScreenWidth , 60)];
    [self.view addSubview:lable];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.numberOfLines = 0;
    lable.textColor = [UIColor lightGrayColor];
    lable.text = @"请在iPhone的\"设置-隐私-通讯录\"选项中，\n选择允许app访问你的通讯录.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
