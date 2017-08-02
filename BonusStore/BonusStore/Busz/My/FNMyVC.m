//
//  FNMyVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//


#import "FNMyVC.h"
#import "FNBonusBO.h"
#import "FNMyBO.h"
#import "FNOrderVC.h"
#import "FNLoginBO.h"
#import "FNCartBO.h"
#import "FNMobileRechargeVC.h"

@interface FNMyVC ()<UITableViewDataSource,UITableViewDelegate, UMSocialUIDelegate>
{
    NSInteger _bonus;
    
    UIImageView *_thumbnail;
    
    UIImageView *_header;
    
    BOOL _isMsg;
    UIImage *_img;
    
    UILabel *nameLabel;
    UILabel *_bonusLab;
    UILabel *_enableLab;
    FNMyHeaderView *_headerView;
}

@property (nonatomic, strong) UITableView * myTableView;

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) NSMutableArray * ableBonus;

@property (nonatomic, strong) NSMutableArray * data;

@property (nonatomic, strong) NSArray * imageArray;

@property (nonatomic, assign) NSInteger integNumber;

@property (nonatomic, assign) BOOL firstContinue;

@property (nonatomic, assign) BOOL secondContinue;

@end

static NSString * identifier1 = @"identifier1";

static NSString * identifier2 = @"identifier2";

@implementation FNMyVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if (!FNUserAccountInfo)
    {
        return;
    }
    [FNLoadingView showInView:self.view];
    
    [[FNBonusBO port02] getBonusWithBlock:^(id result) {
        [FNLoadingView hideFromView:self.view];
        
        if (!result)
        {
            _firstContinue = YES;
            return ;
        }
        
        if ([result[@"code"] integerValue] != 200)
        {
            return ;
        }
        
        _bonus = [result[@"amount"] integerValue];
        NSString * string = [NSString stringWithFormat:@"%ld",_bonus];
        NSString * str = @"当前积分:";
        
        NSString * str2 = [NSString stringWithFormat:@"%@%@",str,string];
        
        NSMutableAttributedString * newstr = [str2 makeStr:string withColor:MAIN_COLOR_WHITE andFont:[UIFont systemFontOfSize:16]];
        
        _bonusLab.attributedText = newstr;
         NSString *right = [NSString stringWithFormat:@"%.02f",_bonus/100.0];
        
        NSString * enaStr2 = [NSString stringWithFormat:@"可抵扣: ¥%@",right];
        
        NSMutableAttributedString * newStr2 = [enaStr2 makeStr:right withColor:MAIN_COLOR_WHITE andFont:[UIFont systemFontOfSize:16]];
        
        _enableLab.attributedText = newStr2;
        [_myTableView reloadData];
    }];
    
    [[FNMyBO port02] getUserInfoWithBlock:^(id result) {
        
        [FNLoadingView hideFromView:self.view];
        
        if (!result)
        {
            _secondContinue = YES;
            [_thumbnail setImage:[UIImage imageNamed:@"avatar_default"]];
            
            return ;
        }
        if ([result isKindOfClass:[NSArray class]])
        {
            
            [_data addObjectsFromArray:result];
            
            FNPersonalModel *person = _data.lastObject;
            
            _personalModel = person;
            
            //优先设置聚分享用户信息-》再设置微信信息－》默认
            
            if (![NSString isEmptyString:person.favImg])
            {
                [_thumbnail sd_setImageWithURL:IMAGE_ID(person.favImg) placeholderImage:[UIImage imageNamed:@"avatar_default"]];
            }
            else if (![NSString isEmptyString:FNUserWechatAccountInfo[@"iconURL"]])
            {
                [_thumbnail sd_setImageWithURL:FNUserWechatAccountInfo[@"iconURL"] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
            }
            else
            {
                _thumbnail.image = [UIImage imageNamed:@"avatar_default"];
            }
            
            if (![NSString isEmptyString:_personalModel.userName])
            {
                nameLabel.text = [NSString stringWithFormat:@"欢迎:%@",_personalModel.userName];
                
            }
            else if (![NSString isEmptyString:FNUserWechatAccountInfo[@"userName"]])
            {
                nameLabel.text = [NSString stringWithFormat:@"欢迎:%@",FNUserWechatAccountInfo[@"userName"]];
            }
            else
            {
                nameLabel.text = @"欢迎:聚分享用户";
            }
        }
        else
        {
        }
    }];

    [[FNCartBO port02 ]getOrderCountListWithBlock:^(id result) {
        if ([result isKindOfClass:[NSArray class]])
        {
            for (FNOrderCountArgs *count in result)
            {
                if ([count.orderState integerValue] == FNOrderStatePaying )
                {
                    if (![[count.count stringValue] isEqualToString:@"0"])
                    {
                        _headerView.payBadges.hidden = NO;
                        _headerView.payBadges.text = [count.count stringValue];
                        [_headerView setBadges];
                    }
                    else
                    {
                        _headerView.payBadges.hidden = YES;
                    }
                }
                if([count.orderState integerValue] == FNOrderStateShipping)
                {
                    if (![[count.count stringValue] isEqualToString:@"0"])
                    {
                        _headerView.senderBadges.hidden = NO;
                        _headerView.senderBadges.text =[count.count stringValue];
                        [_headerView setBadges];
                    }
                    else
                    {
                        _headerView.senderBadges.hidden = YES;
                    }
                }
                if([count.orderState integerValue] == FNOrderStateReceiving)
                {
                    if (![[count.count stringValue] isEqualToString:@"0"])
                    {
                        _headerView.receiveBadges.hidden = NO;
                        _headerView.receiveBadges.text = [count.count stringValue];
                        [_headerView setBadges];
                    }
                    else
                    {
                        _headerView.receiveBadges.hidden = YES;
                    }
                }
            }
            [self.myTableView reloadData];
            return ;
        }
        if(result)
        {
            [UIAlertView alertViewWithMessage:result[@"desc"]];
        }else
        {
            [self.view makeToast:@"加载失败,请重试"];
        }
        
    }];
    
    if ([FNMessageNoti isNewBonusMsg] || [FNMessageNoti isNewOrderMsg] || [FNMessageNoti isNew])
    {
        _isMsg = YES;
        _img = [UIImage imageNamed:@"main_msg_msg"];
    }
    else
    {
        _isMsg = NO;
        _img = [UIImage imageNamed:@"main_msg"];
    }
    
    [self initHeader];
    
    [_myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.dataSource = @[@"我的积分",@"积分卡",@"收货地址管理",@"推荐给朋友",@"联系客服",@"设置"];
    
    self.imageArray = @[@"mybonus_bg",@"bonusCard_bg",@"address_bg",@"share_bg",@"callme_bg",@"set_bg"];

    
    _data = [NSMutableArray array];
    
    [self myTableView];
    
    _myTableView.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    _ableBonus = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(changeName:) name:@"userName" object:nil];
    
}

