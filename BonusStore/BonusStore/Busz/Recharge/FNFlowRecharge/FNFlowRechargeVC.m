//
//  FNFlowRechargeVC.m
//  BonusStore
//
//  Created by cindy on 2017/1/13.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNFlowRechargeVC.h"
#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNFlowRechargeModel.h"
#import "FNRechargeBO.h"
#import "FNLoginBO.h"

@interface FNFlowRechargeVC ()<ABPeoplePickerNavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,FNTextFieldDelegate>
{
    FNMobileRechargeHeaderView *_headerView;
    NSString *_phoneNum;
    NSString *_company;
    NSString * _remarkName;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *countryData; //全国数据
@property (nonatomic, strong) NSMutableArray *localData;  // 本地（省内）数据
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UIButton *provinceBtn;
@property (nonatomic, strong) UILabel *provinceLab;
@property (nonatomic, strong) UIButton *countryBtn;
@property (nonatomic, strong) UILabel *countryLab;
@property (nonatomic, strong) UILabel *supportLab;
@property (nonatomic, assign) BOOL isLocalFlow;
@property (nonatomic, strong) FNFlowRechargeModel *selectedFlowModel;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation FNFlowRechargeVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    self.title = @"流量充值";
    [self setNavigaitionBackItem];
    _dataSources = [FNFlowRechargeModel mobileArray];
    _localData = [NSMutableArray array];
    _countryData = [NSMutableArray array];
    [self initHeader];
    [self collectionView];
    [self createRechargeBtn];
    [self initProvinceOrCountryView];
    _selectIndex = -1;
}

- (void)setIsLocalFlow:(BOOL)isLocalFlow
{
    _isLocalFlow = isLocalFlow;
    
    if (_isLocalFlow == YES)
    {
        _dataSources = _localData ;
    }else
    {
        _dataSources = _countryData ;
    }
    if(_dataSources.count == 0 )
    {
        _dataSources = [FNFlowRechargeModel mobileArray];
    }
    [_collectionView reloadData];
}

- (void)selectProvinceBtnAction
{
    if ([NSString isEmptyString:_headerView.telTextField.text] || ![_headerView.telTextField.text isMobile])
    {
        return;
    }
    self.isLocalFlow = YES;
    self.selectIndex = 0;
    _selectedFlowModel = _dataSources[self.selectIndex];
    [_provinceBtn setImage:[UIImage imageNamed:@"country_select_btn"] forState:UIControlStateNormal];
    _provinceLab.textColor = MAIN_COLOR_RED_ALPHA;
    [_countryBtn setImage:[UIImage imageNamed:@"country_normal"] forState:UIControlStateNormal];
    _countryLab.textColor = MAIN_COLOR_BLACK_ALPHA;
}

