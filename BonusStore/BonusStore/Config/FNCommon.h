//
//  FNCommon.h
//  BonusStore
//
//  Created by Nemo on 15/12/27.
//  Copyright © 2015年 nemo. All rights reserved.
//
//
//  You can set common use type in here.

#ifndef FNCommon_h
#define FNCommon_h

typedef void (^FNNetFinish) (id result);

typedef void (^UIButtonActionBlock) (id sender);

typedef void (^FNSelectedIndex) (NSInteger index);

typedef void (^FNVoidActionBlock) (void);

typedef void (^FNSelectedItem) (id item);

typedef void (^FNRACResponse) (BOOL resp);

// Scroll view de touch event state
typedef NS_ENUM(NSUInteger, FNTouchState)
{
    FNTouchStateBegan,
    FNTouchStateMoved,
    FNTouchStateCancelled,
    FNTouchStateEnded,
};

typedef NS_ENUM(NSUInteger, FNSZStateEntry)
{
    FNSZStateEntryBalance =1,  //余额
    FNSZStateEntryRecharge  =2,   //充值
    FNSZStateEntryDetail,   // 详情
    FNSZStateEntryCheckCard   //验卡
};

typedef NS_ENUM(NSUInteger, FNSZRechargeState)
{
    FNSZRechargeStateFail  = 4 , // 充值失败
    FNSZRechargeStateUnusual =11, //订单异常
    FNSZRechargeStateOrderCancel = 5, //订单取消 
    FNSZRechargeStateSuccess = 7, //充值成功
    FNSZRechargeStatePaySuc =2, //  支付成功(待充值）
    FNSZRechargeStateRefundIn =9,  //退款中
    FNSZRechargeStateRefundDone = 10 // 订单已退款
};

typedef NS_ENUM(NSUInteger, FNSZConsumeType)
{
    FNSZConsumeTypeNone , //没有类型
    FNSZConsumeTypeSell //使用
   
};

typedef NS_ENUM(NSUInteger, FNMainConfigType)
{
    FNMainBonusInterflow =0,
    FNMainBonusRecharge,
    FNMainBonusWallet,
    FNMainDiscountCard,
    FNMainBankCardGift,
    FNMainMobileRecharge,
    FNMainFlowRecharge,
    FNMainQCoinRecharge,
    FNMainGameCard,
    FNMainGlobalFood
};

typedef NS_ENUM(NSUInteger, FNVirRechargeState)
{
    FNVirRechargeSuccess = 1,  // rechargeSuccess
    FNVirRechargefail = 11 ,  //rechargeFail
};

typedef NS_ENUM(NSUInteger, FNMessageType)
{
    FNMessageTypePlain,
    FNMessageTypeLink,
};

typedef NS_ENUM(NSUInteger, FNWebType)
{
    FNWebTypeURL,
    FNWebTypeHTMLDoc,
};

typedef NS_ENUM(NSUInteger, FNStraddleType)
{
    FNStraddleTypeNone = 0,
    FNStraddleTypeUMSocial,
    FNStraddleTypeWXPay,
    FNStraddleTypeAliPay,
    FNStraddleTypeDetail,   //product detail
    FNStraddleTypeBestPay,    //翼支付
};

typedef NS_ENUM(NSUInteger, FNFocusPageAlign)
{
    FNFocusPageAlignLeft,
    FNFocusPageAlignCenter,
    FNFocusPageAlignRight,
};

typedef NS_ENUM(NSUInteger, FNNotificationType)
{
    FNNotificationTypeSystem,
    FNNotificationTypeCampaign,
};

typedef NS_ENUM(NSUInteger, FNBatchType)
{
    FNBatchTypeBuyDirectly = 1,
    FNBatchTypeCart,
};

typedef NS_ENUM(NSUInteger, FNPayType)
{
    FNPayTypeNone = 0,
    FNPayTypeWechat = 9,
    FNPayTypeAlipay = 7,
    FNPayTypeHebao = 6,
    FNPayTypeCMB = 11,
    FNPayTypeWing = 13,
};
//0:无 4,微信H5  5：支付宝H5  6：和包H5

typedef NS_ENUM(NSInteger, FNOrderState)
{
    FNOrderStateDefault         =   0,          //default order state
    FNOrderStateReturning       =   1,          //returning product
    FNOrderStateReturned        =   2,          //returned product
    FNOrderStateReturnFailed    =   3,          //return product fail
    FNOrderStatePaying          =   10,         //wait to pay
    FNOrderStateShipping        =   30,         //wait to ship
    FNOrderStateReceiving       =   40,         //wait to receive
    FNOrderStateFinish          =   50,         //finished commented
    FNOrderStateFinishCommenting=   51,         //finished commenting
    FNOrderStateAutoClosed      =   60,         //auto closed
    FNOrderStateManageCanceled  =   61,         //manage canceled
    FNOrderStateCanceled        =   62,         //buyer canceled
    FNOrderStateAfterSale       =   70,         //returned product ＝＝ FNOrderStateReturned；Only use notification to show vc currently，
    FNOrderStateBonus           =   80,         //bonus state change notification type
    FNOrderStateAll             =   -1,
};
//orderState: int, 	//订单状态: 10:待支付  30:待发货 40:已发货|待收货 50:待评价 51:已评价 60:交易自动关闭 61:管理员取消  62:交易买家取消

