//
//  FNDetailVC.m
//  BonusStore
//
//  Created by feinno on 16/6/14.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNDetailVC.h"
#import "FNCartVC.h"
#import "FNWebVC.h"
#import "FNDetailWebVC.h"
#import "FNDetailHeaderView.h"
#import "FNMainBO.h"
#import "FNCartBO.h"
#import "FNLoginBO.h"
#import "FNCartItemModel.h"
#import "FNProvinceModel.h"
#import "FNDetailSkuModel.h"
#import "MJRefresh.h"
#import "UIView+Toast.h"
#import "FNMyBO.h"
#import "FNMainDetailCell.h"
#import "MJDIYAutoFooter.h"

@interface FNDetailVC ()<UITextFieldDelegate,FNDetailBuyDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate, UIWebViewDelegate, UMSocialUIDelegate>
{
    FNCartItemModel * _productItemModel;
    FNFillOrderVC *_fillOrderVC;
    CGFloat _minCurPrice;
    NSString *_skuNum;
    NSInteger _number;
    NSInteger _count;
    NSMutableDictionary *_shareInfo;
    NSInteger _colorKeyID;
    NSInteger _colorValueID;
    NSString *_colorKeyValue;
    NSString *_colorValueValue;
    NSInteger _sizeKeyID;
    NSInteger _sizeValueID;
    NSString *_sizeKeyValue;
    NSString *_sizeValueValuel;
    NSString *_chooseStr;
    UIButton *_addCartBtn;
    UIButton *_buyNowBtn;
    NSArray *_imgArray;
    NSMutableArray *_imgArrM;
    CGFloat _max;
    CGFloat _maxS;
    BOOL _sizeSelected;
    BOOL _colorSelected;
    FNNoDataView *_noData;
    UIImageView *_tableExtensionView;
    NSUInteger _detailSegmentIndex;
    FNSegBar *_detailSegBar;
    CALayer *_replaceViewLine;
    UIButton *_topBut;
    __block UIPickerView *_pickView;
    BOOL _isWebView;
    UILabel *_titleLab;
    UIView *_baseView;
    CGFloat _sectionHeight;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, assign) NSInteger currenPage;
@property (nonatomic, strong) UIScrollView * overAllScrollView; //分页，放一个tableView ,一个webView
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableArray * detailArr;
@property (nonatomic ,weak)  UIView * blackView;
@property (nonatomic, weak)  UIView *colorSelectView;
@property (nonatomic, weak)  UIView *sizeSelectView;
@property (nonatomic,assign) CGFloat colorViewHeight;
@property (nonatomic,assign) CGFloat colorViewHeightSize;
@property (nonatomic,strong) UILabel * numberLabel;
@property (nonatomic, strong) NSArray *provincesList;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *determineButton;
@property (nonatomic, strong) UIButton *addCartButton;
@property (nonatomic, copy) NSString *citiSelectStr;
@property (nonatomic, strong) UIButton *orderNow;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *pickBasicView;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, strong) NSMutableArray *skuArr;
@property (nonatomic, strong) NSMutableDictionary *skuDict;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSDictionary *skuDictdict;
@property (nonatomic, assign) int  provinceId;
@property (nonatomic, strong) FNDetailView *dataView;
@property (nonatomic, strong) FNDetailSkuModel *detailSkuModel;
@property (nonatomic,weak) UIView * replaceView;

@property (nonatomic,weak) UILabel *textLabel;
@property WebViewJavascriptBridge * bridge;
@end

