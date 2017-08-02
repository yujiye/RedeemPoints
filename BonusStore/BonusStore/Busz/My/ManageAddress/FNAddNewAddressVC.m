//
//  FNAddNewAddressVC.m
//  BonusStore
//
//  Created by qingPing on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//
#import "FNAddNewAddressVC.h"
#import "FNAddressTableViewCell.h"
#import "FNHeader.h"
#import "FNAreaModel.h"
#import "FNMyBO.h"
#import "FNProvinceModel.h"
#import "FNUserAccountArgs.h"
#import "UIView+Toast.h"
#import "FNAreaArgs.h"
#import "FNManageAddressVC.h"
#import "NSString+Cate.h"
#import "FNCityModel.h"
#import "FNTextField.h"
#import "FNCountyModel.h"

typedef enum : NSUInteger {
    KCellTextFieldName,
    KCellTextFieldTelephone,
    KCellTextFieldAddress,
    KCellTextFieldDetailAddress,
} KCellTextField;

@interface FNAddNewAddressVC () <UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    BOOL _isSaveBtnEnable;
}
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIButton *determineButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIPickerView *pickview;
@property (nonatomic, strong) NSArray *provincesList; // 省列表
@property (nonatomic, strong) NSArray *citysList;    // 市列表
@property (nonatomic, strong) NSArray *countyList;    // 镇或者区列表
@property (nonatomic, copy) NSString *provinceName; // 选择的省
@property (nonatomic,assign)int provinceId; // 省ID
@property (nonatomic, copy) NSString *cityName; // 选择的市
@property (nonatomic,assign)int cityId; // 市ID
@property (nonatomic, copy) NSString *countryName; // 选择的区
@property (nonatomic,assign)int countryId; // 区ID
@property (nonatomic,weak)UIButton * defaultBtn; //默认
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView *defaultView;



@end

@implementation FNAddNewAddressVC


- (NSArray *)provincesList
{
    if(_provincesList ==nil)
    {
        _provincesList = [FNProvinceModel provinceArray];
    }
    return _provincesList;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if(_isEdit)
    {
        self.title = @"编辑收货地址";
    }else
    {
        self.title = @"添加收货地址";
        self.addressModel = [[FNAddressModel alloc]init];
    }
    
    if(self.isFirstAddress == YES)
    {
        self.addressModel.isDefault = 1;
        self.defaultBtn.enabled = NO;
    }
    [self setNavigaitionBackItem];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.defaultView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(determineButtonAction)];
    [self.view addGestureRecognizer:tap];
    
    [self addNewAddress];
    if(self.isEdit == YES)
    {
        self.saveBtn.backgroundColor = [UIColor redColor];
        _isSaveBtnEnable = YES;
        self.saveBtn.enabled = YES;
        self.provinceId = self.addressModel.provinceId;
        self.provinceName = self.addressModel.provinceName;
        self.cityId = self.addressModel.cityId;
        self.cityName = self.addressModel.cityName;
        self.countryId = self.addressModel.countyId;
        self.countryName =  self.addressModel.countyName;
        
    }else
    {
        self.saveBtn.backgroundColor = [UIColor grayColor];
        _isSaveBtnEnable = NO;
        self.saveBtn.enabled = NO;
    }
    
    _dateView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 243)];
    _dateView.backgroundColor = UIColorWithRGB(240.0, 240.0, 240.0);
    _pickview = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 43, kScreenWidth, 200)];
    _pickview.backgroundColor = [UIColor whiteColor];
    _pickview.dataSource = self;
    _pickview.delegate = self;
    [_dateView addSubview:self.pickview];
    [self.view addSubview:_dateView];
    [_dateView addSubview:self.determineButton];
    [_dateView addSubview:self.cancelButton];
    
}

- (void)cancleButtonClick
{
    [self.view endEditing:YES];
}

- (void)doneButtonClick
{
    [self.view endEditing:YES];
}

