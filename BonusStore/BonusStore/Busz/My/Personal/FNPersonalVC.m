//
//  FNPersonalData.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//
#import "FNPersonalVC.h"

#import "FNPersonalCell1.h"

#import "FNPersonalCell2.h"

#import "NSString+Cate.h"

#import "CALayer+Cate.h"

#import "FNUserAccountArgs.h"

#import "UIView+Toast.h"

#import "FNMyBO.h"

#import "FNImagePickerController.h"

@interface FNPersonalVC ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,FNImagePickerControllerDelegate,UIImagePickerControllerDelegate>
{
    NSData *data;
    
    NSString *_nameL;
    
    NSString *_sexL;
    
    NSString *_headImage;
    
    NSString *_birthday;
    
    NSString *today;
    
    NSString *birthdayString;
    
    NSString *dateStr;
    
    UIView *labelView;

    //yyyy-MM-dd
    NSDateFormatter *formatterYear;
    
    NSDateFormatter *formatterToday;
    
    NSDateFormatter *formatterMonth;
    
    NSDateFormatter *formatterDay;
    
    //todayData
    NSString *todayYear;
    
    NSString *todayMonth;
    
    NSString *todyDay;
    
    //selectDate
    NSString *selectYear;
    
    NSString *selectMonth;
    
    NSString *selectDay;
    
    BOOL _isChanged;     //is personal info changed.
    
    NSFileManager * fileManager;
    //other
    UIImageView *imageV;
}
@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIActionSheet *imageActionSheet;

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UIView *dateView;

@property (nonatomic,strong)UIView * clearView;

@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, strong) UILabel *birthdayLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *determineButton;

@property (nonatomic, strong) NSMutableArray *monthArray;

@property (nonatomic, strong) NSMutableArray *yearArray;

@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, copy)   NSString *timeSelectedString;

@property (nonatomic, copy)   NSString *year;

@property (nonatomic, copy)   NSString *month;

@property (nonatomic, copy)   NSString *day;

@end

@implementation FNPersonalVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人资料";
    
    formatterToday = [[NSDateFormatter alloc] init];
    
    [formatterToday setDateFormat:@"yyyy-MM-dd"];
    
    today = [formatterToday stringFromDate:[NSDate date]];
    
    formatterYear = [[NSDateFormatter alloc]init];
    
    [formatterYear setDateFormat:@"yyyy"];
    
    todayYear = [formatterYear stringFromDate:[NSDate date]];
    
    formatterMonth = [[NSDateFormatter alloc] init];
    
    [formatterMonth setDateFormat:@"MM"];
    
    todayMonth = [formatterMonth stringFromDate:[NSDate date]];
    
    formatterDay = [[NSDateFormatter alloc] init];
    
    [formatterDay setDateFormat:@"dd"];
    
    todyDay = [formatterDay stringFromDate:[NSDate date]];

    [self tableview];
    
    [self initDateView];
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    
    self.dataSources = [NSMutableArray array];
    
    _birthdayLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 106), 5, 90, 40)];
    
    _birthdayLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
    
    if (![_dataSources count])
    {
        [FNLoadingView showInView:self.view];
        
        [[FNMyBO port02] getUserInfoWithBlock:^(id result) {
            
            [FNLoadingView hideFromView:self.view];
            
            if (![result isKindOfClass:[NSArray class]])
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
            [_dataSources addObjectsFromArray:result];
            
            _model = _dataSources.firstObject;
            
            [self.tableview reloadData];
            
        }];
    }
    self.titleArray = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"出生日期", nil];
    
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,7,13 )];
    
    imageV.image = [UIImage imageNamed:@"cart_order"];
    
    self.day = todyDay;
    
    self.month = todayMonth;
    
    self.year = todayYear;
    
    self.timeSelectedString = [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
    
    int month = [todayMonth intValue];
    
    int year = [todayYear intValue];
    
    int day = [todyDay intValue];
    
    [self.pickView selectRow:day-1 inComponent:2 animated:YES];
    
    [self.pickView selectRow:month-1 inComponent:1 animated:YES];
    
    [self.pickView selectRow:year-1900 inComponent:0 animated:YES];
    
    [self.view addSubview:self.dateView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.anyObject.view == _dateView)
    {
    
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.clearView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        }];
    }
}
- (void)createButton
{
    UIButton * alter = [UIButton buttonWithType:UIButtonTypeSystem];
    
    alter.frame = CGRectMake(0, kScreenHeight - 64 - 48, kScreenWidth, 48);
    
    [alter setTitle:@"确认修改" forState:UIControlStateNormal];
    
    [alter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    alter.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:17];
    
    [alter setBackgroundColor:MAIN_COLOR_RED_BUTTON];
    
    [self.view addSubview:alter];
}

