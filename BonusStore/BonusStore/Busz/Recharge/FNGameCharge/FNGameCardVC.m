//
//  FNGameCardVC.m
//  BonusStore
//
//  Created by cindy on 2016/11/7.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNGameCardVC.h"
#import "FNHeader.h"
#import "FNSearchNameVC.h"
#import "FNSearchAreaVC.h"
#import "FNGameDetail.h"
#import "FNRechargeBO.h"
#import "FNPriceChoice.h"
#import "FNServiceChoiceVC.h"
#import "FNLoginBO.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "FNGameGroup.h"
@interface FNGameCardVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,FNTextFieldDelegate>
{
    NSArray * _mpriceArr;     //固定数量的可选数组
    NSMutableArray * _areaChoiceArr; //区可选的数组
    NSMutableArray * _serviceChoiceArr; // 服务可选的数组
    NSString * _exchangeTip;   //兑换说明
    NSString *_areaChoice;      //大区选择
    NSString * _serviceChoice;   //服务选择
    NSString * _priceTip ;   //固定数量或者是单价
    NSInteger _starNum; //最小数量
    NSInteger _endNum;  //最大数量
    NSInteger _minSpace; // 最小倍数
    UILabel * _moneyLab; //显示金额
}

@property (nonatomic, strong) FNTextField * textField; // 账号输入框
@property (nonatomic, strong) UIButton * payBtn ;   //支付按钮
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *tipArr;
@property (nonatomic, strong) FNGameDetail * gameDetail; //游戏详情
@property (nonatomic, strong) NSString * choicePrice ;//单价
@property (nonatomic, strong) FNGameAreaModel * gameAreaModel; //选择的区或者服务器
@property (nonatomic, strong) FNSeaverModel * seaverModel; //选择的区或者服的下一级
@property (nonatomic, assign) NSInteger choiceNum ;//选择的数量

@end

@implementation FNGameCardVC


