//
//  XMWebVC.m
//  BonusStore
//
//  Created by Nemo on 16/1/9.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "FNWebVC.h"
#import "FNLoginBO.h"
#import "FNCartBO.h"

BOOL isTianYi;

@interface FNWebVC ()<UIWebViewDelegate, UMSocialUIDelegate, UIGestureRecognizerDelegate>
{
    FNWebType _type;
    
    NSString *_html;
    
    NSURL *_url;
    
    NSMutableURLRequest *_request;
    
    NSMutableDictionary *_shareInfo;
}

@property (nonatomic, strong) UIWebView *webView;

@property WebViewJavascriptBridge* bridge;

@end

@implementation FNWebVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [[CMBWebKeyboard shareInstance] hideKeyboard];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        [[CMBWebKeyboard shareInstance] hideKeyboard];
}

- (instancetype)initWithID:(NSString *)ID
{
    FNWebVC *vc = [self initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_SHARE_DETAIL,ID]]];
    
    vc.isPop = YES;
    
    return vc;
}

- (instancetype)initWithURL:(NSURL *)url
{
    return [self initWithURL:url html:@" "];
}

- (instancetype)initWithPath:(NSString *)path
{
    FNWebVC *vc = [self initWithURL:[NSURL fileURLWithPath:path]];
    
    vc.isPop = YES;
    
    return vc;
}

- (instancetype)initWithHTML:(NSString *)html
{
    return [self initWithURL:nil html:html];
}

// CMB使用
- (instancetype)initWithURL:(NSURL *)url body:(NSData *)body
{
    _request = [NSMutableURLRequest requestWithURL:url];
    
    _request.timeoutInterval = 5;
    
    _request.HTTPMethod = @"POST";
    
    _request.HTTPBody = body;
    
    return [self initWithURL:url html:nil];
}