@implementation FNDetailVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.numberLabel.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_PRODUCT_DETAIL,self.productId]]]];
    [[FNCartBO port02] getCartCountWithBlock:^(id result) {
        if([result[@"code"] integerValue]==200 && [result[@"count"] integerValue] >0)
        {
            self.numberLabel.hidden = NO;
            
            [self.numberLabel setEllipseCount:[result[@"count"] integerValue]];
        }
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    _sizeSelected = NO;
    _skuArr = [NSMutableArray array];
    _detailSkuModel = [[FNDetailSkuModel alloc]init];
    _skuDictdict = [NSDictionary dictionary];//声成局部的
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.productName;
    [self refreshData];
    _topBut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _topBut.frame = CGRectMake(kWindowWidth-50, kWindowHeight-NAVIGATION_BAR_HEIGHT-100, 44, 44);
    
    [_topBut setBackgroundImage:[UIImage imageNamed:@"main_back_top"] forState:UIControlStateNormal];
    [_topBut bringSubviewToFront:self.view];
    __weak __typeof(self) weakSelf = self;

    [_topBut addSuperView:self.view ActionBlock:^(id sender) {
        
        [weakSelf loadTableView];
        
    }];
    
    _topBut.alpha = NO;
}

- (void)refreshData
{
    [FNLoadingView showInView:self.view];
    self.overAllScrollView.hidden =YES;
    [_noData removeFromSuperview];
    [[[FNMainBO port01]withOutUserInfo]getProductDetailWithProductId:self.productId block:^(id result)
     {
         [FNLoadingView hideFromView:self.view];
         __weak __typeof(self) weakSelf = self;
         if([result[@"code"] integerValue] != 200 || result == nil)
         {
             self.navigationController.navigationBar.hidden = NO;
             if (!_noData)
             {
                 _noData = [[FNNoDataView alloc] initWithFrame:CGRectMake(0,64,kScreenWidth ,kScreenHeight)];
             }
             [_noData setTypeWithResult:result];
             _noData.backgroundColor = MAIN_BACKGROUND_COLOR;
             [_noData setTypeWithResult:result];

             [_noData setActionBlock:^(id sender) {
                 [weakSelf refreshData];
             }];
             [self.view addSubview:_noData];
             return ;
         }
         _noData.hidden = YES;
         self.overAllScrollView.hidden = NO;
         [_noData removeFromSuperview];
         self.navigationController.navigationBar.hidden = YES;
         _shareInfo = result;
         _productItemModel = [FNCartItemModel mj_objectWithKeyValues:result[@"productInfo"]];
         _productItemModel.sku = [[FNSkuNumModel alloc]init];

         if(![NSString isEmptyString:result[@"minCurPrice"]])
         {
             _productItemModel.minCurPrice = result[@"minCurPrice"];
         }
         if(![NSString isEmptyString:result[@"maxOrgPrice"]])
         {
             _productItemModel.maxOrgPrice = result[@"maxOrgPrice"];
         }
         [self makePageControl];
         [self scrollView];
         self.tableView.tableHeaderView = self.scrollView;
         [self.tableView addSubview:self.pageControl];
    
         NSString *str2 = [NSString stringWithFormat:@"本商品由%@提供配送服务",_productItemModel.sellerName];
         
         UIView * bottomView = [self addCartOrBuyNowView];
         bottomView.frame = CGRectMake(0, kScreenHeight -48, kScreenWidth, 48);
         [self.view addSubview:bottomView];
         _type = _productItemModel.type;
         [_skuArr addObjectsFromArray:result[@"productInfo"][@"skuTemplate"][@"sku"]];
         _detailSkuModel.valueForColorDesc = [_skuArr firstObject][@"key"][@"value"];
         _detailSkuModel.valuesColorArr = [_skuArr firstObject][@"values"] ;
         _detailSkuModel.sizeArr = [_skuArr lastObject][@"values"];
         _detailSkuModel.valueForSizeDesc = [_skuArr lastObject][@"key"][@"value"];
         _detailSkuModel.sizeValue = [[_skuArr lastObject][@"values"] firstObject][@"value"];
         if (_skuArr.count == 1)
         {
             self.detailArr = [NSMutableArray arrayWithObjects:str2,[NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc],nil];
         }
         else if ([NSString isEmptyString:_detailSkuModel.valueForColorDesc] && [NSString isEmptyString:_detailSkuModel.valueForSizeDesc])
         {
             self.detailArr = [NSMutableArray arrayWithObjects:str2 ,@"请选择 数量",nil];
         }
         else
         {
             self.detailArr = [NSMutableArray arrayWithObjects:str2,[NSString stringWithFormat:@"请选择 %@ %@",_detailSkuModel.valueForColorDesc,_detailSkuModel.valueForSizeDesc],nil];
         }
         [self createView];
         self.numberLabel.hidden = YES;

         [[FNMyBO port02] getAddrListWithBlock:^(id result) {
             
             if ([result[@"code"] integerValue] == 200)
             {
                 NSInteger index = 0;
                 
                 NSDictionary *info = [result[@"addressInfoList"] firstObject];
                 
                 for (FNProvinceModel *model in self.provincesList)
                 {
                     if (model.id == [info[@"provinceId"] integerValue])
                     {
                         _citiSelectStr = model.name;
                         _dataView.sendLabel.text = model.name;
                         _provinceId = model.id;
                         [_pickView selectRow:index inComponent:0 animated:NO];
                         
                         break;
                     }
                     
                     index++;
                 }
             }
         }];

         [[FNCartBO port02] getCartCountWithBlock:^(id result) {
             if([result[@"code"] integerValue]==200 && [result[@"count"] integerValue] >0)
             {
                 self.numberLabel.hidden = NO;
                 [self.numberLabel setEllipseCount:[result[@"count"] integerValue]];
             }
         }];
         [self.tableView reloadData];
     }];

    // 设置一个UIScrollView 作为视图底层，并且设置分页为两页
    //在第一个分页上添加一个 UITableView 并且设置表格能够上拉加载（上拉操作即为让视图滚动到下一页）
    // 在第二个分页上添加一个 UIWebView 并且设置能有下拉刷新操作（下拉操作即为让视图滚动到上一页）
    [self.view addSubview:self.overAllScrollView];
    [self.overAllScrollView addSubview:self.tableView];
    [self.overAllScrollView addSubview:self.webView];
    self.tableView.tableFooterView =[[UIView alloc]init];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:nil ];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [footer setTitle:@"继续拖动，查看图文详情" forState:MJRefreshStateIdle];
    [footer setTitle:@"继续拖动，查看图文详情" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"继续拖动，查看图文详情" forState:MJRefreshStateNoMoreData];
    CGFloat imageX;
    if (IS_IPHONE_6)
    {
        imageX = 85;
    }else if (IS_IPHONE_6P)
    {
        imageX = 105;
    }else
    {
        imageX = 60;
    }
    
    UIImageView *footerImg = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, 12, 20, 20)];
    footerImg.image = [UIImage imageNamed:@"detail_top"];
    [footer addSubview:footerImg];
    self.tableView.mj_footer = footer;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadTableView)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"释放，返回宝贝详情" forState:MJRefreshStateIdle];
    [header setTitle:@"释放，返回宝贝详情" forState:MJRefreshStatePulling];
    [header setTitle:@"释放，返回宝贝详情" forState:MJRefreshStateRefreshing];
    [header setTitle:@"释放，返回宝贝详情" forState:MJRefreshStateNoMoreData ];
    [header setTitle:@"释放，返回宝贝详情" forState:MJRefreshStateWillRefresh];
    [header beginRefreshing];
    self.webView.scrollView.mj_header = header;
    UIView * replaceView = [self replaceNavBarWithView];
    replaceView.frame = CGRectMake(0, 0, kScreenWidth, 64);
    [self determineButton];
    [self cancelButton];
}
- (void)createView
{
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _baseView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
    _baseView.hidden = YES;
    [self.view addSubview:_baseView];
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _backView.userInteractionEnabled = YES;
    [self.view addSubview:_backView];
    _dataView = [[FNDetailView alloc]initWithFrame:CGRectMake(0, kScreenHeight-400, kScreenWidth, 400)];
    _dataView.backgroundColor = MAIN_COLOR_WHITE;
    [_backView addSubview:_dataView];
    _dataView.skuLabel.text = [NSString stringWithFormat:@"库存1000件"];
    _dataView.productPrice.text =_productItemModel.minCurPrice;
    if (_type == 2)
    {
        if (_skuArr.count == 1)
        {
        _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc];
        }
        else
        {
        _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@ %@",_detailSkuModel.valueForColorDesc,_detailSkuModel.valueForSizeDesc];
        }
    }
    if (_type == 3)
    {
        _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc];
    }
    _dataView.specificationsL.text = [NSString stringWithFormat:@"%@:",_detailSkuModel.valueForColorDesc ];
    _dataView.sizeLabel.text = [NSString stringWithFormat:@"%@:",_detailSkuModel.valueForSizeDesc ];
    [_dataView.productImage sd_setImageWithURL:IMAGE_ID([_imgArray firstObject])];
    [_dataView.sizeButton setTitle:_detailSkuModel.sizeValue forState:UIControlStateNormal];
    _dataView.sendToLabel.text = @"配送至:";
    _dataView.numText.text = @"1";
    _dataView.textFieldDelegate = self;
    _dataView.addBtn.enabled = YES;
    [_dataView.sendLabel addTarget:self action:@selector(changeAdd)];
    _dataView.sendLabel.text = @"北京市";
    [_dataView.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [_dataView.sizeButton addTarget:self action:@selector(sizeBtn:) forControlEvents:UIControlEventTouchUpInside];
    _pickBasicView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 243)];
    _pickBasicView.backgroundColor = UIColorWithRGB(240.0, 240.0, 240.0);
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 200)];
    _pickView.backgroundColor = MAIN_COLOR_WHITE;
    _pickView.delegate = self;
    _pickView.dataSource = self;
    [_pickBasicView addSubview:_pickView];
    [self.view addSubview:_pickBasicView];
    [_pickBasicView addSubview:self.determineButton];
    [_pickBasicView addSubview:self.cancelButton];
    UIView *view = [[UIView alloc]init];
    self.colorSelectView = view;
    [_dataView.scrollView addSubview:self.colorSelectView];
    self.colorSelectView.frame = CGRectMake(120 ,10, kScreenWidth -120-10, self.colorViewHeight);
    CGFloat margin = 10;
    for(int i =0 ;i < _detailSkuModel.valuesColorArr.count ;i++)
    {
        UIButton * button = [[UIButton alloc]init];
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25,20)];
        [button addSubview:image1];
        [image1 sd_setImageWithURL:IMAGE_ID(_detailSkuModel.valuesColorArr[i][@"image"])];
        [button setImage:[UIImage imageNamed:@"white_bg"] forState:UIControlStateNormal];
        button.selected = NO;
        button.tag = i + 999;
        [button setTitle:_detailSkuModel.valuesColorArr[i][@"value"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorWithRGB(52.0, 52.0, 52.0) forState:UIControlStateNormal];
        button .titleLabel.font = [UIFont systemFontOfSize:12];
        [button sizeToFit];
        [button addTarget:self action:@selector(detailColorSelect:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake( 0,0, button.bounds.size.width+10, button.bounds.size.height +3);
        UIButton * lastButton = nil;
        if (i > 0)
        {
            //现有button的大小，如果放下， y 不变， x 有上一个的x +margin
            // 如果放不下， x = margin ,y =上一个的y + margin
            lastButton = (UIButton *)[view viewWithTag:i+999-1];
            CGFloat maxX = CGRectGetMaxX(lastButton.frame) ;
            CGFloat maxY = CGRectGetMaxY(lastButton.frame) ;
            if(self.colorSelectView.width - maxX - 2* margin > button.frame.size.width +6)// 能放下
            {
                button.frame = CGRectMake(maxX + margin, lastButton.frame.origin.y, button.bounds.size.width+6, button.bounds.size.height + 3);
                ;
            }else
            {
                button.frame = CGRectMake(0, maxY +5, button.bounds.size.width+10, button.bounds.size.height+3);
            }
        }
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 5.0;
        button.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
        [view addSubview:button];
        if (i == _detailSkuModel.valuesColorArr.count -1)
        {
            UIButton * lastOneButton = (UIButton *)[view viewWithTag:i+999];
            CGFloat maxY = CGRectGetMaxY(lastOneButton.frame)+5 ;
            self.colorViewHeight = maxY;
        }
    }
    self.colorSelectView.frame = CGRectMake(120 ,20, kScreenWidth -120-10, self.colorViewHeight);
    _max = CGRectGetMaxY(self.colorSelectView.frame)+5 ;
    _dataView.sizeLabel.frame = CGRectMake(20, _max, 80, 20);
    if (_skuArr.count >1)
    {
        UIView *view1 = [[UIView alloc]init];
        self.sizeSelectView = view1;
        [_dataView.scrollView addSubview:self.sizeSelectView];
        self.sizeSelectView.frame = CGRectMake(120 ,_max, kScreenWidth -120-10, self.colorViewHeightSize);
        for(int i =0 ;i < _detailSkuModel.sizeArr.count ;i++)
        {
            UIButton * button = [[UIButton alloc]init];
            button.selected = NO;
            button.tag = i + 99;
            [button setTitle:_detailSkuModel.sizeArr[i][@"value"] forState:UIControlStateNormal];
            [button setTitleColor:UIColorWithRGB(52.0, 52.0, 52.0) forState:UIControlStateNormal];
            button .titleLabel.font = [UIFont systemFontOfSize:12];
            [button sizeToFit];
            [button addTarget:self action:@selector(sizeBtn:) forControlEvents:UIControlEventTouchUpInside];
            UIButton * lastButton = nil;
            if (i > 0)
            {
                lastButton = (UIButton *)[view1 viewWithTag:i+99-1];
                CGFloat maxXS = CGRectGetMaxX(lastButton.frame);
                CGFloat maxYS = CGRectGetMaxY(lastButton.frame);
                if(self.sizeSelectView.width - maxXS - 2* margin > button.frame.size.width +6)// 能放下
                {
                    button.frame = CGRectMake(maxXS + margin, lastButton.frame.origin.y, button.bounds.size.width+6, button.bounds.size.height);
                }else
                {
                    button.frame = CGRectMake(0, maxYS +5, button.bounds.size.width+10, button.bounds.size.height);
                }
            }
            button.layer.borderWidth = 1.0;
            button.layer.cornerRadius = 5.0;
            button.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
            [view1 addSubview:button];
            if (i == _detailSkuModel.sizeArr.count -1)
            {
                UIButton * lastOneButton = (UIButton *)[view1 viewWithTag:i+99];
                CGFloat maxYS = CGRectGetMaxY(lastOneButton.frame)+5 ;
                self.colorViewHeightSize = maxYS;
            }
        }
        self.sizeSelectView.frame = CGRectMake(120 ,_max, kScreenWidth -120-10, self.colorViewHeightSize);
        
        _maxS = CGRectGetMaxY(self.sizeSelectView.frame)+5 ;
    
        _dataView.sendToLabel.frame = CGRectMake(20, _maxS , 60, 20);
        
        _dataView.sendLabel.frame = CGRectMake(120, _dataView.sendToLabel.y - 5, 120, 30);
        
        _dataView.buyNumLabel.frame = CGRectMake(20, _dataView.sendToLabel.y +50, 80, 20);
        
        _dataView.buttonView.frame = CGRectMake(120, _dataView.buyNumLabel.y -5, 120, 32);
    }
    else
    {
        _dataView.sizeLabel.frame = CGRectMake(20, _max, 60, 20);
        
        _dataView.sizeButton.frame = CGRectMake(120 ,_dataView.sizeLabel.y - 5, 60, 30);
        
        _dataView.sendToLabel.frame = CGRectMake(20, _dataView.sizeButton.y+30 + 20, 60, 20);
        
        _dataView.sendLabel.frame = CGRectMake(120, _dataView.sendToLabel.y - 5, 120, 30);
        
        _dataView.buyNumLabel.frame = CGRectMake(20, _dataView.sendToLabel.y +50, 80, 20);
        
        _dataView.buttonView.frame = CGRectMake(120, _dataView.buyNumLabel.y -5, 120, 32);
    }
}

- (void)selectSku
{
    _dataView.skuLabel.text = @"库存1000件";
    [FNLoadingView showInView:self.view];
    _dataView.determineBtn.enabled = NO;
    [[[FNCartBO port01]withOutUserInfo] getOneQuerystoreBatchWithProvinceId:_provinceId  sellerId:[_productItemModel.sellerId intValue]skuNum:_skuNum productId:_productItemModel.productId block:^(id result) {
        [FNLoadingView hideFromView:self.view];
        if ([NSString isEmptyString:result[@"count"]] )
        {
            _dataView.skuLabel.text = @"库存0件";
            _count = 0;
            [self buttonDisEnable];
           
            
        }
        if ([result[@"count"] integerValue] <= 0)
        {
            _dataView.skuLabel.text = @"库存0件";
            _count = 0;
            [self buttonDisEnable];
        }
        else
        {
            _dataView.skuLabel.text = [NSString stringWithFormat:@"库存%@件",result[@"count"]];
            _count = [result[@"count"] integerValue];
            _dataView.productPrice.text = result[@"curPrice"];
            _productItemModel.sku.weight = result[@"weight"];
            [self buttonEnable];
        }
    }];
}
-(UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:18];
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:69.0/255 green:143.0/255 blue:251.0/255 alpha:1] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

