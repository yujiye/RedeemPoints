//
//  FNBonusCashVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/5/17.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBonusCashVC.h"

#import "FNTextField.h"

#import "FNBonusBO.h"

#import "FNAlertView.h"
#import "FNBonusCashDetailVC.h"

typedef enum :NSUInteger{

    CashTextField,
    
}CashType;

static CGFloat CellHeight = 60;

@interface FNBonusCashVC ()<UITableViewDelegate,UITableViewDataSource,FNBonusCashCellDelegate,FNTextFieldDelegate,UITextFieldDelegate>
{
 
    NSInteger _curBonus;//当前积分
    NSInteger _cashBonus; // 以兑出积分
    NSInteger _surplusBonus;//剩余可兑积分
    NSInteger _fillBonus; //填写的积分
    
    UILabel *_prompt; //提示1000倍递增的label
    FNTextField *_bonusText;
    FNButton *_button;
    UIButton *_addBtn;
    UIButton *_cutBtn;
}

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * titleArray; //提示语数组

@property (nonatomic, strong) NSMutableArray * dataSources; //积分数组

@end

@implementation FNBonusCashVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 18,0 ,17)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"聚分享积分兑出";
    
    self.view.backgroundColor = MAIN_COLOR_WHITE;
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionHelpItem];
    
    _curBonus = 0;
    _cashBonus = 0;
    _surplusBonus = 50000;
    _fillBonus = 1000;
    _titleArray = [NSMutableArray arrayWithObjects:@"当前积分",@"本月已兑出",@"本月剩余可兑出",@"本次兑出", nil];
    _dataSources = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:_curBonus],[NSNumber numberWithInteger:_cashBonus],[NSNumber numberWithInteger:_surplusBonus],[NSNumber numberWithInteger:_fillBonus],nil];

    [self tableView];
    [self otherView];
    //获取该账号当前积分和以兑出积分
    [FNLoadingView showInView:self.view];
    [[FNBonusBO  port02]getBonusDetailWithBlock:^(id result) {
        [FNLoadingView hide];
      if([result[@"code"] integerValue] != 200)
      {
          [UIAlertView alertViewWithMessage:result[@"desc"]];
          return ;
      }
        _curBonus = [result[@"cachAmount"][@"totalAmount"] integerValue];
        _cashBonus = [result[@"cachAmount"][@"CachAmount"] integerValue];
        _surplusBonus = 50000 - _cashBonus;
        _fillBonus = 1000;
        _dataSources = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:_curBonus],[NSNumber numberWithInteger:_cashBonus],[NSNumber numberWithInteger:_surplusBonus],nil];
        [self.tableView reloadData];
        if (_surplusBonus == 0)
        {
            //自定义弹框
           FNAlertView * alertView = [FNAlertView alertViewControllerWithMessage:@"您本月兑换积分额已达上限" content:@"单个账户每月仅限兑换50000积分" block:^{
            [self.navigationController popViewControllerAnimated:YES];
            }];
            [self.view addSubview:alertView];
            
        }else if (_curBonus < 1000)
        {
            FNAlertView * alertView = [FNAlertView alertViewControllerWithMessage:[NSString stringWithFormat:@"当前积分%ld",_curBonus] content:@"很抱歉～ 1000积分起兑哦～" block:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            [self.view addSubview:alertView];
        }
        
        _button.enabled = YES;
        
        [_button setType:FNButtonTypePlain];
    }];
  
}