- (void)determineButtonAction
{
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, kScreenHeight , kScreenWidth, 40);
    }];
    FNAddressTableViewCell * cell =  self.scrollView.subviews[2];
    NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@",self.provinceName, self.cityName,self.countryName];
    addressStr = [addressStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    cell.detailField.text = addressStr;
    
    self.addressModel.provinceName = self.provinceName;
    self.addressModel.provinceId = self.provinceId;
    self.addressModel.cityName = self.cityName;
    self.addressModel.cityId = self.cityId;
    self.addressModel.countyName = self.countryName;
    self.addressModel.countyId = self.countryId;
    
    if([NSString isEmptyString:self.addressModel.receiverName]||[NSString isEmptyString:self.addressModel.mobile]||[NSString isEmptyString:self.addressModel.address]||[NSString isEmptyString:self.addressModel.provinceName]||[NSString isEmptyString:self.addressModel.cityName]||[NSString isEmptyString:self.addressModel.countyName]||[NSString isEmptyString:self.addressModel.address] )
    {
        self.saveBtn.enabled = NO;
        _isSaveBtnEnable = NO;
        self.saveBtn.backgroundColor = UIColorWithRGB(167.0, 170.0, 166.0);
    }else
    {
        self.saveBtn.enabled = YES;
        _isSaveBtnEnable =YES;
        self.saveBtn.backgroundColor = [UIColor redColor];
    }
}

- (UIToolbar *)keyToolbar
{
    
    UIToolbar *keyToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    keyToolbar.barTintColor =  [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.5];
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
    UIBarButtonItem * doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClick)];
    UIBarButtonItem  *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    keyToolbar.items = [NSArray arrayWithObjects:cancleButton,spaceButtonItem,doneButtonItem,nil];
    
    return keyToolbar ;
}


- (void)addressSelecte:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.isSelected)
    {
        [btn setImage:[UIImage imageNamed:@"address _select"] forState:UIControlStateNormal];
        self.addressModel.isDefault = 1;
    }else
    {
        [btn setImage:[UIImage imageNamed:@"address _not_select"] forState:UIControlStateNormal];
        self.addressModel.isDefault = 0;
    }
}

- (void )addNewAddress
{
    self.saveBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    self.saveBtn.backgroundColor = UIColorWithRGB(167.0, 170.0, 166.0);
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    self.saveBtn.enabled = NO;
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    self.saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.saveBtn setFrame:CGRectMake(0, kScreenHeight - 44-64, kScreenWidth, 44)];
    [self.saveBtn addTarget:self action:@selector(saveNewAddress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.saveBtn];
}

- (void)saveNewAddress
{
    if(_isSaveBtnEnable == NO)
    {
        return;
    }
    
    _isSaveBtnEnable = NO;
    
    if (![self.addressModel.mobile isMobile])
    {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    self.addressModel.address =  [self.addressModel.address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.addressModel.address.length < 7 )
    {
        [self.view makeToast:@"详细地址请输入7-40个字符"];
        return;
    }
    
    if(self.isEdit)
    {
        
        [FNMyBO updateAddrWithUser:self.addressModel block:^(id result) {
            if ([result[@"code"] integerValue] == 200)
            {
                [self.view makeToast:@"更改地址成功"];
                if(self.addressModel.isDefault == 1)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"editAddressIsDefault" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.addressModel,@"editAddressIsDefault", nil]];
                    
                }else
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"editAddress" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.addressModel,@"editAddress", nil]];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [self.view makeToast:@"更改地址失败"];
            }
        }];
    }else
    {
        [FNMyBO addAddrWithUser:self.addressModel  block:^(id result) {
            if ([result[@"code"] integerValue] == 200)
            {
                [self.view makeToast:@"添加地址成功"];
                self.addressModel.id = ([result[@"addressId"] intValue]);
                
                // 添加的是第一个地址
                if (self.isFirstAddress == YES)
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"addFirstAddress" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.addressModel,@"addFirstAddress", nil]];
                    
                }else
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"addAddress" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.addressModel,@"addAddress", nil]];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }else
            {
                if(result)
                {
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
            }
            
        }];
        
    }
}