////1：退货中2：退货成功 3：退货失败 99：已完成
//typedef NS_ENUM(NSUInteger, FNOrderReturnType)
//{
//};

//订单状态: 10:待支付 11:支付中 20:审核中 30:待发货 40:已发货|待收货 50:待评价 51:已评价 60:交易自动关闭 61:交易买家取消

typedef NS_ENUM(NSUInteger, FNSortType)
{
    FNSortTypeTimeDesc = 1,     //create_time DESC:按创建时间降序
    FNSortTypeClickDesc,        //click_rate DESC:按点击量降序
    FNSortTypePriceDesc,        //cur_price DESC:按现价降序
    FNSortTypePriceAsc,         //cur_price ASC:按现价升序
};

//clienttype 的分配为android 1，ios 2，H5 2，web4
typedef NS_ENUM(NSUInteger, FNClientType)
{
    FNClientTypeAndroid = 1,
    FNClientTypeiOS,
    FNClientTypeH5,
    FNClientTypeWeb,
};

typedef NS_ENUM(NSUInteger, FNAPPType)
{
    FNAPPTypeAndroidBuyer = 1,          //
    FNAPPTypeAndroidSeller,             //
    FNAPPTypeiOS,                       //app
};

///*订单来源 聚分享pc=1,聚分享Android=2，聚分享ios=3，聚分享H5=4，百分尊享PC=5，百分尊享H5=6*/
typedef NS_ENUM(NSUInteger, FNSourceType)
{
    FNSourceTypeWeb = 1,        //主站
    FNSourceTypeAndroid,
    FNSourceTypeiOS,
    FNSourceTypeH5,
    FNSourceTypeBFZXPC,
    FNSourceTypeBFZXH5,
};

typedef NS_ENUM(NSUInteger, FNFocusListType)
{
    FNFocusListTypePC = 1,
    FNFocusListTypeApp,
};

typedef NS_ENUM(NSUInteger, FNUserType)
{
    FNUserTypeBuyer = 1,    //buyer
    FNUserTypeSeller,       //seller
    FNUserTypeSystem,       //system
};

typedef NS_ENUM(NSUInteger, FNProductType)
{
    FNProductTypeCash = 1,  //1:积分现金够的商品
    FNProductTypeNormal,    //2:普通商品
    FNProductTypeVirtual,   //3:虚拟商品
};

typedef NS_ENUM(NSUInteger, FNBonusType)
{
    FNBonusTypeAll = 0,
    FNBonusTypeToApp = 1,           //1:电信积分兑入
    FNBonusTypeToTele = 2 ,             //2兑换电信积分
    FNBonusTypeOffLine = 3,             //3线下消费
    FNBonusTypeOnLine = 4,              //4线上消费
    FNBonusTypeConsumptionSend = 5, //消费赠送
    FNBonusTypeActivitySend = 6,       //活动赠送
    FNBonusTypePay = 7,                 //返还支付积分
    FNBonusTypeMinus = 8,               //扣减赠送积分
    FNBonusTypeRecharge = 9,            //积分充值
    FNBonusTypeRedGift  =10,            //积分红包活动
    FNBonusTypeRegisteredGift  =11,     // 第三方注册赠送
    FNBonusTypeTrirdSend = 12 ,         // 第三方消费抵扣
    FNBonusTypeAutoReturn =13,          // 自动返还第三方抵扣积分
    FNBonusTypeManualReturn =14,      //手动返还第三方抵扣积分
    FNBonusTypeAfterReturn = 15,   //订单售后退积分
    FNBonusTypeConsumptionDeduction = 99, //消费抵扣
};

typedef NS_ENUM(NSUInteger, FNBonusTime)
{
    FNBonusTimeAll,
    FNBonusTimeDay,
    FNBonusTimeTriduum,     //3days
    FNBonusTimeWeek,
    FNBonusMonth,
    FNBonusTrimester,       //3months
};
//@"全部",@"最近一天",@"最近三天",@"最近一周",@"最近一个月",@"最近三个月"],

typedef NS_ENUM(NSUInteger, FNBonusIncomeType)
{
    FNBonusIncomeTypeAll = 0,
    FNBonusIncomeTypeIn,
    FNBonusIncomeTypeOut,
};

