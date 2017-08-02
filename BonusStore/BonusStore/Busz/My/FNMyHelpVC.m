//
//  FNMyHelpVC.m
//  BonusStore
//
//  Created by sugarkawhi on 16/4/10.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMyHelpVC.h"

@interface FNMyHelpVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;

@end


@implementation FNMyHelpVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"帮助中心";

    [self tableView];
    
    [self autoFitInsets];
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.dataSource = @[@"常见问题",@"在线客服",@"客服热线"];
    
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        _tableView.scrollEnabled = NO;
        
        _tableView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        FNQuestionVC * question = [[FNQuestionVC alloc]init];
        [self.navigationController pushViewController:question animated:YES];
    }
    else if (indexPath.section == 1)
    {
        ZCLibInitInfo *initInfo  = [ZCLibInitInfo new];
        
        initInfo.enterpriseId = FN_SOBOT_ID;
        
        // 用户id，用于标识用户，建议填写
        ZCKitInfo *uiInfo=[ZCKitInfo new];
        
        uiInfo.info=initInfo;
        
        [uiInfo setReceivedBlock:^(id message,int nLeft){
            
        }];
        
        [ZCSobot startZCChatView:uiInfo with:self pageBlock:^(ZCUIChatController *object, ZCPageBlockType type) {
            // 点击返回
            if(type==ZCPageBlockGoBack)
            {

            }
            
            if(type==ZCPageBlockLoadFinish)
            {
                
            }
            
        } messageLinkClick:nil];

    }
    else if (indexPath.section == 2)
    {
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"是否呼叫400-800-2383" cancelTitle:@"确认" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-800-2383"]];
            }
        } otherTitle:@"取消", nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
@end
