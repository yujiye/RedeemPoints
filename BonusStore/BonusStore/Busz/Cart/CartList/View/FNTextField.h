//
//  FNTextField.h
//  BonusStore
//
//  Created by qingPing on 16/4/15.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FNTextField;
@protocol FNTextFieldDelegate <NSObject>

@optional

// 键盘 完成取消点击 代理 flag=0 取消 flag=1 完成
-(void)toolbarBtnClick:(FNTextField *)textField flag:(NSInteger)flag;

@end

@interface FNTextField : UITextField

@property (nonatomic, assign) BOOL isToolBar;

@property (nonatomic, assign) CGFloat placeholderFont;

@property (nonatomic, assign) CGFloat isSanPayVC;


@property(nonatomic,weak)id<FNTextFieldDelegate,UITextFieldDelegate>textFieldDelegate;

@end
