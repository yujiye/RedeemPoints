//
//  FNSearchNameVC.m
//  BonusStore
//
//  Created by cindy on 2016/11/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSearchNameVC.h"
#import "FNHeader.h"
#import "FNGameGroup.h"
#import "FNGameDetail.h"
#import "FNRechargeBO.h"

@interface FNSearchNameVC ()<UITableViewDelegate,UITableViewDataSource,FNTextFieldDelegate,UITextFieldDelegate>
{
    SearchNameClickBlock  _searchNameClickBlock;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray * dataArr;
@property (nonatomic, assign)BOOL isSearch;  //  是否是搜索结果
@property (nonatomic, strong)NSMutableArray *searchArr;  //搜索结果



@end

@implementation FNSearchNameVC

- (void)setSearchNameClickBlock:(SearchNameClickBlock)searchNameClickBlock
{
    _searchNameClickBlock = nil;
    _searchNameClickBlock = searchNameClickBlock;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray array];
    self.searchArr = [NSMutableArray array];
    [self searchNameAddViews];
    
    NSMutableArray *dictArr = [FNSearchNameVC keyedUnarchiverWithString:@"FNGameName"];
    for ( NSDictionary * dict in dictArr )
    {
        [ self.dataArr addObject:[FNGameGroup mj_objectWithKeyValues:dict]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate * recordeDate = [defaults objectForKey:@"firstName"];
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:recordeDate];
    NSInteger mint = seconds/60;
    
    if (self.dataArr == nil || self.dataArr.count == 0 || mint > 30)
    {
        // 三个参数都不传是默认的游戏列表
        [FNLoadingView showInView:self.view];
        
        [[FNRechargeBO port01]getGameNameWithFirstpy:nil name:nil thirdGameId:nil block:^(id result) {
            [FNLoadingView hide];
            if ([result[@"code"] integerValue] == 200)
            {
              [FNSearchNameVC keyedArchiverWithArray:result[@"pyThirdGameList"] string:@"FNGameName"];
        
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSDate date] forKey:@"firstName"];
                
                for ( NSDictionary * dict in result[@"pyThirdGameList"] )
                {
                    [ self.dataArr addObject:[FNGameGroup mj_objectWithKeyValues:dict]];
                }
                [self.tableView reloadData];

            }
        }];
    }else
    {
         [self.tableView reloadData];
    }

}

