//
//  FNBaseVC.h
//  BonusStore
//
//  Created by Nemo on 16/3/22.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface FNBaseVC : UIViewController

@property (nonatomic, assign) BOOL isTableView;

@property (nonatomic, strong) UITableView *tableView;

// If tableViewDelegate is nil, variable isTableView, tableView is nil too, or opposite.
@property (nonatomic, assign) id<UITableViewDataSource, UITableViewDelegate> tableViewDelegate;

@property (nonatomic, assign) BOOL isCollectionView;

@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  If collectionViewDelegate is nil, variable isCollectionView, collectionView is nil too, or opposite.
 *  The default scroll direction is vertical.
 *  You should implement your own collection layout and item size, also you can make a custom cell.
 */
@property (nonatomic, assign) id<UICollectionViewDelegate, UICollectionViewDataSource> collectionViewDelegate;

- (void)registerClass:(Class)clazz;

@property (nonatomic, assign) BOOL isRefreshable;

@property (nonatomic, assign) BOOL isMoreable;

// Show no result view if there is empty response from request.
- (void)showNoResult;

- (void)showLoading;

- (void)hideLoading;

@end
