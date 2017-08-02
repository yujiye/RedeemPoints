//
//  FNMainItemTableCell.m
//  BonusStore
//
//  Created by Nemo on 16/4/6.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNMainItemTableCell.h"
#import "FNMainBO.h"

@interface FNMainItemTableCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    
    void (^_indexBlock) (FNProductArgs *product, NSInteger index) ;
    
    void (^FNMainItemTableCellGoAllBlock) (void);
}

@end

@implementation FNMainItemTableCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _rankArray = [[NSMutableArray alloc] init];

        self.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        UIImageView *_leftView = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowDemiW - 40 - 52, 14.5, 52, 11)];
        
        _leftView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        _leftView.image = [UIImage imageNamed:@"main_section_up_left"];

        [self addSubview:_leftView];
        
        UIImageView *_rightView = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowDemiW+62, 14.5, 52, 11)];
        
        _rightView.backgroundColor = MAIN_BACKGROUND_COLOR;
        
        _rightView.image = [UIImage imageNamed:@"main_section_up_right"];

        [self addSubview:_rightView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAverageValue(frame.size.width-150), 0, 150, 35)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleLabel.textColor = UIColorWithRGB(227, 3, 3);
        
        _titleLabel.text = @"积分兑换排行";
        
        _titleLabel.font = [UIFont fzltBoldWithSize:13];
        
        [self addSubview:_titleLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _titleLabel.height, kWindowWidth, 150) collectionViewLayout:layout];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        
        _collectionView.dataSource = self;
        
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:[FNMainItemCollectionSubCell class] forCellWithReuseIdentifier:@"FNMainItemCollectionSubCell"];
        
        [self refresh];

    }
    return self;
}

- (void)refresh
{
    
    [[FNMainBO port01] getProductListWithPage:1 sort:FNSortTypeTimeDesc perCount:20 block:^(id result) {
        
        if (![result isKindOfClass:[NSArray class]])
        {
            _collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            
            if (result)
            {
                [UIAlertView alertViewWithMessage:result[@"desc"]];                
            }
            else
            {
            }
            
            return ;
        }
        
        [_rankArray removeAllObjects];
        
        [_rankArray addObjectsFromArray:result];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_collectionView reloadData];
            
        });
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rankArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNMainItemCollectionSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FNMainItemCollectionSubCell class]) forIndexPath:indexPath];
    
    FNProductArgs *product = _rankArray[indexPath.row];
    
    [cell setProduct:product];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FNProductArgs *product = _rankArray[indexPath.row];
    
    if (_indexBlock)
    {
        _indexBlock(product, indexPath.row);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 124);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(5, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(5, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-15, 0, 0, 0);
}

- (void)goAllWithBlock:(void (^) (void))block
{
    FNMainItemTableCellGoAllBlock = nil;
    
    FNMainItemTableCellGoAllBlock = block;
}

- (void)didSelectedIndexBlock:(void (^) (FNProductArgs *product, NSInteger index))block
{
    _indexBlock = nil;
    
    _indexBlock = block;
}

@end
