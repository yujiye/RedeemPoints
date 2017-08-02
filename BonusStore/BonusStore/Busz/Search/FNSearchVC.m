//
//  FNSearchVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/27.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSearchVC.h"
#import "FNSearchResultVC.h"
#import "FNMainBO.h"
@interface FNSearchVC ()<UITextFieldDelegate>
{
    UIView *_hotSearchView;
    UIView *_historySearchView;
    UIView *_historyView;
    UIView *_hotView;
    FNNoDataView *_noData;
    UITextField *_searchTextField;
    UIView *_navigationView;
    NSString *_defaultStr;
    UIButton *_searchBtn;
}

@property (nonatomic, strong)NSMutableArray *dataSources;

@property (nonatomic, strong)UIButton *clearBtn;

@property (nonatomic, strong)NSMutableArray *historyArray;

@property (nonatomic,assign) CGFloat historyHeight;

@property (nonatomic,assign) CGFloat hotHeight;

@end


@implementation FNSearchVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    [_dataSources removeAllObjects];
    _historyView.hidden = YES;
    _historySearchView.hidden = YES;
    _hotView.hidden = YES;
    _hotSearchView.hidden = YES;
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigaitionBackItem];

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    _dataSources = [NSMutableArray array];
    _historyArray = [NSMutableArray array];
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _navigationView.backgroundColor = MAIN_COLOR_WHITE;
    [self.view addSubview:_navigationView];
    
    UIView *_backBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15+30, 64)];
    [_backBtnView addTarget:self action:@selector(goBack)];
    [_navigationView addSubview:_backBtnView];
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(15,30, 10, 20);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"nav_back_nor"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_backBtnView addSubview:_backBtn];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 33)];
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(15,7 ,18 ,18 )];
    leftView.image = [UIImage imageNamed:@"search_bg"];
    [bgView addSubview:leftView];
    _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(60, 25, kScreenWidth - 120,33 )];
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchTextField setReturnKeyType:UIReturnKeySearch];
    _searchTextField.leftView = bgView;
    _searchTextField.placeholder = @"购物返积分，积分当钱花";
    _searchTextField.delegate = self;
    _searchTextField.font = [UIFont fzltWithSize:11];
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.backgroundColor = MAIN_BACKGROUND_COLOR;
    _searchTextField.layer.masksToBounds = YES;
    _searchTextField.layer.cornerRadius = 16.0;
    [_navigationView addSubview:_searchTextField];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(kScreenWidth -10- 40, _searchTextField.y , 40, 30);
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [_searchBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    _searchBtn.titleLabel.font = [UIFont fzltWithSize:18];
    [_navigationView addSubview:_searchBtn];
    [_searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    _hotView = [[UIView alloc]initWithFrame:CGRectMake(0, _navigationView.y +_navigationView.height+1, kScreenWidth, 45)];
    _hotView.hidden = YES;
    _hotView.backgroundColor = MAIN_COLOR_WHITE;
    [self.view addSubview:_hotView];
    UILabel *_hotLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 44)];
    _hotLab.font = [UIFont fzltWithSize:18];
    _hotLab.text = @"热门搜索";
    [_hotView addSubview:_hotLab];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, _hotLab.height, kScreenWidth, 1)];
    line.backgroundColor = MAIN_BACKGROUND_COLOR;
    [_hotView addSubview:line];
    
    _hotSearchView = [[UIView alloc]init];
    [self.view addSubview:_hotSearchView];
    
    _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0 ,_navigationView.y+_navigationView.height+44 , kWindowWidth, kWindowHeight)];
    _noData.hidden = YES;
    _noData.backgroundColor = MAIN_BACKGROUND_COLOR;

    [self.view addSubview:_noData];
}
- (void)getData
{
    __weak __typeof(self) weakSelf = self;
    [_dataSources removeAllObjects];
    [FNLoadingView showInView:self.view];
    _noData.hidden = YES;
    [[FNMainBO port04] getHotSearchListWithModuleId:@"6" block:^(id result) {
        [FNLoadingView hide];
        if ([(NSArray *)result count] == 0)
        {
        }
        else
        {
            _hotSearchView.hidden = NO;
            _hotView.hidden = NO;
        }
        for (FNHotSearchModel *model in result)
        {
            if ([model.relaSort isEqualToString:@"1"])
            {
                _searchTextField.placeholder = model.relaImgkey;
                _defaultStr = model.relaImgkey;
            }
            else
            {
                [_dataSources addObject:model.relaImgkey];
            }
        }
        [self hotViewWithArray:_dataSources views:_hotView subView:_hotSearchView];
        _hotSearchView.frame = CGRectMake(0, _hotView.y+_hotView.height, kScreenWidth, _hotHeight);
        [_hotSearchView reloadInputViews];
        [weakSelf initHistorySearchView];
        
        NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *historyArr = [_defaults objectForKey:@"historySearch"];
        
        if (historyArr.count ==0 &&[(NSArray *)result count] == 0)
        {
            //显示小哭脸
            _hotSearchView.hidden = YES;
            _hotView.hidden = YES;
            _historyView.hidden = YES;
            _historySearchView.hidden = YES;
            _noData.hidden = NO;
            [_noData setTypeWithResult:result];
            [_noData setActionBlock:^(id sender) {
                [weakSelf getData];
            }];
        }
        else if(historyArr.count !=0 &&[(NSArray *)result count] == 0  )
        {
            _historyView.frame = CGRectMake(0, _navigationView.y +_navigationView.height+12,kScreenWidth, 45);
            [self hotViewWithArray:historyArr views:_historyView subView:_historySearchView];
            _historySearchView.frame =CGRectMake(0, _historyView.y+_historyView.height+1, kScreenWidth, _hotHeight+10);
            _historySearchView.hidden = NO;
            _hotView.hidden = YES;
            _historyView.hidden = NO;
            _noData.hidden = YES;
        }
        else if(historyArr.count !=0 && [(NSArray *)result count] != 0)
        {
            _hotSearchView.hidden = NO;
            _hotView.hidden = NO;
            [self hotViewWithArray:_dataSources views:_hotView subView:_hotSearchView];
            _hotSearchView.frame = CGRectMake(0, _hotView.y+_hotView.height, kScreenWidth, _hotHeight);
            _historySearchView.hidden = NO;
            _historyView.hidden = NO;
            _historyView.frame = CGRectMake(0, _hotView.y+_hotView.height+_hotHeight+12, kScreenWidth, 44);
            [self historyViewWithArray:historyArr views:_historyView subView:_historySearchView];
            _historySearchView.frame = CGRectMake(0, _historyView.y+_historyView.height, kScreenWidth, _hotHeight+10);
            _noData.hidden = YES;
        }
        else if(historyArr.count ==0 && [(NSArray *)result count] != 0)
        {
            _historySearchView.hidden = YES;
            _historyView.hidden = YES;
            _hotSearchView.hidden = NO;
            _hotView.hidden = NO;
            _noData.hidden = YES;
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnAction:_searchBtn];
    return YES;
}


- (void)initHistorySearchView
{
    _historyView = [[UIView alloc]init];
    _historyView.backgroundColor = MAIN_COLOR_WHITE;
    [self.view addSubview:_historyView];
    UILabel *historyLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30-84, 44)];
    historyLab.font = [UIFont fzltWithSize:18];
    historyLab.text = @"历史搜索";
    [_historyView addSubview:historyLab];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, historyLab.height-1, kScreenWidth, 1)];
    line.backgroundColor = MAIN_BACKGROUND_COLOR;
    [_historyView addSubview:line];
    [line bringSubviewToFront:_historyView];
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.frame = CGRectMake(kScreenWidth - 15 - 84, 10, 84, 25);
    _clearBtn.layer.masksToBounds = YES;
    _clearBtn.layer.borderColor = MAIN_COLOR_BLACK_ALPHA.CGColor;
    _clearBtn.layer.borderWidth = 0.5;
    _clearBtn.layer.cornerRadius = 12;
    [_clearBtn setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    [_clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    _clearBtn.titleLabel.font = [UIFont fzltWithSize:13];
    _clearBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0,0);
    [_clearBtn addTarget:self action:@selector(clearHistoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_historyView addSubview:_clearBtn];
    UIImageView *clearImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 15,15 )];
    clearImg.image = [UIImage imageNamed:@"search_clearBtn"];
    [_clearBtn addSubview:clearImg];
    _historySearchView = [[UIView alloc]init];
    [_historySearchView reloadInputViews];
    [self.view addSubview:_historySearchView];
    
}