- (instancetype)initWithURL:(NSURL *)url html:(NSString *)html
{
    self = [super init];
    
    if (self)
    {
        _url = url;
        
        _html = html;
        
        
        self.navigationController.navigationBar.hidden = NO;
        
        _shareInfo = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setNavigaitionBackItem];
    
    if(self.isMoreItem)
    {
        [self setNavigaitionMoreItem];
    }
    
    if (self.isShareItem)
    {
        UIBarButtonItem *share = [FNNavigationBarItem setCustomRightWithTarget:self image:[UIImage imageNamed:@"nav_share_nor"] action:@selector(goShare)];
        
        [self.navigationItem setRightBarButtonItems:@[share]];
    }
    
    if (self.isShareItem && self.isMoreItem)
    {
        UIBarButtonItem *share = [FNNavigationBarItem setCustomRightWithTarget:self image:[UIImage imageNamed:@"nav_share_nor"] action:@selector(goShare)];
        
        UIBarButtonItem *more = [self setNavigaitionMoreItem];
        
        [self.navigationItem setRightBarButtonItems:@[more,share]];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-NAVIGATION_BAR_HEIGHT)];
    
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
        
    }];
    
    [self.bridge registerHandler:@"showImageGallery" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSArray *imgArr = data[@"imgArr"];
        
        if ([imgArr count] < 2)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
            
            [imageView sd_setImageWithURL:imgArr[0] placeholderImage:nil];
            
            imageView.backgroundColor = [UIColor blackColor];
            
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [[UIApplication sharedApplication].keyWindow addSubview:imageView];
            
            [imageView addTarget:self action:@selector(removeSingleFocusView:)];
            
            return ;
        }
        
        FNFocusView *view = [[FNFocusView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
        
        view.backgroundColor = [UIColor blackColor];
        
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSString *url in imgArr)
        {
            FNImageArgs *arg = [[FNImageArgs alloc] init];
            
            arg.url = url;
            
            [array addObject:arg];
        }
        
        for (UIImageView *v in view.imageViews)
        {
            v.contentMode = UIViewContentModeScaleAspectFit;
        }
        
        view.items = array;
        
        view.pageControl.currentPage = [data[@"index"] integerValue];
        
        [view focusDidSelectedIndex:^(NSInteger index, FNImageArgs *args) {
            
            [view removeFromSuperview];
            
        }];
    }];
    
    [_bridge registerHandler:@"openNewActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:data[@"url"]]];
        
        vc.title = data[@"title"];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [_bridge registerHandler:@"showShareButton" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        _url = [NSURL URLWithString:[_url.absoluteString stringByReplacingOccurrencesOfString:@"?app=app" withString:@""]];
        _url = [NSURL URLWithString:[_url.absoluteString stringByReplacingOccurrencesOfString:@"&app=app" withString:@""]];
        
        _shareInfo = data;
        
        if (!_shareInfo)
        {
            [weakSelf setNavigaitionMoreItem];
        }
        else
        {
            UIBarButtonItem *share = [FNNavigationBarItem setCustomRightWithTarget:self image:[UIImage imageNamed:@"nav_share_nor"] action:@selector(goShare)];
            
            UIBarButtonItem *more = [self setNavigaitionMoreItem];
            
            [weakSelf.navigationItem setRightBarButtonItems:@[more,share]];
        }
    }];
    
    [_bridge registerHandler:@"getUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *json = nil;
        
        [FNUserAccountArgs getUserAccountInfo];
        
        if (FNUserAccountInfo)
        {
            NSDictionary *j = @{@"ppInfo":FNUserAccountInfo[@"ppInfo"],@"token":FNUserAccountInfo[@"token"],@"userId":FNUserAccountInfo[@"userId"],@"browser":[FNDevice idfa],@"clientType":@(FNClientTypeiOS),@"version":APP_ARGUS_VERSION};
            
            
            NSData *d = [NSJSONSerialization dataWithJSONObject:j options:NSJSONWritingPrettyPrinted error:nil];
            
            json = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        }
        else
        {
            json = nil;
        }
        
        responseCallback(json);
    }];
    
    [_bridge registerHandler:@"openShopCar" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (![FNLoginBO isLogin])
        {
            return ;
        }
        
        for (UIViewController *vc in weakSelf.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[FNCartVC class]])
            {
                [weakSelf.navigationController popToViewController:vc animated:YES];
                
                return;
            }
        }
        
        FNCartVC *vc = [[FNCartVC alloc] init];
        vc.isComeFromCartImage =  YES;
        [vc setNavigaitionBackItem];
        
        [vc hideTabBar];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    
    [_bridge registerHandler:@"bugItNow" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (![FNLoginBO isLogin])
        {
            return ;
        }
        NSMutableArray * array = [NSMutableArray array];
        
        for ( NSDictionary * needDict in data[@"sellerDetailList"] )
        {
            [array addObject:[FNCartGroupModel mj_objectWithKeyValues:needDict ]];
        }
        
        for (FNCartGroupModel *model in array)
        {
            for(FNCartItemModel * cartItem in model.productList)
            {
                NSString * str =  cartItem.imgKey;
                NSArray *array = [str componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
                NSArray *arr = [array.lastObject componentsSeparatedByString:@"_"];
                cartItem.imgKey = [NSString stringWithFormat:@"%@.jpg",arr.firstObject];
            }
        }
        if([data[@"type"] intValue]== 3)
        {
            FNVirfulOrderVC *vc  =[[FNVirfulOrderVC  alloc]init];
            vc.fillOrderDataSource = array;
            vc.maxCount = [data[@"maxCount"] intValue];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else if ([data[@"type"] intValue] ==2)
        {
            FNFillOrderVC *vc = [[FNFillOrderVC alloc] init];
            vc.fillOrderDataSource = array;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [_bridge registerHandler:@"loginApp" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (![FNLoginBO isLogin])
        {
            return ;
        }
        
    }];
    
    [_bridge registerHandler:@"openProductDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *url = data[@"jumpUrl"];
        
        NSString *preSlash = [[url componentsSeparatedByString:@"/"] lastObject];
        
        if ([[[preSlash componentsSeparatedByString:@"?"] firstObject] isEqualToString:@"data-detail.html"])
        {
            NSString *ID = [[url componentsSeparatedByString:@"="] lastObject];
            
            FNDetailVC *vc = [[FNDetailVC alloc] init];
            
            vc.productId = ID;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [_bridge registerHandler:@"goMainActivity" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [weakSelf goMain];
        
    }];
    
    if (_request)
    {
        [self loadRequest:_request];
    }
    else if (_url || _html)
    {
        [self loadWithURL:_url html:_html];
    }
}


- (void)goShare
{
    NSString *url = [[_url.absoluteString componentsSeparatedByString:@"?"] firstObject];
    
    [self shareWithText:_shareInfo[@"content"] image:_shareInfo[@"image"] url:url title:_shareInfo[@"title"] delegate:self];
}

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    [FNUBSManager ubsEvent:[NSString stringWithFormat:@"share_%@",platformName]];
}

- (void)loadWithURL:(NSURL *)url html:(NSString *)html
{
    if (url)
    {
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else if (html)
    {
        [_webView loadHTMLString:html baseURL:nil];
    }
}

- (void)loadRequest:(NSURLRequest *)request
{
    [_webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *preSlash = [[request.URL.absoluteString componentsSeparatedByString:@"/"] lastObject];
    
    NSArray * resultArr = [preSlash componentsSeparatedByString:@"?"];
    NSString *loginUrl = [resultArr firstObject];
    NSArray * prapeArr = [[resultArr lastObject] componentsSeparatedByString:@"&"];
    
    if ([preSlash isEqualToString:@"pay-success.html"])
    {
        if ([FNPayInfo[@"tradeCode"] isEqualToString:@"Z8007"])
        {
            FNSZPayFinishVC * szPayFinishVC  = [[FNSZPayFinishVC alloc]init];
            [self.navigationController pushViewController:szPayFinishVC animated:YES];
            
        }else
        {
            FNPayFinishVC *vc = [[FNPayFinishVC alloc] init];
            
            vc.bonus = FNPayInfo[@"price"];
            vc .isSpecialType =  [FNPayInfo[@"isSpecialType"] boolValue];
            vc.orderType = [FNPayInfo[@"orderType"] intValue];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        return NO;
    }//和包支付成功毁掉
        else if ([request.URL.host isCaseInsensitiveEqualToString:@"cmbls"])
        {
            CMBWebKeyboard *secKeyboard = [CMBWebKeyboard shareInstance];
            [secKeyboard showKeyboardWithRequest:request];
            secKeyboard.webView = _webView;
            //以下是实现点击键盘外地方，自动隐藏键盘
            UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [self.view addGestureRecognizer:myTap];
            myTap.delegate = self;
    //        myTap.cancelsTouchesInView = NO;
            return NO;
        }//招商银行自定义键盘
    else if([loginUrl isEqualToString:@"pointsExchangeOutSubmit.html"])
    {
        FNBonusCashDetailVC * bonusCashDetailVC = [[FNBonusCashDetailVC alloc]init];
        [prapeArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj hasPrefix:@"cashAmount"])
            {
                bonusCashDetailVC.bonus = [[[obj componentsSeparatedByString:@"="] lastObject]integerValue];
            }
            if ([obj hasPrefix:@"DeviceNo"])
            {
                bonusCashDetailVC.mobile = [[obj componentsSeparatedByString:@"="] lastObject];
            }
            
        }];
        bonusCashDetailVC.prameArr = prapeArr;
        bonusCashDetailVC.isNotFirstCash = NO;
        NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [tempMarr removeObject:self];
        [tempMarr insertObject:bonusCashDetailVC atIndex:tempMarr.count];
        [self.navigationController setViewControllers:tempMarr animated:YES];
        return NO;
    }//电信积分兑换
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [FNLoadingView showInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [FNLoadingView hideFromView:self.view];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)removeSingleFocusView:(UIGestureRecognizer *)ges
{
    UIView *view = [ges view];
    
    [view removeFromSuperview];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
        [[CMBWebKeyboard shareInstance] hideKeyboard];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)goBack
{
        [[CMBWebKeyboard shareInstance] hideKeyboard];
    
    if (!self.isWebPay)
    {
        [super goBack];
        
        return;
    }
    else if (![FNReachability isReach])
    {
        
        for (UIViewController *vc  in self.navigationController.viewControllers)
        {
            NSObject *root = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
            
            if ([root isKindOfClass:[FNTabBarVC class]])
            {
                FNTabBarVC *tab = (FNTabBarVC *)root;
                
                [tab goTabIndex:3];
                
                UINavigationController *my = [tab selectedViewController];
                FNOrderVC *order = [[FNOrderVC alloc]init];
                order.stateTag = FNTitleTypeOrderStatePaying;
                [my pushViewController:order animated:NO];
                
                break;
            }
        }
        return;
    }else
    {
        [UIAlertView alertViewWithMessage:@"支付已取消"];
        
    }
    
    [FNLoadingView showInView:self.view];
    
    [[FNCartBO port02] getOrderDetailWithOrderID:self.orderId block:^(id result){
        
        [FNLoadingView hide];
        
        if ([result isKindOfClass:[FNOrderArgs class]])
        {
            FNOrderArgs *orderArgs = (FNOrderArgs *)result;
            
            for ( __unused UIViewController *vc  in self.navigationController.viewControllers)
            {
                NSObject *root = [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
                
                if ([root isKindOfClass:[FNTabBarVC class]])
                {
                    FNTabBarVC *tab = (FNTabBarVC *)root;
                    
                    [tab goTabIndex:3];
                    
                    UINavigationController *my = [tab selectedViewController];
                    FNOrderVC *order = [[FNOrderVC alloc]init];
                    if ([orderArgs.orderState integerValue] == FNOrderStatePaying)
                    {
                        order.stateTag = FNTitleTypeOrderStatePaying;
                    }
                    else if ([orderArgs.orderState integerValue] == FNOrderStateShipping)
                    {
                        order.stateTag = FNTitleTypeOrderStateShipping;
                    }
                    else if ([orderArgs.orderState integerValue] == FNOrderStateReceiving)
                    {
                        order.stateTag = FNTitleTypeOrderStateReceiving;
                    }
                    else if ([orderArgs.orderState integerValue] == FNOrderStateFinish || [orderArgs.orderState integerValue] == FNOrderStateFinishCommenting)
                    {
                        order.stateTag = FNTitleTypeOrderStateFinish;
                    }
                    else if ([orderArgs.orderState integerValue] == FNOrderStateAll)
                    {
                        order.stateTag = FNTitleTypeOrderStateAll;
                    }
                    
                    [my pushViewController:order animated:NO];
                    
                    break;
                }
            }
        }
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (void)dealloc {
    _webView.delegate = nil;
        [[CMBWebKeyboard shareInstance] hideKeyboard];
    
    [_webView stopLoading];
        [[CMBWebKeyboard shareInstance] hideKeyboard];
}
@end
