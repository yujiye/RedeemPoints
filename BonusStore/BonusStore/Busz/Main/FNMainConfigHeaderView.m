//
//  FNMainConfigHeaderView.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/26.
//  Copyright © 2016年 Nemo. All rights reserved.
//



#import "FNMainConfigHeaderView.h"
#import "FNBonusBO.h"
#import "FNMainBtn.h"
#import "FNQCoinRechargeVC.h"
#import "FNGameCardVC.h"
#import "FNLoginBO.h"
#import "FNHeader.h"

@implementation FNMainConfigHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        CGFloat margin = (kScreenWidth - 5*45)/10.0;
        self.backgroundColor = [UIColor whiteColor];
        NSArray * imgArr = @[@"main_bonus_interflow",@"main_bonus_recharge",@"main_card_icon",@"main_blank",@"main_blank_sz",@"main_mobile_recharge",@"main_bonus_flowRecharge",@"main_bonus_QCoin",@"main_bonus_gameCard",@"main_bonus_globalFood"];
        NSArray * labelArr = @[@"积分互通",@"积分充值",@"特惠卡券",@"开卡有礼",@"深圳通",@"话费充值",@"流量充值",@"Q币充值",@"游戏点卡", @"全球美食"];
        CGFloat line1Y = 0.0 ;
        CGFloat iconW = 45 + 2*margin;
        for (int i = 0; i < 10;i++)
        {
            int j = i%5;
            int k = i/5;
            FNMainBtn * mainBtn = [[FNMainBtn alloc]initWithFrame:CGRectMake(iconW *j , 75*k  + 15, iconW, 60)];
            mainBtn.tag = i;
            mainBtn.imgView.image = [UIImage imageNamed:imgArr[i]];
            mainBtn.titleLab.text = labelArr[i];
            [mainBtn addTarget:self action:@selector(goDiffPages:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:mainBtn];
            if (i == 9)
            {
                line1Y = CGRectGetMaxY(mainBtn.frame);
            }
            
        }
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 165, self.width, 8)];
        line1.backgroundColor = MAIN_BACKGROUND_COLOR;
        [self addSubview:line1];
        
        CGFloat kscale;
        if (IS_IPHONE_6)
        {
            kscale = 1;
            
        }else if (IS_IPHONE_6P)
        {
            kscale = (CGFloat)(414.0/375.0);
        }else
        {
            kscale = (CGFloat)(320.0/375.0);
        }
        CGFloat marginImg = 18*kscale;
        _configImgViewFirst = [[UIImageView alloc]initWithFrame:CGRectMake(marginImg, line1.y+line1.height, (self.width - marginImg*6)/3 , 135*kscale)];
        _configImgViewFirst.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_configImgViewFirst];
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(_configImgViewFirst.x+_configImgViewFirst.width+marginImg, _configImgViewFirst.y, 1, _configImgViewFirst.height)];
        line2.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        [self addSubview:line2];
        
        _configImgViewSecond = [[UIImageView alloc]initWithFrame:CGRectMake(line2.x+marginImg, _configImgViewFirst.y, _configImgViewFirst.width, _configImgViewFirst.height)];
        _configImgViewSecond.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_configImgViewSecond];
        
        UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(_configImgViewSecond.x+_configImgViewSecond.width+marginImg, _configImgViewSecond.y, 1, _configImgViewSecond.height)];
        line3.backgroundColor = UIColorWith0xRGB(0xF3F3F3);
        [self addSubview:line3];
        
        _configImgViewThird = [[UIImageView alloc]initWithFrame:CGRectMake(line3.x+marginImg, _configImgViewSecond.y, _configImgViewSecond.width, _configImgViewSecond.height)];
        _configImgViewThird.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_configImgViewThird];
        
    }
    
    return self;
}



- (void)goDiffPages:(UIButton *)sender
{
    switch (sender.tag) {
        case FNMainBonusInterflow:
            // 积分互通0
        {
            [self goBonus];
        }
            break;
        case FNMainBonusRecharge:
            //积分充值1
        {
            [self goBonusRecharge];
        }
            break;
        case FNMainBonusWallet:
            
            //特惠卡券3
            [self goToFlowRechargeVC];
            
            break;
        case FNMainDiscountCard:
            //开卡有礼4
            [self goBank];
            
            break;
        case FNMainBankCardGift:
        {
            //深圳通4
            [self goSZTong];
        }
            break;
        case FNMainMobileRecharge:
        {
            //话费充值5
            [self goMobileRecharge];
        }
            break;
        case FNMainFlowRecharge:
        {
            //流量充值6
            [self goFlowRecharge];
        }
            break;
        case FNMainQCoinRecharge:
        { //Q币充值7
            [self goQCoinRechargeVC];
        }
            break;
        case FNMainGameCard:
        {
            //游戏点卡8
            [self goGameCard];
        }
            break;
        case FNMainGlobalFood:
            //全球美食9
            [self goFoodVC];
            break;
            
        default:
            break;
    }
}
- (void)goToFlowRechargeVC
{
    FNCateProductListVC *cateProductListVC = [[FNCateProductListVC alloc]init];
    cateProductListVC.isVirtual = YES;
    cateProductListVC.secCategory.subjectId = @"1012";
    [[self viewController].navigationController pushViewController:cateProductListVC animated:YES];
    
}

