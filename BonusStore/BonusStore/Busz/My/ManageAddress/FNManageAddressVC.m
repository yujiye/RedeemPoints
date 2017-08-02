//
//  FNManageAddressVC.m
//  BonusStore
//
//  Created by qingPing on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNManageAddressVC.h"
#import "FNHeader.h"
#import "FNAddNewAddressVC.h"
#import "FNAddressTableViewCell.h"
#import "FNMyBO.h"
#import "FNAddressCell.h"
#import "FNAddressModel.h"
#import "UIView+Toast.h"

@interface FNManageAddressVC ()<UITableViewDelegate,UITableViewDataSource,FNAddressCellDelegate>
{
    NSIndexPath * _deleteIndexPath;
    FNNoDataView *_noData;

}

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, weak) UIButton * btn;
@property (nonatomic, strong) NSMutableArray * dataSourceArr;
@property (nonatomic, weak) UIView * addView;
@property (nonatomic,weak)UILabel * tipLabel ;

@end

@implementation FNManageAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址管理";
    [self setNavigaitionBackItem];
    [self setNavigaitionMoreItem];
    self.dataSourceArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [FNLoadingView showInView:self.view];
    __weak __typeof(self) weakSelf = self;
    [[FNMyBO port02] getAddrListWithBlock:^(id result) {
        [FNLoadingView hideFromView:self.view];
        
    if([result[@"code"] integerValue] != 200 || result ==nil)
        {
            _noData.hidden = NO;
            if (!_noData)
            {
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,0 ,kScreenWidth ,kScreenHeight)];
            }
            [_noData setTypeWithResult:result];

            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            
            [_noData setActionBlock:^(id sender) {
                
                [weakSelf refreshData];
            }];
            [self.view addSubview:_noData];
            return ;
        }
        
        NSMutableArray * array = [NSMutableArray array];
        if ([result[@"code"] integerValue] == 200)
        {
            for ( NSDictionary * dict in result[@"addressInfoList"] )
            {
                [array addObject:[FNAddressModel mj_objectWithKeyValues:dict]];
            }
        }

        _noData.hidden = YES;
        [_noData removeFromSuperview];
        self.dataSourceArr = array ;
        if(self.dataSourceArr.count == 0)
        {
            // 无收货地址的时候的显示
            UIView * addView = [self viewWithNoShopping];
            addView.frame = CGRectMake(0, 64, kScreenWidth,kScreenHeight-64);
            [self.view addSubview:addView];
        }else
        {
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight-64 -44)  style: UITableViewStylePlain];
            self.tableView = tableView;
            [self.view addSubview:tableView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.backgroundColor = MAIN_BACKGROUND_COLOR;
            self.tableView.delegate =self;
            self.tableView.dataSource =self;
            self.tableView.showsVerticalScrollIndicator = NO;
            UIView * view = [self addNewAddressView];
            self.addView = view;
            [self.view addSubview:self.addView];
            self.tableView.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
            self.view.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
            [self.tableView reloadData];
        }
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self  selector:@selector(editAddressIsDefault:) name:@"editAddressIsDefault" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editAddress:) name:@"editAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addAddress:) name:@"addAddress" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFirstAddress:) name:@"addFirstAddress" object:nil];
}


-(void)refreshData
{
    [FNLoadingView showInView:self.view];
    __weak __typeof(self) weakSelf = self;
    [[FNMyBO port02] getAddrListWithBlock:^(id result) {
        [FNLoadingView hideFromView:self.view];
        
        if([result[@"code"] integerValue] != 200 || result ==nil)
        {
            _noData.hidden = NO;
            if (!_noData)
            {
                _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,0 ,kScreenWidth ,kScreenHeight)];
            }
            [_noData setTypeWithResult:result];

            _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
            
            [_noData setActionBlock:^(id sender) {
                
                [weakSelf refreshData];
            }];
            [self.view addSubview:_noData];
            return ;
        }
        
        NSMutableArray * array = [NSMutableArray array];
        if ([result[@"code"] integerValue] == 200)
        {
            for ( NSDictionary * dict in result[@"addressInfoList"] )
            {
                [array addObject:[FNAddressModel mj_objectWithKeyValues:dict]];
            }
        }
        
        _noData.hidden = YES;
        [_noData removeFromSuperview];
        self.dataSourceArr = array ;
        if(self.dataSourceArr.count == 0)
        {
            // 无收货地址的时候的显示
            UIView * addView = [self viewWithNoShopping];
            addView.frame = CGRectMake(0, 64, kScreenWidth,kScreenHeight-64);
            [self.view addSubview:addView];
        }else
        {
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight-64 -44)  style: UITableViewStylePlain];
            self.tableView = tableView;
            [self.view addSubview:tableView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.backgroundColor = MAIN_BACKGROUND_COLOR;
            self.tableView.delegate =self;
            self.tableView.dataSource =self;
            self.tableView.showsVerticalScrollIndicator = NO;
            UIView * view = [self addNewAddressView];
            self.addView = view;
            [self.view addSubview:self.addView];
            self.tableView.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
            self.view.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
            [self.tableView reloadData];
        }
    }];
}
// 编辑但是没有设置为默认
- (void)editAddress:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"editAddress"];
    __block NSUInteger row ;
    [self.dataSourceArr enumerateObjectsUsingBlock:^(FNAddressModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.id == add.id)
        {
            row = idx;
            *stop = YES;
        }
    }];
    
    [self.dataSourceArr replaceObjectAtIndex:row withObject:add];
    [self.tableView reloadData];
}

