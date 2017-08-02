//
//  FNBonusCashDetailVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/6/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusCashDetailVC.h"

#import "FNBonusBO.h"

#import "FNLoginBO.h"

#import "FNMyBonusVC.h"

#import "FNMyBO.h"

@interface FNBonusCashDetailVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

{
    NSString * _bonusMobileNo;
    FNBonusCashVC * cashVC;
    UITextField * _codeText;
    UITextField *_graphCodeText;
    
}
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * titArray;

@property (nonatomic, strong) NSMutableArray * dataSources;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong)  FNButton * confirmButton;

@property (nonatomic, strong)  UILabel * prompt;

@property (nonatomic, copy) NSString * graphCodeId;


@end

@implementation FNBonusCashDetailVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 18,0 ,17)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionHelpItem];
    
    self.title = @"聚分享积分兑出";
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(graphCodeChanged:) name:@"graphCodeChanged" object:nil];

    
    _data = [NSMutableArray array];
    
    _titArray = [NSMutableArray arrayWithObjects:@"本次兑出积分",@"兑换为翼积分",@"兑入电信账号", nil];
    
    _dataSources = [NSMutableArray arrayWithObjects:@(self.bonus),@(self.bonus),self.mobile, nil];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [self tableView];
    [self otherView];
    
    NSDictionary * userInfo =  [FNUserAccountArgs getUserAccount];
    _bonusMobileNo = [userInfo valueForKey:@"mobile"];
    
    if (self.isNotFirstCash ==YES)
    {
        _prompt.hidden = YES;
    }
   
        if (self.prameArr.count !=0)
    {
            // 校验手机号是否被其他聚分享账号绑定
            [FNLoadingView showInView:self.view];
            [[[FNBonusBO port02]withOutUserInfo] checkTeleBindedWithMobile:self.mobile block:^(id result)
             {
                 [FNLoadingView hide];
        
                 if ([result[@"code"] integerValue] == 200)
                 {
        
                     if ([result[@"value"]  integerValue]!= 0)
                     {
                         // 1 绑定 0 未绑定
                         [UIAlertView alertWithTitle:@"" message:@"该电信账号已绑定其他聚分享账号" cancelTitle:@"更换账号" actionBlock:^(NSInteger bIndex) {
                             if (bIndex == 0)
                             {
                                 [self goBack];
        
                             }
                             if (bIndex ==1)
                             {
                                 [self goMain];
        
                             }
        
                         } otherTitle:@"回到首页" ,nil];
        
                     }else
                     {
                         [[FNBonusBO port02]isPurchaseMobile:self.mobile block:^(id result) {
        
                             if([result[@"code"] integerValue] ==200 )
                             {
                                 if([result[@"value"] integerValue]==0)
                                 {
                                     [UIAlertView alertWithTitle:@"" message:@"暂不支持兑出积分到广东电信账号" cancelTitle:@"更换账号" actionBlock:^(NSInteger bIndex) {
                                         if (bIndex == 0)
                                         {
                                             [self goBack];
        
                                         }
                                         if (bIndex ==1)
                                         {
                                             [self goMain];
        
                                         }
        
                                     } otherTitle:@"回到首页" ,nil];
                                     
                                 }
                                 
                             }
                             
                         }];
                         
        
                     }
                 }
                 else
                 {
                    [self.view makeToast:@"加载失败,请重试!"];
                 }
             }];
    }
    

    }

