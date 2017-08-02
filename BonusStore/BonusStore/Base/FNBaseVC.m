//
//  FNBaseVC.m
//  BonusStore
//
//  Created by Nemo on 16/3/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNBaseVC.h"
//#import "FNMacro.h"
#import "FNHeader.h"

@interface FNBaseVC()
{
    
}

@end

@implementation FNBaseVC

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setTableViewDelegate:(id<UITableViewDataSource,UITableViewDelegate>)tableViewDelegate
{
    _tableViewDelegate = tableViewDelegate;
    
    [self autoFitInsets];
    
    if (_tableViewDelegate)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-NAVIGATION_BAR_HEIGHT)];
        
        _tableView.delegate = _tableViewDelegate;
        
        _tableView.dataSource = _tableViewDelegate;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
        
        _isTableView = YES;
    }
}

- (void)setCollectionViewDelegate:(id<UICollectionViewDelegate,UICollectionViewDataSource>)collectionViewDelegate
{
    _collectionViewDelegate = collectionViewDelegate;
    
    if (_collectionViewDelegate)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight-NAVIGATION_BAR_HEIGHT-self.tabBarController.tabBar.height) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        _collectionView.delegate = _collectionViewDelegate;
        
        _collectionView.dataSource = _collectionViewDelegate;
        
        [self.view addSubview:_collectionView];
        
        _isCollectionView = YES;
    }
}

- (void)registerClass:(Class)clazz
{
    [self.collectionView registerClass:clazz forCellWithReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)showNoResult
{
    
}

- (void)showLoading
{
    
}

- (void)hideLoading
{
    
}

@end