// 编辑并且设置为了默认
- (void)editAddressIsDefault:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"editAddressIsDefault"];
    __block NSUInteger row ;
    [self.dataSourceArr enumerateObjectsUsingBlock:^(FNAddressModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isDefault = 0;
        if(obj.id == add.id)
        {
            row = idx;
        }
    }];
    add.isDefault = 1;
    [self.dataSourceArr replaceObjectAtIndex:row withObject:add];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isDefault" ascending:NO];
    NSArray *array = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [ self.dataSourceArr sortUsingDescriptors:array];
    [self.tableView reloadData];
}

// 添加但不是添加第一个
- (void)addAddress:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"addAddress"];
    if (add.isDefault == 1)
    {
        for (FNAddressModel *model in self.dataSourceArr)
        {
            model.isDefault = 0;
        }
    }
    [self.dataSourceArr addObject:add];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isDefault" ascending:NO];
    NSArray *array = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    [self.dataSourceArr sortUsingDescriptors:array];
    [self.tableView reloadData];
}

// 添加第一个地址
- (void)addFirstAddress:(NSNotification *)noti
{
    FNAddressModel * add = noti.userInfo[@"addFirstAddress"];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight-64 -44)  style: UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.showsVerticalScrollIndicator = NO;
    UIView * view = [self addNewAddressView];
    self.addView = view;
    [self.view addSubview:self.addView];
    self.tableView.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    self.view.backgroundColor = UIColorWithRGB(222.0, 222.0, 222.0);
    [self.dataSourceArr addObject:add];
    [self.tableView reloadData];
    
}
// 添加第一个新地址
- (void)addFirstNewAddress
{
    FNAddNewAddressVC *addNewAddressVC = [[FNAddNewAddressVC alloc]init];
    addNewAddressVC.isEdit = NO;
    addNewAddressVC.isFirstAddress = YES;
    [self.navigationController pushViewController:addNewAddressVC animated:YES];
}

