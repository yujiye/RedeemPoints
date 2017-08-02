//
//  FNMainProductHeaderView.h
//  BonusStore
//
//  Created by sugarwhi on 16/9/27.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNHeader.h"
@interface FNMainProductHeaderView : UIView

@property (nonatomic, strong)UIImageView *headImg;

@property (nonatomic, strong)UIImageView *productImg;

@property (nonatomic, strong) NSMutableArray *imgArr;

@property (nonatomic, strong) NSMutableArray *productImageArr1;

@property (nonatomic, strong) NSMutableArray *productImageArr2;

- (void)setConfigForProductWithImgArray:(NSMutableArray *)imageArray;

- (void)setHeaderImg:(NSMutableArray *)headImgArray;

@end
