//
//  FNMessageCenterVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMessageCenterVC.h"

#import "FNMainBO.h"

@interface FNMessageCenterVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImage * mesImage;
}

@property (nonatomic, strong) NSMutableArray * titleImageArray;

@property (nonatomic, strong) NSMutableArray * messageTitleArray;

@property (nonatomic, strong) NSMutableArray * messageContentArray;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * data;
@end
static NSString * messageCell = @"messageCell";


@implementation FNMessageCenterVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([FNMessageNoti isNewOrderMsg])
    {
        _isOrderMsg = YES;
    }
    else
    {
        _isOrderMsg = NO;
    }
    
    if ([FNMessageNoti isNewBonusMsg])
    {
        _isBonusMsg = YES;
    }
    else
    {
        _isBonusMsg = NO;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.navigationController.navigationBar.translucent = NO;
    
    _titleImageArray = [NSMutableArray arrayWithObjects:@"message_center_order",@"message_center_bonus",@"message_center_system",@"message_center_im",@" ",nil];
    _messageTitleArray = [NSMutableArray arrayWithObjects:@"订单消息",@"积分动态",@"系统消息",@"客服消息",@"消息通知", nil];
}

+ (void)setBonusMsg:(BOOL)bonusMsg
{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FNMessageCell * cell1 = [tableView dequeueReusableCellWithIdentifier:messageCell];
    if (!cell1) {
        cell1 = [[FNMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCell];
    }

    cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell1.titleImageView.image = [UIImage imageNamed:_titleImageArray[indexPath.section]];
    cell1.messageImageView1.hidden = YES;
    cell1.messageImageView1.backgroundColor = MAIN_COLOR_RED_BUTTON;
    cell1.messageTitle.text = _messageTitleArray[indexPath.section];

    switch (indexPath.section) {
        case 0:
            cell1.messageContent.text = @"点击查看订单详情";
            
            if (_isOrderMsg == YES)
            {
                cell1.messageImageView1.hidden = NO;
            }
            else
            {
                cell1.messageImageView1.hidden = YES;
            }
            break;
        case 1:
            cell1.messageContent.text = @"点击查看您的积分详情";
            if (_isBonusMsg == YES)
            {
                cell1.messageImageView1.hidden = NO;
            }
            else
            {
                cell1.messageImageView1.hidden = YES;
            }
            break;
        case 2:
            cell1.messageContent.text = @"点击查看消息";
            if (_isMsg == YES)
            {
                cell1.messageImageView1.hidden = NO;
            }
            else
            {
                cell1.messageImageView1.hidden = YES;
            }
            break;
        case 3:
            cell1.messageContent.text = @"点击查看您与客服的聊天信息";
            cell1.messageImageView1.hidden = YES;
            break;
        case 4:
            cell1.textLabel.text = self.messageTitleArray[4];
            cell1.messageImageView1.hidden = YES;
            cell1.messageTitle.hidden = YES;
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    return cell1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 4)
    {
        return 96;
    }
    else
    {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 0.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FNOrderVC *orderVC = nil;
    FNMyBonusDetailVC *bousDetailVC = nil;
    FNSystemVC * systemVC = nil;
    ZCLibInitInfo *initInfo = nil;
    ZCKitInfo *uiInfo = nil;
    NSURL * url = nil;
    FNMessageCell * cell1 = [tableView dequeueReusableCellWithIdentifier:messageCell];
    if (!cell1) {
        cell1 = [[FNMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageCell];
    }
    
    switch (indexPath.section) {
        case 0:
            [FNMessageNoti touchOffOrder];
            cell1.messageImageView1.hidden = YES;
            orderVC = [[FNOrderVC alloc]init];
            orderVC.stateTag = FNTitleTypeOrderStateAll;
            [self.navigationController pushViewController:orderVC animated:YES];
            break;
        case 1:
            [FNMessageNoti touchOffBonus];
            bousDetailVC = [[FNMyBonusDetailVC alloc]init];
            [self.navigationController pushViewController:bousDetailVC animated:YES];
            break;
        case 2:
            _isMsg = NO;
           systemVC = [[FNSystemVC alloc]init];
            
            systemVC.view.backgroundColor = [UIColor whiteColor];
            
            [self.navigationController pushViewController:systemVC animated:YES];
            break;
        case 3:
             initInfo  = [ZCLibInitInfo new];
            
            initInfo.enterpriseId = FN_SOBOT_ID;
            uiInfo=[ZCKitInfo new];
            
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

            break;
        case 4:
            
            url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }

            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _tableView = nil;
    _titleImageArray = nil;
    _messageTitleArray = nil;
    _messageContentArray = nil;
}

@end
