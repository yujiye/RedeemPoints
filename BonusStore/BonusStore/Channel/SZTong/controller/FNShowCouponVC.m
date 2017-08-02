//
//  FNShowCouponVC.m
//  BonusStore
//
//  Created by cindy on 2017/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNShowCouponVC.h"
#import "FNHeader.h"
#import "OrderReq.h"
#import "Mask.h"
@interface FNShowCouponVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UILabel *noLabel; //无充值券
@property (nonatomic, strong)UILabel *choiceLabel;
@property (nonatomic, strong)UIButton * payBtn; //支付或者购买卡券

@property (nonatomic, strong)NSMutableArray * dataArr;
@property (nonatomic, assign)NSInteger seleIndex;
@property (nonatomic, strong)UICollectionView * collectionView;

@end

@implementation FNShowCouponVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"深圳通充值";
    [self setNavigaitionBackItem];
    [self addAndLayoutSubView];
    self.dataArr = [NSMutableArray array];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)refreshData
{
    OrderReq *orderReq  = [OrderReq new];
    orderReq.token = FNUserAccountInfo[@"token"];
    orderReq.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
    NSDictionary * user = [FNUserAccountArgs getUserAccount];
    orderReq.phoneNo =  [user valueForKey:@"mobile"];
    _payBtn.hidden = YES;
    _noLabel.hidden = YES;
    _choiceLabel.hidden = YES;
    self.collectionView.hidden = YES;
    [self.dataArr removeAllObjects];
    [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
    
    [[OrderAPI sharedManager]getVoucherCount:orderReq success:^(RequestResult *requestResult) {
        [Mask HUDHideInView:self.view];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (requestResult.status == 0)
            {
                //成功
                if(![requestResult.results isKindOfClass:[NSNull class]])
                {
                    NSMutableArray * arrM = [NSMutableArray array];
                    for (NSDictionary * dict in requestResult.results )
                    {
                        FNShowCouponModel *model =  [FNShowCouponModel mj_objectWithKeyValues:dict];
                        model.isChoice = NO;
                        [arrM addObject:model];
                    }
                    self.dataArr = arrM;
                }
                
                if (self.dataArr.count > 0)
                {
                    _noLabel.hidden = YES;
                    _choiceLabel.hidden = NO;
                    [_payBtn setTitle:@"充值" forState:UIControlStateNormal];
                    _payBtn.hidden = NO;
                    FNShowCouponModel * firstModel =  self.dataArr.firstObject;
                    firstModel.isChoice = YES;
                    _seleIndex = 0;
                    self.collectionView.hidden = NO;
                    [self.collectionView reloadData];
                    
                }else
                {
                    self.collectionView.hidden = YES;
                    _noLabel.hidden = NO;
                    _choiceLabel.hidden = YES;
                    _payBtn.hidden = NO;
                    [_payBtn setTitle:@"去买券" forState:UIControlStateNormal];
                }
            }
            
        });
        
    } failure:^(RequestResult *requestResult) {
        [Mask HUDHideInView:self.view];
        [self.view makeToast:@"数据获取失败，请返回重试"];
        self.collectionView.hidden = YES;
        _noLabel.hidden = YES;
        _choiceLabel.hidden = YES;
        _payBtn.hidden = YES;
        
    }];
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(124,63);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    CGFloat marginW = (kScreenWidth  -2*124)/3.0;

    return UIEdgeInsetsMake(15, marginW, 15, marginW);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FNShowCoupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNShowCoupCell class]) forIndexPath:indexPath];
    cell.showCouponModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (FNShowCouponModel * model in self.dataArr)
    {
        model.isChoice = NO;
    }
    FNShowCouponModel *seleModel = self.dataArr[indexPath.row];
    seleModel.isChoice = YES;
    _seleIndex = indexPath.row;
    [self.collectionView reloadData];
}