- (void)numberLabelTextChange:(UITextField *)textField
{
    self.searchArr = [NSMutableArray array];
    
    if (textField.text.length == 0 )
    {
        _isSearch = NO;
        [self.tableView reloadData];
        
    }else if (textField.text.length == 1)
    {
        if ([self MatchLetter:textField.text])
        {
            for (FNGameGroup * gameGroup in self.dataArr)
            {
                if([gameGroup.py isEqualToString:textField.text]||[gameGroup.py isEqualToString:[textField.text uppercaseString]] )
                {
                    _isSearch = YES;
                    self.searchArr = gameGroup.listGame;
                    break;
                }
            }
            
        }else
        {
            for (FNGameGroup * gameGroup in self.dataArr)
            {
                for (FNGameDetail *detail in  gameGroup.listGame)
                {
                    if([[detail.name uppercaseString] rangeOfString:[textField.text uppercaseString] ].location != NSNotFound )
                    {
                        _isSearch = YES;
                        
                        [self.searchArr addObject:detail];
                        continue;
                    }
                }
            }
            
        }
        
    }else
    {
        for (FNGameGroup * gameGroup in self.dataArr)
        {
            for (FNGameDetail *detail in  gameGroup.listGame)
            {
                if([[detail.name uppercaseString] rangeOfString:[textField.text uppercaseString]].location != NSNotFound )
                {
                    _isSearch = YES;
                    [self.searchArr addObject:detail];
                    continue;
                }
            }
        }
        
    }
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearch)
    {
        return 1;
        
    }else
    {
        return self.dataArr.count;
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isSearch)
    {
        if(self.searchArr.count == 0)
        {
            return 0;
        }
        return self.searchArr.count;
    }else
    {
        FNGameGroup * gameGroup = self.dataArr[section];
        return gameGroup.listGame.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuserId = NSStringFromClass([self class]);
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
        cell.textLabel.frame = CGRectMake(25, 0, kScreenWidth -50, 60);
        cell.textLabel.font = [UIFont fzltWithSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = UIColorWithRGB(51, 51, 51);
    }
    if (_isSearch)
    {
        if (self.searchArr.count ==0)
        {
            return nil;
        }
        FNGameDetail * gameDetail = self.searchArr[indexPath.row];
        cell.textLabel.text = gameDetail.name;
    }else
    {
        FNGameGroup * gameGroup = self.dataArr[indexPath.section];
        FNGameDetail * gameDetail = gameGroup.listGame[indexPath.row];
        cell.textLabel.text = gameDetail.name;
        
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isSearch)
    {
        return 0;
    }else
    {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearch)
    {
        return nil;
    }else
    {
        FNGameGroup * gameGroup  = self.dataArr[section];
        return gameGroup.py;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNGameDetail * gameDetail = nil;
    if (_isSearch)
    {
        gameDetail = self.searchArr[indexPath.row];
    }else
    {
        FNGameGroup * gameGroup  = self.dataArr[indexPath.section];
        gameDetail = gameGroup.listGame[indexPath.row];
    }
    if (_searchNameClickBlock)
    {
        _searchNameClickBlock(gameDetail);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchNameAddViews
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 15+15, 15, 15);
    [backBtn setImage:[UIImage imageNamed:@"nav_back_nor"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    
    FNTextField * _textField= [[FNTextField alloc]initWithFrame:CGRectMake(55, 20, kScreenWidth-30-55, 40)];
    _textField.layer.cornerRadius = 4;
    _textField.layer.masksToBounds = YES;
    _textField.tag = 1;
    _textField.backgroundColor = UIColorWithRGB(216, 216, 216);
    _textField.layer.borderColor = UIColorWithRGB(172, 171, 171).CGColor;
    _textField.delegate = self;
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(55+18, 24, 18, 34)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_textField setValue:UIColorWithRGB(176, 176, 176) forKeyPath:@"_placeholderLabel.textColor"];
    [_textField setValue:[UIFont fzltWithSize:16] forKeyPath:@"_placeholderLabel.font"];
    _textField.isToolBar = NO;
    _textField.placeholder= @"请输入您的游戏账号";

//    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(45, 23, kScreenWidth-55, 34)];
//    textField.layer.cornerRadius = 4;
//    textField.layer.masksToBounds = YES;
//    textField.layer.borderWidth = 0.5;
//    textField.backgroundColor = UIColorWithRGB(216, 216, 216);
//    textField.layer.borderColor = UIColorWithRGB(172, 171, 171).CGColor;
//    textField.placeholder = @"搜索游戏名称或者字母";
//    [textField  addTarget:self action:@selector(numberLabelTextChange:) forControlEvents:UIControlEventEditingChanged];
//    textField.isToolBar = NO;
//    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(55+18, 23, 18, 34)];
//    textField.leftViewMode = UITextFieldViewModeAlways;


//    _textField.returnKeyType = UIReturnKeySearch;
//    _textField.delegate = self;
//    UIView *imgView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 15, 15)];
//    textField.leftView = imgView;
//    textField.leftViewMode = UITextFieldViewModeAlways;
//    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [textField setValue:UIColorWithRGB(176, 176, 176) forKeyPath:@"_placeholderLabel.textColor"];
//    [textField setValue:[UIFont fzltWithSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_textField];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, kScreenWidth, 1)];
    lineLabel.backgroundColor = UIColorWithRGB(176, 176, 176);
    [self.view addSubview:lineLabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    if ([ self.tableView respondsToSelector: @selector (setSeparatorInset:)])
    {
        [ self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [ self.tableView setSeparatorColor:MAIN_BACKGROUND_COLOR];
    }

}


-(BOOL)MatchLetter:(NSString *)str
{
    
    NSString * regex = @"[A-Za-z]";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

+ (void)keyedArchiverWithArray:(NSMutableArray * )array string:(NSString *)string
{
    
    NSArray  *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:string];
    [NSKeyedArchiver archiveRootObject:array toFile:fileName];
}

+ (NSMutableArray * )keyedUnarchiverWithString:(NSString *)string
{
    NSArray  *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[path objectAtIndex:0] stringByAppendingPathComponent:string];
    id array = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    return array;
}


@end