typedef NS_ENUM(NSUInteger, FNMsgType)
{
    FNMsgTypeAll = 0,
    FNMsgTypeMain,          //主站
    FNMsgTypeAllApp,        //全部app
    FNMsgTypeAndroidBuyer,
    FNMsgTypeAndroidSeller,
    FNMsgTypeiOS,
};

typedef NS_ENUM(NSUInteger, FNTradeCode)
{
    FNTradeCodeBonus = 1,       //Z0001:积分兑换类
    FNTradeCodeVirtualHuafei,   //Z0002:虚拟商品-话费充值
    FNtradeCodeEntity,          //Z0003:实体宝贝交易
    FNTradeCodeCOD,             //Z0004:货到付款
    FNTradeCodeBonusCash,       //Z0005:积分现金购
    FNTradeCodeRedEnvelope,     //Z0006:天天红包
    FNTradeCodeWechatNewYear,   //Z0008:微信春节卡券项目
    FNTradeCodeOneRob,          //Z9001:一元抢
    FNTradeCodeTimeRob,         //Z9002:限时抢
    FNTradeCodeBuyMinus,        //Z9003:拍下立减
    FNTradeCodeVirtualCard,     //Z8001:虚拟商品-卡密
    FNTradeCodeVirtualSN,       //Z8002:虚拟商品-密码（兑换码）
    
};
// tradeCode

typedef NS_ENUM(NSUInteger, FNShareType)
{
    FNShareTypeWechat = 1,
};

typedef NS_ENUM(NSUInteger, FNNoDataType)
{
    FNNoDataTypeError,
    FNNoDataTypeEmpty,
};



typedef NS_ENUM(NSUInteger,FNBonusRechargeFailType)
{
    FNBonusFailTypeCardExpired,         //过期
    FNBonusFailTypeRechargeOnlyOne,     //仅充一次
    FNBonusFailTypeCardInvalid,         //卡无效
    FNBonusFailTypeCardUsed,            //卡已使用
    FNBonusFailTypeCardNumOrPassFail,   //卡号或密码错误

} ;

typedef NS_ENUM(NSUInteger, FNPayChannel) // 订单详情页面，查询支付方式
{
    FNPayChannelAllBonus = 0 ,    // 全是积分支付
    FNPayChannelTianYiApp = 1,    //天翼积分
    FNPayChannelAlipay =2 ,     // 支付宝
    FNPayChannelWeiXinpay =3,  // 微信
    FNPayChannelWeiXinWap =4,  //微信H5
    FNPayChannelAliwap=5,   // 支付宝H5
    FNPayChannelHeBaogzwap=6,  //  和包广州H5
    FNPayChannelAliApp=7,    // 支付宝app
    FNPayChannelHeBaoPay =8,  // 和包pc
    FNPayChannelWeiXinApp=9 ,  // 微信app
    FNPayChannelTianYiWap = 10,   // 天翼H5
    FNPayChannelCMB = 11,       //招商银行
    FNPayChannelBestPayH5 = 12,    // 翼支付
    FNPayChannelBestPayAPP =13 ,
    FNPayChannelBestPayPC = 14,
};
typedef NS_ENUM (NSUInteger, FNTitleType){//订单中心－头部订单名称
    FNTitleTypeOrderStateAll=0,
    FNTitleTypeOrderStatePaying=1,
    FNTitleTypeOrderStateShipping,
    FNTitleTypeOrderStateReceiving,
    FNTitleTypeOrderStateFinish,
    FNTitleTypeOrderStateAfterSale,
};
typedef NS_ENUM(NSUInteger, FNSearchSortType)
{
    FNSearchSortTypeTimeDesc = 1,     //create_time DESC:按创建时间降序
    FNSearchSortTypePriceDesc,        //cur_price DESC:按现价降序
    FNSearchSortTypePriceAsc,         //cur_price ASC:按现价升序
    FNSearchSortTypeClickDesc,        //click_rate DESC:按点击量降序

};
typedef NS_ENUM(NSUInteger, FNMainModelOfAdvertIdType)
{
    FNMainModelOfAdvertIdTypeOfFocus = 5, //首页 模块配置 adverId=5  轮播图
    FNMainModelOfAdvertIdTypeOfProduct = 6, //首页 模块配置 adverId=6  6个商品(品牌)配置区
    FNMainModelOfAdvertIdTypeOfImage = 7, //首页 模块配置 adverId=7  1个图片广告区
    FNMainModelOfAdvertIdTypeOfCash = 8, //首页 模块配置 adverId=8  3个兑换区
};

typedef NS_ENUM(NSUInteger, FNMainSearchOfModuleIdType)
{
    FNMainSearchOfModuleIdTypeOfProduct = 4, //模块配置 ModuleId=4  热门搜索
    FNMainSearchOfModuleIdTypeOfSearch = 6, //首页 模块配置 ModuleId=6  首页底部商品模块配置区
};

#endif /* FNCommon_h */