- (void)addAndLayoutSubView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    headView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showCoupon_order_bg"]];
    [self.view addSubview:headView];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -97)*0.5, 16, 97, 97)];
    imgView.image = [UIImage imageNamed:@"showCoupon_order"];
    [headView addSubview:imgView];
    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgView.frame)+5, kScreenWidth -30, 14)];
    tipLabel.text = @"深圳通";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:tipLabel];
    
    CGFloat btnW =  kScreenWidth/3.0;
    CGFloat btnY = CGRectGetMaxY(headView.frame);
    NSArray *imageArr  =@[@"balance_sz",@"order_sz",@"useTip_sz"];
    NSArray * titleArr = @[@"卡片余额",@"充值订单",@"使用说明"];
    for (int i =0;i<3;i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW*i, btnY, btnW, 60);
        [btn setImage: [UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorWith0xRGB(0x4A4A4A) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
        if (i ==1||i==2)
        {
             UILabel * lineLab = [[UILabel alloc]initWithFrame:CGRectMake(btnW *i-1, 15+140, 1, 30)];
            lineLab.backgroundColor = UIColorWith0xRGB(0xDCDADA);
            [self.view addSubview:lineLab];
        }
        
    }
    UILabel * backLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 200-1, kScreenWidth, 1)];
    backLine.backgroundColor = UIColorWith0xRGB(0xDCDADA);
    [self.view addSubview:backLine];
    
     _choiceLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,200+12, kScreenWidth -30, 12)];
    _choiceLabel.textColor = UIColorWith0xRGB(0x666666);
    _choiceLabel.font = [UIFont systemFontOfSize:12];
    _choiceLabel.text = @"请选择充值券";
    _choiceLabel.hidden = YES;
    [self.view addSubview:_choiceLabel];
    
    UILabel * intrLab = [[UILabel alloc]initWithFrame:CGRectMake(15, kScreenHeight - 44-64, kScreenWidth -30, 32)];
    intrLab.numberOfLines = 0;
    intrLab.textColor = UIColorWith0xRGB(0x999999);
    intrLab.font = [UIFont systemFontOfSize:12];
    intrLab.textAlignment = NSTextAlignmentCenter;
    intrLab.text = @"本服务由深圳市深圳通电子商务有限公司提供\n客服电话:4008883700";
    [self.view addSubview:intrLab];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.backgroundColor = UIColorWith0xRGB(0xEF3030);
    _payBtn.frame = CGRectMake(15, kScreenHeight -44-60-64, kScreenWidth -30, 44);
    [_payBtn addTarget:self action:@selector(rechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _payBtn.titleLabel.font = [UIFont fzltWithSize:18];
    _payBtn.layer.cornerRadius = 4;
    _payBtn.layer.masksToBounds = YES;
    [self.view addSubview:_payBtn];
    _payBtn.hidden = YES;
    CGFloat needHeight = CGRectGetMinY(_payBtn.frame);
    //无卡券
    _noLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 230+(needHeight -230)*0.5, kScreenWidth -30, 14)];
    _noLabel.textAlignment = NSTextAlignmentCenter;
    _noLabel.textColor = UIColorWith0xRGB(0x666666);
    _noLabel.font = [UIFont systemFontOfSize:14];
    _noLabel.text = @"您还没有充值券哦~";
    _noLabel.hidden = YES;
    [self.view addSubview:_noLabel];
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 230, kScreenWidth, needHeight -230)collectionViewLayout:flowLayOut];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[FNShowCoupCell class] forCellWithReuseIdentifier:NSStringFromClass([FNShowCoupCell class])];
    [self.view addSubview:self.collectionView];
}


- (void)headBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            //卡片余额
            FNSZBLSearchListVC *myOderVC = [[FNSZBLSearchListVC alloc]init];
            myOderVC.stateEntry = FNSZStateEntryBalance;
            [self.navigationController pushViewController:myOderVC animated:YES];
        }
            break;
        case 1:
        {
            //充值订单
            FNReChargeOrderVC *rechargeOrderVC = [[FNReChargeOrderVC alloc]init];
            [self.navigationController pushViewController:rechargeOrderVC animated:YES];

        }
            break;
        case 2:
        {
            //使用说明
            FNSZBLRechargeIntroVC *useVC = [[FNSZBLRechargeIntroVC alloc]init];
            [self.navigationController pushViewController:useVC animated:YES];

        }
            break;
            
        default:
            break;
    }
}

