//
//  FNCateHeadReusableView.h
//  BonusStore
//
//  Created by sugarwhi on 16/4/18.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+Cate.h"
#import "FNHeader.h"

@interface FNCateHeadReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel * titleLable;

@property (nonatomic, strong) UIButton * checkAllBtn;

@property (nonatomic, strong) UIButton * checkBtn;

@property (nonatomic, strong) UIButton * hotCheckBtn;

@end
