//
//  XMSegBar.m
//  PandaFinancial
//
//  Created by Nemo on 16/1/3.
//  Copyright © 2016年 nemo. All rights reserved.
//

#import "FNSegBar.h"

@interface FNSegBar ()
{
    FNSelectedIndex _segBlock;
    
    CALayer *_line;
    
    NSMutableArray *_array;
    
    CGFloat _column;
}

@end

@implementation FNSegBar

@synthesize selectedIndex = _selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _array = [NSMutableArray array];
        
        self.lineColor = [UIColor whiteColor];
        
        self.defaultTitleColor = MAIN_COLOR_RED_ALPHA;
        
        self.selectedTitleColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setItems:(NSArray *)items
{
    _column = self.width/items.count;
    
    NSInteger i = 0;
    
    for (NSString *item in items)
    {
        FNButton *it = [FNButton buttonWithType:FNButtonTypePlain title:item];
        
        it.tag = i;
        
        it.frame = CGRectMake(i*_column, 0, _column, self.height);
        
        it.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [it setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        [it addSuperView:self ActionBlock:^(UIButton *sender) {
            
            [self setSelectedIndex:sender.tag];
            
        }];
        
        [_array addObject:it];
        
        i++;
    }
    
    [self setSelectedIndex:0];
    
    _line = [CALayer layerWithFrame:CGRectMake(0, self.height-2, _column, 2) color:self.lineColor];
    
    [self.layer addSublayer:_line];

}

- (void)selectedItemWithBlock:(void (^) (NSInteger index))block
{
    _segBlock = nil;
    
    _segBlock = block;
}

- (void)setSelectedIndex:(NSInteger)index
{
    _selectedIndex = index;
    
    UIButton *sender = _array[index];
    
    for (UIButton *b in _array)
    {
        [b setTitleColor:self.defaultTitleColor forState:UIControlStateNormal];
        
        b.backgroundColor = [UIColor whiteColor];
        
        b.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    
    [sender setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
        
    _line.frame = CGRectMake(_column*sender.tag, self.height-2, _column, 2);
    
    if (_segBlock)
    {
        _segBlock(sender.tag);
    }
}

@end
