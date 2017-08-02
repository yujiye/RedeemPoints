//
//  FNSexVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSexVC.h"

#import "FNMyBO.h"

@interface FNSexVC ()<UITableViewDataSource,UITableViewDelegate>
{
    FNPersonalModel * personal;
}

@property (nonatomic, strong) UITableView * tableview;

@property (nonatomic, strong) NSArray * data;

@property (nonatomic, assign) NSInteger selectRow;

@end


@implementation FNSexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"性别修改";
    
    [self tableview];
    
    [self setNavigaitionBackItem];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    self.data = @[@"保密",@"男",@"女"];
    
    for (NSString *str in self.data)
    {
        if ([str isEqualToString:self.sex])
        {
            break;
        }
        
        _selectRow++;
    }
    
    [_tableview reloadData];
}

- (UITableView *)tableview
{
    if (_tableview == nil) {
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180) style:UITableViewStylePlain];
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableview.separatorStyle =  UITableViewCellSeparatorStyleSingleLine;
        
        _tableview.dataSource = self;
        
        _tableview.delegate = self;
        
        [self.view addSubview:_tableview];
    }
    return _tableview;
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    if (indexPath.row == _selectRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectRow == indexPath.row)
    {
        
    }
    else
    {
        NSIndexPath * indexPath2 = [NSIndexPath indexPathForRow:_selectRow inSection:0];

        UITableViewCell * cell2 = [tableView cellForRowAtIndexPath:indexPath2];

        cell2.accessoryType = UITableViewCellAccessoryNone;
        
        _selectRow = (NSInteger)indexPath.row;

        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    self.sexBlock(_selectRow);
    
    FNPersonalModel * _personalModel = [[FNPersonalModel alloc]init];
    
    _personalModel.sex = _selectRow;
    
    [FNLoadingView showInView:self.view];
    
    __weak __typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[FNMyBO port02] updateUser:_personalModel block:^(id result) {
            
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
            }
            else
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