- (void)createPickerView
{
   
    
}

-(UIView *)clearView
{
    if(!_clearView)
    {
        _clearView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        [_clearView addSubview:self.dateView];
        _clearView.backgroundColor =[UIColor clearColor];
        
    }
    return _clearView;
}

- (void)initDateView
{
    _dateView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight*2-243, kScreenWidth, 243)];
    
    _dateView.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:0.5];
    
    [_dateView addSubview:self.determineButton];
    
    [_dateView addSubview:self.cancelButton];
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 43, kScreenWidth, 200)];
    
    _pickView.backgroundColor = [UIColor whiteColor];
    
    _pickView.dataSource = self;
    
    _pickView.delegate = self;

    
    [_dateView addSubview:self.pickView];
}

-(UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _cancelButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:18];
        
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [_cancelButton setTitleColor:[UIColor colorWithRed:69.0/255 green:143.0/255 blue:251.0/255 alpha:1] forState:UIControlStateNormal];
        
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIButton *)determineButton
{
    if (!_determineButton)
    {
        
        _determineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _determineButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:18];
        
        [_determineButton setTitleColor:[UIColor colorWithRed:69.0/255 green:143.0/255 blue:251.0/255 alpha:1] forState:UIControlStateNormal];
        
        [_determineButton setTitle:@"确定" forState:UIControlStateNormal];
        
        [_determineButton addTarget:self action:@selector(determineButtonActions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;
}

- (void)cancelButtonAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.clearView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

- (void)determineButtonActions
{
    _isChanged = YES;
    
    if ([selectYear intValue] < [todayYear intValue])
    {
        _birthdayLabel.text = _timeSelectedString;
        
        _model.birthday = _birthdayLabel.text;
    }
    else if ([selectYear intValue] == [todayYear intValue])
    {
        if ([selectMonth  intValue]<[todayMonth intValue])
        {
            _birthdayLabel.text = _timeSelectedString;
            
            _model.birthday = _timeSelectedString;
        }
        
        else if ([ selectMonth  intValue]== [todayMonth intValue])
        {
            if ([selectDay intValue] == [todyDay intValue])
            {
                _birthdayLabel.text = today;
                
                _model.birthday = today;
            }
            else if ([selectDay  intValue]< [todyDay intValue])
            {
                _birthdayLabel.text = self.timeSelectedString;
                
                _model.birthday = self.timeSelectedString;
            }
            else if ([selectDay intValue]>[ todyDay intValue])
            {
                _birthdayLabel.text = today;
                
                _model.birthday = today;
                
                [self.view makeToast:@"请选择正确的时间"];
            }
        }
        else if([selectMonth intValue] == [todayMonth intValue] && [selectDay intValue] == [todyDay intValue])
        {
            _birthdayLabel.text = _timeSelectedString;
            
            _model.birthday = _timeSelectedString;
        }
        else if ([selectMonth intValue] > [todayMonth intValue])
        {
            _birthdayLabel.text = today;
            
            _model.birthday = today;
            
            [self.view makeToast:@"请选择正确的时间"];
        }
    }
    else
    {
        _birthdayLabel.text = today;
        
        _model.birthday = today;
    }
    
    [FNLoadingView showInView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[FNMyBO port02] updateUser:_model block:^(id result) {
            [FNLoadingView hideFromView:self.view];
            
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
        }];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        self.clearView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
    
    
}
- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
        
        [_tableview registerClass:[FNPersonalCell1 class] forCellReuseIdentifier:NSStringFromClass([FNPersonalCell1 class])];
        
        _tableview.tableFooterView = [[UIView alloc]init];
        
        _tableview.scrollEnabled = YES;
        
        _tableview.dataSource = self;
        
        _tableview.delegate = self;
        
        [self.view addSubview:_tableview];
    }
    return _tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * cellID = @"cellID";
        
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    FNPersonalCell1 * cell1 = [FNPersonalCell1 headCell:tableView];
    
    FNPersonalCell2 * cell2 = [FNPersonalCell2 sexCell:tableView];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    switch (indexPath.row) {
        case 0:
            cell1.textLabel.text = _titleArray[0];
            
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell1.headImage.tag = 4;
            
            [cell1.headImage sd_setImageWithURL:IMAGE_ID(_model.favImg) placeholderImage:[UIImage imageNamed:@"avatar_default"]];
            
            [cell1 addTarget:self action:@selector(openC)];
            
            return cell1;
            
            break;
        case 1:
            cell2.textLabel.text = _titleArray[1];
            
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if ([NSString isEmptyString:_model.userName])
            {
                cell2.sexLabel.text = [NSString stringWithFormat:@"%ld",(long)[_model.mobile integerValue]];
            }
            else
            {
                cell2.sexLabel.text =  _model.userName;
            }
            
            cell2.sexLabel.tag = 2;
            
            return cell2;
            
            break;
        case 2:
            cell2.textLabel.text = _titleArray[2];
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell2.sexLabel.tag = 3;
     
            cell2.sexLabel.text = [_model getGenderBySex:_model.sex];
            return cell2;
            break;
        case 3:
            
            cell.textLabel.text = _titleArray[3];
            
            cell.accessoryView = _birthdayLabel;
            if ([NSString isEmptyString:_model.birthday])
            {
                _birthdayLabel.text = @" ";
            }
            else
            {
                birthdayString = _model.birthday;
                
                birthdayString = [birthdayString substringToIndex:10];
                
                _birthdayLabel.text = birthdayString;
                
            }
            [cell.contentView addSubview:_birthdayLabel];
            
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)openC
{
    _imageActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册中获取", nil];
    
    [_imageActionSheet showInView:self.view];
    
}

#pragma mark - actionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == _imageActionSheet.cancelButtonIndex)
    {

    }
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self localPhoto];
        default:
            break;
    }
}
- (void)takePhoto
{
    FNImagePickerController * picker = [[FNImagePickerController alloc] init];
    
    picker.imageDelegate = self;
    
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)localPhoto
{
    FNImagePickerController * photo = [[FNImagePickerController alloc] init];
    
    photo.navigationBar.translucent = NO;
    
    [photo.viewControllers lastObject].automaticallyAdjustsScrollViewInsets = NO;
    
    photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    photo.imageDelegate = self;
    
    photo.allowsEditing = YES;
    
    [self presentViewController:photo animated:YES completion:nil];
    
}

