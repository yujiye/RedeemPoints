//
//  FNOrderCenterView.m
//  BonusStore
//
//  Created by sugarwhi on 16/9/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNOrderCenterView.h"
#import "FNHeader.h"
@interface FNOrderCenterView ()

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)UIView * lineView;//线

@end


@implementation FNOrderCenterView

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    [self initView];
}

- (UIView *)lineView{
    
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = MAIN_COLOR_RED_ALPHA;
        [self.scrollView addSubview:_lineView];
    }
    
    return _lineView;
}

- (void)initView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    //设置 内容大小
    self.scrollView.contentSize = CGSizeMake([self totalWidth], self.frame.size.height);
    
    [self selectIndex:0];
    [self addSubview:self.scrollView];

}

-(float)totalWidth{
    
    float width = 0;
    
    for (NSString * title in _titles) {
        
        float buttonWidth = self.frame.size.width/_titles.count;//button的宽
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(width, 0, buttonWidth, self.frame.size.height);
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setTitle:title forState:UIControlStateNormal];
        
        [self.scrollView addSubview:button];
        
        width += buttonWidth;
        //设置 button的选址状态的颜色
        [button setTitleColor:MAIN_COLOR_RED_ALPHA forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];
        
    }
    
    return width;//返回总长度
}

-(NSMutableArray *)buttons{
    
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)clickButton:(UIButton*)button
{
    if (button.selected) {//如果已经选中 直接返回
        return;
    }
    for (UIButton * b in _buttons) {
        b.selected = NO;
    }
    button.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(button.frame.origin.x, self.frame.size.height - 3, button.frame.size.width , 3);

    }];
    if ([self.delegate respondsToSelector:@selector(titleView:selectIndex:)]) {
       
        [self.delegate titleView:self selectIndex:[self.buttons indexOfObject:button]];
    }
}
//选中第几个
-(void)selectIndex:(NSInteger)index{
    UIButton * button = self.buttons[index];
    for (UIButton * b in _buttons) {
        b.selected = NO;
    }
    button.selected = YES;

    self.lineView.frame = CGRectMake(button.frame.origin.x, self.frame.size.height - 3, button.frame.size.width, 3);
}

@end