//充值或者是去买卡券
- (void)rechargeBtnClick:(UIButton *)btn
{
    if( self.dataArr.count > 0)
    {
        //有卡券去订单确认页
        _payBtn.enabled = NO;
        FNShowCouponModel * showCouponModel  = self.dataArr[_seleIndex];
        OrderReq *orderReq  = [OrderReq new];
        orderReq.token = FNUserAccountInfo[@"token"];
        orderReq.openId = [NSString stringWithFormat:@"%@", FNUserAccountInfo[@"userId"]];
        NSDictionary * user = [FNUserAccountArgs getUserAccount];
        orderReq.phoneNo =  [NSString stringWithFormat:@"%@", [user valueForKey:@"mobile"]];
        orderReq.orderMoney = [NSString stringWithFormat:@"%d",[showCouponModel.amount intValue]];
        orderReq.orderType = charge;
        [Mask HUDShowInView:self.view AndController:self AndHUDColor:[UIColor clearColor] AndLabelText:@"正在加载..." AndDetailsLabelText:nil AndDimBackground:NO];
        [[OrderAPI sharedManager]getChargeOrder:orderReq success:^(RequestResult *requestResult) {
            _payBtn.enabled = YES;

            if (requestResult.status == 0)
            {
                [Mask HUDHideInView:self.view];

                if(![requestResult.resultInfo isKindOfClass:[NSNull class]])
                {
                 FNOrderConfVC *orderConfVC = [[FNOrderConfVC alloc]init];
                 orderConfVC.money = [NSString stringWithFormat:@"%@",showCouponModel.amount];
                 orderConfVC.moneyCount = [NSString stringWithFormat:@"%@",showCouponModel.couponCount];
                    orderConfVC.orderno = [requestResult.resultInfo objectForKey:@"orderNo"];
                [self.navigationController pushViewController:orderConfVC animated:YES];
                }
            }else
            {
                [Mask HUDHideInView:self.view];

                [self.view makeToast:@"下单失败,请重试"];
            }
            
        } failure:^(RequestResult *requestResult) {
            [Mask HUDHideInView:self.view];
            _payBtn.enabled = YES;
            [self.view makeToast:@"下单失败,请重试"];

        }];
        
    }else
    {
        //去购券页
        FNBuyCouponVC * buyVC = [[FNBuyCouponVC alloc]init];
        [self.navigationController pushViewController:buyVC animated:YES];

    }
}
-(void)goBack
{
    for (NSInteger i = 0; i <self.navigationController.viewControllers.count; i++) {
        UIViewController *VC = self.navigationController.viewControllers[i];
        
        if ([VC isKindOfClass:[FNSZWelcomeVC class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KRemoveTestPIc" object:nil userInfo:@{@"position":@(i)}];
            [self.navigationController popToViewController:VC animated:NO];
            return;
        }
        
        if ([VC isKindOfClass:[FNOrderVC class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KRemoveTestPIc" object:nil userInfo:@{@"position":@(i)}];
            [self.navigationController popToViewController:VC animated:NO];
            return;
        }
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{

}


@end

@implementation FNShowCouponModel


@end

@implementation FNShowCoupCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        
        [self addSubview:_bgImgView];
        
        _moneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 14, self.width, 14)];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        [self  addSubview:_moneyLabel];
        
        UILabel * lineLab = [[UILabel alloc]initWithFrame:CGRectMake(24, 31, 76, 0.5)];
        lineLab.backgroundColor = UIColorWith0xRGB(0xDCDADA);
        [self addSubview:lineLab];
        
       _numLabel  =[[UILabel alloc]initWithFrame:CGRectMake(0, 32, self.width, 14)];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_numLabel];

    }
    return self;
}


- (void)setShowCouponModel:(FNShowCouponModel *)showCouponModel
{
    _showCouponModel = showCouponModel;
    if (_showCouponModel.isChoice)
    {
        _bgImgView.image = [UIImage imageNamed:@"coupons_sz_selected"];
        _moneyLabel.textColor = [UIColor whiteColor];
        _numLabel.textColor = [UIColor whiteColor];
        
    }else
    {
        _bgImgView.image = [UIImage imageNamed:@"coupons_sz"];
        _moneyLabel.textColor = UIColorWith0xRGB(0x666666);
        _numLabel.textColor = UIColorWith0xRGB(0x999999);

    }
    _moneyLabel.text = [NSString stringWithFormat:@"%d  元券",[_showCouponModel.amount intValue]/100];
    _numLabel.text = [NSString stringWithFormat:@"(%d张)",[_showCouponModel.couponCount intValue]];
}

@end