- (void)imageWithModel:(FNImagePickerController *)imagePickerController
{
    
    if ((imagePickerController.data.length/(1024.0*1024.0))>1.0 )
    {
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"选择图片大于2M,是否要压缩上传" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {
                
                data = UIImageJPEGRepresentation(imagePickerController.image, (1.0*1024.0*1024.0)/imagePickerController.data.length);
                
                fileManager = [NSFileManager defaultManager];
                
                [fileManager createDirectoryAtPath:imagePickerController.path withIntermediateDirectories:YES attributes:nil error:nil];
                
                [fileManager createFileAtPath:[imagePickerController.path stringByAppendingString:@"/image.png"] contents:data attributes:nil];
                
                _model.favImgPath = [[NSString alloc]initWithFormat:@"%@%@",imagePickerController.path,@"/image.png"];
                
                [FNLoadingView showInView:self.view];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [[FNMyBO port30] uploadImage:_model.favImgPath block:^(id result) {
                        [FNLoadingView hideFromView:self.view];
                        
                        if ([result[@"result"] integerValue] != 1)
                        {
                            return ;
                        }
                        
                        _model.favImg = result[@"title"];
                        
                        [[FNMyBO port02] updateUser:_model block:^(id result) {
                            
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
                            else
                            {
                                [UIAlertView alertViewWithMessage:@"头像上传成功"];
                                [_tableview reloadData];
                            }
                        }];
                    }];
                });
            }
        } otherTitle:@"取消", nil];
    }
    else
    {
        [FNLoadingView showInView:self.view];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[FNMyBO port30] uploadImage:imagePickerController.model.favImgPath block:^(id result) {
                
                [FNLoadingView hideFromView:self.view];
                
                if ([result[@"result"] integerValue] != 1)
                {
                    return ;
                }
                
                _model.favImg = result[@"title"];
                
                [[FNMyBO port02] updateUser:_model block:^(id result) {
                    
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
                    else
                    {
                        [UIAlertView alertViewWithMessage:@"头像上传成功"];
                        [_tableview reloadData];
                    }
                }];
            }];
        });
    }
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 74;
    }
    else
    {
        return 50;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1)
    {
        
        UILabel * nameLabel = (UILabel *)[self.view viewWithTag:2];
        
        FNNameVC * nameVC = [[FNNameVC alloc]init];
        
        nameVC.name = _model.userName;
        
        nameVC.nameBlock = ^(FNPersonalModel * model){
            
            nameLabel.text = [NSString stringWithFormat:@"%@",model.userName];
            
            _model.userName = nameLabel.text;
            
            _isChanged = YES;
            
        };
        
        if (self.nameBlock != nil) {
            self.nameBlock(nameLabel.text);
        }
        [self.navigationController pushViewController:nameVC animated:YES];
    }
    
    if (indexPath.row == 2) {
        
        UILabel * sexLabel = (UILabel *)[self.view viewWithTag:3];
        
        FNSexVC * sexVC = [[FNSexVC alloc]init];
        
        sexVC.sex = ((sexLabel.text.length > 0) ? (sexLabel.text) : [_model getGender]);
        
        sexVC.sexBlock = ^(NSInteger sex){
            
            sexLabel.text = [_model getGenderBySex:sex];
            
            _model.sex = sex;
            
            _isChanged = YES;
        };
        
        [self.navigationController pushViewController:sexVC animated:YES];
    }
    if (indexPath.row == 3)
    {
        
        
        [self.view addSubview:self.clearView];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.clearView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            
            self.dateView.frame = CGRectMake(0, kScreenHeight - 306, kScreenWidth,  243);
            
            self.cancelButton.frame = CGRectMake(0, 10, 60, 30);
            
            self.determineButton.frame = CGRectMake(kScreenWidth - 60, 10, 60, 30);
        }];
    }
}

