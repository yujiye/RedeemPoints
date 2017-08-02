//
//  FNAboutJShareVC.m
//  BonusStore
//
//  Created by sugarkawhi on 16/4/10.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNAboutJShareVC.h"

#import "FNAboutHeadView.h"

#import "FNMyBO.h"

#import "UIView+Toast.h"

@interface FNAboutJShareVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;

@end

static NSString * identifer = @"identifer";

static NSString * cellID = @"cellID";

@implementation FNAboutJShareVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[FNMyBO port01] withOutUserInfo] getUpdateWithBlock:^(id result) {
        
        if ([result[@"code"] integerValue] != 200)
        {
            if(result)
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];
            }else
            {
                [self.view makeToast:@"加载失败,请重试"];
            }
            
            return ;
        }
        //1.0.0001.0613
        
        if (![FNMyUpdateInfo isKindOfClass:[NSDictionary class]] || ![[FNMyUpdateInfo allKeys] count])
        {
            return;
        }
        
        if (FNMyIsEnforceUpdate == 2)
        {
            
            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:FNMyUpdateInfo[@"upgradeDesc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                
                if (bIndex == 0)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FNMyUpdateInfo[@"url"]]];
                }
                
            } otherTitle:nil, nil];
        }
        else if (FNMyIsEnforceUpdate == 1)
        {
            [UIAlertView alertWithTitle:APP_ARGUS_NAME message:FNMyUpdateInfo[@"upgradeDesc"] cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
                
                if (bIndex == 0)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FNMyUpdateInfo[@"url"]]];
                }
                
            } otherTitle:@"取消", nil];
        }
        else
        {
//            [self.view makeToast:@"当前已是最新版本"];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于聚分享";
    
    [self tableView];
    
    [self protem];
    
    [self setNavigaitionMoreItem];
    
    [self setNavigaitionBackItem];
    
    self.dataSource = @[@"版本信息",@"去App Store评分"];
    
    self.navigationController.navigationBar.translucent = NO;

    self.view.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
}


- (void)protem
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 95)/2, _tableView.y + _tableView.height + 10, 95, 20)];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 150)/2, label.y + label.height + 2, 150, 20)];
    
    label.text = @"Copyright©2016";
    
    label1.text = @"深圳市博源电子商务有限公司";
    
    label.font = [UIFont systemFontOfSize:11];
    
    label1.font = [UIFont fontWithName:FONT_NAME_LTH size:11];
    
    label.textColor = MAIN_COLOR_GRAY_ALPHA;
    
    label1.textColor = MAIN_COLOR_GRAY_ALPHA;
    
    [self.view addSubview:label];
    
    [self.view addSubview:label1];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 422) style:UITableViewStylePlain];
        
        [_tableView registerClass:[FNAboutHeadView class] forCellReuseIdentifier:identifer];
        
        [_tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:cellID];
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.scrollEnabled = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * version = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 30 ,5 , 200, 25)];
    
    version.textAlignment = NSTextAlignmentRight;

    version.text = APP_ARGUS_VERSION;
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FNAboutHeadView * cellHeadCell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (indexPath.section == 0)
    {
        if (cellHeadCell == nil)
        {
            cellHeadCell = [[FNAboutHeadView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        cellHeadCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellHeadCell.backgroundColor = [UIColor whiteColor];
        
        return cellHeadCell;
    }
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    else if (indexPath.section == 1)
    {
        cell.accessoryView = version;
        
        [cell.contentView addSubview:version];
        
        [cell.contentView addSubview:version];
        
        cell.backgroundColor = MAIN_COLOR_WHITE;
        
        cell.textLabel.text = self.dataSource[indexPath.section - 1];
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
    else if(indexPath.section == 2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.backgroundColor = MAIN_COLOR_WHITE;
        
        cell.textLabel.text = self.dataSource[indexPath.section - 1];
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 282;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (indexPath.section == 2)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_ARGUS_URL_MARK]];
    }
}
@end
