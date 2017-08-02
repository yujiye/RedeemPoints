//
//  FNSystemVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSystemVC.h"

#import "FNMainBO.h"

@interface FNSystemVC ()<UITableViewDataSource,UITableViewDelegate>
{
    FNNoDataView *_noData;
}

@property (nonatomic, strong) UITableView * tableview;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) NSMutableArray * contentArray;

@property (nonatomic, strong) NSMutableArray * data;

@end

@implementation FNSystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"系统消息";

    [self setNavigaitionMoreItem];
    
    [self setNavigaitionBackItem];
    
    _data = [NSMutableArray array];

    [self tableview];
    [self loadMore];

}

- (void)loadMore
{
    __weak typeof(self) weakSelf = self;
    [FNLoadingView showInView:self.view];
    [_noData removeFromSuperview];
    _noData = nil;

    [[[FNMainBO port01] withOutUserInfo] getMessageListWithBlock:^(id result) {
        if (![result isKindOfClass:[NSArray class]] || result == nil || [(NSArray *)result count] == 0)
        {
            [FNLoadingView hide];
            _tableview.hidden = YES;
            if (!_noData)
            {
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0 ,0 , kWindowWidth, kWindowHeight)];
            }
            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            [_noData setTypeWithResult:result];
            [_noData setActionBlock:^(id sender) {
                [weakSelf loadMore];
            }];
            [self.view addSubview:_noData];
        }
        else if ([result isKindOfClass:[NSArray class]])
        {
            [FNLoadingView hide];
            _tableview.hidden = NO;
            _data = result;
            [_tableview reloadData];
        }
    }];
}

- (UITableView *)tableview
{
    if (_tableview == nil) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
        
        [_tableview registerClass:[FNSystemCell class] forCellReuseIdentifier:NSStringFromClass([FNSystemCell class])];
        
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableview.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        _tableview.delegate = self;
        
        _tableview.dataSource = self;
        
        [self.view addSubview:_tableview];
    }
    return _tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNSystemCell * cell = [FNSystemCell systemTableView:tableView];

    FNMessageArgs * model = _data[indexPath.section];
    
    [cell setModel:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNMessageArgs * model = _data[indexPath.section];
    
    CGFloat titleHeight = [self textHeight:model.title];
    CGFloat height = [self textHeight:model.content];
    
    return titleHeight+height+20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FNActivityHeadView * header = [[FNActivityHeadView alloc]initWithFrame:CGRectMake(112, 12, kScreenWidth - 112, 12)];
    
    FNSysteModel * model = _data[section];
    
    header.time.text = model.beginDate;
    
    return header;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 44;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        
    }
}
- (CGFloat)textHeight:(NSString *)string{

    CGRect rect =[string boundingRectWithSize:CGSizeMake(394, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    return rect.size.height;//返回高度
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