- (void)returnText:(NameTextBlock)block
{
    self.nameBlock = block;
}

#pragma mark - pickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.year = self.yearArray[row];
    }
    else if (component == 1) {
        self.month = self.monthArray[row];
    }
    else if (component == 2) {
        self.day = self.dayArray[row];
    }
    
    self.timeSelectedString = [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
    
    selectMonth = [NSString stringWithFormat:@"%@",self.month];
    
    selectDay = [NSString stringWithFormat:@"%@",self.day];
    
    selectYear = [NSString stringWithFormat:@"%@",self.year];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
    {
        return self.yearArray.count;
    }
    else if (component == 1)
    {
        return 12;
    }
    else if(component == 2)
    {
        return self.dayArray.count;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component == 0) {
        return 48;
    }
    if (component == 1) {
        return 45;
    }
    if (component == 2) {
        return 48;
    }
    return 0;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
    {
        return  self.yearArray[row];
    }
    else if (component == 1)
    {
        return  self.monthArray[row];
    }
    return self.dayArray[row];
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0)
    {
        return  self.view.frame.size.width/3;
    } else if(component==1)
    {
        return  self.view.frame.size.width/3;
    }
    return  self.view.frame.size.width/3;
}

-(NSMutableArray *)yearArray
{
    if (!_yearArray)
    {
        self.yearArray = [NSMutableArray array];
        
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        
        [formatter3 setDateFormat:@"yyyy"];
        
        NSString *yearStr = [formatter3 stringFromDate:[NSDate date]];
        
        for (int i = 1900; i<[yearStr integerValue] + 1; i++)
        {
            
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [self.yearArray addObject:str];
        }
    }
    return _yearArray;
}
-(NSMutableArray *)monthArray
{
    if (!_monthArray)
    {
        self.monthArray = [NSMutableArray array];
        
        for (int i = 1; i<13; i++)
        {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [self.monthArray addObject:str];
        }
    }
    return _monthArray;
}

- (NSMutableArray *)dayArray
{
    if (!_dayArray)
    {
        self.dayArray = [NSMutableArray array];
        for (int i =1 ; i < 32; i ++)
        {
            NSString * str = [NSString stringWithFormat:@"%d",i];
            [self.dayArray addObject:str];
        }
    }
    return _dayArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_pickView removeFromSuperview];
    _pickView = nil;
}



@end
