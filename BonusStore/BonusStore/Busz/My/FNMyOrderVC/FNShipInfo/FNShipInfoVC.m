//
//  FNLogisInformationController.m
//  BonusStore
//
//  Created by feinno on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNShipInfoVC.h"
#import "FNHeader.h"
#import "FNShipCell.h"
#import "FNMyBO.h"
#import "FNShipModel.h"
#import "UIView+Toast.h"
@interface FNShipInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) FNShipModel *shipModel;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, strong) UIView * headView2;
@property (nonatomic, weak) UILabel *label2;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic,weak)UILabel * tipLabel ;
@property (nonatomic, weak)UIView *bgView;

@end

@implementation FNShipInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    self.shipModel = [[FNShipModel alloc]init];
    [self setNavigaitionBackItem];
    [self setNavigaitionMoreItem];
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [FNMyBO getExpressWithOrderID:self.orderArgs.orderId expressId:self.orderArgs.expressId expressNo:self.orderArgs.expressNo block:^(id result) {

        if ([result[@"code"] integerValue]!=200)
        {
            UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            bgView.backgroundColor = MAIN_BACKGROUND_COLOR;
            self.bgView = bgView;
            [self.view addSubview:bgView];
            UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 60)*0.5, (kScreenWidth -72) *0.5, 60, 72)];
            imgView.image = [UIImage imageNamed:@"no_data_logo"];
            self.imgView = imgView;
            [self.view addSubview:imgView];
            UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 120)*0.5, (kScreenWidth -72) *0.5+72, 120, 30)];
            self.tipLabel = tipLabel;
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.text = @"加载失败点击屏幕重试";
            tipLabel.font = [UIFont systemFontOfSize:12];
            tipLabel.textColor = UIColorWithRGB(52.0, 52.0, 52.0);
            [self.view addSubview:tipLabel];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shipDataReload)];
            [bgView addGestureRecognizer:tap];

        }else
        {
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 ) style:UITableViewStylePlain];
            self.tableView.backgroundColor = [UIColor whiteColor];
            FNShipModel * shipModel = [[FNShipModel alloc]init];
            shipModel.id = [self.orderArgs.expressNo integerValue];
            shipModel.name = result[@"name"];
            NSMutableArray * arr = [NSMutableArray array];
            if (![ result[@"traceItems"] isKindOfClass:[NSNull class]])
            {
             for ( NSDictionary * dict in result[@"traceItems"])
             {
                [arr addObject:[FNTraceModel mj_objectWithKeyValues:dict]];
              }
            }
                UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                UILabel *label1 = [[UILabel alloc]init];
                label1.backgroundColor = [UIColor grayColor];
                label1.frame = CGRectMake(kScreenWidth * 0.2, 22, kScreenWidth*0.6, 1);
                [footView addSubview:label1];
                UILabel *footLabel  = [[UILabel alloc]init];
                footLabel.backgroundColor = [UIColor whiteColor];
                footLabel.text = @"已无更多数据";
                footLabel.font = [UIFont systemFontOfSize:14];
                footLabel.textAlignment = NSTextAlignmentCenter;
                footLabel.textColor =UIColorWithRGB(52.0, 52.0, 52.0);
                CGSize labelSize = [footLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                footLabel.frame = CGRectMake((kScreenWidth - labelSize.width)*0.5, 0, labelSize.width, 44);
                [footView addSubview:footLabel];
                self.tableView.tableFooterView = footView;
                

            
            shipModel.traceJson = arr;
            self.shipModel = shipModel;
            [self sectionView];
            self.tableView.delegate = self;
            self.tableView.dataSource =self;
            self.tableView.showsVerticalScrollIndicator = NO;
            self.tableView.showsHorizontalScrollIndicator = NO;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
        }
        
    }];
    
}
-(void)shipDataReload
{
    self.tipLabel.text = @"正在加载中...";
    self.imgView.image = [UIImage imageNamed:@"loading"];
    [FNMyBO getExpressWithOrderID:self.orderArgs.orderId expressId:self.orderArgs.expressId expressNo:self.orderArgs.expressNo block:^(id result) {
        if ([result[@"code"] integerValue] == 200)
        {
            self.bgView.hidden =YES;
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 ) style:UITableViewStylePlain];
            self.tableView.backgroundColor = [UIColor whiteColor];
            FNShipModel * shipModel = [[FNShipModel alloc]init];
            shipModel.id = [self.orderArgs.expressNo integerValue];
            shipModel.name = result[@"name"];
            NSMutableArray * arr = [NSMutableArray array];
            for ( NSDictionary * dict in result[@"traceItems"])
            {
                [arr addObject:[FNTraceModel mj_objectWithKeyValues:dict]];
            }
//            if(arr.count == 0)
//            {
                UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                
                UILabel *label1 = [[UILabel alloc]init];
                label1.backgroundColor = [UIColor grayColor];
                label1.frame = CGRectMake(kScreenWidth * 0.2, 22, kScreenWidth*0.6, 1);
                [footView addSubview:label1];
                UILabel *footLabel  = [[UILabel alloc]init];
                footLabel.backgroundColor = [UIColor whiteColor];
                footLabel.text = @"已无更多数据";
                footLabel.font =[UIFont systemFontOfSize:14];
                footLabel.textAlignment = NSTextAlignmentCenter;
                footLabel.textColor =UIColorWithRGB(52.0, 52.0, 52.0);
                CGSize labelSize = [footLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
                footLabel.frame = CGRectMake((kScreenWidth - labelSize.width)*0.5, 0, labelSize.width, 44);
                [footView addSubview:footLabel];
                self.tableView.tableFooterView = footView;
                
//            }
            shipModel.traceJson = arr;
            self.shipModel = shipModel;
            [self sectionView];
            self.tableView.delegate = self;
            self.tableView.dataSource =self;
            self.tableView.showsVerticalScrollIndicator = NO;
            self.tableView.showsHorizontalScrollIndicator = NO;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
  
        }else
        {
            self.tableView.hidden = YES;
            self.tipLabel.text = @"加载失败点击屏幕重试";
            self.imgView.image = [UIImage imageNamed:@"no_data_logo"];
        }
    }];

}