- (void)selectCountryBtnAction
{
    if ([NSString isEmptyString:_headerView.telTextField.text] || ![_headerView.telTextField.text isMobile])
    {
        return;
    }
    self.isLocalFlow = NO;
    self.selectIndex = 0;
    _selectedFlowModel = _dataSources[self.selectIndex];
    [_provinceBtn setImage:[UIImage imageNamed:@"country_normal"] forState:UIControlStateNormal];
    _provinceLab.textColor = MAIN_COLOR_BLACK_ALPHA;
    [_countryBtn setImage:[UIImage imageNamed:@"country_select_btn"] forState:UIControlStateNormal];
    _countryLab.textColor = MAIN_COLOR_RED_ALPHA;
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
    FNFlowRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNFlowRechargeCell class]) forIndexPath:indexPath];
    CGFloat height = 55;
    if (IS_IPHONE_5)
    {
        height = 45;
    }
    if (cell == nil)
    {
        cell = [[FNFlowRechargeCell alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-32)/2,height)];
    }
    FNFlowRechargeModel * flowModel = _dataSources[indexPath.row];
    cell.flowLab.text = [NSString stringWithFormat:@"%@",flowModel.flowName];
    if (_selectIndex == indexPath.row)
    {
        cell.bgView.backgroundColor = MAIN_COLOR_RED_ALPHA;
        cell.bgView.layer.borderWidth = 0;
        cell.flowLab.textColor = MAIN_COLOR_WHITE;
        self.selectedFlowModel = _dataSources[_selectIndex];
    }
    else
    {
        cell.bgView.backgroundColor = MAIN_COLOR_WHITE;
        cell.bgView.layer.borderWidth = 1.0;
        cell.flowLab.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5)
    {
        return CGSizeMake(90,45);
    }
    
    return CGSizeMake((kScreenWidth - 50)/3,55);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_headerView.telTextField.text isEqualToString:@"nil"]|| _headerView.telTextField.text.length < 11)
    {
        _collectionView.userInteractionEnabled = NO;
    }
    else if(_headerView.telTextField.text.length == 11)
    {
        self.selectIndex = indexPath.row;
        self.selectedFlowModel = _dataSources[_selectIndex];
        [_collectionView reloadData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length < 11 )
    {
        _moneyLab.hidden = YES;
        [self.view makeToast:@"请输入正确的手机号"];
        _headerView.phoneNumName.hidden = YES;
        _rechargeBtn.enabled = NO;
        [_rechargeBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
        _rechargeBtn.backgroundColor = [UIColor lightGrayColor];
        
    }else if(textField.text.length == 11)
    {
        if (![textField.text isMobile])
        {
            [self.view makeToast:@"请输入正确的手机号"];
            self.selectIndex = -1;
        }
        else
        {
            [self loadDataWithMobile:textField.text fromAB:NO ];
        }
    }
}


- (void)loadDataWithMobile:(NSString *)mobile fromAB:(BOOL)fromAB
{
    [FNLoadingView showInView:self.view];
    [[[FNRechargeBO port01] withOutUserInfo] mobileInfoWithMobile:mobile block:^(id result)
     {
         [FNLoadingView hide];
         [_countryData removeAllObjects];
         [_localData removeAllObjects];
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
         
         [_headerView.phoneNumName removeFromSuperview];
         NSString * support = result[@"data"][@"support"];
         
         if([support isEmpty])
         {
             _supportLab.hidden = YES;
             
         }else
         {
             _supportLab.hidden = NO;
             _supportLab.text = support;
             CGSize supportSize = [support contentSizeWithMaxWidth:kScreenWidth-30];
             _supportLab.frame = CGRectMake(0, _countryLab.y+_countryLab.height+5, kScreenWidth -30, supportSize.height);
         }
         if ([NSString isEmptyString: _headerView.telTextField.text] )
         {
             [_headerView.phoneNumName removeFromSuperview];
             
         }else
         {
             NSString *provinceTip = result[@"data"][@"province"];
             NSString *operatorTip = result[@"data"][@"operator"];
             if([NSString isEmptyString:provinceTip])
             {
                 provinceTip = @"中国";
             }
             if([operatorTip rangeOfString:@"移动"].location != NSNotFound)
             {
                 _company = @"中国移动";
                 _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@移动",provinceTip];
                 
             }else if ([operatorTip rangeOfString:@"联通"].location != NSNotFound)
             {
                 _company = @"中国联通";

                 _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@联通",provinceTip];
                 
             }else
             {
                 _company = @"中国电信";
                 _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@电信",provinceTip];
             }

             if (fromAB == YES)
             {
                 _headerView.phoneNumName.text = [NSString stringWithFormat:@"%@(%@)",_headerView.phoneNumName.text, _remarkName];
             }
             
             [_headerView addSubview:_headerView.phoneNumName];
         }
         for (NSDictionary *dict  in result[@"data"][@"flowList"])
         {
             [_countryData addObject:[FNFlowRechargeModel mj_objectWithKeyValues:dict]];
         }
         if([result[@"data"][@"localList"] isKindOfClass:[NSNull class]] || [((NSArray *)result[@"data"][@"localList"]) count] == 0)
         {
             _provinceBtn.hidden = YES;
             _provinceLab.hidden = YES;
         }else
         {
             _provinceBtn.hidden = NO;
             _provinceLab.hidden = NO;
             for (NSDictionary *dict  in result[@"data"][@"localList"])
             {
                 FNFlowRechargeModel * modle = [[FNFlowRechargeModel alloc]init];
                 modle.flowName = [dict valueForKey:@"flowName"];
                 modle.flowno = [dict valueForKey:@"flowCode"];
                 modle.pieceValue = [dict valueForKey:@"flowPrice"];
                 [_localData addObject:modle];
             }

         }
         self.isLocalFlow = NO;
         self.selectIndex = 0;
         self.selectedFlowModel = _dataSources[self.selectIndex];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length >= 11 && ![NSString isEmptyString:string])
    {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.selectIndex = -1;
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
     self.selectIndex = -1;
    
    return YES;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if(_selectIndex == -1)
    {
        _collectionView.userInteractionEnabled = NO;
        _headerView.telTextField.placeholder = @"请输入手机号";
        _headerView.phoneNumName.hidden = YES;
        [_rechargeBtn setBackgroundColor:[UIColor lightGrayColor]];
        _rechargeBtn.enabled = NO;
        _provinceBtn.hidden = YES;
        _provinceLab.hidden = YES;
        
        [_provinceBtn setImage:[UIImage imageNamed:@"country_normal"] forState:UIControlStateNormal];
        _provinceLab.textColor = MAIN_COLOR_BLACK_ALPHA;
        [_countryBtn setImage:[UIImage imageNamed:@"country_select_btn"] forState:UIControlStateNormal];
        _countryLab.textColor = MAIN_COLOR_RED_ALPHA;
        _moneyLab.hidden = YES;
        [_collectionView reloadData];
        return;
    }
    _moneyLab.hidden = NO;
    _collectionView.userInteractionEnabled = YES;
    _headerView.phoneNumName.hidden = NO;
    _selectedFlowModel = _dataSources[_selectIndex];
    NSString *moneyStr2 = [NSString stringWithFormat:@"总额: ¥ %@",_selectedFlowModel.pieceValue];
    NSMutableAttributedString * money = [moneyStr2 makeStr:_selectedFlowModel.pieceValue withColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1] andFont:[UIFont systemFontOfSize:15]];
    _moneyLab.attributedText = money;
    [_rechargeBtn setBackgroundColor:MAIN_COLOR_RED_BUTTON];
    _rechargeBtn.enabled = YES;
    
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
   _remarkName = (__bridge NSString *)ABRecordCopyCompositeName(person);
    if (property == kABPersonPhoneProperty)
    {
        ABMutableMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        int index = ABMultiValueGetIdentifierAtIndex(phone, identifier);
        
        if (index < 0)
        {
            index = 0;
        }
        _phoneNum = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
        if ([_phoneNum isEqualToString:@"无"])
        {
            self.selectIndex = -1;
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
                self.selectIndex = -1;
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
            if (_phoneNum.length != 11 ||( _phoneNum.length == 11 && ![_phoneNum isMobile]))
            {
                self.selectIndex = -1;
              
            }else
            {
                [self loadDataWithMobile:_phoneNum fromAB:YES];
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
    _rechargeBtn.enabled = NO;
    [[FNRechargeBO port02]rechargeMoneyWithTotalSum:_selectedFlowModel.pieceValue flowno:_selectedFlowModel.flowno company:_company provinceName:nil receiverMobile:_headerView.telTextField.text block:^(id result)
     {
         [FNLoadingView hide];
         _rechargeBtn.enabled = YES;
         if ([result[@"code"] integerValue] == 200)
         {
             FNPayVC *payVC = [[FNPayVC alloc]init];
             payVC.isSpecialType = YES;
             payVC.orderIds = result[@"orderIdList"];
             payVC.allPrice = self.selectedFlowModel.pieceValue;
             if([NSString isEmptyString:_company])
             {
                 //Q币
                 payVC.tradeCode = @"Z8005";
             }else
             {
                 if([NSString isEmptyString:_selectedFlowModel.flowno])
                 {
                     //话费
                     payVC.tradeCode = @"Z8003";
                 }else
                 {
                     //流量
                     payVC.tradeCode = @"Z8004";
                 }
             }
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
    [self.view endEditing:YES];
}

- (void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    [self.view endEditing:YES];
}

- (void)createRechargeBtn
{
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat margin = 20;
    if (IS_IPHONE_5)
    {
        margin = 10;
    }
    _rechargeBtn.frame = CGRectMake(16, kScreenHeight - 44- NAVIGATION_BAR_HEIGHT-margin, kScreenWidth - 32, 44);
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.layer.cornerRadius = 5.0;
    [_rechargeBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_rechargeBtn setTitleColor:MAIN_COLOR_WHITE forState:UIControlStateNormal];
    [_rechargeBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    _rechargeBtn.backgroundColor = [UIColor lightGrayColor];
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_rechargeBtn];
    _rechargeBtn.enabled = NO;
    CGFloat marginY = 10;
    if (IS_IPHONE_5)
    {
        marginY = 5;
    }
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _rechargeBtn.y-marginY-25, kScreenWidth, 25)];
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

- (void)initProvinceOrCountryView
{
    UIView *provinceView = [[UIView alloc]initWithFrame:CGRectMake(15, _collectionView.y+_collectionView.height +10, kScreenWidth - 30, 64)];
    provinceView.backgroundColor = MAIN_COLOR_WHITE;
    [self.view addSubview:provinceView];
    _countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _countryBtn.frame = CGRectMake(0, 5, 25 , 25);
    [_countryBtn setImage:[UIImage imageNamed:@"country_select_btn"] forState:UIControlStateNormal];
    [provinceView addSubview:_countryBtn];
    [_countryBtn addTarget:self action:@selector(selectCountryBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _countryLab = [[UILabel alloc]initWithFrame:CGRectMake(_countryBtn.x + _countryBtn.width+3, _countryBtn.y, provinceView.width - _countryBtn.width - 3, 25)];
    _countryLab.font = [UIFont fzltWithSize:12];
    _countryLab.textColor = MAIN_COLOR_RED_ALPHA;
    NSString *countryStr = @"全国";
    NSString *countryString = [NSString stringWithFormat:@"%@  全国可用，即时生效，当月有效",countryStr];
    _countryLab.attributedText = [countryString makeStr:countryStr withColor:MAIN_COLOR_RED_ALPHA andFont:[UIFont systemFontOfSize:16]];
    [provinceView addSubview:_countryLab];
    [_countryLab addTarget:self action:@selector(selectCountryBtnAction)];
    
    _provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _provinceBtn.frame = CGRectMake(_countryBtn.x, _countryBtn.y + _countryBtn.height+5, _countryBtn.width, _countryBtn.height);
    [_provinceBtn setImage:[UIImage imageNamed:@"country_normal"] forState:UIControlStateNormal];
    [provinceView addSubview:_provinceBtn];
    [_provinceBtn addTarget:self action:@selector(selectProvinceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _provinceBtn.hidden = YES;
    _provinceLab = [[UILabel alloc]initWithFrame:CGRectMake(_provinceBtn.x + _provinceBtn.width+3, _provinceBtn.y, _countryLab.width, 25)];
    _provinceLab.font = [UIFont fzltWithSize:12];
    _provinceLab.textColor = MAIN_COLOR_GRAY_ALPHA;
    NSString *provinceStr = @"省内";
    NSString *provinceString = [NSString stringWithFormat:@"%@  本地可用，即时生效，当月有效，价格更优",provinceStr];
    _provinceLab.attributedText = [provinceString makeStr:provinceStr withColor:MAIN_COLOR_GRAY_ALPHA andFont:[UIFont systemFontOfSize:16]];
    [provinceView addSubview:_provinceLab];
    [_provinceLab  addTarget:self action:@selector(selectProvinceBtnAction)];
    _provinceLab.hidden = YES;
    _supportLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _provinceLab.y+_provinceLab.height+5, kScreenWidth -30, 25)];
    _supportLab.font = [UIFont fzltWithSize:12];
    _supportLab.textColor = MAIN_COLOR_GRAY_ALPHA;
    _supportLab.textAlignment = NSTextAlignmentLeft;
    _supportLab.numberOfLines = 0;
    [provinceView addSubview:_supportLab];
    provinceView.frame = CGRectMake(16,  _collectionView.y+_collectionView.height +10, kScreenWidth-32, _supportLab.y+_supportLab.height);
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
        NSUInteger count =  (_dataSources.count%3) ?(_dataSources.count/3 +1): (_dataSources.count/3);
        CGFloat height = 55+15;
        if (IS_IPHONE_5)
        {
            height = 45+10;
        }
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(15,_headerView.y+_headerView.height,kScreenWidth - 30, count*height)collectionViewLayout:flowLayOut];
        [_collectionView registerClass:[FNFlowRechargeCell class] forCellWithReuseIdentifier:NSStringFromClass([FNFlowRechargeCell class])];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = MAIN_COLOR_WHITE;
        _collectionView.userInteractionEnabled = NO;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
