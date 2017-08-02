//
//  FNSearchAreaVC.m
//  BonusStore
//
//  Created by cindy on 2016/11/8.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSearchAreaVC.h"
#import "FNHeader.h"
#import "FNRechargeBO.h"
@interface FNSearchAreaVC ()<UITableViewDelegate,UITableViewDataSource>
{
    AreaModelClickBlock _areaModelClickBlock;
}
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation FNSearchAreaVC
- (void)setBlockAreaModelClick:(AreaModelClickBlock )block
{
    _areaModelClickBlock = nil;
    _areaModelClickBlock = block;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.tipString;

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    if ([self.tableView respondsToSelector: @selector (setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:MAIN_BACKGROUND_COLOR];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuserId = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.frame = CGRectMake(20, 0, kScreenWidth -48, 60);
        cell.textLabel.font = [UIFont fzltWithSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = UIColorWithRGB(51, 51, 51);
    }
    
    FNGameAreaModel *gameModel = self.gameArr[indexPath.row];
    cell.textLabel.text = gameModel.gameAreaName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNGameAreaModel * gameAreaModel = self.gameArr[indexPath.row];
    if (_areaModelClickBlock)
    {
        _areaModelClickBlock(gameAreaModel);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end

@implementation FNGameAreaModel
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{@"gameSeaverList" : [FNSeaverModel class] };
}

@end

@implementation FNSeaverModel

@end