- (void)goToMyBonus
{
    if (![FNLoginBO isLogin])
    {
        return ;
    }
    
    FNMyBonusVC *vc = [[FNMyBonusVC alloc ] init];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (void)goFoodVC
{
    FNCateProductListVC *cateProductListVC = [[FNCateProductListVC alloc]init];
    cateProductListVC.isVirtual = NO;
    FNHeadRightModel * model = [[FNHeadRightModel alloc]init];
    model.subjectId = @"1006";
    model.subjectName = @"食品酒水";
    cateProductListVC.secCategory = model;
    [[self viewController].navigationController pushViewController:cateProductListVC animated:YES];
    
}

- (void)goFlowRecharge
{
    FNFlowRechargeVC * flowRechargeVC = [[FNFlowRechargeVC alloc]init];
    [[self viewController].navigationController pushViewController:flowRechargeVC animated:YES];
}

-(void)goGameCard
{
    FNGameCardVC * gameCardVC = [[FNGameCardVC alloc]init];
    [[self viewController].navigationController pushViewController:gameCardVC animated:YES];
    
}

- (void)goBonus
{
    FNHopeVC *hopeVC = [[FNHopeVC alloc]init];
    [[self viewController].navigationController pushViewController:hopeVC animated:YES];
}

- (void)goBonusRecharge
{
    FNBonusRechargeVC *bonusRecharge = [[FNBonusRechargeVC alloc]init];
    [[self viewController].navigationController pushViewController:bonusRecharge animated:YES];
}

- (void)goMobileRecharge
{
    FNMobileRechargeVC *mobileRecharge = [[FNMobileRechargeVC alloc]init];
    [[self viewController].navigationController pushViewController:mobileRecharge animated:YES];
}

- (void)goBank
{
    NSString *url = @"https://ecentre.spdbccc.com.cn/creditcard/indexActivity.htm?data=P766829";
    NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:encodedString]];
    web.title = @"开卡有礼";
    [[self viewController].navigationController pushViewController:web animated:YES];
}

- (void)goSZTong
{
    FNSZWelcomeVC *buyCouponVC = [[FNSZWelcomeVC  alloc]init];
    [buyCouponVC setHidesBottomBarWhenPushed:YES];
    [[self viewController].navigationController pushViewController:buyCouponVC animated:YES];
    
}

- (void)goQCoinRechargeVC
{
    FNQCoinRechargeVC *QCoinVC = [[FNQCoinRechargeVC alloc]init];
    [[self viewController].navigationController pushViewController:QCoinVC animated:YES];
}