-(UIButton *)determineButton
{
    if (!_determineButton)
    {
        _determineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _determineButton.titleLabel.font = [UIFont fontWithName:FONT_NAME_LTH size:18];
        _determineButton.frame = CGRectMake(kScreenWidth - 44, 0, 44, 44);
        [_determineButton setTitleColor:[UIColor colorWithRed:69.0/255 green:143.0/255 blue:251.0/255 alpha:1] forState:UIControlStateNormal];
        [_determineButton setTitle:@"确定" forState:UIControlStateNormal];
        [_determineButton addTarget:self action:@selector(determineBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;
}

- (UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame =  CGRectMake(0, 0, kScreenWidth, kScreenHeight *0.55);
        NSString * str =  _productItemModel.imgKey;
        _imgArray =  [str componentsSeparatedByString:@","];
        _imgArrM = [NSMutableArray array];
        [_imgArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop){
            if(![NSString isEmptyString:obj]){
                [_imgArrM addObject:obj];
            }
        }];
        _pageControl.numberOfPages = _imgArrM.count;
        CGSize scrollSize = _scrollView.frame.size;
        for (int i = 0; i < _imgArrM.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            CGFloat scrollWidth = scrollSize.width;
            CGFloat imageX = scrollWidth * i;
            CGFloat imageY = 0;
            CGFloat imageW = scrollWidth;
            CGFloat imageH = scrollSize.height;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [imageView sd_setImageWithURL:IMAGE_ID(_imgArray[i])];
            [_scrollView addSubview:imageView];
        }
        UILabel *textLabel = [[UILabel alloc]init];
        self.textLabel = textLabel;
        textLabel.text =  @"释\n放\n查\n看\n图\n文\n详\n情";
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = [textLabel.text length];
        textLabel.frame = CGRectMake(scrollSize.width * _imgArrM.count+10, 0, 30, scrollSize.height);
        [_scrollView addSubview:textLabel];
        if(_imgArrM.count ==1)
        {
            _scrollView.contentSize = CGSizeMake(scrollSize.width * _imgArrM.count + 40, scrollSize.height);

        }else{
        _scrollView.contentSize = CGSizeMake(scrollSize.width * _imgArrM.count+40, scrollSize.height);
        }
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickScrollView:)];
        [_scrollView addGestureRecognizer:tapGesture];
    }
    return _scrollView;
}

- (UIPageControl *)makePageControl
{
    if(_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenHeight *0.55-20, kScreenWidth, 20)];
        _pageControl.currentPage = self.currenPage;
    }
    return _pageControl;
}
- (UIScrollView *)overAllScrollView
{
    if(_overAllScrollView == nil)
    {
        _overAllScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _overAllScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 2-48);
        _overAllScrollView.pagingEnabled = YES;
        _overAllScrollView.scrollEnabled = NO;
    }
    return _overAllScrollView;
}

- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -48) style:UITableViewStylePlain ];
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorColor:MAIN_COLOR_SEPARATE];
        }
        [_tableView registerClass:[FNMainDetailCell class] forCellReuseIdentifier:NSStringFromClass([FNMainDetailCell class])];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kScreenHeight+64, kScreenWidth, kScreenHeight-48-64)];
        self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
            responseCallback(@"Response for message from ObjC");
        }];
        
        _detailSegBar = [[FNSegBar alloc] initWithFrame:CGRectMake(0, kWindowHeight, kWindowWidth, 50)];
        _detailSegBar.defaultTitleColor = MAIN_COLOR_GRAY_ALPHA;
        _detailSegBar.selectedTitleColor = [UIColor redColor];
        _detailSegBar.lineColor = [UIColor redColor];
        [_detailSegBar setItems:@[@"图文详情"]];
        __weak __typeof(self) weakSelf = self;
        
        CALayer *uLine = [CALayer layerWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
        [_detailSegBar.layer addSublayer:uLine];
        
        CALayer *bLine = [CALayer layerWithFrame:CGRectMake(0, _detailSegBar.height-1, kWindowWidth, 1)];
        [_detailSegBar.layer addSublayer:bLine];
        [_detailSegBar selectedItemWithBlock:^(NSInteger index) {
            
            NSDictionary *j = @{@"index":@(index)};
            
            NSData *d = [NSJSONSerialization dataWithJSONObject:j options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *json = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            
            [weakSelf.bridge callHandler:@"detailSegment" data:json responseCallback:^(id responseData) {
                
            }];
        }];
    }
    return _webView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (touches.anyObject.view == _dataView)
    {
    }
    else
    {
        _baseView.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
            _pickBasicView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        }];
    }
}

