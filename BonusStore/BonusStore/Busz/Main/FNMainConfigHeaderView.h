//
//  FNMainConfigHeaderView.h
//  BonusStore
//
//  Created by sugarwhi on 16/9/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FNHeader.h"

@interface FNMainConfigHeaderView : UIView

@property (nonatomic, strong)UIImageView *bonusInterflowImg;

@property (nonatomic, strong)UILabel *bonusInterflowLab;

@property (nonatomic, strong)UIImageView *bonusRechageImg;

@property (nonatomic, strong)UILabel *bonusRechageLab;

@property (nonatomic, strong)UIImageView *mobileRechageImg;

@property (nonatomic, strong)UILabel *mobileRechageLab;

@property (nonatomic, strong)UIImageView *cardRechageImg;

@property (nonatomic, strong)UILabel *cardRechageLab;

@property (nonatomic, strong)UIImageView *bankImg;

@property (nonatomic, strong)UILabel *bankLab;

@property (nonatomic, strong)UIImageView *configImgViewFirst;

@property (nonatomic, strong)UIImageView *configImgViewSecond;

@property (nonatomic, strong)UIImageView *configImgViewThird;

@property (nonatomic, strong)NSMutableArray *imageUrlArr;


- (void)setCashDataWithCashArray:(NSMutableArray *)cashArray;


@end
