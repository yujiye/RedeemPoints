//
//  FNDetailWebVC.m
//  BonusStore
//
//  Created by feinno on 16/6/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNDetailWebVC.h"
#import "FNHeader.h"
@interface FNDetailWebVC ()<UIWebViewDelegate>
{
    FNSegBar *_detailSegBar;
}

@property (nonatomic,strong)UIWebView * webView;
@property WebViewJavascriptBridge* bridge;

@end

@implementation FNDetailWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    [self setNavigaitionMoreItem];
    
    _detailSegBar = [[FNSegBar alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 50)];
    _detailSegBar.defaultTitleColor = MAIN_COLOR_GRAY_ALPHA;
    _detailSegBar.selectedTitleColor = [UIColor redColor];
    _detailSegBar.lineColor = [UIColor redColor];
    [_detailSegBar setItems:@[@"图文详情"]];

    CALayer *uLine = [CALayer layerWithFrame:CGRectMake(0, 0, kWindowWidth, 1)];
    [_detailSegBar.layer addSublayer:uLine];
    
    CALayer *bLine = [CALayer layerWithFrame:CGRectMake(0, _detailSegBar.height-1, kWindowWidth, 1)];
    [_detailSegBar.layer addSublayer:bLine];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-NAVIGATION_BAR_HEIGHT)];
    
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(@"Response for message from ObjC");
    }];
    
    __weak __typeof(self) weakSelf = self;
    
    [_detailSegBar selectedItemWithBlock:^(NSInteger index) {
        NSDictionary *j = @{@"index":@(index)};
        
        NSData *d = [NSJSONSerialization dataWithJSONObject:j options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *json = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        
        [weakSelf.bridge callHandler:@"detailSegment" data:json responseCallback:^(id responseData) {
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_PRODUCT_DETAIL,self.productId]]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