- (void)dealloc
{
    [_pickView removeFromSuperview];
    _pickView = nil;
}

-(void)personTapGesture:(UITapGestureRecognizer *)tap
{
    _baseView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        _pickBasicView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

- (void)didClickScrollView:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.blackView = view;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(windowViewDismiss:)];
        [view addGestureRecognizer:tapGesture];
        view.backgroundColor = [UIColor blackColor];
        self.textLabel.textColor = [UIColor whiteColor];
        [view addSubview:self.scrollView];
        self.scrollView.frame = CGRectMake(0, kScreenHeight * 0.45*0.5, kScreenWidth, kScreenHeight *0.55);
        self.pageControl.frame = CGRectMake(0, kScreenHeight -20, kScreenWidth, 20);
        [self.scrollView addGestureRecognizer:tapGesture];
        self.scrollView.delegate = self;
        [view addSubview:self.pageControl];
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:view];
    } completion:^(BOOL finished) {
    }];
}
-(void)windowViewDismiss:(UIView *)view
{
    [self.blackView removeFromSuperview];
    self.scrollView = nil;
    self.pageControl = nil;
    [self makePageControl];
    [self scrollView];
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight *0.55);
    self.tableView.tableHeaderView = self.scrollView;
    CGSize scrollSize = self.scrollView.frame.size;
    self.pageControl.frame = CGRectMake(0, scrollSize.height-20, scrollSize.width, 20);
    [self.tableView addSubview:self.pageControl];
}

- (void)loadTableView
{
    //设置动画效果
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.overAllScrollView.contentOffset = CGPointMake(0, 0);
        UIReframeWithY(_detailSegBar, kWindowHeight);
        _topBut.alpha = 0;
        _titleLab.hidden = YES;
    } completion:^(BOOL finished) {
        [self.webView.scrollView.mj_header endRefreshing];
    }];
}

