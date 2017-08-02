//
//  FNNameVC.m
//  BonusStore
//
//  Created by sugarwhi on 16/4/23.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNNameVC.h"

#import "UIView+Toast.h"

#import "FNMyBO.h"

@interface FNNameVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * prompt;

@end

@implementation FNNameVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(determine)];
    [item setTintColor:[UIColor blackColor]];
    
    [self.navigationItem setRightBarButtonItem:item];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"修改昵称";
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    [self nameText];
    
    [self prompt];
    
    [self setNavigaitionBackItem];
    
    _model = [[FNPersonalModel alloc]init];
}

- (UITextField *)nameText
{
    if (_nameText == nil)
    {
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 10, 30)];
        
        _nameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        
        _nameText.leftView = paddingView1;
        
        _nameText.delegate = self;
        
        _nameText.placeholder = _name;
        
        _nameText.leftViewMode = UITextFieldViewModeAlways;
        
        _nameText.font = [UIFont fontWithName:FONT_NAME_LTH size:15];
        
        _nameText.backgroundColor = MAIN_COLOR_WHITE;
        
        _nameText.borderStyle = UITextBorderStyleNone;
        
        _nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [self.view addSubview:_nameText];
    }
    return _nameText;
}

- (UILabel *)prompt
{
    if (_prompt == nil)
    {
        _prompt = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 30)];
        
        _prompt.font = [UIFont fontWithName:FONT_NAME_LTH size:12];
        
        _prompt.textColor = [UIColor colorWithRed:150.0/255 green:156.0/255 blue:150.0/255 alpha:1];
        
        _prompt.text = @"   4-20个字符,可由中英文、数字、\"_\"、\"-\"组成";
        
        [self.view addSubview:_prompt];
    }
    return _prompt;
}

- (void)determine
{
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9-]+$";
    
    NSPredicate *name = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (_nameText.text.length < 4 || _nameText.text.length > 20 )
    {
        [self.view makeToast:@"请输4-20个字符有效字符,昵称只能由中英文、数字、\"_\"\"-\""];
    }
    else if ([name evaluateWithObject:_nameText.text])
    {
        _nameText.text = [_nameText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        _model.userName = _nameText.text;
        
        _nameBlock(_model);
        
        FNPersonalModel * _personalModel = [[FNPersonalModel alloc]init];
        
        _personalModel.userName = _nameText.text;
        
        [FNLoadingView showInView:self.view];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [FNLoadingView hideFromView:self.view];
            
            [[FNMyBO port02] updateUser:_personalModel block:^(id result) {
                
                if ([result[@"code"] integerValue] != 200)
                {
                    if(result)
                    {
                        [UIAlertView alertViewWithMessage:result[@"desc"]];
                    }else
                    {
                        [self.view makeToast:@"加载失败,请重试"];
                    }
                    
                    return ;
                }
                else
                {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"userName" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_personalModel.userName,@"userName", nil]];
                }
            }];
            
        });
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [UIAlertView alertViewWithMessage:@"请输入4-20个有效字符"];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger num = textField.text.length+string.length;
    
    if (textField == _nameText && num > 20 && ![NSString isEmptyString:string])
    {
        [UIAlertView alertViewWithMessage:@"请输入少于20个有效字符"];

        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