- (void)searchBtnAction:(UIButton *)sender
{
    [_historyArray removeAllObjects];
    if ([NSString isEmptyString:_searchTextField.text] && [NSString isEmptyString:_defaultStr])
    {
        [self.view makeToast:@"请输入搜索商品"];
    }
    else
    {
        FNSearchResultVC *resultVC = [[FNSearchResultVC alloc]init];
        if ([NSString isEmptyString:_searchTextField.text])
        {
            _defaultStr = [_defaultStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            resultVC.searchStr = _defaultStr;
        }
        else
        {
          _searchTextField.text = [_searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            resultVC.searchStr = _searchTextField.text;
        }
    
        if (_searchTextField.isFirstResponder == YES)
        {
            [_searchTextField resignFirstResponder];
        }
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *historyArr = [_defaults objectForKey:@"historySearch"];
    if (historyArr.count == 0)
    {
    }
    else
    {
        for (NSString *defaultStr in historyArr)
        {
            [_historyArray addObject:defaultStr];
        }
    }
    if ([NSString isEmptyString:_searchTextField.text] && [NSString isEmptyString:_defaultStr])
    {
    }
    else
    {
        NSString *textStr;
        textStr = _searchTextField.text ;
        if ([NSString isEmptyString:textStr] && ![NSString isEmptyString:_defaultStr])
        {
            textStr = _defaultStr;
        }
        if (_historyArray.count == 20)
        {
            [_historyArray removeObjectAtIndex:0];
        }
        
        NSMutableArray *strArr = [NSMutableArray array];
        for (NSString *searchStr in _historyArray)
        {
            if ([searchStr isEqualToString:textStr])
            {
                [strArr addObject:searchStr];
            }
        }
        if (strArr.count > 0)
        {
            [_historyArray removeObject:textStr];
            [_historyArray addObject:textStr];
        }
        else if (strArr.count == 0)
        {
            if ([textStr isEqualToString:@""])
            {
            }
            else
            {
                [_historyArray addObject:textStr];
            }
        }
        NSArray *searchArr = [NSArray arrayWithArray:_historyArray];
        NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
        [_defaults setObject:searchArr forKey:@"historySearch"];
        NSMutableArray *historyArr = [_defaults objectForKey:@"historySearch"];
        [self historyViewWithArray:historyArr views:_historyView subView:_historySearchView];
        _historySearchView.frame = CGRectMake(0, _historyView.y+_historyView.height+1, kScreenWidth, _hotHeight);
        if (historyArr.count == 0)
        {
            _historySearchView.hidden = YES;
            _historyView.hidden = YES;
        }
        else
        {
            _noData.hidden = YES;
        }
    }
}

- (void)clearHistoryBtnAction:(UIButton *)sender
{
    if (_dataSources.count != 0)
    {
        _historySearchView.hidden = YES;
        _historyView.hidden = YES;
        _hotView.hidden = NO;
        _hotSearchView.hidden = NO;
        
    }
    else
    {
        _historySearchView.hidden = YES;
        _historyView.hidden = YES;
        _hotView.hidden = YES;
        _hotSearchView.hidden = YES;
        _noData.hidden = NO;
        __weak __typeof(self) weakSelf = self;
        [_noData setActionBlock:^(id sender) {
            [weakSelf getData];
        }];
    }
    NSUserDefaults *_defaults = [NSUserDefaults standardUserDefaults];
    [_defaults removeObjectForKey:@"historySearch"];
    [_defaults synchronize];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_searchTextField.isFirstResponder == YES)
    {
        [_searchTextField resignFirstResponder];
    }
}

- (void)hotViewWithArray:(NSMutableArray *)array views:(UIView *)views subView:(UIView *)subView
{
    NSMutableArray *arr =[NSMutableArray array];
    
    for (NSInteger i = array.count - 1; i>=0 ; i --)
    {
        [arr addObject:array[i]];
    }
    UIView *_viewBoard = [[UIView alloc]init];
    _viewBoard.backgroundColor = MAIN_COLOR_WHITE;
    _viewBoard.frame = CGRectMake(0 ,1, self.view.frame.size.width, _hotHeight);
    [subView addSubview:_viewBoard];
    CGFloat margin = 10;
   
    for(int i =0 ;i < arr.count ;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 999;
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        button .titleLabel.font = [UIFont systemFontOfSize:12];
        button.backgroundColor = MAIN_BACKGROUND_COLOR;
        [button sizeToFit];
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake( 15,10, button.bounds.size.width+10,24);
        UIButton * lastButton = nil;
        if (i > 0)
        {
            lastButton = (UIButton *)[_viewBoard viewWithTag:i+999-1];
            CGFloat maxX = CGRectGetMaxX(lastButton.frame) ;
            CGFloat maxY = CGRectGetMaxY(lastButton.frame) ;
            if(_viewBoard.frame.size.width - maxX - 2* margin > button.frame.size.width +6)// 能放下
            {
                button.frame = CGRectMake(maxX + margin, lastButton.frame.origin.y, button.bounds.size.width+6, 24);
            }else
            {
                button.frame = CGRectMake(15, maxY +5, button.bounds.size.width+10, 24);
            }
        }
        
        button.layer.cornerRadius = 5.0;
        [_viewBoard addSubview:button];
        if (i == arr.count -1)
        {
            UIButton * lastOneButton = (UIButton *)[_viewBoard viewWithTag:i+999];
            CGFloat maxY = CGRectGetMaxY(lastOneButton.frame)+5 ;
            _hotHeight = maxY;
        }
    }
        _viewBoard.frame = CGRectMake(0 ,0, self.view.frame.size.width , _hotHeight);
}

- (void)historyViewWithArray:(NSMutableArray *)array views:(UIView *)views subView:(UIView *)subView
{
    NSMutableArray *arr =[NSMutableArray array];
    for (NSInteger i = array.count - 1; i>=0 ; i --)
    {
        [arr addObject:array[i]];
    }
    
    UIView *_viewBoard = [[UIView alloc]init];
    _viewBoard.backgroundColor = MAIN_COLOR_WHITE;
    _viewBoard.frame = CGRectMake(0 ,1, self.view.frame.size.width, _hotHeight);
    [subView addSubview:_viewBoard];
    CGFloat margin = 10;
    
    for(int i =0 ;i < arr.count ;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i + 999;
        
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
        button .titleLabel.font = [UIFont systemFontOfSize:12];
        button.backgroundColor = MAIN_BACKGROUND_COLOR;
        [button sizeToFit];
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        if (button.bounds.size.width+ 10 > kScreenWidth - 30)
        {
            button.frame = CGRectMake( 15,10, kScreenWidth - 30,24);
        }
        else
        {
            button.frame = CGRectMake( 15,10, button.bounds.size.width+10,24);
        }
        UIButton * lastButton = nil;
        if (i > 0)
        {
            lastButton = (UIButton *)[_viewBoard viewWithTag:i+999-1];
            CGFloat maxX = CGRectGetMaxX(lastButton.frame) ;
            CGFloat maxY = CGRectGetMaxY(lastButton.frame) ;
            if(_viewBoard.frame.size.width - maxX - 2* margin > button.frame.size.width +6)// 能放下
            {
                button.frame = CGRectMake(maxX + margin, lastButton.frame.origin.y, button.bounds.size.width+6, 24);
            }
            else if(kScreenWidth- 30 < button.frame.size.width + 6)
            {
            
                button.frame = CGRectMake(15, maxY +5, kScreenWidth - 30,24);
            }
            else
            {
                button.frame = CGRectMake(15, maxY +5, button.bounds.size.width+10,24);
            }
        }
        button.layer.cornerRadius = 5.0;
        [_viewBoard addSubview:button];
        if (i == arr.count -1)
        {
            UIButton * lastOneButton = (UIButton *)[_viewBoard viewWithTag:i+999];
            CGFloat maxY = CGRectGetMaxY(lastOneButton.frame)+5 ;
            _hotHeight = maxY;
        }
    }
    _viewBoard.frame = CGRectMake(0 ,0, self.view.frame.size.width , _hotHeight);
}

- (void)action:(UIButton *)sender
{
    _searchTextField.text = sender.titleLabel.text;
    [self searchBtnAction:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