-(void)loadWebView
{
    //设置动画效果
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.overAllScrollView.contentOffset = CGPointMake(0, kScreenHeight);
        UIReframeWithY(_detailSegBar, NAVIGATION_BAR_HEIGHT);

    } completion:^(BOOL finished) {
        //结束加载
        _titleLab.hidden = NO;
        [self.tableView.mj_footer endRefreshing];
        if (!_tableExtensionView)
        {
            UIImage *image = [FNCaptureScreen getImageFromView:self.view];

            CGFloat height = [self tableView:self.tableView heightForHeaderInSection:0];
            
            CGFloat scale = 2.0;
            
            if (IS_IPHONE_6P || [[FNDevice machineModel] isEqualToString:@"iPhone 6 Plus"])
            {
                height += 200;
                
                scale = 3.0;
            }
            else if(IS_IPHONE_5)
            {
                height += 200;
            }
            else if (IS_IPHONE_6)
            {
                height += 200;
            }
            
            _tableExtensionView = [[UIImageView alloc] initWithImage:image];
            
            _tableExtensionView.frame = CGRectMake(0, kWindowHeight*0.55+ height, kWindowWidth, kWindowHeight/scale);
            
            [self.tableView addSubview:_tableExtensionView];
            
            _tableExtensionView.backgroundColor = [UIColor redColor];
            
            if (IS_IPHONE_5 || IS_IPHONE_6)
            {
                CALayer *line = [CALayer layerWithFrame:CGRectMake(0, 0, _tableExtensionView.width, 1)];
                
                [_tableExtensionView.layer addSublayer:line];
            }
        }
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offsetY = scrollView.contentOffset.y;

    CGFloat page = round(offsetX / scrollView.frame.size.width);
    if (page != self.pageControl.currentPage) {
        self.pageControl.currentPage = page ;
    }
    if(offsetY > 100 )
    {
        self.replaceView.backgroundColor = [UIColor whiteColor];
        _replaceViewLine.backgroundColor = [UIColorWithRGBA(204, 204, 204, 1) CGColor];
    }else if (offsetY >20)
    {
        self.replaceView.backgroundColor = [UIColor whiteColor];
        self.replaceView.alpha = offsetY/100.0;
        _replaceViewLine.backgroundColor = [UIColorWithRGBA(204, 204, 204, offsetX/100.0) CGColor];
    }else
    {
        self.replaceView.backgroundColor = [UIColor clearColor];
    }
    
    CGFloat offset = scrollView.contentOffset.y;
    
 
    if (_isWebView == NO)
    {
        _topBut.alpha = 1- (100 - offset)/100;
    }
    else
    {
        _topBut.alpha = 1;
    }

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if(self.pageControl.numberOfPages == 0)
    {
        return;
    }
    
    if (self.pageControl.numberOfPages>1 && offsetX > (self.pageControl.numberOfPages -1)* scrollView.frame.size.width +50)
    {
        [self.blackView removeFromSuperview];
        self.scrollView = nil;
        self.pageControl = nil;
        [self makePageControl];
        [self scrollView];
        self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight *0.55);
        self.tableView.tableHeaderView = self.scrollView;
        CGSize scrollSize = self.scrollView.frame.size;
        self.pageControl.frame = CGRectMake(0, scrollSize.height-20, scrollSize.width, 20);
        [self.tableView addSubview:self.pageControl];
        // 跳转到商品详情页
        FNDetailWebVC *detailWebVC = [[FNDetailWebVC alloc]init];
        detailWebVC.productId = self.productId;
        detailWebVC.title = @"商品详情";
        [self.navigationController pushViewController:detailWebVC animated:YES];
        
        return;
    }
    
    if (self.pageControl.numberOfPages ==1)
    {
        if ( offsetX >50)
        {
            [self.blackView removeFromSuperview];
            self.scrollView = nil;
            self.pageControl = nil;
            [self makePageControl];
            [self scrollView];
            self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight *0.55);
            self.tableView.tableHeaderView = self.scrollView;
            CGSize scrollSize = self.scrollView.frame.size;
            self.pageControl.frame = CGRectMake(0, scrollSize.height-20, scrollSize.width, 20);
            [self.tableView addSubview:self.pageControl];
            // 跳转到商品详情页
            FNDetailWebVC *detailWebVC = [[FNDetailWebVC alloc]init];
            detailWebVC.productId = self.productId;
            detailWebVC.title = @"商品详情";
            [self.navigationController pushViewController:detailWebVC animated:YES];
        }
        else
        {
            offsetX = 0;
        }
    }

     if(offsetY > 100)
     {
         _isWebView = YES;
        [self loadWebView];
         
     }
     else
     {
         _isWebView = NO;
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
     }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseId = @"UITableViewCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    UILabel * backLabel =nil;
    UILabel * backLabel1 =nil;
    FNMainDetailCell *mainCell = [FNMainDetailCell mainDetailCellTableView:tableView];

    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        backLabel = [[UILabel alloc]init];
        backLabel.hidden = YES;
        backLabel.frame = CGRectMake(0, 0, kScreenWidth, 10);
        backLabel.backgroundColor = MAIN_BACKGROUND_COLOR;
        [cell.contentView addSubview:backLabel];
        backLabel1 = [[UILabel alloc]init];
        backLabel1.hidden =YES;
        backLabel1.frame = CGRectMake(0, 54, kScreenWidth, 10);
        backLabel1.backgroundColor = MAIN_BACKGROUND_COLOR;
        [cell.contentView addSubview:backLabel1];
        
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0)
    {
        backLabel.hidden = NO;
        cell.textLabel.text = self.detailArr[indexPath.row];
        cell.textLabel.hidden = YES;
        NSString * str = cell.textLabel.text;
        NSMutableAttributedString *needStr1 = [str makeStr:[NSString stringWithFormat:@"%@",_productItemModel.sellerName] withColor:MAIN_COLOR_BLACK_ALPHA andFont:[UIFont systemFontOfSize:15]];
        mainCell.shopNameLab.attributedText = needStr1;
        mainCell.leftImg.image = [UIImage imageNamed:@"freight_bg"];
        
        if ([_productItemModel.remark isEqualToString:@""])
        {
            _sectionHeight = 44;
            mainCell.freightLab.hidden = YES;
            mainCell.leftImg.hidden = YES;
            
        }else
        {
            
            mainCell.freightLab.hidden = NO;
            mainCell.leftImg.hidden = NO;
            mainCell.freightLab.text = _productItemModel.remark;
            _sectionHeight = 64;
        }
       
        mainCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return mainCell;
    }
    
    else  if(indexPath.row == 1)
    {
        cell.textLabel.text = self.detailArr[indexPath.row];

        backLabel.hidden = NO;
        backLabel1.hidden = NO;
        cell.textLabel.textColor = UIColorWithRGB(52.0, 52.0, 52.0);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];

        if (!_productItemModel.enabled)
        {
            cell.textLabel.text = @"商品已下架";
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==1)
    {
        return 64;
    }
    return _sectionHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    FNDetailHeaderView *detailHeaderView = [FNDetailHeaderView detailHeaderViewWithTableView:tableView];
    detailHeaderView.productModel = _productItemModel;
    return [detailHeaderView height];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FNDetailHeaderView *detailHeaderView = [FNDetailHeaderView detailHeaderViewWithTableView:tableView];
    detailHeaderView.productModel = _productItemModel;
    [detailHeaderView.clickBtn addTarget:self action:@selector(sharedWithOther) forControlEvents:UIControlEventTouchUpInside];
    return detailHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        FNSellerVC *vc = [[FNSellerVC alloc]init];
        vc.sellerName = _productItemModel.sellerName;
        vc.sellerId = _productItemModel.sellerId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == 1 && _productItemModel.enabled)
    {
        if (_type == 2)
        {
            [self detailBtnClickAddCart:nil];
        }
        else
        {
            [self createDetailView];
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - selectSpecifications
-(void)detailColorSelect:(UIButton *)button
{
    button.selected = !button.selected;
    
    button.layer.borderWidth = 1.0;
    
    button.layer.cornerRadius = 5.0;
    
    _dataView.numText.text = @"1";
    
    [_dataView.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
    
    [_dataView.addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
    
    if(button.selected == YES)
    {
        
        for(UIButton *btn in self.colorSelectView.subviews)
        {
            btn.selected = NO;
            
            btn.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
            
            _colorSelected = NO;
            
        }
        button.selected = YES;
        
        _colorSelected = YES;
        
        button.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
        
        _skuDictdict =   [_skuArr firstObject];
        
        NSDictionary *key = _skuDictdict[@"key"];
        
        NSArray *values = _skuDictdict[@"values"];
        
        NSDictionary *colorDict = values[button.tag - 999];
        
        _colorKeyID = [key[@"id"] integerValue];
        
        _colorValueID = [colorDict[@"id"] integerValue];
        
        _colorKeyValue = key[@"value"];
        
        _colorValueValue = colorDict[@"value"];
        
        if (_type == 3)
        {
            _skuNum = [NSString stringWithFormat:@"%ld-%ld",(long)_colorKeyID,(long)_colorValueID];
            
            [self selectSku];
            
            if ([NSString isEmptyString:_sizeValueValuel])
            {
                _dataView.choseLabel.text = [NSString stringWithFormat:@"已选择:%@",_colorValueValue];
                _dataView.choseLabel.hidden = NO;
                
                [self buttonEnable];
            }
        }
        
        if (_skuArr.count == 1)
        {
            _skuNum = [NSString stringWithFormat:@"%ld-%ld",(long)_colorKeyID,(long)_colorValueID];
            
            [self selectSku];
            
            _dataView.choseLabel.text = [NSString stringWithFormat:@"已选择:%@",_colorValueValue];
            _dataView.choseLabel.hidden = NO;
            [self buttonEnable];
        }
        else {
            if (_sizeSelected == YES)
            {
                _skuNum = [NSString stringWithFormat:@"%ld-%ld:%ld-%ld",(long)_colorKeyID,(long)_colorValueID,(long)_sizeKeyID,(long)_sizeValueID];
                [self selectSku];
                _dataView.choseLabel.text = [NSString stringWithFormat:@"已选择:%@-%@",_colorValueValue,_sizeValueValuel];
                _dataView.choseLabel.hidden = NO;
                [self buttonEnable];
                
            }
            else if (_sizeSelected == NO)
            {
                _dataView.skuLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForSizeDesc];
                _dataView.choseLabel.hidden = YES;
                [self buttonDisEnable];
            }
        }
    }
    else
    {
        button.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
        _colorSelected = NO;
        if (_skuArr.count == 1)
        {
            _dataView.skuLabel.text = @"库存1000件";
            _dataView.choseLabel.hidden = NO;
            _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc];
            [self buttonDisEnable];
        }
        else
        {
            if (_sizeSelected == YES)
            {
                _dataView.skuLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc];
                _dataView.choseLabel.hidden = YES;
                
                [self buttonDisEnable];
            }
            else if(_sizeSelected == NO)
            {
                _dataView.skuLabel.text = @"库存1000件";
                _dataView.choseLabel.hidden = NO;
                _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@ %@",_detailSkuModel.valueForColorDesc,_detailSkuModel.valueForSizeDesc];
                [self buttonDisEnable];
                
            }
        }
        
    }
}

- (void)sizeBtn:(UIButton *)button
{
    button.selected = !button.selected;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 5.0;
    [_dataView.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
    [_dataView.addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
    if(button.selected == YES)
    {
        for(UIButton *btn in self.sizeSelectView.subviews)
        {
            btn.selected = NO;
            _sizeSelected = NO;
            btn.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
        }
        button.selected = YES;
        _sizeSelected = YES;
        button.layer.borderColor = MAIN_COLOR_RED_ALPHA.CGColor;
        _skuDictdict =   [_skuArr lastObject];
        NSDictionary *sizeKey = _skuDictdict[@"key"];
        NSArray *values = _skuDictdict[@"values"];
        NSDictionary *sizeDict = values[button.tag - 99];
        _sizeKeyID = [sizeKey[@"id"] integerValue];
        _sizeValueID = [sizeDict[@"id"] integerValue];
        _sizeKeyValue  = sizeKey[@"value"];
        _sizeValueValuel = sizeDict[@"value"];
        if (_colorSelected == NO)
        {
            _colorKeyID = nil;
            _dataView.skuLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc];
            [self buttonDisEnable];
        }
        else
        {
            _skuNum = [NSString stringWithFormat:@"%ld-%ld:%ld-%ld",(long)_colorKeyID,(long)_colorValueID,(long)_sizeKeyID,(long)_sizeValueID];
            [self buttonEnable];
        }
        if (_colorKeyID)
        {
            [self selectSku];
            _dataView.choseLabel.text = [NSString stringWithFormat:@"已选择:%@-%@",_colorValueValue,_sizeValueValuel];
            _dataView.choseLabel.hidden = NO;
            [self buttonEnable];
        }
    }
    else
    {
        _sizeSelected = NO;
        button.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
        if (_colorSelected == YES)
        {
            _dataView.skuLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForSizeDesc];
            _dataView.choseLabel.hidden = YES;
            [self buttonDisEnable];
        }
        else if (_colorSelected == NO)
        {
            _dataView.skuLabel.text = @"库存1000件";
            _dataView.choseLabel.hidden = NO;
            _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@ %@",_detailSkuModel.valueForColorDesc,_detailSkuModel.valueForSizeDesc];
            [self buttonDisEnable];
        }
    }
}

- (void)buttonEnable
{
    _dataView.determineBtn.enabled = true;
    _dataView.cutBtn.enabled = true;
    [_dataView.determineBtn setBackgroundColor:MAIN_COLOR_RED_BUTTON];
}

- (void)buttonDisEnable
{
    _dataView.determineBtn.enabled = false;
    _dataView.cutBtn.enabled = false;
    [_dataView.determineBtn setBackgroundColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]];
}

