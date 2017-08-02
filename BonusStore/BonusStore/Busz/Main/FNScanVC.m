//
//  FNScanViewController.m
//  BonusStore
//
//  Created by Nemo on 16/4/12.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNScanVC.h"
#import "FNLoginBO.h"
#import "FNMainBO.h"

@interface FNScanVC ()
{
    NSTimer *_timer;
    UIImageView *_imageView;
    UIImageView *_lineImageView;
    UILabel *_titleLabel;
}

@end

@implementation FNScanVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initUiConfig];
    [self addDiscoverView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    self.title = @"扫描二维码";
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    self.preview.frame =CGRectMake(self.view.bounds.size.width * 0.5 - 140, (self.view.bounds.size.height -64) * 0.5 - 140, 280, 280);
}

- (void)initUI:(CGRect)previewFrame
{
    
    if (self.device ==nil)
    {

        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    NSError *error = nil;
    if (self.input == nil)
    {
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    }
    if (error) {
        [self.view makeToast:@"你手机不支持二维码扫描!"];
        return;
    }
    if (self.output == nil)
    {
        self.output = [[AVCaptureMetadataOutput alloc]init];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    if (self.session ==nil)
    {
        self.session = [[AVCaptureSession alloc]init];
        if ([self.session canAddInput:self.input])
        {
            [self.session addInput:self.input];
        }
        if ([self.session canAddOutput:self.output])
        {
            [self.session addOutput:self.output];
        }
    }
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    if(self.preview ==nil)
    {
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = previewFrame;
        [self.view.layer addSublayer:self.preview];
    }
    if ([UIScreen mainScreen].bounds.size.height == 480)
    {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }
    else
    {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    //10.设置扫描范围
    _output.rectOfInterest = CGRectMake(0.1f, 0.1f, 0.8f, 0.8f);
    [self.session startRunning];
}

//扫描完成的时候就会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self.session stopRunning];
    NSString *val = nil;
    if (metadataObjects.count > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        val = obj.stringValue;
        if ([NSString isEmptyString:val])
        {
            [UIAlertView alertViewWithMessage:@"扫描正确二维码"];
            [self.session startRunning];
            return;
        }
        // 兼容
        if([val hasPrefix:@"http://h5.jfshare.com/html/offlinePayment.html?encryCode="])
        {
            val = [[val componentsSeparatedByString:@"encryCode="]lastObject];
        }
        NSString *b = [FNTools textFromBase64String:val];
        
        if ([NSString isEmptyString:b])
        {
            b =  val;
        }
        NSData *jsonData = [b  dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:nil];
        if ([NSString isEmptyString:dict[@"sellerId"]] || [NSString isEmptyString:dict[@"sellerName"]] ||  [NSString isEmptyString:dict[@"tradeCode"]] )
        {
            [UIAlertView alertViewWithMessage:@"扫描正确二维码"];
            [self.session startRunning];
        }else{
            NSMutableArray * arr = [NSMutableArray array];
            [arr addObject:dict];
            FNScanPayVC *vc = [[FNScanPayVC alloc] init];
            vc.sellerDetailList = arr;
            vc.tradeCode = dict[@"tradeCode"];
            NSMutableArray *tempMarr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [tempMarr removeObject:self];
            [tempMarr insertObject: vc atIndex:tempMarr.count];
            [self.navigationController setViewControllers:tempMarr animated:YES];
        }
  
    }
}

- (void)initUiConfig
{
    [self initUI: CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height)];
    if (_imageView ==nil)
    {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_image"]];
        _imageView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
        _imageView.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 140, (self.view.bounds.size.height -64) * 0.5 - 140, 280, 280);
        [self.view addSubview:_imageView];
    }
    if(_lineImageView == nil)
    {
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
        _lineImageView.image = [UIImage imageNamed:@"scan_light_green"];
        [_imageView addSubview:_lineImageView];
        
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.6 target:self selector:@selector(scanLineAnimation) userInfo:nil repeats:YES];
    if(_titleLabel == nil)
    {
        CGFloat titleY = CGRectGetMaxY(_imageView.frame);
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleY+10, kScreenWidth, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:MAIN_BACKGROUND_COLOR];
        [_titleLabel setText:@"请扫描聚分享(商家版)二维码付款" align:NSTextAlignmentCenter];
        [self.view addSubview:_titleLabel];
    }
}

- (void)scanLineAnimation
{
    [UIView animateWithDuration:2.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _lineImageView.frame = CGRectMake(30, 260, 220, 2);
        
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(30, 10, 220, 2);
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
    [_timer invalidate];
    
}

- (void)addDiscoverView
{
    //上边
    UIView * topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.preview addSublayer:topView.layer];
    CGFloat topViewH = CGRectGetMinY(_imageView.frame);
    topView.frame = CGRectMake(0, 0, kScreenWidth, topViewH);
    
    //下边
    UIView * bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.preview addSublayer:bottomView.layer];
    CGFloat bottomViewH = CGRectGetMaxY(_imageView.frame);
    bottomView.frame = CGRectMake(0, bottomViewH, kScreenWidth,kScreenHeight -bottomViewH);
    
    // 左边
    UIView * leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.preview addSublayer:leftView.layer];
    CGFloat leftViewW = CGRectGetMinX(_imageView.frame);
    leftView.frame = CGRectMake(0, topViewH,leftViewW , bottomViewH - topViewH);
    
    // 右边
    UIView * rightView = [[UIView alloc]init];
    rightView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.preview addSublayer:rightView.layer];
    CGFloat rightViewY = CGRectGetMaxX(_imageView.frame);
    rightView.frame = CGRectMake(rightViewY, topViewH,leftViewW , bottomViewH - topViewH);
}

@end
