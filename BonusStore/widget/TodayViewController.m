//
//  TodayViewController.m
//  widget
//
//  Created by cindy on 2017/2/13.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "FNTouchArgs.h"
#import "FNMainBtn.h"
@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong)NSArray * widgetArr;
@end

@implementation TodayViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.extensionContext setValue:@"1" forKey:@"widgetLargestAvailableDisplayMode"];
   self.widgetArr = [FNTouchArgs widgetArr];
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - 5*45 -20)/10.0;
    CGFloat iconW = 45 + 2*margin;
    for (int i = 0; i < 10;i++)
    {
        FNTouchArgs * widgetArgs = self.widgetArr[i];
        int j = i%5;
        int k = i/5;
        FNMainBtn * mainBtn = [[FNMainBtn alloc]initWithFrame:CGRectMake(iconW *j , 85*k  + 30, iconW, 60)];
        mainBtn.tag = i;
        mainBtn.imgView.image = [UIImage imageNamed:widgetArgs.imageName];
        mainBtn.titleLab.text = widgetArgs.title;
        [mainBtn addTarget:self action:@selector(goDiffPages:) forControlEvents:UIControlEventTouchUpInside];
        [self.view  addSubview:mainBtn];
    }

}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,110 );
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110*2);
    }
}

- (void)goDiffPages:(UIButton *)btn
{
    NSString * customUrl = [NSString stringWithFormat:@"group.jfshare.today://type=%ld",(long)btn.tag];
    [self.extensionContext openURL:[NSURL URLWithString:customUrl] completionHandler:^(BOOL success) {
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 110);
   
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

@end