// 添加新地址
- (void)addNewAddress
{
    FNAddNewAddressVC *addNewAddressVC = [[FNAddNewAddressVC alloc]init];
    addNewAddressVC.isEdit = NO;
    
    [self.navigationController pushViewController:addNewAddressVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FNAddressModel *addressModel =  self.dataSourceArr[indexPath.row];
    FNAddressCell *cell = [FNAddressCell addressCellWithTableView:tableView];
    cell.delegate = self;
    cell.addressModel = addressModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  104+10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001f;
}

// 如果是从填写订单进入收货地址管理的话，点击某一行代表选中该地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.fromFillOrder == YES)
    {
        FNAddressModel *addressModel =  self.dataSourceArr[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clickAddress" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:addressModel,@"clickAddress", nil]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 编辑，设置默认，删除的事件
//  默认地址只能一个， 在这把以前的默认地址设置为不是默认地址
- (void)addressCellBtnClick:(FNAddressCell *)cell flag:(NSInteger)flag
{
    NSIndexPath *index  = [self.tableView indexPathForCell:cell];
    FNAddressModel  *addressModel = self.dataSourceArr[index.row];
    _deleteIndexPath = index;
    
    switch (flag) {
        case kButtonTypeEdit:
        {
            FNAddNewAddressVC *addNewAddressVC = [[FNAddNewAddressVC alloc]init];
            addNewAddressVC.isEdit = YES;
            addNewAddressVC.addressModel = addressModel;
            [self.navigationController pushViewController:addNewAddressVC animated:YES];
            
        }
            break;
        case kButtonTypedelete:
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle: nil  message:@" 是否要删除该地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消" , nil];
            [alert show];
        }
            break;
        case kButtonTypeDefault:
        {
            [[FNMyBO port02]setDefaultAddressWithId:addressModel.id block:^(id result) {
                if ([result[@"code"] integerValue] == 200)
                {
                    for(FNAddressModel * model in self.dataSourceArr)
                    {
                        model.isDefault = 0;
                    }
                    addressModel.isDefault = 1;
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isDefault" ascending:NO];
                    NSArray *array = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
                    [ self.dataSourceArr sortUsingDescriptors:array];
                    [self.tableView reloadData];
                    [self.view makeToast:@"设置默认成功"];
                    
                }else
                {
                    if(result)
                    {
                        [self.view makeToast:result[@"desc"]];
                    }else
                    {
                        [self.view makeToast:@"加载失败,请重试"];
                    }

                }
            }];
            
        }
            break;
            
        default:
            break;
    }
}

// 是否删除
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
      
        FNAddressModel *model = self.dataSourceArr[_deleteIndexPath.row];
        [[FNMyBO port02] delAddrWithAddrID:model.id block:^(id result) {
            if ([result[@"code"] integerValue] == 200)
            {
                [self.view makeToast:@"删除成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteAddress" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:model,@"deleteAddress", nil]];
                [self.dataSourceArr removeObjectAtIndex:_deleteIndexPath.row];
                [self.tableView reloadData];
            }else
            {
                if(result)
                {
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
            }
            
        }];
        if (self.dataSourceArr.count == 1)
        {
            UIView * addView = [self viewWithNoShopping];
            self.view.backgroundColor = MAIN_COLOR_WHITE;
            addView.frame = CGRectMake(0, 64, kScreenWidth,kScreenHeight-64);
            addView.backgroundColor = MAIN_COLOR_WHITE;
            
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            bgView.backgroundColor = MAIN_COLOR_WHITE;
            [bgView addSubview:addView];
            [self.view addSubview:bgView];
            [self.btn removeFromSuperview];
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"editAddressIsDefault" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"editAddress" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addFirstAddress" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addAddress" object:nil];
}


// 无收货地址时候的view
- (UIView *)viewWithNoShopping
{
    UIView *view = [[UIView alloc]init];
    
    UIImageView *shoppingView = [[UIImageView alloc]init];
    [shoppingView setImage:[UIImage imageNamed:@"cart_unLogin_logo"]];
    shoppingView.frame = CGRectMake((kScreenWidth -224)*0.5, 34, 224, 171);
    [view addSubview:shoppingView];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    NSString *tipLabelStr = @"客官～您还没有登记收货地址哟 ～ ";
    tipLabel.text = tipLabelStr;
    tipLabel.textAlignment = NSTextAlignmentCenter ;
    [tipLabel clearBackgroundWithFont:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithRed:30.0/255 green:30.0/255 blue:30.0/255 alpha:1.0]];
    CGFloat tipLabelY = CGRectGetMaxY(shoppingView.frame)  + 5;
    CGSize tipLabelSize = [tipLabelStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    tipLabel.frame = CGRectMake((kScreenWidth - tipLabelSize.width) * 0.5, tipLabelY, tipLabelSize.width, tipLabelSize.height);
    [view addSubview:tipLabel];
    
    UIButton * aroundBtn = [[UIButton alloc]init];
    NSString * aroundBtnStr = @"添加收货地址";
    CGFloat aroundBtnY = CGRectGetMaxY(tipLabel.frame) + 5 ;
    aroundBtn.frame = CGRectMake((kScreenWidth - 195) * 0.5, aroundBtnY, 195, 41);
    [aroundBtn.layer setBorderWidth:1];
    [aroundBtn.layer setBorderColor:UIColorWithRGB(239.0, 48.0, 48.0).CGColor ];
    [aroundBtn setBackgroundColor:UIColorWithRGB(239.0, 48.0, 48.0)];
    [aroundBtn.layer setCornerRadius:5];
    [aroundBtn.layer setMasksToBounds:YES];
    [aroundBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [aroundBtn setTitle:aroundBtnStr  forState:UIControlStateNormal];
    [aroundBtn addTarget:self action:@selector(addFirstNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [aroundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:aroundBtn];
    
    return view;
}

- (UIView *)addNewAddressView
{
    UIButton * btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor redColor];
    self.btn = btn;
    [btn setTitle:@"添加新地址" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    [btn addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, kScreenHeight - 44-64, kScreenWidth, 44);
    return btn;
}

@end
