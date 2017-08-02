//
//  FNSegListBar.m
//  BonusStore
//
//  Created by Nemo on 16/4/20.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNSegListBar.h"

@interface FNSegListBar ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    void (^FNSegSelectedBlock) (NSArray *array);
    
    void (^FNColumnSelectedBlock) (NSInteger index);
    
    NSMutableArray *_array;     //Button array
    
    CGFloat _column;            //column width
    
    UITableView *_tableView;
    
    NSMutableArray *_tableArray;//
    
    BOOL _isShow;               //table is show
    
    CGFloat _height;            //self height
    
    UIView *_mask;              //mask
    
    CGFloat _maskHeight;        //mask height
    
    NSMutableArray *_selectedArray; //selected item array
}

@end

@implementation FNSegListBar

@synthesize selectedIndex = _selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _height = frame.size.height;
        
        _array = [NSMutableArray array];
        
        _tableArray = [NSMutableArray array];
        
        _selectedArray = [NSMutableArray array];
    }
    return self;
}

- (void)initMaskWithPoint:(CGPoint)point
{
    _maskHeight = kWindowHeight-point.y +1;
    
    if (_mask)
    {
        return;
    }
    
    _mask = [[UIView alloc] initWithFrame:CGRectMake(0, point.y, self.width, 0)];
    
    _mask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_mask];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    
    _tableView.scrollEnabled = YES;

    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.delaysContentTouches = NO;
    
    _tableView.canCancelContentTouches = YES;

    _tableView.delegate = self;

    _tableView.dataSource = self;

    [_mask addSubview:_tableView];
    
    _mask.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    
    tap.numberOfTapsRequired = 1;
    
    tap.numberOfTouchesRequired = 1;
    
    tap.delegate = self;
    
    [_mask addGestureRecognizer:tap];
}

//二维数组：items
- (void)setItems:(NSArray *)items
{
    [_tableArray addObjectsFromArray:items];
    
    _column = self.width/items.count;
    
    NSInteger i = 0;
    
    for (NSArray *item in items)
    {
        FNButton *it = [FNButton buttonWithType:FNButtonTypePlain title:item[0]];
        
        it.tag = i;
        
        if (i == 0)
        {
            [it setTitle:@"交易时间" forState:UIControlStateNormal];
        }
        if (i == 1)
        {
            [it setTitle:@"交易类型" forState:UIControlStateNormal];
        }
        
        it.backgroundColor = [UIColor whiteColor];
        
        it.layer.borderColor = [MAIN_BACKGROUND_COLOR CGColor];
        
        it.frame = CGRectMake(i*_column, 0, _column, self.height);
        
        it.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [it setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [it addSuperView:self ActionBlock:^(UIButton *sender) {
            
            [self setSelectedIndex:sender.tag];
            
        }];
        
        [_array addObject:it];
        
        [_selectedArray addObject:@(0)];
        
        i++;
    }
    
}

// 选择左右的column

- (void)selectedColumnWithBlock:(void (^) (NSInteger index))block
{
    FNColumnSelectedBlock = nil;
    
    FNColumnSelectedBlock = block;
}

//选择列表item

- (void)selectedItemWithBlock:(void (^) (NSArray *array))block
{
    FNSegSelectedBlock = nil;
    
    FNSegSelectedBlock = block;
}

- (void)setSelectedIndex:(NSInteger)index
{
    UIButton *sender = _array[index];



    if (_isShow)
    {
        [self hide];
    
        for (UIButton *b in _array)
        {
            [b setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateNormal];
            
            b.backgroundColor = [UIColor whiteColor];
        }
        
        if (_selectedIndex != index)
        {
            _selectedIndex = index;
            
            if (_tableView)
            {
                [_tableView reloadData];
            }

            [self show];
            
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            sender.backgroundColor = MAIN_COLOR_RED_BUTTON;
        }
    }
    else
    {
        _selectedIndex = index;
        
        if (_tableView)
        {
            [_tableView reloadData];
        }

        [self show];
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        sender.backgroundColor = MAIN_COLOR_RED_BUTTON;
    }

    FNColumnSelectedBlock(_selectedIndex);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)_tableArray[self.selectedIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _tableArray[self.selectedIndex][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *but = _array[self.selectedIndex];
    
    [but setTitle:_tableArray[self.selectedIndex][indexPath.row] forState:UIControlStateNormal];
    
    [self hide];
    
    if ([_selectedArray count]-1 >= self.selectedIndex)
    {
        [_selectedArray replaceObjectAtIndex:self.selectedIndex withObject:@(indexPath.row)];
    }
    
    if (FNSegSelectedBlock)
    {
        FNSegSelectedBlock(_selectedArray);
    }
    
    for (UIButton *b in _array)
    {
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        b.backgroundColor = [UIColor whiteColor];
    }
}

- (void)hide
{
    [UIView animateWithDuration:0.35 animations:^{
        
        UIReframeWithH(_mask, 0);
        
        UIReframeWithH(_tableView, 0);
        
    } completion:^(BOOL finished) {
      
        
    }];
    
    _isShow = NO;
}

- (void)show
{
    if (_isShow)
    {
        [_tableView reloadData];
        
        _isShow = !_isShow;
        
        return;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        
        UIReframeWithH(_mask, _maskHeight);

     NSArray * arr = (NSArray *)_tableArray[self.selectedIndex] ;
        UIReframeWithH(_tableView, arr.count * 44);

        if (arr.count *44 > kScreenHeight - CGRectGetMaxY(self.frame) -64)
        {
            UIReframeWithH(_tableView,kScreenHeight-CGRectGetMaxY(self.frame)-64);
        }

    } completion:^(BOOL finished) {

    }];

    _isShow = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:_mask];
    
    if (CGRectContainsPoint(_tableView.bounds, point))
    {
        return NO;
    }
    
    return YES;
}

- (void)deallocMask
{
    [_mask removeFromSuperview];
    
    _mask = nil;
}

@end
