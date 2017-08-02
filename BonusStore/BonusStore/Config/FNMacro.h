//
//  YXMacro.h
//  YueXin
//
//  Created by feinno on 15/6/24.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#ifndef YueXin_YXMacro_h
#define YueXin_YXMacro_h
#define MainColor [UIColor colorWithRed:62.0/255.0 green:162.0/255.0 blue:232.0/255.0 alpha:1.0]
//### SELF Define ###
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//### NetworkReachablity Define ###
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
#define FNCallPhoneNotification @"FNCallPhoneAndAddressBook"
#define FNAddressBookNotification @"FNAddressBookNotification"

//### Color Define ###
#define UIColorWithClear [UIColor clearColor]
#define UIColorWithRGB(R,G,B) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]
#define UIColorWithRGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define UIColorWith0xRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//### Bundle Define ###
#define BUNCLE_NAME() ([[NSBundle mainBundle] pathForResource:@"FNBundle" ofType:@"bundle"])

#ifdef IS_IPHONE_6P
#define IMAGE_COMPONENT(image) ([NSString stringWithFormat:@"/images/%@@3x%@",image,IMAGE_EXTENSION_PNG])
#elif IS_IPHONE_4_OR_LESS
#define IMAGE_COMPONENT(image) ([NSString stringWithFormat:@"/images/%@%@",image,IMAGE_EXTENSION_PNG])
#else
#define IMAGE_COMPONENT(image) ([NSString stringWithFormat:@"/images/%@@2x%@",image,IMAGE_EXTENSION_PNG])
#endif
#define FILE_COMPONENT(file) ([NSString stringWithFormat:@"/files/%@",file])

#define _IMAGE_PATH(component) ([BUNCLE_NAME() stringByAppendingPathComponent:IMAGE_COMPONENT(component)])
#define IMAGE_NAME(name) ([UIImage imageWithContentsOfFile:_IMAGE_PATH(name)])

#define FILE_PATH(component) ([BUNCLE_NAME() stringByAppendingPathComponent:FILE_COMPONENT(component)])
#define FILE_NAME(name) ([NSData dataWithContentsOfFile:FILE_PATH(name)])

#define IMAGE_EXTENSION_JPG @".jpg"
#define IMAGE_EXTENSION_PNG @".png"


//### SandBox Define ###
#define SANDBOX(root) [NSHomeDirectory() stringByAppendingPathComponent:root]
#define SANDBOX_SRC(root) [SANDBOX(root) stringByAppendingPathComponent:@"src"]
#define SANDBOX_SRC_IMAGE(name) [[SANDBOX_SRC(@"Documents") stringByAppendingPathComponent:@"images"]stringByAppendingPathComponent:name]

//### NavigationBar Define ###
#define STATE_BAR_HEIGHT ((IOS_VERSION_GREATER_THAN_7)?20:0)
#define NAVIGATION_BAR_HEIGHT ((IOS_VERSION_GREATER_THAN_7)?64:44)

//### SystemVersion Deifne ###
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_VERSION_GREATER_THAN_10 ((IOS_VERSION >= 10.0) ? (YES) : (NO))
#define IOS_VERSION_GREATER_THAN_8 ((IOS_VERSION >= 8.0) ? (YES) : (NO))
#define IOS_VERSION_GREATER_THAN_7 ((IOS_VERSION >= 7.0) ? (YES) : (NO))
#define IOS_VERSION_GREATER_THAN_6 ((IOS_VERSION >= 6.0) ? (YES) : (NO))
#define IOS_VERSION_GREATER_THAN_5 ((IOS_VERSION >= 5.0) ? YES : NO)
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//### Compatible 5s - iOS 7.0-7.1 ###
#define IOS_VERSION_5S_7_0_AND_7_1    (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_0 && NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_1)
#define YX_COMPATIBLE_5S(OY) (IOS_VERSION_5S_7_0_AND_7_1 ? (NAVIGATION_BAR_HEIGHT+OY) : OY)

//### ViewFrame Define ###
#define kWindowWidth [UIApplication sharedApplication].keyWindow.frame.size.width
#define kWindowHeight [UIApplication sharedApplication].keyWindow.frame.size.height

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWindowDemiW    kAverageValue(kWindowWidth)-10
#define kWindowDemiH    kAverageValue(kWindowHeight)-10
#define kWindowWidthAVG(x) (kWindowWidth*x)

#define kView_C_X(view) (view.frame.size.width/2.0)
#define kView_C_Y(view) (view.frame.size.height/2.0)
#define kView_X(view) (view.frame.origin.x)
#define kView_W(view) (view.frame.size.width)
#define kView_Y(view) (view.frame.origin.y)
#define kView_H(view) (view.frame.size.height)
#define kView_X_W(view) (view.frame.origin.x+view.frame.size.width)
#define kView_Y_H(view) (view.frame.origin.y+view.frame.size.height)
#define kAverageValue(value) ((value)/2.0)

#define kImage_S(image) (image.size)
#define kImage_W(image) (image.size.width)
#define kImage_H(image) (image.size.height)
#define kImage_W_2(image) (kImage_W(image)/2.0)
#define kImage_H_2(image) (kImage_H(image)/2.0)

#define kFrame_X(frame) (frame.origin.x)
#define kFrame_Y(frame) (frame.origin.y)
#define kFrame_W(frame) (frame.size.width)
#define kFrame_H(frame) (frame.size.height)
#define kFrame_maxX(frame) CGRectGetMaxX(frame)
#define kFrame_maxY(frame) CGRectGetMaxY(frame)
#define kFrame_minX(frame) CGRectGetMinX(frame)
#define kFrame_minY(frame) CGRectGetMinY(frame)

//### Config Define ###
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define MAIN_SCREEN_RECT [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define COMMON_VIEW_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATE_BAR_HEIGHT)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
//基于6适配其他尺寸
#define HeightScale_IOS6(height) ((height/667.0) * kScreenHeight)
#define WidthScale_IOS6(width) ((width/375.0) * kScreenWidth)

//### UIFont Define ###
//#define UIFont(font) [UIFont systemFontOfSize:font]
//#define UIBoldFont(font) [UIFont boldSystemFontOfSize:font]

//### App Info ###
#define APP_ARGUS_NAME              [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]
#define APP_ARGUS_RELEASE_VERSION   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//#define APP_ARGUS_URL_SHARE     @"http://buy.jfshare.com/android/download.html"
#define APP_ARGUS_URL_SHARE     @"https://active.jfshare.com/android/download.html"

#define APP_ARGUS_URL_DOWNLOAD  [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@",APP_ITUNES_ID]

#define APP_ARGUS_URL_MARK      [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/ju-fen-xiang/id%@?mt=8",APP_ITUNES_ID]

#define kScale ((IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) ? 0.7 : 1)

#define kScaleH(h) ((h/667.0) * kScreenHeight)
#define kScaleW(w) ((w/375.0) * kScreenWidth)




#endif
