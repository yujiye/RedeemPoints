//
//  FNHopeVC.m
//  BonusStore
//
//  Created by Nemo on 16/5/11.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNHopeVC.h"
#import "FNLoginBO.h"
#import "FNMyBO.h"
#import "FNBonusBO.h"

@interface FNHopeVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_teleOutBut;
    
    UIScrollView *_header;
    
    UIImageView *_top;
    
    UIView *_teleView;
    
    UIView *_airView;
    
    UIView *_moreView;
}

@end

@implementation FNHopeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"积分互通";
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
        
    [self initHeader];
}

- (void)initHeader
{
    _header = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-NAVIGATION_BAR_HEIGHT)];
    
    _header.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [self.view addSubview:_header];
    
    _top = [[UIImageView alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"main_hope_top"];
    
    _top.image = image;
    
    _top.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    if (IS_IPHONE_5)
    {
        UIReframeWithW(_top, 320);
        UIReframeWithH(_top, 143);
    }
    
    [_header addSubview:_top];
    
    [self initTeleView];
    
    [self initAirView];
    
    [self initMoreView];
    
    [_header setContentSize:CGSizeMake(kWindowWidth, _moreView.y+_moreView.height+20)];
    
}

- (void)initTeleView
{
    _teleView = [[UIView alloc] initWithFrame:CGRectMake(15, _top.y+_top.height+10, kWindowWidth-30, 176)];
    
    _teleView.backgroundColor = [UIColor whiteColor];
    
    [_teleView setCorner:5];
    
    [_header addSubview:_teleView];

    UIImageView *tele = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 44, 45)];
    
    tele.image = [UIImage imageNamed:@"tele_logo"];
    
    [_teleView addSubview:tele];

    UIImageView *con = [[UIImageView alloc] initWithFrame:CGRectMake(tele.x+tele.width+10, 24, 28, 26)];
    
    con.image = [UIImage imageNamed:@"tele_con"];
    
    [_teleView addSubview:con];
    
    UIImageView *jfshare = [[UIImageView alloc] initWithFrame:CGRectMake(con.x+con.width+10, tele.y, 45, 45)];
    
    jfshare.image = [UIImage imageNamed:@"jfshare_logo"];
    
    [_teleView addSubview:jfshare];
    
    if (IS_IPHONE_5)
    {
        UIReframeWithH(tele, 37);
        UIReframeWithW(tele, 37);
        
        UIReframeWithH(jfshare, 37);
        UIReframeWithW(jfshare, 37);
    }

    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(_teleView.width-100, 20, 80, 20)];
    [tipLabel setFont:[UIFont systemFontOfSize:13]];
    [tipLabel setTextColor:UIColorWith0xRGB(0x333333)];
    [tipLabel setText:@"电信积分兑换" align:NSTextAlignmentRight];
    [_teleView addSubview:tipLabel];

    UILabel *ratioLabel = [[UILabel alloc]initWithFrame:CGRectMake(_teleView.width-160, tipLabel.y+tipLabel.height+5, 140, 20)];
    [ratioLabel setFont:[UIFont systemFontOfSize:12]];
    [ratioLabel setTextColor:UIColorWith0xRGB(0x666666)];
    [ratioLabel setText:@"1电信积分=1聚分享积分" align:NSTextAlignmentRight];
    [_teleView addSubview:ratioLabel];
    
    CALayer *line =[CALayer layerWithFrame:CGRectMake(0, ratioLabel.y+ratioLabel.height+15, _teleView.width, 0.5) color:UIColorWith0xRGB(0xF3F3F3)];
    
    [_teleView.layer addSublayer:line];
    
    UIButton *teleInBut = [FNButton buttonWithType:FNButtonTypePlain title:@"立即兑入"];
    
    teleInBut.frame = CGRectMake(15, ratioLabel.y+ratioLabel.height+30, _teleView.width-30, 35);
    
    [teleInBut setCorner:5];
    
    teleInBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
    
    [teleInBut addSuperView:_teleView ActionBlock:^(id sender) {
        
        [self goTeleIn];
        
    }];
    
    UIButton *teleOutBut = [UIButton buttonWithType:UIButtonTypeCustom];//[FNButton buttonWithType:FNButtonTypeOpposite title:@"积分兑出"];
    
    [teleOutBut setTitle:@"积分兑出" forState:UIControlStateNormal];
    
    [teleOutBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    teleOutBut.backgroundColor = [UIColor whiteColor];
    
    teleOutBut.frame = CGRectMake(_teleView.width-80, teleInBut.y+teleInBut.height+5, 75, 35);
    
    teleOutBut.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    [teleOutBut addSuperView:_teleView ActionBlock:^(id sender) {
        
        [self goTeleOut];
        
    }];
}

