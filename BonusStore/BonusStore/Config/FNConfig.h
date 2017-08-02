//
//  FNConfig.h
//  BonusStore
//
//  Created by Nemo on 15/12/24.
//  Copyright © 2015年 nemo. All rights reserved.
//

#ifndef FNConfig_h
#define FNConfig_h

#if TARGET_DEV
static NSString *URL_BASE               =   @"http://120.24.153.102";
#else
static NSString *URL_BASE               =   @"http://proxy.jfshare.com";
#endif

//JPush 环境
#ifdef TARGET_DEV
static BOOL const FN_JPUSH_DIS = NO;
#else
static BOOL const FN_JPUSH_DIS = YES;
#endif

static NSString *URL_SHARE_DETAIL       =   @"http://h5.jfshare.com/h5-hybrid/html/data-detail.html?productId=";

static NSString *URL_PRODUCT_DETAIL     =   @"http://h5.jfshare.com/h5-hybrid/html/product-detail.html?productId=";

#if TARGET_DEV
static NSString *URL_IMAGE_BASE         =   @":3000/system/v1/jfs_image";
#else
static NSString *URL_IMAGE_BASE         =   @"/system/v1/jfs_image";
#endif
static NSString *URL_WECHAT_BASE        =   @"http://api.weixin.qq.com/sns";

static NSString *URL_PATCH_CONFIG       =   @"http://testactive.jfshare.com/iOS/patches/jfshare/patchConfig?123";

static NSString *URL_PATCH_ME           =   @"http://testactive.jfshare.com/iOS/patches/jfshare/patch.me?123";

#if TARGET_DEV
static NSString *APP_ARGUS_ID           =   @"com.jfshare.bonusDev";
#else
static NSString *APP_ARGUS_ID           =   @"com.jfshare.bonus";
#endif

static NSString *APP_ARGUS_VERSION      =   @"2.6.6.0512";       //与服务器交互的版本号，另外一个是App Store版本号

static NSString *APP_ITUNES_ID          =   @"1118852908";

static NSString *FONT_NAME_ARIAL        =   @"Arial";

static NSString *FONT_NAME_ARIAL_BOLD   =   @"Arial-Blod";

static NSString *FONT_NAME_LTH          =   @"FZLTH_YS_GB2312";

static NSString *FONT_NAME_LTH_BOLD     =   @"FZLanTingHei-M-GBK";

static NSInteger MAIN_REFRESH_OFFSET    =   45;

static NSInteger MAIN_PER_PAGE          =   10;

static NSInteger MAIN_TOKEN_FPS         =   25*60;

static NSString *FN_CHANNEL_ID          =   @"App Store";

#define MAIN_BACKGROUND_COLOR           UIColorWith0xRGB(0xebebeb)

#define MAIN_COLOR_SEPARATE             UIColorWith0xRGB(0xdedede)

#define MAIN_COLOR_ORIGIN               UIColorWith0xRGB(0xff801a)

#define MAIN_COLOR_RED_ALPHA            UIColorWith0xRGB(0xe30303)

#define MAIN_COLOR_RED_BUTTON           [UIColor redColor]

#define MAIN_COLOR_GRAY_ALPHA           UIColorWith0xRGB(0xa7aaa6)

#define MAIN_COLOR_BLACK_ALPHA          UIColorWith0xRGB(0x1e1e1e)

#define MAIN_COLOR_WHITE                UIColorWith0xRGB(0xffffff)

static NSString *FN_UMENG_KEY              =    @"571dc966e0f55a05e70009f4";

static NSString *FN_UMENG_SECRET           =    @"";

static NSString *FN_WECHAT_ID              =    @"wx4ee9e61ac3632537";

static NSString *FN_WECHAT_SECRET          =    @"b2f0a8eebceac6e6eaa01d3807dae14b";

static NSString *FN_MERCHANT_ID            =    @"1330572901";

static NSString *FN_PARTNER_ID             =    @"1330572901";

static NSString *FN_SINA_KEY               =    @"";

static NSString *FN_SINA_SECRET            =    @"";

static NSString *FN_QQ_ID                  =    @"";

static NSString *FN_QQ_KEY                 =    @"";

static NSString *FN_SOBOT_ID               =    @"3f8ca3d3c87c45949ee9d5d7fe04aa12";

static NSString *FN_JPUSH_KEY              =    @"ad0a39eae9f5b0e699bb40db";

static NSString *FN_BAIDU_UBS_KEY          =    @"c9B3ILxHfev8RbzNtq0YvwuGRF2TVGyZ";

static NSString *FN_JSPATCH_KEY            =    @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPMgr9tA/a2CAfwrrtXQxWHCbCqoWADHPdaTUm4Dzm51D6fP+NGpNLYsJuU17/Ynf3rqs1UX678mHBchRWQvZev3K+rPUxsFX6ch/5VVozBYXfAdo2KtIdc0agD9a3KT2GiaEWsRoVvlvPvoikABk8hSURtgdqIDqDc43WXWRDIwIDAQAB";//这个key是通过RSA方式生成的的公钥

#endif /* FNConfig_h */
