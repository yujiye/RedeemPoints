//
//  FNOrderSendGoodsVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderSendGoodsVC.h"

#import "FNOrderSendGoodsCell.h"

#import "FNOrderSendGoods.h"

static CGFloat CellHeight = 130;

static CGFloat Height     = 53;

@interface FNOrderSendGoodsVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableview;

@property (nonatomic, strong) NSMutableArray * datasources;
@end

@implementation FNOrderSendGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待发货";

    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    self.datasources = [FNOrderSendGoods goods];
    
    [self tableview];
}

- (UITableView *)tableview
{
    if (_tableview == nil) {
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        [_tableview registerClass:[FNOrderSendGoodsCell class] forCellReuseIdentifier:NSStringFromClass([FNOrderSendGoodsCell class])];
        
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableview.delegate = self;
        
        _tableview.dataSource = self;
        
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNOrderSendGoods * model = self.datasources[indexPath.row];
    
    FNOrderSendGoodsCell * cell = [FNOrderSendGoodsCell sendGoodsTableView:tableView];
    
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
