//
//  FNMainHeaderReusableView.h
//  BonusStore
//
//  Created by Nemo on 16/4/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import "FNMainConfigHeaderView.h"
#import "FNMainProductHeaderView.h"
@class FNFocusView;
@class FNMainConfigHeaderView;
@class FNMainProductHeaderView;

@interface FNMainHeaderReusableView : UICollectionReusableView

@property (nonatomic, strong) FNFocusView *focusView;

@property (nonatomic, strong) FNMainConfigHeaderView *configView;

@property (nonatomic, strong)FNMainProductHeaderView *productHeaderView;

@property (nonatomic, strong)NSMutableArray *advertOfProductArray;

@property (nonatomic, strong)NSMutableArray *advertOfImageArray;

@property (nonatomic, strong)NSMutableArray *advertOfCashArray;

- (void)goItemIndexBlock:(FNSelectedIndex)block;

@end
