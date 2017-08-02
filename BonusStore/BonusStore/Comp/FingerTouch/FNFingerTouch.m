//
//  FNFingerTouch.m
//  BonusStore
//
//  Created by cindy on 2017/2/14.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#import "FNFingerTouch.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "FNHeader.h"
@implementation FNFingerTouch

//指纹验证的实现
+ (void)authenticateUser
{
    //初始化上下文对象，这个属性是设置指纹输入失败之后的弹出框的选项
    LAContext *context = [[LAContext alloc] init];
    //错误对象
    NSError *error = nil;
    NSString *result = @"通过Home键验证已有手机指纹";
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {//支持指纹验证
        
        //验证touchID
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，跳转到主页面
                NSLog(@"验证成功，去主页吧");
            }
            else
            {
//                //设备支持指纹解锁，但是识别指纹失败
//                //创建LAContext
//                //左边按钮的内容
//                context.localizedFallbackTitle = @"没有忘记密码";
//                context.localizedCancelTitle = @"不要取消";
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择其他验证方式，切换主线程处理
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        // 表示不支持指纹解锁
        // 界面上更改其他登录方式

        //不支持指纹识别，LOG出错误详情
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
        
    }
}
@end