- (void)setChoiceNum:(NSInteger)choiceNum
{
    _choiceNum = choiceNum;
    _moneyLab.hidden = NO;
    _moneyLab.text = [NSString stringWithFormat:@"金额: ¥ %2.f",(CGFloat)(_choiceNum * [self.gameDetail.mprice floatValue])];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    self.title = @"游戏点卡充值";
    self.view.backgroundColor = [UIColor whiteColor];
    _areaChoiceArr = [NSMutableArray array];

    // 三个参数都不传是默认的游戏列表
    [FNLoadingView showInView:self.view];
    NSMutableArray * arrM = [NSMutableArray array];
    [[FNRechargeBO port01]getGameNameWithFirstpy:@"A" name:nil thirdGameId:nil block:^(id result) {

        if ([result[@"code"] integerValue] == 200)
        {
            for ( NSDictionary * dict in result[@"pyThirdGameList"] )
            {
                [arrM addObject:[FNGameGroup mj_objectWithKeyValues:dict]];
            }
            
            [self addTableview];
            FNGameGroup * gameGroup = arrM.firstObject;
            if (arrM.count == 0 || gameGroup.listGame.count == 0)
            {
                self.titleArr = [NSMutableArray arrayWithObjects:@"游戏名称",@"充值金额",@"所在大区", nil];
                self.tipArr = [NSMutableArray arrayWithObjects:@"请选择",@"请选择",@"请选择", nil];
                self.tableView.hidden = NO;
                _payBtn.hidden = NO;
                [self.tableView reloadData];

            }else
            {
                FNGameGroup * gameGroup =  arrM.firstObject;
                FNGameDetail *gameDetail = gameGroup.listGame.firstObject;
                self.gameDetail = gameDetail;
                [self getDetailWithGameDetail:gameDetail];
            }            
        }else
        {
            [FNLoadingView showInView:self.view text:@"加载失败"];
 
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)getDetailWithGameDetail:(FNGameDetail *)gameDetail
{
    //根绝第一个选择的游戏的id,获取游戏名字和区，服务器等
    _areaChoiceArr = nil;
    _areaChoice = nil;
    _serviceChoice = nil;
    _priceTip = nil;
    _mpriceArr = nil;
    _serviceChoiceArr = nil;
    self.gameAreaModel = nil;
    self.gameAreaModel = nil;
    
    [FNLoadingView showInView:self.view];
    self.titleArr = [NSMutableArray arrayWithObjects:@"游戏名称",@"充值金额",@"所在大区", nil];
    self.tipArr = [NSMutableArray arrayWithObjects:self.gameDetail.name,@"请选择",@"请选择", nil];
    [self.tableView reloadData];
    [FNRechargeBO getGameNameWithFirstpy:nil name:nil thirdGameId:gameDetail.thirdGameId block:^(id result)
     {
         [FNLoadingView hide];
         if([result[@"code"] integerValue] == 200)
         {
             self.gameDetail = [FNGameDetail mj_objectWithKeyValues:result[@"thirdGame"]]; //游戏详情
             
             if (![self.gameDetail.contbuy isEqualToString:@"0"] )
             {
                 // 这个字段不是空，说明有固定面额
                 _priceTip = @"充值面额";
                 _exchangeTip = @"请选择";
                 _mpriceArr = [self.gameDetail.contbuy componentsSeparatedByString:@","];
                 
             }else
             {
                 _priceTip = @"单价";
                 _exchangeTip = [NSString stringWithFormat:@"%@元/%@%@",self.gameDetail.mprice,self.gameDetail.point,self.gameDetail.gameunit];
                 _minSpace = [self.gameDetail.spacenum integerValue];  // 数量的最小间距
                 
                 //每个数组中第一个是第三方平台限制的数量 第二个值是聚分享限制的数量
                 NSArray * startbuy = [self.gameDetail.startbuy componentsSeparatedByString:@","];
                 NSArray *endbuy = [self.gameDetail.endbuy componentsSeparatedByString:@","];
                 if([endbuy[0] integerValue] < [startbuy[1] integerValue])
                 {
                     _starNum = [startbuy[0] integerValue];
                     _endNum =  [endbuy[0] integerValue];
                 }else
                 {
                     _starNum = [startbuy[1] integerValue];
                     _endNum =  [endbuy[1] integerValue];
                 }
                 
                 for(NSInteger i = _starNum; i <_endNum;i++)
                 {
                     if (i % _minSpace ==0)
                     {
                         _starNum = i;
                         break;
                     }
                 }
                 for(NSInteger i = _endNum; i > _starNum;i--)
                 {
                     if (i % _minSpace == 0)
                     {
                         _endNum = i;
                         break;
                     }
                 }
                 
                 self.choiceNum = _starNum;
                 
             }
             self.titleArr = [NSMutableArray arrayWithObjects:@"游戏名称",_priceTip, nil];
             self.tipArr = [NSMutableArray arrayWithObjects:gameDetail.name,_exchangeTip,nil];
             
             //判断needparam里面是否有a和s,有的话取出对应的值，请求网络获取区或者服务器
             if([self.gameDetail.needparam rangeOfString:@"a="].location != NSNotFound ||[self.gameDetail.needparam rangeOfString:@"s="].location != NSNotFound  )
             {
                 if ([self.gameDetail.needparam rangeOfString:@"a="].location != NSNotFound)
                 {
                     NSArray * arr = [self.gameDetail.needparam componentsSeparatedByString:@"|"];
                     for(NSString * str in  arr)
                     {
                         if ([str rangeOfString:@"a="].location != NSNotFound)
                         {
                             _areaChoice = [str stringByReplacingOccurrencesOfString:@"a=" withString:@""];
                             break;
                         }
                     }
                 }
                 
                 if ([self.gameDetail.needparam rangeOfString:@"s="].location != NSNotFound)
                 {
                     NSArray * arr = [self.gameDetail.needparam componentsSeparatedByString:@"|"];
                     for(NSString * str in  arr)
                     {
                         if ([str rangeOfString:@"s="].location != NSNotFound)
                         {
                             _serviceChoice = [str stringByReplacingOccurrencesOfString:@"s=" withString:@""];
                             break;
                         }
                     }
                 }
                 
                 if (![NSString isEmptyString:_serviceChoice] )
                 {
                     self.titleArr = [NSMutableArray arrayWithObjects:@"游戏名称",_priceTip,_areaChoice,_serviceChoice, nil];
                     self.tipArr = [NSMutableArray arrayWithObjects:gameDetail.name,_exchangeTip,@"请选择",@"请选择",nil];
                 }else
                 {
                     self.titleArr = [NSMutableArray arrayWithObjects:@"游戏名称",_priceTip,_areaChoice,nil];
                     self.tipArr = [NSMutableArray arrayWithObjects:gameDetail.name,_exchangeTip,@"请选择",nil];
                 }
                 
                 // 获取区或者服务器
                 [FNRechargeBO getAreaListAndSeaverListWith:gameDetail.thirdGameId block:^(id result) {
                     if ([result[@"code"] integerValue ]== 200)
                     {
                         _areaChoiceArr = [NSMutableArray array];
                         for ( NSDictionary * dict in result[@"gameAreaList"])
                         {
                             [_areaChoiceArr addObject:[FNGameAreaModel mj_objectWithKeyValues:dict]];
                         }
                     }
                     
                 }];
                 
             }
             if ([_priceTip isEqualToString:@"单价"])
             {
                 [self.titleArr addObject:@"购买数量"];
             }
             self.tableView.hidden = NO;
             _payBtn.hidden = NO;
             [self.tableView reloadData];
         }else
         {
             [FNLoadingView showInView:self.view text:@"加载失败"];
         }
     }];
}


- (void)addTableview
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64 -50 -35) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView * view = [[UIView alloc]initWithFrame: CGRectMake(0, 0, kScreenWidth, 88)];
    UILabel * accountLabel =[[UILabel alloc]initWithFrame: CGRectMake(15,0, 36, 88)];
    accountLabel.text = @"账号";
    accountLabel.font = [UIFont fzltWithSize:16];
    accountLabel.textColor = UIColorWithRGB(51, 51, 51);
    [view addSubview:accountLabel];
    
     _textField= [[FNTextField alloc]initWithFrame:CGRectMake(55, 24, kScreenWidth-30-55, 40)];
    _textField.layer.cornerRadius = 4;
    _textField.layer.masksToBounds = YES;
    _textField.tag = 1;
    _textField.backgroundColor = UIColorWithRGB(216, 216, 216);
    _textField.layer.borderColor = UIColorWithRGB(172, 171, 171).CGColor;
    _textField.placeholder= @"请输入您的游戏账号";
    _textField.delegate = self;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(55+18, 88*3+24, 18, 40)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_textField setValue:UIColorWithRGB(176, 176, 176) forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:[UIFont fzltWithSize:16] forKeyPath:@"_placeholderLabel.font"];
    _textField.isToolBar = NO;
    [view addSubview:_textField];
    self.tableView.tableFooterView = view;
    self.tableView.hidden = YES;
    _payBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.backgroundColor = [UIColor redColor];
    [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    _payBtn.frame = CGRectMake(15, kScreenHeight - 40 - 10 -64, kScreenWidth -30, 40);
    _payBtn.titleLabel.font = [UIFont fzltWithSize:18];
    _payBtn.layer.cornerRadius = 4;
    [_payBtn addTarget:self action:@selector(payBtnClick)];
    _payBtn.hidden = YES;
    _payBtn.layer.masksToBounds = YES;
    [self.view addSubview:_payBtn];
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _payBtn.y- 10 -25, kScreenWidth, 25)];
    _moneyLab.textColor = [UIColor redColor];
    _moneyLab.hidden = YES;
    _moneyLab.font = [UIFont systemFontOfSize:12];
    _moneyLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyLab];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNGameCell * cell  = [FNGameCell gameCellWithTableView:tableView];
    
    cell.introLabel.text = self.titleArr[indexPath.row];
    cell.IndexPath = indexPath;
    if ([self.titleArr[indexPath.row] isEqualToString:@"购买数量"])
    {
        cell.inputView.hidden = NO;
        cell.tipLabel.hidden = YES;
        cell.imgView.hidden = YES;
        cell.numberField.delegate = self;
        cell.numberField.textFieldDelegate = self;
        cell.numberField.text = [NSString stringWithFormat:@"%ld",(long)self.choiceNum];
        __weak typeof(cell) weakCell = cell ;
        
        cell.subtractClick = ^(NSIndexPath *indexPath,UITextField *textF)
        {
            NSString *tempStr = textF.text;
            if([tempStr integerValue] % _minSpace !=0)
            {
               self.choiceNum = ([tempStr integerValue] / _minSpace) *_minSpace;
                textF.text = [NSString stringWithFormat:@"%ld",(long)self.choiceNum];

            }else
            {
            if([tempStr integerValue] - _minSpace < _starNum)
            {
                [weakCell.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
                 [weakCell.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
                [self.view makeToast:@"已经是最小数量"];
            }else
            {
                self.choiceNum =[tempStr integerValue] -_minSpace;
               [weakCell.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
               [weakCell.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
                textF.text = [NSString stringWithFormat:@"%ld",(long)self.choiceNum];
            }
            }
        };
        
        cell.plusClick = ^(NSIndexPath *indexPath,UITextField *textF)
        {
            NSString *tempStr = textF.text;
            if([tempStr integerValue] % _minSpace !=0)
            {
                self.choiceNum =  ([tempStr integerValue] / _minSpace +1) *_minSpace;
                textF.text = [NSString stringWithFormat:@"%ld",(long)self.choiceNum];
            }else
            {
            if([tempStr integerValue] + _minSpace > _endNum)
            {
                [weakCell.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];

                [weakCell.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_disSelecte"] forState:UIControlStateNormal];
                [self.view makeToast:@"已经是最大数量"];
            }
            else{
                self.choiceNum = [tempStr integerValue] + _minSpace;
                [weakCell.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];

                [weakCell.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
                textF.text = [NSString stringWithFormat:@"%ld",(long)self.choiceNum];
            }
            }
        };
        
    }else
    {
        cell.inputView.hidden = YES;
        cell.tipLabel.hidden = NO;
        cell.imgView.hidden = NO;
        if (indexPath.row == 1 && ![_exchangeTip isEqualToString:@"请选择"])
        {
            cell.imgView.hidden = YES;
        }
        cell.tipLabel.text = self.tipArr[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:@"main_rank_more"];
    }
    return cell;
    
}


- (void)keyBoardWillShow:(NSNotification *)notoINfo
{
    NSDictionary *dict = notoINfo.userInfo;
    CGRect keyBoardFram = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - keyBoardFram.size.height - 64);
    NSIndexPath * indexPath = nil;
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (void)keyBoardWillHide:(NSNotification*)notoINfo
{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 44 -56);
    NSIndexPath * indexPath = nil;
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >99 && ![NSString isEmptyString:string])
    {
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
        if (textField.tag != 1)
        {
            if ([NSString isEmptyString:textField.text] || [textField.text integerValue] < _starNum)
            {
                textField.text = [NSString stringWithFormat:@"%li",(long)_starNum];
                self.choiceNum = _starNum;
                [self.view makeToast:[NSString stringWithFormat:@"数量要求在%ld和%ld之间",(long)_starNum,(long)_endNum]];
                
            }else if ([textField.text integerValue] >_endNum)
            {
                textField.text = [NSString stringWithFormat:@"%li",(long)_endNum];
                self.choiceNum = _endNum;
                [self.view makeToast:[NSString stringWithFormat:@"数量要求在%ld和%ld之间",(long)_starNum,(long)_endNum]];
            }else
            {
                if ([textField.text integerValue] % _minSpace != 0)
                {
                    [self.view makeToast:[NSString stringWithFormat:@"输入数量是%ld的整数倍",(long)_minSpace]];
                    self.choiceNum = [textField.text integerValue];
                }else
                {
                    self.choiceNum = [textField.text integerValue];
                }
            }
        }


    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.gameDetail == nil)
    {
        if(indexPath.row!=0)
        {
            [self.view makeToast:@"请先选择游戏名称"];
            return;
        }
    }
    
    if (indexPath.row == 0)
    {
        FNSearchNameVC * searchNameVC  = [[FNSearchNameVC alloc]init];
        
        [searchNameVC  setSearchNameClickBlock:^(FNGameDetail *sender)
         {
             self.gameDetail = sender;
             [self getDetailWithGameDetail:sender];
         }];
        [self.navigationController pushViewController:searchNameVC animated:YES];
        
    }else if(indexPath.row == 1)
    {
        if ([_priceTip isEqualToString:@"单价"])
        {
            return;
        }else
        {
            FNPriceChoice * searchAreaVC = [[FNPriceChoice alloc]init];
            searchAreaVC.dataArr = _mpriceArr;
            searchAreaVC.price = self.gameDetail.mprice;
            [searchAreaVC setPriceChoiceClick:^(NSString *sender)
             {
                 _moneyLab.hidden = NO;
                 _choiceNum = [sender integerValue];
                 self.choicePrice = [NSString stringWithFormat:@"%ld",(NSUInteger)(_choiceNum*[self.gameDetail.mprice integerValue])];
                 _moneyLab.text = [NSString stringWithFormat:@"金额: ¥ %@",self.choicePrice];
                [self.tipArr replaceObjectAtIndex:1 withObject:self.choicePrice ];
                 
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:searchAreaVC animated:YES];
            
        }
        
        
    }else  if (indexPath.row ==2)
    {
        NSString * str = self.titleArr[indexPath.row];
        if ( [str isEqualToString:@"购买数量"])
        {
            return;
        }else
        {
        FNSearchAreaVC * searchAreaVC = [[FNSearchAreaVC alloc]init];
        searchAreaVC.tipString = [NSString stringWithFormat:@"请选择%@",_areaChoice];
        searchAreaVC.gameArr = _areaChoiceArr;
        [searchAreaVC setBlockAreaModelClick:^(FNGameAreaModel *gameAreaModel) {
            self.gameAreaModel = gameAreaModel;
            [self.tipArr replaceObjectAtIndex:2 withObject:gameAreaModel.gameAreaName ];
            if (![NSString isEmptyString:_serviceChoice])
            {
                [self.tipArr replaceObjectAtIndex:3 withObject:@"请选择"];
                self.seaverModel = nil;
            }
            [self.tableView reloadData];
            
        }];
        [self.navigationController pushViewController:searchAreaVC animated:YES];
        }
        
    }else if(indexPath.row == 3)
    {
        NSString * str = self.titleArr[indexPath.row];
        if ( [str isEqualToString:@"购买数量"])
        {
            return;
        }else
        {
            if(self.gameAreaModel == nil)
            {
                [self.view makeToast:@"请按顺序选择"];
                return;
            }
            FNServiceChoiceVC * serviceChoiceVC = [[FNServiceChoiceVC alloc]init];
            serviceChoiceVC.tipString = [NSString stringWithFormat:@"请选择%@",_serviceChoice];
            serviceChoiceVC.serviceArr = self.gameAreaModel.gameSeaverList;
            [serviceChoiceVC setBlockSeaverModelClick:^(FNSeaverModel *seaverModel) {
                self.seaverModel = seaverModel;
                [self.tipArr replaceObjectAtIndex:3 withObject:seaverModel.gameSeaverName];
                [self.tableView reloadData];
                
            }];
            [self.navigationController pushViewController:serviceChoiceVC animated:YES];
        }
        
    }
}

-(void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag
{
    [self.view endEditing:YES];
    
    
}

- (void)payBtnClick
{
    
    if (![FNLoginBO isLogin])
    {
        
        return ;
    }
    NSString * flowno = nil;
    
    NSString * receiverMobile = [[NSString alloc]init] ;
    
    receiverMobile = [receiverMobile stringByAppendingFormat:@"%@,",self.gameDetail.thirdGameId];
    if ([_priceTip isEqualToString:@"充值面额"])
    {
       if ([NSString isEmptyString:self.choicePrice])
       {
           [self.view makeToast:@"请选择充值金额"];
           return;
       }else
       {
           flowno = self.gameDetail.mprice;
       }
    }
    
    if ([_priceTip isEqualToString:@"单价"])
    {
        if (_choiceNum % _minSpace !=0)
        {
            [self.view makeToast:[NSString stringWithFormat:@"输入金额是%ld的倍数",(long)_minSpace]];
            return;

        }else
        {
         self.choicePrice = [NSString stringWithFormat:@"%f",[self.gameDetail.mprice floatValue] * _choiceNum];
            
         flowno = self.gameDetail.mprice;
        }
    }
    
    if (![NSString isEmptyString:_areaChoice])
    {
        if (self.gameAreaModel == nil )
        {
            [self.view makeToast:[NSString stringWithFormat:@"请选择%@",_areaChoice]];
            return;
            
        }else
        {
            receiverMobile = [receiverMobile stringByAppendingFormat:@"%@,%@,",self.gameAreaModel.gameAreaId, self.gameAreaModel.gameAreaName];
        }
    }else
    {
        receiverMobile = [receiverMobile stringByAppendingString:@",,"];

    }
    
     if(![NSString isEmptyString:_serviceChoice])
     {
         if (self.seaverModel == nil)
         {
             [self.view makeToast:[NSString stringWithFormat:@"请选择%@",_serviceChoice]];
             return;
         }else
         {
           receiverMobile = [receiverMobile stringByAppendingFormat:@"%@,%@,",self.seaverModel.gameSeaverId, self.seaverModel.gameSeaverName];
         }
     }else
     {
         receiverMobile = [receiverMobile stringByAppendingString:@",,"];

     }
    
    if ([NSString isEmptyString:_textField.text])
    {
        [self.view makeToast:@"请输入充值账号"];
        return;
    }else
    {
        if(_textField.text.length >100)
        {
            _textField.text = [_textField.text substringToIndex:100];
        }
        receiverMobile = [receiverMobile stringByAppendingFormat:@"%@",_textField.text];
    }
    [FNLoadingView showInView:self.view];

    [[FNRechargeBO  port02]payOrderCreatesWithTotalSum:self.choicePrice flowno:flowno company:[NSString stringWithFormat:@"%ld",(long)_choiceNum] receiverMobile:receiverMobile  sellerComment:[NSString stringWithFormat:@"%@充值",self.gameDetail.name]  provinceName:[self getIPAddress] block:^(id result) {
        [FNLoadingView hide];
        if ([result[@"code"] integerValue] == 200)
        {
            FNPayVC *payVC = [[FNPayVC alloc]init];
            payVC.tradeCode = @"Z8006";
            payVC.isSpecialType  = YES;
            payVC.orderIds = result[@"orderIdList"];
            payVC.allPrice = self.choicePrice;
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


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}


@end

@implementation  FNGameCell

+ (instancetype)gameCellWithTableView:(UITableView *) tableView
{
    NSString *reuserId = NSStringFromClass([self class]);
    FNGameCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell == nil)
    {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * introLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 60)];
        self.introLabel = introLabel;
        introLabel.font = [UIFont fzltWithSize:14];
        introLabel.textAlignment = NSTextAlignmentLeft;
        introLabel.textColor = UIColorWithRGB(51, 51, 51);
        [self.contentView addSubview:introLabel];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth- 15 - 18 , 21, 18, 18)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.imgView = imgView;
        [self.contentView addSubview:imgView];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, kScreenWidth - 120, 60)];
        self.tipLabel = tipLabel;
        tipLabel.textColor = UIColorWithRGB(176, 176, 176);
        tipLabel.font = [UIFont fzltWithSize:14];
        tipLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:tipLabel];
        self.inputView = [self addBottonsView];
        self.inputView.frame = CGRectMake(kScreenWidth -130 , 12, 115, 34);
        [self.contentView addSubview:self.inputView];
        
        UILabel * lineLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
        lineLabel.backgroundColor = UIColorWithRGB(222, 222, 222);
        [self.contentView addSubview:lineLabel];
        
    }
    return self;
}
- (UIView *)addBottonsView
{
    
    UIView *inputView = [[UIView alloc]init];
    self.minuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inputView addSubview: self.minuBtn];
    self.minuBtn.tag = kNumberBtnTypeMinus;
    self.minuBtn.frame = CGRectMake(0,1, 33, 34);
    [self.minuBtn setImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inputView addSubview: self.addBtn];
    self.addBtn.tag = kNumberBtnTypeAdd;
    self.addBtn.frame = CGRectMake(79, 1, 33, 34);
    [self.addBtn setImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
    self.numberField = [[FNTextField alloc] init];
    [inputView addSubview: self.numberField ];
    self.numberField.keyboardType = UIKeyboardTypeNumberPad ;
    self.numberField.frame = CGRectMake(32, 1, 48, 34);
    self.numberField.textAlignment = NSTextAlignmentCenter;
    [self.numberField setBackground:[UIImage imageNamed:@"cart_textFeild"]];
    
    [self.minuBtn addTarget:self action:@selector(minusBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.numberField  addTarget:self action:@selector(numberLabelTextChange) forControlEvents:UIControlEventEditingChanged];
    return inputView;
}


-(void)minusBtnAction
{
    if(self.subtractClick){
        self.subtractClick(self.IndexPath,self.numberField);
    }
}
-(void)addBtnAction
{
    if(self.plusClick){
        self.plusClick(self.IndexPath,self.numberField);
    }
}
-(void)numberLabelTextChange
{
    if(self.textValueChangeClick){
        self.textValueChangeClick(self.IndexPath,self.numberField);
    }
}



@end
