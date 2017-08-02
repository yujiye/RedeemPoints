//
//  ViewController.m
//  De
//
//  Created by sugarwhi on 16/4/20.
//  Copyright © 2016年 sugarwhi. All rights reserved.
//

#import "FNQuestionVC.h"

@interface FNQuestionVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView * sectionView;
    
    UIButton * sectionButton;
}

@property(nonatomic, strong)UITableView *tableview;

@property(nonatomic, strong)NSMutableArray *sectionTitle;//section标题

@property(nonatomic, strong)NSMutableArray *rowInSectionArray;//section中的cell个数

@property(nonatomic, strong)NSMutableArray *selectedArray;//是否被点击

@property(nonatomic, strong)NSMutableArray *titleArray;//cell的标题

@property (nonatomic, strong) UIImageView * imagev;

@property (nonatomic, strong) NSMutableArray * titleArray1;

@property (nonatomic, strong) NSMutableArray * titleArray2;

@property(nonatomic, assign)NSInteger flag;

@property (nonatomic, strong)NSMutableArray * data;

@end

@interface FNQuestionVC ()

@end

@implementation FNQuestionVC

-(void)loadView
{
    [super loadView];
    _flag = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"常见问题";
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    _sectionTitle = [NSMutableArray arrayWithObjects:@"积分获得",@"支付方式",@"售后政策",@"线下消费", nil];
    
    _rowInSectionArray = [NSMutableArray arrayWithObjects:@"3",@"0",@"2",@"0", nil];
    
    _selectedArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];
    
    _titleArray = [NSMutableArray arrayWithObjects:@"中国移动积分/和包",@"中国电信积分兑换",@"消费累积",nil];
    
    _titleArray2 = [NSMutableArray arrayWithObjects:@"售后政策",@"退换货流程", nil];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [self tableview];
    
}

- (UITableView *)tableview
{
    if (_tableview == nil)
    {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        _tableview.tableFooterView = [[UIView alloc]init];
        
        _tableview.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        _tableview.dataSource = self;
        
        _tableview.delegate = self;
        
        [self.view addSubview:_tableview];
    }
    return _tableview;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier2 = @"cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
    }
    if (indexPath.section == 0)
    {
        cell.textLabel.text = _titleArray[indexPath.row];
        
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 2)
    {
        cell.textLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:16];
        
        cell.textLabel.textColor = [UIColor lightGrayColor];
        
        cell.textLabel.text = _titleArray2[indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //判断section的标记是否为1,如果是说明为展开,就返回真实个数,如果不是就说明是缩回,返回0.
    if ([_selectedArray[section] isEqualToString:@"1"])
    {
        return [_rowInSectionArray[section]integerValue];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNWebVC *vc = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                    vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"jifen" ofType:@"html"]];
                    vc.title = _titleArray[indexPath.row];
                    break;
                case 1:
                    vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"duihuan" ofType:@"html"]];
                    vc.title = _titleArray[indexPath.row];
                    break;
                case 2:
                    vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"xiaofei" ofType:@"html"]];
                    vc.title = _titleArray[indexPath.row];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
            
            break;
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                    vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"shouhou" ofType:@"html"]];
                    vc.title = _titleArray2[indexPath.row];
                    break;
                case 1:
                    vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"tuihuan" ofType:@"html"]];
                    vc.title = _titleArray2[indexPath.row];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
           
            break;
            
        default:
            break;
    }
    
    [vc setNavigaitionMoreItem];

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark section的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitle.count;
}

#pragma cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
}

#pragma mark - section内容
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 48)];
    
    sectionView.backgroundColor = MAIN_COLOR_WHITE;
    
   sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    sectionButton.frame = CGRectMake(15, 0, sectionView.frame.size.width, 48);
    
    sectionButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:16];
    
    [sectionButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [sectionButton setTitleColor:MAIN_COLOR_BLACK_ALPHA forState:UIControlStateNormal];
    
    [sectionButton setTitle:[_sectionTitle objectAtIndex:section] forState:UIControlStateNormal];
    
    _imagev = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width -  45, 20, 16, 8)];
    
    [sectionView addSubview:sectionButton];
    
    if (section == 0 || section == 2)
    {
        [sectionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        sectionButton.tag = 1000 + section;
        
        _imagev.image = [UIImage imageNamed:@"bonus_indicator_n"];
        
        [sectionButton addSubview:_imagev];
    }
    if (section == 1|| section == 3)
    {
        if (section == 1)
        {
            [sectionButton addTarget:self action:@selector(sectionAction1) forControlEvents:UIControlEventTouchUpInside];
        }
        if (section == 3)
        {
            [sectionButton addTarget:self action:@selector(sectionAction3) forControlEvents:UIControlEventTouchUpInside];
        }
        _imagev.frame = CGRectMake(self.view.bounds.size.width -  45, 20, 10, 16);
        
        _imagev.image = [UIImage imageNamed:@"main_rank_more"];
        
        [sectionButton addSubview:_imagev];
        
    }
    return sectionView;
}

- (void)sectionAction1
{
    FNWebVC *vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"pay" ofType:@"html"]];
    
    vc.title = _sectionTitle[1];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sectionAction3
{
    FNWebVC *vc = [[FNWebVC alloc] initWithPath:[[NSBundle mainBundle]pathForResource:@"xianxia" ofType:@"html"]];
    
    vc.title = _sectionTitle[3];
    
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark button点击方法
-(void)buttonAction:(UIButton *)button
{
    if ([_selectedArray[button.tag - 1000] isEqualToString:@"0"])
    {
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"1"];
        
        [_tableview reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        
        _imagev.image = [UIImage imageNamed:@"icon_top"];
    
    }
    else
    {
        [_selectedArray replaceObjectAtIndex:button.tag - 1000 withObject:@"0"];
        
        [_tableview reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 1000] withRowAnimation:UITableViewRowAnimationFade];
        
        _imagev.image = [UIImage imageNamed:@"bonus_indicator_n"];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