- (void)otherView
{
    _prompt = [[UILabel alloc]initWithFrame:CGRectMake(0, _tableView.y+ _tableView.height + 10, kScreenWidth, 30)];
    
    _prompt.text = @"1000积分起兑，兑换额按1000的整数倍递增";
    
    _prompt.textColor = MAIN_COLOR_RED_ALPHA;
    
    _prompt.textAlignment = NSTextAlignmentCenter;
    
    _prompt.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
    
    [self.view addSubview:_prompt];
    
    _button = [FNButton buttonWithType:FNButtonTypePlain title:@"下一步"];
    
    [_button setCorner:5];
    
    _button.enabled = NO;
    
    [_button setType:FNButtonTypeOpposite];
    
    _button.frame = CGRectMake(60, _prompt.y + _prompt.height + 10, kScreenWidth - 2*60, 40);
    
    _button.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:14];
    
    [self.view addSubview:_button];
    
    [_button addTarget:self action:@selector(goNumberVC) forControlEvents:UIControlEventTouchUpInside];
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 4 * CellHeight) style:UITableViewStylePlain];
        
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
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNBonusCashCell * cell = [FNBonusCashCell cashTableviewCell:tableView];
    cell.inteLabel.hidden = YES;
    cell.titleLable.text = _titleArray[indexPath.row];
    cell.codeBtn.hidden = YES;
    
    if (indexPath.row < 3)
    {
        cell.userInteractionEnabled = NO;
        cell.buttonView.hidden = YES;
        cell.inteLabel.hidden = NO;
        cell.inteLabel.text = [NSString stringWithFormat:@"%@",_dataSources[indexPath.row]] ;
    }

    switch (indexPath.row) {
        case 0:
            
            cell.inteLabel.textColor = MAIN_COLOR_RED_ALPHA;
            break;
            
        case 1:
            cell.inteLabel.textColor = [UIColor colorWithRed:143.0/255 green:143.0/255 blue:143.0/255 alpha:1];
            break;
        case 2:
            cell.inteLabel.textColor = [UIColor colorWithRed:143.0/255 green:143.0/255 blue:143.0/255 alpha:1];
            break;
        case 3:
            cell.inteLabel.hidden = YES;
            cell.cashTextField.userInteractionEnabled = YES;
            cell.textFielddelegate = self;
            cell.cashTextField.tag = CashTextField;
            cell.cashTextField.delegate = self;
            cell.cashTextField.text = [NSString stringWithFormat:@"%ld",(long)_fillBonus];
            _bonusText = cell.cashTextField;
            _addBtn = cell.addBtn;
            _cutBtn = cell.cutBtn;
            cell.cashTextField.textFieldDelegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark - 加减号
- (void)cashCellBtnClick:(FNBonusCashCell *)cell flag:(NSInteger)flag
{
    NSInteger num = [cell.cashTextField.text integerValue];
    NSInteger maxBonus = _curBonus/1000*1000 < 50000 - _cashBonus ? _curBonus/1000*1000: 50000 - _cashBonus;
    
    switch (flag) {
            
        case kNumberBtnTypeMinus:
            
            cell.addBtn.enabled = YES;
            [cell.addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
            
            if ( num == 1000)
            {
                [self.view makeToast:@"最少兑出1000积分"];
                
                [cell.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
                
            }else if (num > 1000)
            {
                num = num - 1000;
                
                if (num == 1000)
                {
                    [cell.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
                }
                NSString * str = [NSString stringWithFormat:@"%ld",(long)num];
                
                cell.cashTextField.text = str;
                
                _fillBonus = num;
                
            }
            break;
        case kNumberBtnTypeAdd:
            
            [cell.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
            
            if (num == maxBonus)
            {
                [cell.addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_disSelecte"] forState:UIControlStateNormal];
                cell.addBtn.enabled = NO;
                cell.cashTextField.text = [NSString stringWithFormat:@"%ld",maxBonus];
                _fillBonus = num;
                [self.view makeToast:[NSString stringWithFormat:@"最多可兑出%ld积分",maxBonus]];
            }
            else if (num <maxBonus)
            {
                [cell.addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
                
                num = num +1000;
                
                cell.cashTextField.text = [NSString stringWithFormat:@"%ld",(long)num];
                
                _fillBonus = num;
            }
    
            break;
        default:
            break;
    }
}
- (void)tapGesture: (UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma  mark - textField值的限制

- (void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger maxBonus = _curBonus/1000*1000 < 50000 - _cashBonus ? _curBonus/1000*1000: 50000 - _cashBonus;
    if (textField.tag == CashTextField )
    {
        if ([textField.text integerValue] < 1000)
        {
            textField.text = @"1000";
            _fillBonus = [textField.text integerValue];
            [self.view makeToast:@"最少兑出1000"];
            [_addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
            [_cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
        }
        else if([textField.text integerValue]>1000 &&[textField.text integerValue] <maxBonus)
        {
            [_addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
            [_cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
            if ([textField.text integerValue] % 1000 != 0)
            {
                [self.view makeToast:@"请输入1000的整数倍"];
                textField.text = [NSString stringWithFormat:@"%ld",[textField.text integerValue]/1000*1000 ];
                _fillBonus = [textField.text integerValue];
            }
            else
            {
                _fillBonus = [textField.text integerValue];
            }
        }else
        {
            [self.view makeToast:[NSString stringWithFormat:@"最多可兑出%ld",maxBonus]];
            textField.text = [NSString stringWithFormat:@"%ld",maxBonus];
            _fillBonus = [textField.text integerValue];
            [_addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_disSelecte"] forState:UIControlStateNormal];
            [_cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
        }
        
    }
    
}


- (void)goNumberVC
{
    [FNLoadingView showInView:self.view];
    _button.enabled = NO;
    [[FNBonusBO  port02]checkAccountIsBinded:^(id result) {
        [FNLoadingView hide];
        _button.enabled = YES;
        if ([result[@"code"] integerValue ]== 200)
        {
            //未绑定
            if ([result[@"scoreAccountResult"][@"value"] integerValue] ==0)
            {
                [[FNBonusBO port02] userAuthorizeWithScore:[NSString stringWithFormat:@"%ld",_fillBonus] block:^(id res ){
                    _button.enabled = YES;
                    
                    if( [res[@"code"] integerValue ]== 200)
                    {
                        NSString *url = [NSString stringWithFormat:@"%@?requestXml=%@",res[@"action"],res[@"requestXml"]];
                        
                        FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:url]];
                        
                        vc.title = @"聚分享积分兑出";
                        
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else
                    {
                        [self.view makeToast:@"加载失败,请重试!"];
                        
                    }
                    
                }];
                
            }else
            {
                //绑定
                FNBonusCashDetailVC * bonusCashDetailVC = [[FNBonusCashDetailVC alloc]init];
                bonusCashDetailVC.bonus = _fillBonus;
                bonusCashDetailVC.mobile = result[@"scoreAccountResult"][@"scoreAccount"][@"account"];
                bonusCashDetailVC.isNotFirstCash = YES;
                [self.navigationController pushViewController:bonusCashDetailVC animated:YES];
                _button.enabled = YES;
            }
        }
        else
        {
            [self.view makeToast:@"加载失败,请重试!"];
        }
        
    }];
    
}

@end