- (void) sectionView
{
    self.headView = [[UIView alloc]init];
    self.headView.backgroundColor = [UIColor whiteColor];
    UILabel * label =[[UILabel alloc]init];
    self.label = label;
    self.label.frame = CGRectMake(20, 0, kScreenWidth -30, 43);
    [self.label clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
    [self.headView addSubview:label];
    
    UILabel * lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = MAIN_COLOR_SEPARATE;
    lineLabel.frame = CGRectMake(0, 43, kScreenWidth, 1);
    [self.headView addSubview:lineLabel];
    
    self.headView2 = [[UIView alloc]init];
    self.headView2.backgroundColor = [UIColor whiteColor];
    UILabel *label2 = [[UILabel alloc]init];
    self.label2 = label2;
    [self.label2 clearBackgroundWithFont:[UIFont systemFontOfSize:14] textColor:UIColorWithRGB(52.0, 52.0, 52.0)];
    self.label2.frame = CGRectMake(20, 0, kScreenWidth-30, 44);
    [self.headView2 addSubview:label2];
    
    UILabel * lineLabel2 = [[UILabel alloc]init];
    lineLabel2.backgroundColor = MAIN_COLOR_SEPARATE;
    lineLabel2.frame = CGRectMake(0, 43, kScreenWidth, 1);
    [self.headView2 addSubview:lineLabel2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        
        return 0;
    }else
    {
        return self.shipModel.traceJson.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section ==1)
    {
      FNShipModel * model = self.shipModel;
      FNTraceModel * traceModel = model.traceJson[indexPath.row];
      return [FNShipCell cellHeightWithModel:traceModel];
    }else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     if(section ==0)
     {
         self.label.text = [NSString stringWithFormat:@"物流商  :            %@",self.shipModel.name];
          return self.headView;
     }
    if(section ==1)
     {
         self.label2.text = [NSString stringWithFormat:@"物流单号:           %zd",self.shipModel.id];
        return self.headView2;
     }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FNShipCell *cell = [FNShipCell  shipCellWithTableView:tableView];
    FNShipModel * model = self.shipModel;
    FNTraceModel * traceModel = model.traceJson[indexPath.row];
    cell.traceModel = traceModel ;
     if(indexPath.row == 0)
     {
         cell.timeLabel.textColor = [UIColor redColor];
         cell.shipLabel.textColor = [UIColor redColor];
     }else
     {
         cell.timeLabel.textColor = UIColorWithRGB(52.0, 52.0, 52.0);
         cell.shipLabel.textColor = UIColorWithRGB(52.0, 52.0, 52.0);

     }
    return cell;
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

@end