- (void)changeName:(NSNotification *)noti
{
    _personalModel.userName  = noti.userInfo[@"userName"];
    
    nameLabel.text = [NSString stringWithFormat:@"欢迎:%@",_personalModel.userName];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"userName" object:nil];
}

- (UITableView *)myTableView
{
    if (_myTableView == nil)
    {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight- NAVIGATION_BAR_HEIGHT+10) style:UITableViewStylePlain];
        
        _myTableView.showsVerticalScrollIndicator = NO;
        
        [_myTableView registerClass:[FNMyTableCell class] forCellReuseIdentifier:NSStringFromClass([FNMyTableCell class])];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (void)initHeader
{
    if (_header)
    {
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 300)];
    
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 190)];
    
    _header.backgroundColor = UIColorWith0xRGB(0xff544a);
    
    _header.image = [UIImage imageNamed:@"personal_bg"];
    
    [view addSubview:_header];
    
    UILabel *indicator = [[UILabel alloc]initWithFrame:CGRectMake(15, 34, 50, 20)];
    
    indicator.text = @"个人资料";
    
    indicator.textAlignment = NSTextAlignmentRight;
    
    [indicator clearBackgroundWithFont:[UIFont fzltWithSize:12] textColor:[UIColor whiteColor]];
    
    [_header addSubview:indicator];
    UIView *msgBgView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-50, 20, 54, 50)];
    [_header addSubview:msgBgView];
    
    UIImageView *messageImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];

    messageImg.image = _img;
    
    [msgBgView addTarget:self action:@selector(goMessage)];
    [msgBgView addSubview:messageImg];
    
    _thumbnail = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 64)/2, indicator.y+ indicator.height + 3, 64, 64)];
    
    _thumbnail.layer.masksToBounds = YES;
    
    _thumbnail.layer.borderWidth = 1.0;
    
    _thumbnail.layer.borderColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.5].CGColor;
    
    _thumbnail.contentMode = UIViewContentModeScaleAspectFit;
    
    _thumbnail.layer.cornerRadius = 32.0;
    
    [_header addSubview:_thumbnail];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _thumbnail.y + _thumbnail.height+8, kScreenWidth, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [nameLabel clearBackgroundWithFont:[UIFont fzltWithSize:12] textColor:[UIColor whiteColor]];
    
    [_header addSubview:nameLabel];
    
    UIImageView *indicatorMore = [[UIImageView alloc]initWithFrame:CGRectMake(indicator.x + indicator.width ,indicator.y-5, 25, 28)];
    
    indicatorMore.image = [UIImage imageNamed:@"my_info_indicator"];
    
    [_header addSubview:indicatorMore];
    
    _bonusLab = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.y+nameLabel.height+8, kScreenWidth/2-15, 25)];
   
    _bonusLab.textAlignment = NSTextAlignmentRight;
    _bonusLab.font = [UIFont systemFontOfSize:12];
    _bonusLab.textColor = MAIN_COLOR_WHITE;
    _enableLab = [[UILabel alloc]initWithFrame:CGRectMake(_bonusLab.x+_bonusLab.width+30,_bonusLab.y, kScreenWidth/2-30, _bonusLab.height)];
    _enableLab.textColor = MAIN_COLOR_WHITE;
    
    _enableLab.font = [UIFont systemFontOfSize:12];
    [_header addSubview:_enableLab];
    [_header addSubview:_bonusLab];
    
    [_header addTarget:self action:@selector(goPersonal)];
    
    _headerView = [[FNMyHeaderView alloc]initWithFrame:CGRectMake(0, _header.y + _header.height, kScreenWidth, 110)];
    _headerView.backgroundColor = MAIN_COLOR_WHITE;
    [view addSubview:_headerView];

    [_headerView.payBtn addTarget:self action:@selector(goToOrderVC:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.sendBtn addTarget:self action:@selector(goToOrderVC:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.receiveBtn addTarget:self action:@selector(goToOrderVC:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.finishBtn addTarget:self action:@selector(goToOrderVC:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.afterSaleBtn addTarget:self action:@selector(goToOrderVC:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.checkAllBtn addTarget:self action:@selector(goToOrderVC:) forControlEvents:UIControlEventTouchUpInside];
    
    _myTableView.tableHeaderView = view;
}

- (void)goMessage
{
    FNMessageCenterVC *message = [[FNMessageCenterVC alloc]init];
    [self.navigationController pushViewController:message animated:YES];
}

- (void)checkAllBtnAction:(UIButton *)sender
{
    FNOrderVC *order = [[FNOrderVC alloc]init];
    [self.navigationController pushViewController:order animated:YES];
}

- (void)goToOrderVC:(UIButton *)sender
{
    FNOrderVC *order = [[FNOrderVC alloc]init];
    order.stateTag = sender.tag;
    [self.navigationController pushViewController:order animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FNMyTableCell *cell = [FNMyTableCell dequeueWithTableView:tableView];
    
    cell.nameLabel.text = self.dataSource[indexPath.row];

    cell.leftImage.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *vc = nil;
    

    switch (indexPath.row)
    {
        case 0:
            vc = [[FNMyBonusVC alloc] init];
            break;
        case 1:
            vc = [[FNBonusRechargeVC alloc]init];
            
            break;
        case 2:
            vc = [[FNManageAddressVC alloc]init];
            break;
        case 3:
            [self shareWithText:@"中国电信战略合作伙伴--“移动互联网通用积分服务平台”，支持多渠道积分整合，并提供线上线下多场景积分消费服务。积分可以当钱花，快来查查你的积分吧！" image:[UIImage imageNamed:@"logo180"] url:APP_ARGUS_URL_SHARE title:@"聚分享积分钱包客户端" delegate:self];
            break;
        case 4:
            vc = [[FNMyHelpVC alloc]init];
            break;
        case 5:
            vc = [[FNMySetVC alloc]init];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    [FNUBSManager ubsEvent:[NSString stringWithFormat:@"share_%@",platformName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)goPersonal
{
    FNPersonalVC * personal = [[FNPersonalVC alloc]init];
    [self.navigationController pushViewController:personal animated:YES];
}

@end
