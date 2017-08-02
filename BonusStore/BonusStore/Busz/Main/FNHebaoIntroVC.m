//
//  FNHebaoIntroVC.m
//  BonusStore
//
//  Created by Nemo on 16/5/16.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNHebaoIntroVC.h"

@interface FNHebaoIntroVC ()

@end

@implementation FNHebaoIntroVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"移动和包";
    
    [self setNavigaitionBackItem];
    
    [self setNavigaitionMoreItem];
    
    UIImage *intro = [UIImage imageNamed:@"main_hebao_intro"];

    UIScrollView *bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, intro.size.height)];
    
    [self.view addSubview:bg];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, intro.size.height)];
    
    view.image = intro;
    
    [bg addSubview:view];
    
    [bg setContentSize:CGSizeMake(kWindowWidth, 895)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
