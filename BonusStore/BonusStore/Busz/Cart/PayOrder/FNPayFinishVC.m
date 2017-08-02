//
//  FNPayFinishVC.m
//  BonusStore
//
//  Created by Nemo on 16/4/13.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPayFinishVC.h"
#import "FNCartBO.h"
@interface FNPayFinishVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *_titleLabel;
}


@end

@implementation FNPayFinishVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.tableViewDelegate = self;
    

    if ([(NSArray *)FNPayInfo[@"orderId"] count] > 1 || (self.bonus && ![self.bonus isEqualToString:@""]))
    {
        
        [self initHeader];
        
        if (self.isSpecialType == YES)
        {
            _titleLabel.hidden = YES;

        }else
        {
        if ([self.bonus floatValue] < 1.0)
        {
            _titleLabel.hidden = YES;
        }
        else
        {
            _titleLabel.hidden = NO;
        }
        }
    }
    else
    {
        
        [[FNCartBO port02] getOrderDetailWithOrderID:[FNPayInfo[@"orderId"] lastObject] block:^(id result){
            
            if (![result isKindOfClass:[FNOrderArgs class]])
            {
                if(result)
                {
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
                
                return ;
            }
            
            FNOrderArgs *order = result;
            
            self.bonus = [NSString stringWithFormat:@"%@",order.closingPrice];
            
            [self initHeader];
            
            if ([self.bonus floatValue] < 1.0)
            {
                _titleLabel.hidden = YES;
            }
            else
            {
                _titleLabel.hidden = NO;
            }
        }];
    }
   
    FNPayInfo = nil;
}

- (void)initHeader
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-NAVIGATION_BAR_HEIGHT)];
    
    UIImageView *_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 150, 212)];
    
    [_iconView setHorizonCenterWithSuperView:header];
    
    _iconView.image = [UIImage imageNamed:@"pay_finish"];
    
    [header addSubview:_iconView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 284, kWindowWidth, 30)];
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_titleLabel clearBackgroundWithFont:[UIFont fzltWithSize:22] textColor:[UIColor blackColor]];
    
    [header addSubview:_titleLabel];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜您获得%.0f聚分享积分",floor([self.bonus floatValue])]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, self.bonus.length)];
    
    _titleLabel.attributedText = string;
    
   if (self.isSpecialType)
   {
       _titleLabel.hidden = YES;
   }else
   {
       _titleLabel.hidden = NO;
   }
    
    

    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.y + _titleLabel.height, kWindowWidth, 30)];
    
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    subTitleLabel.text = @"聚聚将快马加鞭为您发货哟～";
    
    [subTitleLabel clearBackgroundWithFont:[UIFont fzltWithSize:16] textColor:UIColorWith0xRGB(0x8c8c8c)];
    
    [header addSubview:subTitleLabel];
    
    UIButton *orderBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    orderBut.frame = CGRectMake(kAverageValue(kWindowWidth/2.0-100), subTitleLabel.y + subTitleLabel.height+10, 100, 50);
    
    [orderBut setDefaultStateTitle:@"" titleColor:[UIColor blueColor]];

    NSString *order = @"查看订单";
    
    NSMutableAttributedString *orderString = [order setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) , NSUnderlineColorAttributeName : UIColorWithRGB(32, 87, 200), NSFontAttributeName : [UIFont fzltWithSize:18]} range:NSMakeRange(0, order.length)];
    
    [orderBut setAttributedTitle:orderString forState:UIControlStateNormal];
    
    [orderBut addSuperView:header ActionBlock:^(id sender) {
        
//        FNOrderVC *vc = [[FNOrderVC alloc] initWithOrderState:FNOrderStateShipping];
        
//        vc.isReceiving = YES;
        
//        [self.navigationController pushViewController:vc animated:YES];
        FNOrderVC *orderVC = [[FNOrderVC alloc]init];
        
        if (_isVirtualGoods == YES)
        {
            orderVC.stateTag = FNTitleTypeOrderStateFinish;
            orderVC.isPayFinish = YES;
        }
        else
        {
            orderVC.stateTag = FNTitleTypeOrderStateShipping;
            orderVC.isPayFinish = YES;
        }
        
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }];
    
    UIButton *bonusBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    bonusBut.frame = CGRectMake(kAverageValue(kWindowWidth/2.0-100) + kWindowWidth/2.0, orderBut.y, 100, 50);
    
    NSString *bonus = @"查看积分";
    
    NSMutableAttributedString *bonusString = [bonus setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) , NSUnderlineColorAttributeName : UIColorWithRGB(32, 87, 200), NSFontAttributeName : [UIFont fzltWithSize:18]} range:NSMakeRange(0, bonus.length)];
   
    [bonusBut setAttributedTitle:bonusString forState:UIControlStateNormal];

    [bonusBut addSuperView:header ActionBlock:^(id sender) {
        
        FNMyBonusDetailVC *vc = [[FNMyBonusDetailVC alloc] init];
        
        vc.isFinish = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    //If Scan pay finish, only show 'bonus button';
    //else show order and bonus button;
    
    if (FNLoginIsScan)
    {
        orderBut.hidden = YES;
        
        UIReframeWithX(bonusBut, kAverageValue(kWindowWidth -100));
    }
    else
    {
        orderBut.hidden = NO;
        
        bonusBut.frame = CGRectMake(kAverageValue(kWindowWidth/2.0-100) + kWindowWidth/2.0, orderBut.y, 100, 50);
    }
    
    FNButton *visionBut = [FNButton buttonWithType:FNButtonTypePlain title:@"继续逛逛"];
    
    visionBut.frame = CGRectMake(kAverageValue(kWindowWidth-200), bonusBut.y + bonusBut.height + 10, 200, 40);
    
    [visionBut setCorner:5];
    
    __weak __typeof(self) weakSelf = self;
    
    [visionBut addSuperView:header ActionBlock:^(id sender) {
        
        [weakSelf goMain];
        
    }];
    
    self.tableView.tableHeaderView = header;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    FNLoginIsScan = NO;
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