- (void)graphCodeChanged:(NSNotification *)noti
{
    self.graphCodeId = noti.userInfo[@"graphCodeChanged"];
    
}
- (void)otherView
{
    _prompt = [[UILabel alloc]init];
    
    _prompt.text = @"首次确认兑出后将绑定此电信账号!";
    
    _prompt.textColor = MAIN_COLOR_RED_ALPHA;
    
    _prompt.textAlignment = NSTextAlignmentCenter;
    
    _prompt.font = [UIFont fzltWithSize:14];
    
    
    _prompt.frame = CGRectMake(0, self.tableView.y + self.tableView.height +10, kScreenWidth, 30);
    
    [self.view addSubview:_prompt];
    
    _confirmButton = [FNButton buttonWithType:FNButtonTypePlain title:@"确认"];
    
    [_confirmButton setCorner:5];
    
    _confirmButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
    
    [self.view addSubview:_confirmButton];
    
    [_confirmButton addTarget:self action:@selector(confirBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmButton.frame = CGRectMake(60, _prompt.y + _prompt.height + 10, kScreenWidth - 120, 40);
    
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
    
    _codeText = [[UITextField alloc]init];
    
    _codeText.delegate = self;
    
    
    
    _codeText.placeholder = @"请输入验证码";
    
    
    _codeText.leftView = paddingView1;
    
    _codeText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    _codeText.keyboardType = UIKeyboardTypeNumberPad;
    
    _codeText.leftViewMode = UITextFieldViewModeAlways;
    _codeText.clearButtonMode = UITextFieldViewModeWhileEditing;

    
    _codeText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
    
    _codeText.frame = CGRectMake(22, 6 , kScreenWidth - 4 * 49 , 48);

    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
    
    _graphCodeText = [[UITextField alloc]init];
    
    _graphCodeText.delegate = self;
    
    _graphCodeText.clearButtonMode = UITextFieldViewModeWhileEditing;

    _graphCodeText.placeholder = @"请输入图形验证码";
    
    _graphCodeText.leftView = paddingView2;
    
    _graphCodeText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    _graphCodeText.leftViewMode = UITextFieldViewModeAlways;
    
    _graphCodeText.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
    
    _graphCodeText.frame = CGRectMake(22, 6 , kScreenWidth - 4 * 49 , 48);
    
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5 * 60) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.scrollEnabled =  NO;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.separatorColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titArray.count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNBonusCashCell * cell = [FNBonusCashCell cashTableviewCell:tableView];
    
    cell.buttonView.hidden = YES;
    
    if (indexPath.row < 3)
    {
        cell.codeBtn.hidden = YES;
        
        cell.titleLable.text = _titArray[indexPath.row];
        
        cell.inteLabel.textColor = MAIN_COLOR_RED_BUTTON;
        
        cell.userInteractionEnabled = NO;
    }
    if (indexPath.row == 3)
    {
        cell.inteLabel.hidden = YES;
        
        cell.titleLable.hidden = YES;
        cell.codeBtn.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FNCodeView *codeView = [[FNCodeView alloc]initWithFrame:CGRectMake(kScreenWidth - 133 -15, 5, 133,50 )];
        [cell.contentView addSubview:codeView];
        [cell.contentView addSubview:_graphCodeText];
        
    }
    if (indexPath.row == 4)
    {
        cell.inteLabel.hidden = YES;
        
        cell.titleLable.hidden = YES;
        
        [cell.codeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:_codeText];
    }
    switch (indexPath.row) {
            
        case 0:
            cell.inteLabel.text = [NSString stringWithFormat:@"%@", _dataSources[indexPath.row]];
            break;
        case 1:
            cell.inteLabel.text = [NSString stringWithFormat:@"%@", _dataSources[indexPath.row]];
            break;
        case 2:
            cell.inteLabel.hidden = YES;

            cell.telephoneLabel.frame = CGRectMake(kScreenWidth - 120, 10, 100, 40);

            cell.telephoneLabel.text = [NSString stringWithFormat:@"%@", _dataSources[indexPath.row]];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)getCode:(id)sender
{
    UIButton * getCode = (UIButton *)sender;
    if ([NSString isEmptyString:self.mobile] ||[NSString isEmptyString:self.graphCodeId]||[NSString isEmptyString:_graphCodeText.text])
    {
        [self.view makeToast:@"请输入相应的内容"];

        return;
    }
    [FNLoadingView showInView:self.view];
    
    
    [[[FNLoginBO port02] withOutUserInfo] getSMSWithMobile:_bonusMobileNo withId:self.graphCodeId value:_graphCodeText.text block:^(id result) {
           if (!result)
        {
            [FNLoadingView hide];
            [self.view makeToast:@"获取失败请重试"];
            return ;
        }
        
        if ([result[@"code"] integerValue] == 200)
        {
            [FNLoadingView hide];
            __block int timeout = 120; //倒计时时间
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            
            dispatch_source_set_event_handler(_timer, ^{
                
                if(timeout<=0){
                    
                    dispatch_source_cancel(_timer);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        getCode.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
                        [getCode setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
                        [getCode setTitle:@"重新获取" forState:UIControlStateNormal];
                        
                        getCode.userInteractionEnabled = YES;
                        
                    });
                    
                }
                else
                {
                    int seconds = timeout % 356;
                    
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [getCode setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                        
                        getCode.layer.borderColor = [UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1].CGColor;
                        [getCode setTitleColor:[UIColor colorWithRed:147.0/255 green:153.0/255 blue:147.0/255 alpha:1] forState:UIControlStateNormal];
                        
                        getCode.userInteractionEnabled = NO;
                        
                    });
                    
                    timeout--;
                }
            });
    
            dispatch_resume(_timer);
    
        }
        else
        {
            [FNLoadingView hide];
            [UIAlertView alertViewWithMessage:result[@"desc"]];
        }
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)confirBtnAction
{
    
    if (_codeText.text.length == 0)
    {
        self.confirmButton.enabled = YES;
        [UIAlertView alertViewWithMessage:@"请输入验证码"];
        return;
    }
    [FNLoadingView showInView:self.view];
    [[FNBonusBO port02]teleOutWithMobile:self.mobile bonus:self.bonus prame:self.prameArr captchaDesc:_codeText.text block:^(id result) {
        
        self.confirmButton.enabled = YES;
        [FNLoadingView hide];

        if ([result[@"code"] integerValue] != 200)
        {
            [FNLoadingView hide];
            [self.view makeToast:result[@"desc"]];
            return ;
                        
        }
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"兑换成功" cancelTitle:@"去首页" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {

                [self goMain];

            }
            if (bIndex ==1)
            {
                [self.view endEditing:YES];
                NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [tempMarr removeObject:self];
                FNWebVC * webVc = [[FNWebVC alloc]initWithURL:[NSURL URLWithString:@"http://tyclub.telefen.com/newjf_hgo2/html/HGOIndex_em_qg.html?provinceId=35"] html:nil];
                webVc.title = @"天翼商城";
                [tempMarr insertObject:webVc atIndex:tempMarr.count];
                isTianYi = YES;
                [self.navigationController setViewControllers:tempMarr animated:YES];
            }
            
        } otherTitle:@"去天翼", nil];
        
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_4_OR_LESS)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, -(kScreenHeight-216- 4*60 +120+44), kScreenWidth, 5*60);
            _prompt.frame = CGRectMake(0, self.tableView.y + self.tableView.height +10, kScreenWidth, 30);
            _confirmButton.frame = CGRectMake(60, _prompt.y + _prompt.height + 10 ,  kScreenWidth - 120, 40);
        }];
    }
    else if(IS_IPHONE_5)
    {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame = CGRectMake(0, -(kScreenHeight-216-4*60-70+44), kScreenWidth, 5*60);
            _prompt.frame = CGRectMake(0, self.tableView.y + self.tableView.height +10, kScreenWidth, 30);
            _confirmButton.frame = CGRectMake(60, _prompt.y + _prompt.height + 10 ,  kScreenWidth - 120, 40);
        }];
    }
}

- (void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, 5*60);
        _prompt.frame = CGRectMake(0, self.tableView.y + self.tableView.height +10, kScreenWidth, 30);
        _confirmButton.frame = CGRectMake(60, _prompt.y + _prompt.height + 10 ,  kScreenWidth - 120, 40);
    }];
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length+string.length;
    
    if (textField == _codeText && num > 4)
    {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _codeText)
    {
        
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame = CGRectMake(0, 0, kScreenWidth, 5*60);
        _prompt.frame = CGRectMake(0, self.tableView.y + self.tableView.height +10, kScreenWidth, 30);
        _confirmButton.frame = CGRectMake(60, _prompt.y + _prompt.height + 10 ,  kScreenWidth - 120, 40);
    }];
    [self.view endEditing:YES];
}

- (void )viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"graphCodeChanged" object:nil];

}


@end
