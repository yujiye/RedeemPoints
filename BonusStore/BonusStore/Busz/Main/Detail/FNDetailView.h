//
//  FNDetailView.h
//  BonusStore
//
//  Created by sugarwhi on 16/6/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

#import "FNMacro.h"

@class FNDetailView;

@protocol FNDetailBuyDelegate <NSObject>

@optional

- (void)numBtnClick:(FNDetailView *)view flag:(NSInteger)flag;

- (void)numChangeView:(FNDetailView *)view numberOfTextField:(UITextField *)textField;

@end

@interface FNDetailView : UIView

@property (nonatomic, strong)UIImageView *productImage;

@property (nonatomic, strong)UIButton *closeBtn;

@property (nonatomic, strong)UILabel *productPrice;

@property (nonatomic, strong)UILabel *skuLabel;

@property (nonatomic, strong)UILabel *choseLabel;

@property (nonatomic, strong)UILabel *colorLabel;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)UILabel *specificationsL;

@property (nonatomic, strong)UIImageView *specificationsView;

@property (nonatomic, strong)UILabel *specificationsTitle;

@property (nonatomic, strong)UIButton *specificationsButton;

@property (nonatomic, strong)UILabel *sizeLabel;
//
@property (nonatomic, strong)UIButton *sizeButton;

@property (nonatomic, strong)UILabel *sendToLabel;

@property (nonatomic, strong)UILabel *sendLabel;

@property (nonatomic, strong)UILabel *buyNumLabel;

@property (nonatomic, strong)UIView *buttonView;

@property (nonatomic, strong)UIButton *cutBtn;

@property (nonatomic, strong)UITextField *numText;

@property (nonatomic, strong)UIButton *addBtn;

@property (nonatomic, strong)UIButton *determineBtn;

@property (nonatomic, weak)id<FNDetailBuyDelegate>textFieldDelegate;

@end
