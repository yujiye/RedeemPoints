//
//  FNMobileRechargeVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMobileRechargeVC.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "FNHeader.h"
#import "FNAccessABVC.h"
#import "FNRechargeBO.h"
#import "FNLoginBO.h"

@interface FNMobileRechargeVC ()<ABPeoplePickerNavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,FNTextFieldDelegate>
{
    FNMobileRechargeHeaderView *_headerView;
    NSString *_payMoney;
    NSInteger _selectIndex;
    NSString *_phoneNum;
    NSString *_company;
    NSString *_selectedName;
}
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UILabel *moneyLab;


@end

@implementation FNMobileRechargeVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    self.title = @"话费充值";
    [self setNavigaitionBackItem];
    _dataSources = [NSMutableArray arrayWithObjects:@"30",@"50",@"100",@"300",@"500", nil];
    _selectIndex = -1;
    [self initHeader];
    [self collectionView];
    [self createRechargeBtn];
    
}
- (void)loadDataWithMobile:(NSString *)mobile fromAB:(BOOL)fromAB
{
    [FNLoadingView showInView:self.view];
    [_headerView.phoneNumName removeFromSuperview];
    [[[FNRechargeBO port01] withOutUserInfo] mobileInfoWithMobile:mobile block:^(id result) {
        [FNLoadingView hide];
        if ([result[@"code"] integerValue] != 200)
        {
            NSString * tip = @"加载失败，请重试";
            if (![NSString isEmptyString:result[@"desc"]])
            {
                tip = result[@"desc"];
            }
            [UIAlertView alertViewWithMessage:tip];
            return ;
        }
        [_headerView addSubview:_headerView.phoneNumName];
        _headerView.phoneNumName.hidden = NO;
            NSString *provinceTip = result[@"data"][@"province"];
            NSString *operatorTip = result[@"data"][@"operator"];
            if([NSString isEmptyString:provinceTip])
            {
                provinceTip = @"中国";
            }
            if([operatorTip rangeOfString:@"移动"].location != NSNotFound)
            {
                _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@移动",provinceTip];
                
            }else if ([operatorTip rangeOfString:@"联通"].location != NSNotFound)
            {
                _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@联通",provinceTip];
                
            }else
            {
                _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@电信",provinceTip];
            }
        if (fromAB ==YES)
        {
            _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@(%@)",_headerView.phoneNumName.text,_selectedName];
        }
            _company =  _headerView.phoneNumName.text;
            _selectIndex = 0;
            _collectionView.userInteractionEnabled = YES;
            [_collectionView reloadData];
            _moneyLab.hidden = NO;
            NSString *payMoney = _dataSources[_selectIndex];
            NSString *moneyStr2 = [NSString stringWithFormat:@"总额: ¥ %@",payMoney];
            NSMutableAttributedString * money = [moneyStr2 makeStr:payMoney withColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] andFont:[UIFont systemFontOfSize:15]];
            _moneyLab.attributedText = money;
            [_rechargeBtn setBackgroundColor:MAIN_COLOR_RED_BUTTON];
            _rechargeBtn.enabled = YES;
            _payMoney = payMoney;
        
    }];
    
}

-(void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    [self.view endEditing:YES];
}
- (void)createRechargeBtn
{
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.frame = CGRectMake(16, kScreenHeight - 44- NAVIGATION_BAR_HEIGHT-20, kScreenWidth - 32, 44);
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.layer.cornerRadius = 5.0;
    [_rechargeBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_rechargeBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
    [_rechargeBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    _rechargeBtn.backgroundColor = [UIColor lightGrayColor];
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_rechargeBtn];
    _rechargeBtn.enabled = NO;
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _rechargeBtn.y-10-25, kScreenWidth, 25)];
    _moneyLab.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    _moneyLab.font = [UIFont systemFontOfSize:12];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    _moneyLab.hidden = YES;
    [self.view addSubview:_moneyLab];
}

