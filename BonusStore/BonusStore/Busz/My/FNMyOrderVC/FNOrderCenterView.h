//
//  FNOrderCenterView.h
//  BonusStore
//
//  Created by sugarwhi on 16/9/5.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNOrderCenterView;//前置声明 告诉编译器有这个类 别报错

@protocol FNOrderCenterViewDelegate <NSObject>

-(void)titleView:(FNOrderCenterView *)view selectIndex:(NSInteger)index;

@end

@interface FNOrderCenterView : UIView

@property(nonatomic,strong)NSArray * titles;

@property(nonatomic,strong)NSMutableArray * buttons;

@property(nonatomic,weak)id<FNOrderCenterViewDelegate>delegate;

//选中第几个
-(void)selectIndex:(NSInteger)index;

-(void)clickButton:(UIButton*)button;

@end
