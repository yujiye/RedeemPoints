//
//  XMWebVC.h
//  BonusStore
//
//  Created by Nemo on 16/1/9.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNCommon.h"

UIKIT_EXTERN BOOL isTianYi;

@interface FNWebVC : UIViewController

@property (nonatomic, assign) BOOL isShareItem;

@property (nonatomic, assign) BOOL isMoreItem;

@property (nonatomic, assign) BOOL isPop;   //处理部分页面无法返回，增加一个pop

@property (nonatomic, assign) BOOL isWebPay;

- (instancetype)initWithID:(NSString *)ID;

- (instancetype)initWithURL:(NSURL *)url;

- (instancetype)initWithPath:(NSString *)path;

- (instancetype)initWithHTML:(NSString *)html;

- (instancetype)initWithURL:(NSURL *)url body:(NSData *)body;

- (void)loadWithURL:(NSURL *)url html:(NSString *)html;

//CMB need order ids to check whether it's pay sucess or not
//and go different page in order center.
@property (nonatomic, strong) NSString *orderId;

- (instancetype)initWithURL:(NSURL *)url html:(NSString *)html;


@end