- (void)commonBtnClick
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, kWindowHeight-243-44, kScreenWidth,  243);
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dateView.mas_top).offset(0);
            make.left.mas_equalTo(self.view.mas_left).offset(15);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
        [self.determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dateView.mas_top).offset(0);
            make.right.mas_equalTo(self.view.mas_right).offset(-15);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
    }];
    if( self.isEdit == NO )
    {
        if([NSString isEmptyString:self.provinceName])
        {
            FNProvinceModel *provinceModel = self.provincesList.firstObject;
            self.provinceName = provinceModel.name;
            self.provinceId = provinceModel.id;
            FNCityModel *cityModel = provinceModel.cityList.firstObject;
            self.cityName = cityModel.name;
            self.cityId = cityModel.id;
            FNCountyModel * countyModel = cityModel.countyList.firstObject;
            self.countryId = countyModel.id;
            self.countryName = countyModel.name;
        }
    }
}

#pragma mark - pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 返回每一列包含的行书u
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.provincesList.count;
        
    }else if (component == 1)
    {
        NSInteger proIndex = [pickerView selectedRowInComponent:0];
        self.citysList = [self.provincesList[proIndex] cityList];
        return  self.citysList.count;
    }else
    {
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
        self.countyList = [self.citysList[cityIndex] countyList];
        return self.countyList.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [self.provincesList[row] name];
        
    }else if (component ==1)
    {
        return [self.citysList[row] name];
        
    }else
    {
        return [self.countyList[row] name] ;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        FNProvinceModel *provinceModel = self.provincesList[row];
        self.provinceName = provinceModel.name;
        self.provinceId = provinceModel.id;
        self.citysList = provinceModel.cityList;
        FNCityModel *cityModel = self.citysList.firstObject;
        self.cityName = cityModel.name;
        self.cityId  = cityModel.id;
        FNCountyModel *countyModel = cityModel.countyList.firstObject;
        self.countryName = countyModel.name;
        self.countryId= countyModel.id;
        [self.pickview reloadComponent:1];
        [self.pickview reloadComponent:2];
        FNAddressTableViewCell * cell =  self.scrollView.subviews[2];
        NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@",self.provinceName, self.cityName,self.countryName];
        addressStr = [addressStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        cell.detailField.text = addressStr;
        
        
    }else if(component ==1)
    {
        FNCityModel *cityModel = self.citysList[row];
        self.cityName = cityModel.name;
        self.cityId = cityModel.id;
        FNCountyModel * coutyModel = cityModel.countyList.firstObject;
        self.countryId = coutyModel.id;
        self.countryName = coutyModel.name;
        [self.pickview reloadComponent:2];
        FNAddressTableViewCell * cell =  self.scrollView.subviews[2];
        NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@",self.provinceName, self.cityName,self.countryName];
        addressStr = [addressStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        cell.detailField.text = addressStr;
        
    }else
    {
        FNCountyModel * countyModel = self.countyList[row];
        self.countryName = countyModel.name;
        self.countryId  = countyModel.id;
        FNAddressTableViewCell * cell =  self.scrollView.subviews[2];
        NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@",self.provinceName, self.cityName,self.countryName];
        addressStr = [addressStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        cell.detailField.text = addressStr;
        
    }
}

//设置行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

#pragma mark textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length + string.length;
//  
//    if(textField.tag == KCellTextFieldName )
//    {
//        
//        if(textField.text.length >14 && ![NSString isEmptyString:string])
//        {
//            [textField resignFirstResponder];
//            [self.view makeToast:@"请输入正确的名字"];
//            return NO;
//        }else
//        {
//            return YES;
//        }
//    }
    
    if(textField.tag == KCellTextFieldTelephone && num > 11)
    {
        [self.view makeToast:@"国内手机号最多输入11位"];
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case KCellTextFieldName:
        {
            if(textField.text.length >15)
            {
                textField.text = [textField.text substringToIndex:15];
                self.addressModel.receiverName = textField.text;
            }else
            {
                self.addressModel.receiverName = textField.text;

            }
        }
            break;
        case KCellTextFieldTelephone:
        {
            if([textField.text isMobile])
            {
                self.addressModel.mobile = textField.text;
                
            }else{
                self.addressModel.mobile = textField.text;
                [self.view makeToast:@"请输入正确的手机号码"];
            }
        }
            break;
        case KCellTextFieldAddress:
        {
            
        }
            break;
            
        case KCellTextFieldDetailAddress:
        {
            if(textField.tag == KCellTextFieldDetailAddress)
            {
                textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (textField.text.length >40)
                {
                    textField.text = [textField.text substringToIndex:40];
                }
                self.addressModel.address = textField.text;
                
            }
            
        }
            break;
        default:
            break;
    }
    if([NSString isEmptyString:self.addressModel.receiverName]||[NSString isEmptyString:self.addressModel.mobile]||[NSString isEmptyString:self.addressModel.address]||[NSString isEmptyString:self.addressModel.provinceName]||[NSString isEmptyString:self.addressModel.cityName]||[NSString isEmptyString:self.addressModel.countyName]||[NSString isEmptyString:self.addressModel.address] )
    {
        self.saveBtn.enabled = NO;
        _isSaveBtnEnable = NO;
        self.saveBtn.backgroundColor = UIColorWithRGB(167.0, 170.0, 166.0);
    }else
    {
        self.saveBtn.enabled = YES;
        _isSaveBtnEnable = YES;
        self.saveBtn.backgroundColor = [UIColor redColor];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if(textField.tag == KCellTextFieldName||textField.tag == KCellTextFieldTelephone||textField.tag == KCellTextFieldDetailAddress)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.dateView.frame = CGRectMake(0, kScreenHeight , kScreenWidth, 40);
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (UIButton *)cancelButton
{
    
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:17];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorWithRGB(0.0, 122.0, 255.0) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(determineButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)determineButton
{
    if (!_determineButton) {
        _determineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _determineButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:17];
        [_determineButton setTitleColor:UIColorWithRGB(0.0, 122.0, 255.0) forState:UIControlStateNormal];
        [_determineButton setTitle:@"确定" forState:UIControlStateNormal];
        [_determineButton addTarget:self action:@selector(determineButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;
}

- (UIView *)defaultView
{
    if (_defaultView ==nil)
    {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 176, kScreenWidth, kScreenHeight)];
        UIButton *defaultBtn = [[UIButton alloc]init];
        self.defaultBtn = defaultBtn;
        if(self.isFirstAddress == YES)
        {
            defaultBtn.enabled = NO;
            defaultBtn.selected = YES;
        }
        
        if(self.addressModel.isDefault == 1)
        {
            defaultBtn.selected = YES;
            [defaultBtn setImage:[UIImage imageNamed:@"address _select"] forState:UIControlStateNormal];
        }else
        {
            defaultBtn.selected = NO;
            [defaultBtn setImage:[UIImage imageNamed:@"address _not_select"] forState:UIControlStateNormal];
        }
        
        [defaultBtn addTarget:self action:@selector(addressSelecte:) forControlEvents:UIControlEventTouchUpInside];
        defaultBtn.frame = CGRectMake(15, 14, 16, 16);
        [_defaultView addSubview:defaultBtn];
        
        CGFloat labelX = CGRectGetMaxX(defaultBtn.frame);
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(labelX, 0, kScreenWidth-labelX, 44);
        label.text = @"  设为默认地址";
        [label clearBackgroundWithFont:[UIFont systemFontOfSize:12] textColor:UIColorWithRGB(30.0, 30.0, 30.0)];
        [_defaultView addSubview:label];
    }
    return _defaultView;
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        for (int i=0; i<4; i++)
        {
            if(i == 0)
            {
                FNAddressTableViewCell * cell = [[FNAddressTableViewCell alloc]init];
                cell.frame = CGRectMake(0, 0, kScreenWidth, 44);
                cell.detailField.tag = KCellTextFieldName;
                cell.detailField.returnKeyType = UIReturnKeyDone;
                cell.detailField.enablesReturnKeyAutomatically = YES;
                cell.detailField.delegate = self;
                cell.introduceLabel.text = @"   收货人:";
                if([NSString isEmptyString:self.addressModel.receiverName])
                {
                    NSString * commentStr = @"收货人姓名在15字以内";
                    NSMutableAttributedString *commentAttribute = [commentStr makeStr:@"收货人姓名在15字以内" withColor: UIColorWithRGBA(152.0, 152.0 ,152.0, 0.7) andFont:[UIFont systemFontOfSize:13]];
                    cell.detailField.attributedPlaceholder = commentAttribute;
                    
                }else
                {
                    cell.detailField.text = self.addressModel.receiverName;
                }

                [_scrollView addSubview:cell];
                
            }else if (i == 1)
            {
                FNAddressTableViewCell * cell = [[FNAddressTableViewCell alloc]init];
                cell.frame = CGRectMake(0,44, kScreenWidth, 44);
                cell.detailField.tag = KCellTextFieldTelephone;
                cell.detailField.inputAccessoryView = [self keyToolbar];
                cell.detailField.keyboardType = UIKeyboardTypeNumberPad;
                cell.detailField.delegate = self;
                cell.introduceLabel.text = @"   手机号码:";
                cell.detailField.text = self.addressModel.mobile;
                [_scrollView addSubview:cell];
                
            }else if(i == 2)
            {
                FNAddressTableViewCell * cell = [[FNAddressTableViewCell alloc]init];
                cell.frame = CGRectMake(0,44*2, kScreenWidth, 44);
                cell.detailField.tag = KCellTextFieldAddress;
                cell.detailField.delegate = self;
                cell.introduceLabel .text = @"   地址选择:";
                cell.btn.hidden = NO;
                cell.image1.hidden = NO;
                [cell.btn addTarget:self action:@selector(commonBtnClick) forControlEvents:UIControlEventTouchUpInside];
                if([NSString isEmptyString:self.addressModel.provinceName]&&[NSString isEmptyString:self.addressModel.cityName] &&[NSString isEmptyString:self.addressModel.countyName])
                {
                    NSString * commentStr = @"请选择城市";
                    NSMutableAttributedString *commentAttribute = [commentStr makeStr:@"请选择城市" withColor: UIColorWithRGBA(152.0, 152.0 ,152.0, 0.7) andFont:[UIFont systemFontOfSize:13]];
                    cell.detailField.attributedPlaceholder = commentAttribute;
                }
                else
                {
                    self.provinceName = self.addressModel.provinceName;
                    self.cityName = self.addressModel.cityName;
                    self.countryName = self.addressModel.countyName;
                    NSString *addressStr = [NSString stringWithFormat:@"%@ %@ %@",self.addressModel.provinceName, self.addressModel.cityName,self.addressModel.countyName];
                    addressStr = [addressStr stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                    cell.detailField.text = addressStr;
                }
                [_scrollView addSubview:cell];
                
            }else
            {
                FNAddressTableViewCell * cell = [[FNAddressTableViewCell alloc]init];
                cell.frame = CGRectMake(0,44*3, kScreenWidth, 44);
                cell.detailField.tag = KCellTextFieldDetailAddress;
                cell.detailField.delegate = self;
                cell.detailField.returnKeyType = UIReturnKeyDone;
                cell.detailField.enablesReturnKeyAutomatically = YES;
                cell.introduceLabel.text = @"   详细地址:";
                if([NSString isEmptyString:self.addressModel.address])
                {
                    NSString * commentStr = @"详细地址请输入7-40个字符";
                    NSMutableAttributedString *commentAttribute = [commentStr makeStr:@"详细地址请输入7-40个字符" withColor: UIColorWithRGBA(152.0, 152.0 ,152.0, 0.7) andFont:[UIFont systemFontOfSize:13]];
                    cell.detailField.attributedPlaceholder = commentAttribute;
                    
                }else
                {
                    cell.detailField.text = self.addressModel.address;
                }
                [_scrollView addSubview:cell];
            }
        }
        
    }
    return _scrollView;
}

// 判断字符串为6～12位“字符”
- (BOOL)isValidateName:(NSString *)name
{
    NSUInteger  character = 0;
    for(int i = 0; i < [name length];i++){
        int a = [name characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    
    if (character >0 && character <=20) {
        return YES;
    }else{
        return NO;
    }
    
}
@end
