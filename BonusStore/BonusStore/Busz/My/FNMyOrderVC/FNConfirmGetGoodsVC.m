//
//  FNConfirmGetGoodsVC.m
//  BonusStore
//
//  Created by cindy on 16/9/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNConfirmGetGoodsVC.h"

#import "FNOrderDetailVC.h"
@interface FNConfirmGetGoodsVC ()

@end

@implementation FNConfirmGetGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.state == 1)
    {
        self.title = @"确认收货";
    }else
    {
        self.title = @"取消订单";
    }
    [self setNavigaitionBackItem];
    [self setNavigaitionMoreItem];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imgView  =  [[UIImageView alloc]init];
    
    if(self.state == 1)
    {
        imgView.image = [UIImage imageNamed:@"confirmGoods"];
    }else
    {
        imgView.image = [UIImage imageNamed:@"confirmCancel"];
    }
    
    imgView.frame = CGRectMake((kScreenWidth - imgView.image.size.width)*0.5,85, imgView.image.size.width, imgView.image.size.height);
    [self.view addSubview:imgView];
    CGFloat confirmLabelY = CGRectGetMaxY(imgView.frame);
    UILabel * confirmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, confirmLabelY + 10, kScreenWidth, [UIFont systemFontOfSize:18].lineHeight)];
    confirmLabel.textAlignment = NSTextAlignmentCenter;
    confirmLabel.font = [UIFont systemFontOfSize:18];
    confirmLabel.textColor = UIColorWithRGB(102.0, 102.0, 102.0);
    if(self.state ==1)
    {
        confirmLabel.text = @"确认收货成功";
    }else
    {
        confirmLabel.text = @"取消订单成功";
    }
    [self.view addSubview:confirmLabel];
    
    CGFloat btnY = CGRectGetMaxY(confirmLabel.frame)+ 40;

    FNButton *indexBut = [FNButton buttonWithType:FNButtonTypePlain title:@"回到首页"];
    indexBut.frame =  CGRectMake(100, btnY, kScreenWidth - 2*100, 40);
    [indexBut setCorner:5];
    [indexBut addSuperView:self.view ActionBlock:^(id sender) {
        [self goMain];
    }];
}

- (void)goToOrderVC
{
    
    FNOrderDetailVC *orderDatailVC = [[FNOrderDetailVC alloc]initWithState:FNOrderStateCanceled];
    orderDatailVC.orderID = self.orderID;
    if (_state == 1)
    {
        orderDatailVC.state = FNOrderStateFinish;
    }
    NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [tempMarr removeObject:self];
    [tempMarr insertObject:orderDatailVC atIndex:tempMarr.count];
    [self.navigationController setViewControllers:tempMarr animated:YES];
    
}

@end