- (void)initAirView
{
    _airView = [[UIView alloc] initWithFrame:CGRectMake(15, _teleView.y+_teleView.height+10, kWindowWidth-30, 148)];
    
    _airView.backgroundColor = [UIColor whiteColor];
    
    [_airView setCorner:5];
    
    [_header addSubview:_airView];
    
    UIImageView *tele = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 44, 45)];
    
    tele.image = [UIImage imageNamed:@"air_logo"];
    
    [_airView addSubview:tele];
    
    UIImageView *con = [[UIImageView alloc] initWithFrame:CGRectMake(tele.x+tele.width+10, 24, 28, 26)];
    
    con.image = [UIImage imageNamed:@"air_con"];
    
    [_airView addSubview:con];
    
    UIImageView *jfshare = [[UIImageView alloc] initWithFrame:CGRectMake(con.x+con.width+10, tele.y, 45, 45)];
    
    jfshare.image = [UIImage imageNamed:@"jfshare_logo"];
    
    [_airView addSubview:jfshare];
    
    if (IS_IPHONE_5)
    {
        UIReframeWithH(tele, 37);
        UIReframeWithW(tele, 37);
        
        UIReframeWithH(jfshare, 37);
        UIReframeWithW(jfshare, 37);
    }

    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(_teleView.width-100, 20, 80, 20)];
    [tipLabel setFont:[UIFont systemFontOfSize:13]];
    [tipLabel setTextColor:UIColorWith0xRGB(0x333333)];
    [tipLabel setText:@"海航积分兑换" align:NSTextAlignmentRight];
    [_airView addSubview:tipLabel];
    
    UILabel *ratioLabel = [[UILabel alloc]initWithFrame:CGRectMake(_teleView.width-160, tipLabel.y+tipLabel.height+5, 140, 20)];
    [ratioLabel setFont:[UIFont systemFontOfSize:12]];
    [ratioLabel setTextColor:UIColorWith0xRGB(0x666666)];
    [ratioLabel setText:@"1海航里程=1聚分享积分" align:NSTextAlignmentRight];
    [_airView addSubview:ratioLabel];
    
    CALayer *line =[CALayer layerWithFrame:CGRectMake(0, ratioLabel.y+ratioLabel.height+15, _teleView.width, 0.5) color:UIColorWith0xRGB(0xF3F3F3)];
    
    [_airView.layer addSublayer:line];
    
    UIButton *teleInBut = [FNButton buttonWithType:FNButtonTypeOpposite title:@"即将开通"];
    
    teleInBut.frame = CGRectMake(15, ratioLabel.y+ratioLabel.height+30, _teleView.width-30, 35);
    
    [teleInBut setCorner:5];
    
    [teleInBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    teleInBut.titleLabel.font = [UIFont fzltBoldWithSize:15];
    
    [teleInBut addSuperView:_airView ActionBlock:^(id sender) {
        
    }];
   
}

- (void)initMoreView
{
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(15, _airView.y+_airView.height+10, kWindowWidth-30, 162)];
    
    _moreView.backgroundColor = [UIColor whiteColor];
    
    [_moreView setCorner:5];
    
    [_header addSubview:_moreView];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 21)];
    
    if (IS_IPHONE_6P)
    {
        UIReframeWithH(_moreView, 208);
        UIReframeWithH(tipLabel, 31);

    }
    else if (IS_IPHONE_6)
    {
        UIReframeWithH(_moreView, 190);
        UIReframeWithH(tipLabel, 27);
    }
    
    [tipLabel setFont:[UIFont systemFontOfSize:12]];
    [tipLabel setTextColor:UIColorWith0xRGB(0x979797)];
    [tipLabel setText:@"更多积分兑换，敬请期待" align:NSTextAlignmentLeft];
    [_moreView addSubview:tipLabel];
    
    NSArray *mores = @[@"cb",@"south_air",@"cbc",@"cmb",@"ccb",@"sb"];
    
    NSInteger index = 0;
    
    CGSize size;
    
    for (NSString *m in mores)
    {
        UIImage *image = [UIImage imageNamed:m];
        
        size = CGSizeMake(kScaleW(image.size.width), kScaleH(image.size.height));
        
        UIImageView *tele = [[UIImageView alloc] initWithFrame:CGRectMake(size.width*(index%3), size.height*(index/3)+tipLabel.y+tipLabel.height+5,size.width-0.5, size.height-0.5)];
        
        tele.image = image;
        
        tele.contentMode = UIViewContentModeScaleAspectFit;
        
        [_moreView addSubview:tele];
        
        
        CALayer *line = [CALayer layerWithFrame:CGRectMake(tele.width*(index%3)-0.5, tipLabel.y+tipLabel.height+5, 0.5, size.height*2) color:UIColorWith0xRGB(0xF3F3F3)];
        
        [_moreView.layer addSublayer:line];
        
        index++;
    }
    
    CALayer *tLine = [CALayer layerWithFrame:CGRectMake(0, tipLabel.y+tipLabel.height+5-0.5, _moreView.width, 0.5) color:UIColorWith0xRGB(0xF3F3F3)];
    
    [_moreView.layer addSublayer:tLine];
    
    CALayer *cLine = [CALayer layerWithFrame:CGRectMake(0, size.height+tipLabel.y+tipLabel.height+5, _moreView.width, 0.5) color:UIColorWith0xRGB(0xF3F3F3)];
    
    [_moreView.layer addSublayer:cLine];

    CALayer *bLine = [CALayer layerWithFrame:CGRectMake(0, size.height*2+tipLabel.y+tipLabel.height+5, _moreView.width, 0.5) color:UIColorWith0xRGB(0xF3F3F3)];
    
    [_moreView.layer addSublayer:bLine];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (void)goTeleIn
{
    __weak __typeof(self) weakSelf = self;
    
    [[[FNBonusBO port01] withOutUserInfo] teleInWithBlock:^(id result) {
    
        if ([result[@"code"] integerValue] == 200)
        {

            FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:result[@"url"]]];
            
            vc.isMoreItem = YES;
            
            vc.title = @"电信积分";
            
            vc.isPop = YES;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            NSString *url = @"http://active.jfshare.com/android/comesoon.html";
            
            FNWebVC *vc = [[FNWebVC alloc] initWithURL:[NSURL URLWithString:url]];

            vc.isMoreItem = YES;
            
            vc.title = @"电信积分";
            
            vc.isPop = YES;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    
        
    }];
}

- (void)goTeleOut
{
    if (![FNLoginBO isLogin])
    {
        return ;
    }

    _teleOutBut.enabled = NO;
    
    FNBonusCashVC *vc = [[FNBonusCashVC alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    _teleOutBut.enabled = YES;
}
@end