#pragma mark - addCartOrBuyNowView
- (UIView *)addCartOrBuyNowView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat btnWidth = (kScreenWidth *0.75 -3 * 10 )*0.5;
    CALayer *line = [CALayer layerWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
    [view.layer addSublayer:line];
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_cart_n"]];
    imgView.frame = CGRectMake(10, (48-imgView.image.size.height)*0.5,imgView.image.size.width, imgView.image.size.height);
    [view addSubview:imgView];
    UIButton * cartButton = [[UIButton alloc]init];
    cartButton.frame = CGRectMake(10, 0, 48, 48);
    [cartButton addTarget:self action:@selector(detailBtnClickGoCart) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cartButton];
    CGFloat numberX = CGRectGetMaxX(imgView.frame);
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.backgroundColor = [UIColor redColor];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.font = [UIFont systemFontOfSize:11];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.frame = CGRectMake(numberX-10, 5, 22, 22);
    [view addSubview:self.numberLabel];
    
    
    if (_productItemModel.enabled)
    {
        
        _addCartBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 2*(10+btnWidth), 6, btnWidth, 36)];
        [_addCartBtn  addTarget:self action:@selector(detailBtnClickAddCart:) forControlEvents:UIControlEventTouchUpInside];
        _addCartBtn.backgroundColor = [UIColor whiteColor];
        [_addCartBtn.layer setMasksToBounds:YES];
        [_addCartBtn.layer setCornerRadius:5];
        [_addCartBtn.layer setBorderWidth:2];
        [_addCartBtn.layer setBorderColor:[UIColor redColor].CGColor];
        [_addCartBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_addCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        if(_productItemModel.type == 3)
        {
            _addCartBtn.hidden = YES;
            
        }else
        {
            _addCartBtn.hidden = NO;
        }
        [view addSubview:_addCartBtn];
        
        _buyNowBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - btnWidth-10, 6, btnWidth, 36)];
        _buyNowBtn.backgroundColor = [UIColor redColor];
        [_buyNowBtn setCorner:5];
        [_buyNowBtn setTitle:@"立即购买"forState:UIControlStateNormal];
        _buyNowBtn.titleLabel.textColor = [UIColor whiteColor];
        [_buyNowBtn  addTarget:self action:@selector(detailBtnClickBuyNow:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_buyNowBtn];
    }
    else
    {
        FNButton *soldOutBut = [FNButton buttonWithType:FNButtonTypeEdge title:@"商品已下架"];
        
        soldOutBut.frame = CGRectMake(kScreenWidth - btnWidth-10, 6, btnWidth, 36);
        
        [soldOutBut setCorner:5];
        
        [soldOutBut setType:FNButtonTypeOpposite];
        
        soldOutBut.titleLabel.font = [UIFont fzltWithSize:14];
        
        [view addSubview:soldOutBut];
    }

    
    return view ;
}

#pragma mark - FNDetailBuyDelegate