- (void)setCashDataWithCashArray:(NSMutableArray *)cashArray
{
    _imageUrlArr = cashArray;
    NSMutableArray *imageArray = [NSMutableArray array];
    for (FNAdvertOfConfig *advert in cashArray)
    {
        [imageArray addObject:advert.imgKey];
    }
    switch (cashArray.count) {
        case 0:
            _configImgViewFirst.image = [UIImage imageNamed:@"main_item_default"];
            _configImgViewSecond.image = [UIImage imageNamed:@"main_item_default"];
            _configImgViewThird.image = [UIImage imageNamed:@"main_item_default"];
            break;
        case 1:
            [_configImgViewFirst  sd_setImageWithURL:IMAGE_ID(imageArray.firstObject) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
            [_configImgViewFirst addTarget:self action:@selector(configImgViewSecondAction:)];
            _configImgViewSecond.image = [UIImage imageNamed:@"main_item_default"];
            _configImgViewThird.image = [UIImage imageNamed:@"main_item_default"];
            break;
        case 2:
            [_configImgViewFirst sd_setImageWithURL:IMAGE_ID(imageArray.firstObject) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
            [_configImgViewFirst addTarget:self action:@selector(configImgViewFirstAction:)];
            [_configImgViewSecond  sd_setImageWithURL:IMAGE_ID(imageArray[1]) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
            [_configImgViewSecond addTarget:self action:@selector(configImgViewSecondAction:)];
            _configImgViewThird.image = [UIImage imageNamed:@"main_item_default"];
            break;
        case 3:
            [_configImgViewFirst sd_setImageWithURL:IMAGE_ID(imageArray.firstObject) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
            [_configImgViewFirst addTarget:self action:@selector(configImgViewFirstAction:)];
            [_configImgViewSecond  sd_setImageWithURL:IMAGE_ID(imageArray[1]) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
            [_configImgViewSecond addTarget:self action:@selector(configImgViewSecondAction:)];
            
            [_configImgViewThird  sd_setImageWithURL:IMAGE_ID(imageArray[2]) placeholderImage:[UIImage imageNamed:@"main_item_default"]];
            [_configImgViewThird addTarget:self action:@selector(configImgViewThirdAction:)];
            break;
        default:
            break;
    }
}

- (void)configImgViewFirstAction:(UIButton *)sender
{
    NSMutableArray *urlArr = [NSMutableArray array];
    
    for (FNAdvertOfConfig *advert in _imageUrlArr)
    {
        [urlArr addObject:advert.jump];
    }
    NSMutableString *j = [NSMutableString stringWithFormat:@"%@", urlArr.firstObject];
    if ([j rangeOfString:@"data-detail.html?"].location !=NSNotFound)
    {
        
        NSArray *urlArr = [j componentsSeparatedByString:@"productId"];
        NSString *productId = [urlArr.lastObject substringFromIndex:1];
        FNDetailVC *mainDetailVC = [[FNDetailVC alloc]init];
        mainDetailVC.productId = productId;
        
        [[self viewController].navigationController pushViewController:mainDetailVC animated:YES];
    }
    else
    {
        if ([j rangeOfString:@"?"].length)
        {
            [j appendString:@"&app=app"];
        }
        else
        {
            [j appendString:@"?app=app"];
        }
        
        
        FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:j]];
        web.title = @"聚分享活动";
        [[self viewController].navigationController pushViewController:web animated:YES];
    }
    
    
}
- (void)configImgViewSecondAction:(UIButton *)sender
{
    NSMutableArray *urlArr = [NSMutableArray array];
    
    for (FNAdvertOfConfig *advert in _imageUrlArr)
    {
        [urlArr addObject:advert.jump];
    }
    NSMutableString *j = [NSMutableString stringWithFormat:@"%@", urlArr[1]];
    if ([j rangeOfString:@"data-detail.html?"].location !=NSNotFound)
    {
        
        NSArray *urlArr = [j componentsSeparatedByString:@"productId"];
        NSString *productId = [urlArr.lastObject substringFromIndex:1];
        FNDetailVC *mainDetailVC = [[FNDetailVC alloc]init];
        mainDetailVC.productId = productId;
        
        [[self viewController].navigationController pushViewController:mainDetailVC animated:YES];
    }
    else
    {
        if ([j rangeOfString:@"?"].length)
        {
            [j appendString:@"&app=app"];
        }
        else
        {
            [j appendString:@"?app=app"];
        }
        
        
        FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:j]];
        web.title = @"聚分享活动";
        [[self viewController].navigationController pushViewController:web animated:YES];
    }
}

- (void)configImgViewThirdAction:(UIButton *)sender
{
    NSMutableArray *urlArr = [NSMutableArray array];
    
    for (FNAdvertOfConfig *advert in _imageUrlArr)
    {
        [urlArr addObject:advert.jump];
    }
    NSMutableString *j = [NSMutableString stringWithFormat:@"%@", urlArr[2]];
    if ([j rangeOfString:@"data-detail.html?"].location !=NSNotFound)
    {
        
        NSArray *urlArr = [j componentsSeparatedByString:@"productId"];
        NSString *productId = [urlArr.lastObject substringFromIndex:1];
        FNDetailVC *mainDetailVC = [[FNDetailVC alloc]init];
        mainDetailVC.productId = productId;
        
        [[self viewController].navigationController pushViewController:mainDetailVC animated:YES];
    }
    else
    {
        if ([j rangeOfString:@"?"].length)
        {
            [j appendString:@"&app=app"];
        }
        else
        {
            [j appendString:@"?app=app"];
        }
        
        FNWebVC *web = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:j]];
        web.title = @"聚分享活动";
        [[self viewController].navigationController pushViewController:web animated:YES];
    }
}

- (UIViewController *)viewController
{
    UIViewController *vc = nil;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            vc =  (UIViewController *)nextResponder;
            return (UIViewController*)nextResponder;
            
        }
    }
    return vc;
}

@end
