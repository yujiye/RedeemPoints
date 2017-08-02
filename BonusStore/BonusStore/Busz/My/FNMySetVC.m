//
//  FNMySetVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMySetVC.h"

#import "UIFont+Cate.h"

#import "UIView+Toast.h"

@interface FNMySetVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * myTableView;

@property (nonatomic, strong) NSArray * titleName;

@end

@implementation FNMySetVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self myTableView];

    [self createButton];
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    self.titleName = @[@"个人资料",@"修改密码",@"关于聚分享"];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
}

- (void)createButton
{
    UIButton * backBton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    backBton.frame = CGRectMake(0, self.view.height -NAVIGATION_BAR_HEIGHT - 48, kScreenWidth, 48);
    
    [backBton setTitle:@"退出当前用户" forState:UIControlStateNormal];
    
    [backBton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    backBton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:17];
    
    [backBton setBackgroundColor:MAIN_COLOR_RED_BUTTON];
    
    [backBton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBton];
    
}

- (UITableView *)myTableView
{
    if (!_myTableView)
    {
        
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 174) style:UITableViewStyleGrouped];
        
        _myTableView.scrollEnabled = NO; //设置tableview 不能滚动
        
        _myTableView.dataSource = self;
        
        _myTableView.delegate = self;
        
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.accessoryView.backgroundColor = [UIColor blackColor];
    
    cell.textLabel.text = self.titleName[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        FNPersonalVC * personal = [[FNPersonalVC alloc]init];
        
        [self.navigationController pushViewController:personal animated:YES];
    }
    
    if (indexPath.section == 1)
    {
        FNAlterPassWordVC * alterPassWord = [[FNAlterPassWordVC alloc]init];
        
        [self.navigationController pushViewController:alterPassWord animated:YES];
    }
    if (indexPath.section == 2)
    {
        
        FNAboutJShareVC * head = [[FNAboutJShareVC alloc]init];
        
        [self.navigationController pushViewController:head animated:YES];
        
    }
}

- (void)backButton
{
//    鉴权失败和退出登录都要删除密码
    
    [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"您是否确认退出" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
        
        if (bIndex == 0)
        {
            [FNTokenFetcher cancel];
            
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[FNUserAccountArgs getUserAccount]];
            
            [info removeObjectForKey:@"pwdEnc"];
            
            [FNUserAccountArgs setUserAccount:info];
            
            [FNUserAccountArgs removeUserAccountInfo];
            
            [FNUserAccountArgs removeUserWechatAccountInfo];

            [self.navigationController.tabBarController.viewControllers[2] tabBarItem].badgeValue = nil;
            
            FNPayInfo = nil;
            FNLoginIsScan = NO;
            [self goMain];
        }
    } otherTitle:@"取消",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