- (void)numBtnClick:(FNDetailView *)view flag:(NSInteger)flag
{
    NSInteger num = [view.numText.text integerValue];
        switch (flag) {
        case kNumberBtnTypeMinus:
                [view.addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_normal"] forState:UIControlStateNormal];
                if (num == 1)
                {
                    [view.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_disSelecte"] forState:UIControlStateNormal];
                }
                else if(num > 1)
                {
                    num = num - 1;
                    NSString * str = [NSString stringWithFormat:@"%ld",(long)num];
                    view.numText.text = str;
                }
            break;
        case kNumberBtnTypeAdd:
                
                if (_count == 0)
                {
                    num = 1;
                    view.cutBtn.enabled = false;
                }
                else if (num < _count)
                {
                    num = num  +1 ;
                    [view.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
                }
                else if (num == _count)
                {
                    [view.addBtn setBackgroundImage:[UIImage imageNamed:@"cart_addBtn_disSelecte"] forState:UIControlStateNormal];
                    [view.cutBtn setBackgroundImage:[UIImage imageNamed:@"cart_minuBtn_normal"] forState:UIControlStateNormal];
                }
                view.numText.text = [NSString stringWithFormat:@"%ld",(long)num];
            break;
        default:
            break;
    }
        if (_skuArr.count == 0)
        {
            if (_count == 0)
            {
                view.cutBtn.enabled = false;
                _dataView.choseLabel.text = @"请选择 数量";
            }
            else
            {
             _dataView.choseLabel.text = [NSString stringWithFormat:@"已选数量:%ld",[_dataView.numText.text integerValue]];
            }
        }
}

- (NSArray *)provincesList
{
    if(_provincesList ==nil)
    {
        _provincesList = [FNProvinceModel provinceArray];
    }
    return _provincesList;
}

#pragma mark - pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// 返回每一列包含的行书u
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.provincesList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.provincesList[row] name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    FNProvinceModel *provinceModel = self.provincesList[row];
    self.provinceId = provinceModel.id;
    _citiSelectStr = [NSString stringWithFormat:@"%@",[_provincesList[row] name]];
    
}

#pragma mark - goToCartVC -直接去购物车
-(void)detailBtnClickGoCart
{
    if (![FNLoginBO isLogin])
    {
        
        return ;
    }
        
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[FNCartVC class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            
            return;
        }
    }
    FNCartVC *vc = [[FNCartVC alloc] init];
    vc.isComeFromCartImage =  YES;
    [vc setNavigaitionBackItem];
    [vc hideTabBar];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - addToCartVC 弹起购物车页面
-(void)detailBtnClickAddCart:(UIButton *)btn
{
    [self popCartView];
    if (_skuArr.count == 0 )
    {
        _provinceId = 110000;
        [self selectSku];
    }
    [_dataView.determineBtn removeTarget:self action:@selector(goToFillOrderVC) forControlEvents:UIControlEventTouchUpInside];
    [_dataView.determineBtn addTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - addTCartVC 加入购物车功能
- (void)addToCart
{
    if (![FNLoginBO isLogin])
    {
        return ;
    }
    if (_skuArr.count == 0)
    {
        _skuNum = nil;
    }
    else if (_skuArr.count == 1)
    {
        _skuNum = [NSString stringWithFormat:@"%ld-%ld",(long)_colorKeyID,(long)_colorValueID];
    }
    else
    {
        _skuNum = [NSString stringWithFormat:@"%ld-%ld:%ld-%ld",(long)_colorKeyID,(long)_colorValueID,(long)_sizeKeyID,(long)_sizeValueID];
    }
    [FNLoadingView showInView:self.view];
    [[[FNCartBO port01]withOutUserInfo] getOneQuerystoreBatchWithProvinceId:_provinceId sellerId:[_productItemModel.sellerId intValue]skuNum:_skuNum productId:_productItemModel.productId block:^(id result) {
        [FNLoadingView hideFromView:self.view];
        _productItemModel.storehouseId = result[@"storehouseId"];
        if (![NSString isEmptyString:result[@"curPrice"]])
        {
            _productItemModel.curPrice = result[@"curPrice"];
        }
        [[FNCartBO port02] addCartWithProduct:_productItemModel skuNum:result[@"skuNum"] count:[_dataView.numText.text intValue] block:^(id result) {
            
            if ([result[@"code"] integerValue] != 200)
            {
                if(result)
                {
                    [self.view makeToast:result[@"desc"]];
                }else
                {
                    [self.view makeToast:@"加载失败,请重试"];
                }
                return ;
            }else
            {
                [[FNCartBO port02] getCartCountWithBlock:^(id result) {
                    if([result[@"code"] integerValue]==200 && [result[@"count"] integerValue] >0)
                    {
                        self.numberLabel.hidden = NO;
                        [self.numberLabel setEllipseCount:[result[@"count"] integerValue]];
                    }
                }];
                [self.view makeToast:@"加入购物车成功"];
            }
        }];
    }];
//    NSString * str1 = [NSString stringWithFormat:@"送%zd积分起",(int) _productItemModel.minCurPrice];
    NSString *str2 = [NSString stringWithFormat:@"本商品由%@提供配送服务",_productItemModel.sellerName];
    if ([NSString isEmptyString:_detailSkuModel.valueForSizeDesc])
    {
        self.detailArr = [NSMutableArray arrayWithObjects:str2,[NSString stringWithFormat:@"已选择数量:%ld",[_dataView.numText.text integerValue]] ,nil];
    }
    else
    {
        if (_skuArr.count == 1)
        {
            self.detailArr = [NSMutableArray arrayWithObjects:str2,[NSString stringWithFormat:@"已选择%@",_colorValueValue] ,nil];
        }
        else
        {
            self.detailArr = [NSMutableArray arrayWithObjects:str2,[NSString stringWithFormat:@"已选择%@-%@",_colorValueValue,_sizeValueValuel] ,nil];
        }
    }
    [self.tableView reloadData];
    _baseView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        _pickBasicView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

#pragma mark - popImmediatelyBuyView -弹出立即购买视图
-(void)detailBtnClickBuyNow:(UIButton *)btn
{
    _dataView.skuLabel.text = @"库存1000件";
    [self createDetailView];
}

- (void)createDetailView
{
    [self popView];
    if (_skuArr.count == 0 )
    {
        _provinceId = 110000;
        [self selectSku];
    }
    [_dataView.determineBtn removeTarget:self action:@selector(addToCart) forControlEvents:UIControlEventTouchUpInside];
    [_dataView.determineBtn addTarget:self action:@selector(goToFillOrderVC) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goToFillOrderVC
{
    if (![FNLoginBO isLogin])
    {
        return ;
    }
    NSMutableArray *arr = [NSMutableArray array];
    FNCartGroupModel *groupModel = [[FNCartGroupModel alloc]init];
    [arr addObject:groupModel];
    _productItemModel.imgKey = [_imgArray firstObject];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:_productItemModel];
    groupModel.productList = array;
    groupModel.sellerId = [_productItemModel.sellerId intValue];
    groupModel.sellerName = _productItemModel.sellerName;
    groupModel.remark = _productItemModel.remark;
    NSString *string = _dataView.skuLabel.text;
    string = [string substringToIndex:[string length] - 1];
    string = [string substringFromIndex:2];
    _productItemModel.count = [_dataView.numText.text intValue];
    if (_type == 3)
    {
        _productItemModel.curPrice = _productItemModel.minCurPrice;
        FNVirfulOrderVC *vc  =[[FNVirfulOrderVC  alloc]init];
        if (_skuArr.count == 0)
        {
            _productItemModel.sku.skuName = @"";
            _productItemModel.sku.skuNum = @"";
        }
        else  if (_skuArr.count == 1)
        {
            _productItemModel.sku.skuNum = [NSString stringWithFormat:@"%ld-%ld",(long)_colorKeyID,(long)_colorValueID];
            _productItemModel.sku.skuName = [NSString stringWithFormat:@"%@-%@",_colorKeyValue,_colorValueValue];
        }
        else  if (_skuArr.count == 2)
        {
            _productItemModel.sku.skuName = [NSString stringWithFormat:@"%@-%@:%@-%@",_colorKeyValue,_colorValueValue,_sizeKeyValue,_sizeValueValuel];
            _productItemModel.sku.skuNum = _skuNum;
        }
        vc.fillOrderDataSource = arr;
        vc.maxCount = [string intValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(_type == 2)
    {
        if (_skuArr.count == 0)
        {
            _productItemModel.sku.skuName = @"";
            _productItemModel.sku.skuNum = @"";
        }
        else if(_skuArr.count == 1)
        {
            _productItemModel.sku.skuName = [NSString stringWithFormat:@"%@-%@",_colorKeyValue,_colorValueValue];
            _productItemModel.sku.skuNum = _skuNum;
        }
        else
        {
            _productItemModel.sku.skuName = [NSString stringWithFormat:@"%@-%@:%@-%@",_colorKeyValue,_colorValueValue,_sizeKeyValue,_sizeValueValuel];
            _productItemModel.sku.skuNum = _skuNum;
        }
        _productItemModel.cartPrice = _productItemModel.minCurPrice;
        _fillOrderVC = [[FNFillOrderVC alloc] init];
        _fillOrderVC.fillOrderDataSource = arr;
        [self.navigationController pushViewController:_fillOrderVC animated:YES];
    }
    _baseView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        
        _pickBasicView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

- (void)popView
{
    _dataView.skuLabel.text = @"库存1000件";
    if ([NSString isEmptyString:_detailSkuModel.valueForSizeDesc] && [NSString isEmptyString:_detailSkuModel.valueForColorDesc])
    {
        _dataView.choseLabel.text = @"请选择 数量";
    }
    _baseView.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        _backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self defaultStatusForPopView];
        if (_type == 2)
        {
            if (_skuArr.count == 1)
            {
                _dataView.frame = CGRectMake(0, _backView.height -  (224 + _max ),kScreenWidth , 224 + _max);
                _dataView.sendToLabel.hidden = NO;
                _dataView.sendLabel.hidden = NO;
                _dataView.sendToLabel.frame = CGRectMake(20,_max, 60, 20);
                _dataView.sendLabel.frame = CGRectMake(120,_dataView.sendToLabel.y - 5 , _dataView.buttonView.width, 30);
                _dataView.buyNumLabel.frame = CGRectMake(20, _dataView.sendToLabel.y + 50, 80, 20);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth,224 + _max);
                _dataView.sizeLabel.hidden = YES;
                _dataView.sizeButton.hidden = YES;
            }
            else if (_skuArr.count == 0)
            {
                _dataView.specificationsL.hidden = YES;
                _dataView.sizeButton.hidden = YES;
                _dataView.sizeLabel.hidden = YES;
                _dataView.sendToLabel.hidden = NO;
                _dataView.sendToLabel.frame = CGRectMake(20,30, 60, 20);
                _dataView.frame = CGRectMake(0,kScreenHeight- 243-10 , kScreenWidth,243+10);
                _dataView.buyNumLabel.frame = CGRectMake(20, _dataView.sendToLabel.y + 50, 80, 20);
                _dataView.sendLabel.hidden = NO;
                _dataView.sendLabel.frame = CGRectMake(120,_dataView.sendToLabel.y - 5 , _dataView.buttonView.width, 30);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth, 121);
            }
            else
            {
                _dataView.frame = CGRectMake(0,_backView.height - _dataView.height ,kScreenWidth ,400);
                _dataView.scrollView.contentSize = CGSizeMake(kScreenWidth,_dataView.height - _dataView.productImage.height+50);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
            }

        }
        if (_type == 3)
        {
          
           if (_skuArr.count == 0)
            {
                _dataView.specificationsL.hidden = YES;
                _dataView.sizeButton.hidden = YES;
                _dataView.sizeLabel.hidden = YES;
                _dataView.sendToLabel.hidden = YES;
                _dataView.sendLabel.hidden = YES;
                _dataView.frame = CGRectMake(0,kScreenHeight- 243 , kScreenWidth,243);
                _dataView.buyNumLabel.frame = CGRectMake(20,_max+20, 80, 20);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth, 121);
            }
            else if (_skuArr.count == 1)
            {
                _dataView.frame = CGRectMake(0, _backView.height -  (224 + _max ),kScreenWidth , 224 + _max);
                _dataView.sendLabel.hidden =YES;
                _dataView.sendToLabel.hidden = YES;
                _dataView.buyNumLabel.frame = CGRectMake(20,_max+20, 80, 20);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth,224);
                _dataView.sizeLabel.hidden = YES;
                _dataView.sizeButton.hidden = YES;
                
                [self buttonDisEnable];
            }
            else
            {
                
            _dataView.buyNumLabel.frame = CGRectMake(20, _maxS + 10, 80, 20);
            
            _dataView.buttonView.frame = CGRectMake(120, _dataView.buyNumLabel.y - 10, 120, 32);
        
            _dataView.frame = CGRectMake(0, _backView.height - ( _dataView.productImage.height +  + _colorSelectView.height +  _sizeSelectView.height + _dataView.buttonView.y + _dataView.buttonView.height+ 44) ,kScreenWidth , _dataView.productImage.height +  + _colorSelectView.height +  _sizeSelectView.height + _dataView.buttonView.y + _dataView.buttonView.height+ 44);
            
            _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
            
            _dataView.sizeButton.hidden = YES;
            
            _dataView.sendToLabel.hidden = YES;
            
            _dataView.sendLabel.hidden = YES;
            }
        }
    }];
    if (_type == 2)
    {
        if (_skuArr.count == 0)
        {
            [self buttonEnable];
        }
        else
        {
            [self buttonDisEnable];
        }
    }
    
}

- (void)popCartView
{
    _dataView.skuLabel.text = @"库存1000件";
    if ([NSString isEmptyString:_detailSkuModel.valueForSizeDesc] && [NSString isEmptyString:_detailSkuModel.valueForColorDesc])
    {
        _dataView.choseLabel.text = @"请选择 数量";
    }
    _baseView.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        _backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        [self defaultStatusForPopView];
        
        if (_type == 2)
        {
            if (_skuArr.count == 1)
            {
                _dataView.frame = CGRectMake(0, _backView.height -  (224 + _max ),kScreenWidth , 224 + _max);
                _dataView.sendToLabel.hidden = NO;
                _dataView.sendLabel.hidden = NO;
                _dataView.sendToLabel.frame = CGRectMake(20,_max, 60, 20);
                _dataView.sendLabel.frame = CGRectMake(120,_dataView.sendToLabel.y - 5 , _dataView.buttonView.width, 30);
                _dataView.buyNumLabel.frame = CGRectMake(20, _dataView.sendToLabel.y + 50, 80, 20);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth,224 + _max);
                _dataView.sizeLabel.hidden = YES;
                _dataView.sizeButton.hidden = YES;
            }
           else if (_skuArr.count == 0)
            {
                _dataView.specificationsL.hidden = YES;
                _dataView.sizeButton.hidden = YES;
                _dataView.sizeLabel.hidden = YES;
                _dataView.sendToLabel.hidden = NO;
                _dataView.sendToLabel.frame = CGRectMake(20,30, 60, 20);
                _dataView.frame = CGRectMake(0,kScreenHeight- 243-10 , kScreenWidth,243+10);
                _dataView.buyNumLabel.frame = CGRectMake(20, _dataView.sendToLabel.y + 50, 80, 20);
                _dataView.sendLabel.hidden = NO;
                _dataView.sendLabel.frame = CGRectMake(120,_dataView.sendToLabel.y - 5 , _dataView.buttonView.width, 30);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth, 121);
            }
            else
            {
                CGFloat scrollViewHeight;
                if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS)
                {
                    scrollViewHeight = 120;
                }
                else
                {
                    scrollViewHeight = 50;
                }
                _dataView.frame = CGRectMake(0,_backView.height - _dataView.height ,kScreenWidth ,400);
                _dataView.scrollView.contentSize = CGSizeMake(kScreenWidth,_dataView.height - _dataView.productImage.height+scrollViewHeight);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
            }
        }
        if (_type == 3)
        {
            
            if (_skuArr.count == 0)
            {
                _dataView.specificationsL.hidden = YES;
                _dataView.sizeButton.hidden = YES;
                _dataView.sizeLabel.hidden = YES;
                _dataView.sendToLabel.hidden = YES;
                _dataView.sendLabel.hidden = YES;
                _dataView.frame = CGRectMake(0,kScreenHeight- 243 , kScreenWidth,243);
                _dataView.buyNumLabel.frame = CGRectMake(20,_max+20, 80, 20);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth, 121);
            }
            else if (_skuArr.count == 1)
            {
                _dataView.frame = CGRectMake(0, _backView.height -  (224 + _max ),kScreenWidth , 224 + _max);
                _dataView.sendLabel.hidden =YES;
                _dataView.sendToLabel.hidden = YES;
        
                _dataView.buyNumLabel.frame = CGRectMake(20,_max+20, 80, 20);
                _dataView.buttonView.frame = CGRectMake(120 , _dataView.buyNumLabel.y - 10, 120, 32);
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                _dataView.scrollView.frame = CGRectMake(0, _dataView.productImage.height, kScreenWidth,224);
                _dataView.sizeLabel.hidden = YES;
                _dataView.sizeButton.hidden = YES;
                
                [self buttonDisEnable];
            }
            else
            {
                
                _dataView.buyNumLabel.frame = CGRectMake(20, _maxS + 10, 80, 20);
                
                _dataView.buttonView.frame = CGRectMake(120, _dataView.buyNumLabel.y - 10, 120, 32);
                
                _dataView.frame = CGRectMake(0, _backView.height - ( _dataView.productImage.height +  + _colorSelectView.height +  _sizeSelectView.height + _dataView.buttonView.y + _dataView.buttonView.height+ 44) ,kScreenWidth , _dataView.productImage.height +  + _colorSelectView.height +  _sizeSelectView.height + _dataView.buttonView.y + _dataView.buttonView.height+ 44);
                
                _dataView.determineBtn.frame = CGRectMake(0, _dataView.height - 44, kScreenWidth, 44);
                
                _dataView.sizeButton.hidden = YES;
                
                _dataView.sendToLabel.hidden = YES;
                
                _dataView.sendLabel.hidden = YES;
            }
            
        }

    }];
    if (_type == 2)
    {
        if (_skuArr.count == 0)
        {
            [self buttonEnable];
        }
        else
        {
            [self buttonDisEnable];
        }
    }
}

