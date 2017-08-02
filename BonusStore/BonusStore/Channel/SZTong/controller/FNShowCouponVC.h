//
//  FNShowCouponVC.h
//  BonusStore
//
//  Created by cindy on 2017/4/24.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNShowCouponVC : UIViewController

@end

@interface FNShowCouponModel : NSObject

@property(nonatomic, assign)NSNumber *amount;
@property(nonatomic, assign)NSNumber *couponCount;
@property (nonatomic,assign)BOOL isChoice;


@end

@interface  FNShowCoupCell: UICollectionViewCell

@property (nonatomic,strong)FNShowCouponModel * showCouponModel;
@property (nonatomic,strong)UIImageView *bgImgView;
@property (nonatomic,strong)UILabel * moneyLabel;
@property (nonatomic,strong)UILabel * numLabel;

@end