- (void)initHeader
{
    _headerView = [[FNMobileRechargeHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    [_headerView.addressBtnView addTarget:self action:@selector(accessTheAddress:)];
    [_headerView.addressBtn addTarget:self action:@selector(accessTheAddress:) forControlEvents:UIControlEventTouchUpInside];
    _headerView.telTextField.delegate = self;
    _headerView.telTextField.textFieldDelegate = self;
    [self.view addSubview:_headerView];
}

- (UICollectionView *)collectionView
{
    if (_collectionView==nil)
    {
        UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
        CGFloat height ;
        if (_dataSources.count > 6)
        {
            height = 260;
        }
        else
        {
            height = 180;
        }
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15,_headerView.y+_headerView.height+ 10,kScreenWidth-30,height ) collectionViewLayout:flowLayOut];
        [_collectionView registerClass:[FNMobileRechargeCell class] forCellWithReuseIdentifier:NSStringFromClass([FNMobileRechargeCell class])];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = MAIN_COLOR_WHITE;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSources.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FNMobileRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNMobileRechargeCell class]) forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[FNMobileRechargeCell alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-32)/2,80 )];
    }
    cell.defaultLab.text =[NSString stringWithFormat:@"%@元", _dataSources[indexPath.row]];
    
    if (_selectIndex == indexPath.row)
    {
        cell.bgView.backgroundColor = MAIN_COLOR_RED_ALPHA;
        cell.bgView.layer.borderWidth = 0;
        cell.defaultLab.textColor = MAIN_COLOR_WHITE;
        _payMoney = _dataSources[_selectIndex];
    }
    else
    {
        cell.bgView.backgroundColor = MAIN_COLOR_WHITE;
        cell.bgView.layer.borderWidth = 1.0;
        cell.defaultLab.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5)
    {
        return CGSizeMake(90,75);
    }
    
    return CGSizeMake((kScreenWidth - 50)/3,75);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_headerView.telTextField.text isEqualToString:@"nil"]|| _headerView.telTextField.text.length<11)
    {
        _collectionView.userInteractionEnabled = NO;
    }
    else if(_headerView.telTextField.text.length == 11)
    {
        _collectionView.userInteractionEnabled = YES;
        _selectIndex = indexPath.row;
        [_collectionView reloadData];
        _payMoney = _dataSources[_selectIndex];
        NSString *moneyStr2 =[NSString stringWithFormat:@"总额: ¥ %@",_payMoney];
        NSMutableAttributedString * money = [moneyStr2 makeStr:_payMoney withColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] andFont:[UIFont systemFontOfSize:15]];
        _moneyLab.attributedText = money;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length + string.length;
    
    if ([NSString isEmptyString:string])
    {
        _selectIndex = -1;
        [_collectionView reloadData];
        num --;
    }
    if (num < 11)
    {
        _collectionView.userInteractionEnabled = NO;
        _moneyLab.hidden = YES;
        _headerView.phoneNumName.hidden = YES;
        _rechargeBtn.enabled = NO;
        [_rechargeBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        _rechargeBtn.backgroundColor = [UIColor lightGrayColor];
    }else if (num == 11)
    {
        
        NSString *str = [NSString stringWithFormat:@"%@%@",_headerView.telTextField.text,string];
        
        if (![str isMobile])
        {
            [self.view makeToast:@"请输入正确的手机号"];
            _selectIndex = -1;
            [_collectionView reloadData];
            _headerView.phoneNumName.hidden = YES;
            
        }
        else
        {
           
            [self loadDataWithMobile:str fromAB:NO];
        }
    }else
    {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _selectIndex = -1;
    [_collectionView reloadData];
    _headerView.phoneNumName.hidden = YES;
    [_rechargeBtn setBackgroundColor:[UIColor lightGrayColor]];
    _rechargeBtn.enabled = NO;
    _moneyLab.hidden = YES;
    return YES;
}
#pragma mark - 调用手机通讯录
- (void)accessTheAddress:(UIButton *)sender
{
    [FNUBSManager ubsEvent:@"AddressBook"];
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        ABAuthorizationStatus authStatus =
        ABAddressBookGetAuthorizationStatus();
        if (authStatus != kABAuthorizationStatusAuthorized)
        {
            ABAddressBookRequestAccessWithCompletion
            (addressBook, ^(bool granted, CFErrorRef error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (error)
                         NSLog(@"Error: %@", (__bridge NSError *)error);
                     else if (!granted)
                     {
                         FNAccessABVC *accessVC = [[FNAccessABVC alloc]init];
                         [self.navigationController pushViewController:accessVC animated:YES];
                     }else{
                         [self addressBookAction];
                     }
                 });
             });
        }else{
            [self addressBookAction];
        }
    }else{
        addressBook = ABAddressBookCreate();
    }
}
- (void)addressBookAction
{
    ABPeoplePickerNavigationController *addBook = [[ABPeoplePickerNavigationController alloc] init];
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],[NSNumber numberWithInt:kABPersonEmailProperty],[NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
    addBook.displayedProperties = displayedItems;
    addBook.peoplePickerDelegate = self;
    [self presentViewController:addBook animated:YES completion:nil];
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
  _selectedName = (__bridge NSString *)ABRecordCopyCompositeName(person);
    if (property == kABPersonPhoneProperty)
    {
        ABMutableMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        int index = ABMultiValueGetIdentifierAtIndex(phone, identifier);
        
        if (index < 0)
        {
            index = 0;
        }
        _collectionView.userInteractionEnabled = YES;
        _phoneNum = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
        if ([_phoneNum isEqualToString:@"无"])
        {
            _selectIndex = -1;
            _headerView.telTextField.text = @"请输入手机号码";
            _headerView.phoneNumName .hidden = YES;
            _headerView.telTextField.text = @"";
            [_rechargeBtn setBackgroundColor:[UIColor lightGrayColor]];
            _rechargeBtn.enabled = NO;
            _moneyLab.hidden = YES;
            [self.view makeToast:@"请输入正确手机号"];
            
            [_collectionView reloadData];
        }
        else
        {
            NSString *str1 ;
            if (_phoneNum.length > 3)
            {
                str1 = [_phoneNum substringToIndex:2];
            }
            else
            {
                _selectIndex = -1;
                [self.view makeToast:@"请输入正确手机号"];
                _headerView.telTextField.text = @"请输入手机号码";
                _headerView.phoneNumName .hidden = YES;
                _headerView.telTextField.text = @"";
                [_rechargeBtn setBackgroundColor:[UIColor lightGrayColor]];
                _rechargeBtn.enabled = NO;
                _moneyLab.hidden = YES;
                [_collectionView reloadData];
                return ;
            }
            if ([str1 rangeOfString:@"86"].location == NSNotFound)
            {
            }
            else
            {
                _phoneNum = [_phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
                _phoneNum = [_phoneNum stringByReplacingOccurrencesOfString:str1 withString:@""];
                _headerView.telTextField.text = _phoneNum;
            }
            if ([_phoneNum rangeOfString:@"+86"].location == NSNotFound )
            {
                _phoneNum = [_phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
                _headerView.telTextField.text = _phoneNum;
            }
            else
            {
                _phoneNum = [_phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
                _phoneNum = [_phoneNum stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                if (_phoneNum.length == 12)
                {
                    _phoneNum = [_phoneNum substringFromIndex:1];
                }
                _headerView.telTextField.text = _phoneNum;
            }
            if (_phoneNum.length > 11)
            {
                _selectIndex = -1;
                [self.view makeToast:@"请输入正确的手机号"];
                _headerView.phoneNumName .hidden = YES;
                _headerView.telTextField.text = @"";
                [_rechargeBtn setBackgroundColor:[UIColor lightGrayColor]];
                _rechargeBtn.enabled = NO;
                _moneyLab.hidden = YES;
                
                [_collectionView reloadData];
            }
            else if(_phoneNum.length < 11)
            {
                _selectIndex = -1;
                [self.view makeToast:@"请输入正确的手机号"];
                _headerView.phoneNumName .hidden = YES;
                _headerView.telTextField.text = @"";
                [_rechargeBtn setBackgroundColor:[UIColor lightGrayColor]];
                _rechargeBtn.enabled = NO;
                _moneyLab.hidden = YES;
                
                [_collectionView reloadData];
            }
            else
            {
                if (![_phoneNum isMobile])
                {
                    _selectIndex = -1;
                    [self.view makeToast:@"请输入正确的手机号"];
                    _headerView.phoneNumName .hidden = YES;
                    _headerView.telTextField.text = @"";
                    [_rechargeBtn setBackgroundColor:[UIColor lightGrayColor]];
                    _rechargeBtn.enabled = NO;
                    _moneyLab.hidden = YES;
                    
                    [_collectionView reloadData];
                }
                else
                {
                    [self loadDataWithMobile:_phoneNum fromAB:YES];
                    
                }
            }
        }
        
    }
}

- (void)payAction:(UIButton *)sender
{
    
    if (![FNLoginBO isLogin])
    {
        return ;
    }
    
    [FNLoadingView showInView:self.view];
    [[FNRechargeBO port02]rechargeMoneyWithTotalSum:_payMoney flowno:nil company:_company provinceName:nil receiverMobile:_headerView.telTextField.text block:^(id result)
     {
         [FNLoadingView hide];
         if ([result[@"code"] integerValue] == 200)
         {
             FNPayVC *payVC = [[FNPayVC alloc]init];
             payVC.tradeCode = @"Z8003";
             payVC.isSpecialType = YES;
             payVC.orderIds = result[@"orderIdList"];
             payVC.allPrice = _payMoney;
             [self.navigationController pushViewController:payVC animated:YES];
         }
         else if([result [@"code"] integerValue ] == 500)
         {
             [UIAlertView alertViewWithMessage:result[@"desc"]];
         }
         else
         {
             [self.view makeToast:@"加载失败,请重试"];
         }
     }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_headerView.telTextField resignFirstResponder];
}
@end