#pragma mark - determineBtn、cancelBtn、closeBtn、changeAddress
- (void)determineBtnAction
{
    if ([NSString isEmptyString:_citiSelectStr])
    {
        _dataView.sendLabel.text = @"北京市";
        _provinceId = 110000;
    }
    else
    {
        _dataView.sendLabel.text = _citiSelectStr;
        _provinceId = self.provinceId;
    }
    
    [self selectSku];
    _baseView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _pickBasicView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);;
    }];
}

- (void)cancelButtonAction
{
    _baseView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        _pickBasicView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);;
    }];
}

- (void)closeView
{
    _baseView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        
        _pickBasicView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

- (void)changeAdd
{
    [UIView animateWithDuration:0.35 animations:^{
        _pickBasicView.frame = CGRectMake(0, kWindowHeight-243, kScreenWidth,  243);
        _backView.frame = CGRectMake(0,-243 , kScreenWidth, kScreenHeight);
        
        _determineButton.frame = CGRectMake(kScreenWidth - 44, 0, 44, 44);
        
        _cancelButton.frame = CGRectMake(0, 0, 44, 44);
        
        _pickView.frame = CGRectMake(0, 43 ,kScreenWidth , _pickBasicView.height - 44);
        
    }];
}

- (void)defaultStatusForPopView
{
    for(UIButton *btn in self.colorSelectView.subviews)
    {
        if (btn.selected == YES)
        {
            btn.selected = NO;
            
            btn.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
            
            _colorSelected = NO;
            
            if (_skuArr.count ==1)
            {
                _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc];
            }
            else
            {
                _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@%@",_detailSkuModel.valueForColorDesc,_detailSkuModel.valueForSizeDesc];
            }
        }
    }
    
    for(UIButton *btn in self.sizeSelectView.subviews)
    {
        if (btn.selected == YES)
        {
            btn.selected = NO;
            
            btn.layer.borderColor = [UIColor colorWithRed:84.0/255 green:84.0/255 blue:84.0/255 alpha:1].CGColor;
            
            _sizeSelected = NO;
            
            if (_skuArr.count ==1)
            {
                _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@",_detailSkuModel.valueForColorDesc];
            }
            {
                _dataView.choseLabel.text = [NSString stringWithFormat:@"请选择 %@%@",_detailSkuModel.valueForColorDesc,_detailSkuModel.valueForSizeDesc];
            }
        }
    }
}
// 代替navgationBar的view
- (UIView *)replaceNavBarWithView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.replaceView = view;
    [self.view addSubview:self.replaceView];
    view.backgroundColor = [UIColor clearColor];
    
    _replaceViewLine = [CALayer layerWithFrame:CGRectMake(0, view.height-1, view.width, 1)];
    _replaceViewLine.backgroundColor = [[UIColor clearColor] CGColor];
    [view.layer addSublayer:_replaceViewLine];
    
   
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 39, 39)];
    [backButton setImage:[UIImage imageNamed:@"detail_back"] forState:UIControlStateNormal];
    [backButton sizeToFit];
    [backButton addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    
    UIButton * moreButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -49, 20, 39, 39)];
    [moreButton setImage:[UIImage imageNamed:@"detail_more"] forState:UIControlStateNormal];
    [moreButton sizeToFit];
    [moreButton addTarget:self action:@selector(goMore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreButton];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-200)*0.5,24 , 200,40)];
    _titleLab.font = [UIFont systemFontOfSize:20];
    _titleLab.text= @"商品详情";
    _titleLab.textColor = MAIN_COLOR_BLACK_ALPHA;
    _titleLab.hidden = YES;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLab];
    return view;
}


- (void)goToBack
{
    
    if(self.fromOtherApp)
    {
        [self goMain];
    }else
    {
        [self goBack];
    }
}
// 分享的事件
-(void)sharedWithOther
{
    NSString *ID = [[_shareInfo[@"productInfo"][@"imgKey"] componentsSeparatedByString:@","] firstObject];
    NSString *image;
    image = [NSString stringWithFormat:@"%@%@/%@",URL_BASE,URL_IMAGE_BASE,ID];
    [self shareWithText:@"中国电信战略合作伙伴--聚分享积分钱包，积分可以当钱花啦，快来查查你的积分吧!" image:image url:[NSString stringWithFormat:@"%@%@",URL_SHARE_DETAIL,self.productId] title:self.productName delegate:self];
}

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    [FNUBSManager ubsEvent:[NSString stringWithFormat:@"share_%@",platformName]];
}


// 设置换行的label 的size
- (CGSize)sizeWithMaxSize:(CGFloat)maxWidth andFont:(UIFont *)font WithString:(NSString*)str
{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:0];
    [paragraphStyle setHeadIndent:0];
    return  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
}


@end
