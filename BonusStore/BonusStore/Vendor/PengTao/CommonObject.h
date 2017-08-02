//
//  CommonObject.h
//  CommonProject
//
//  Created by jiayi on 14-6-11.
//  Copyright (c) 2014年 jiayi. All rights reserved.
//

//------- 第三方平台分享类型 -------
typedef enum{
    ThirdShareWeiXinFriend = 0,      //微信好友
    ThirdShareWeiXinCommunity,       //微信朋友圈
    ThirdShareSinaWeiBo,             //新浪微博
    ThirdShareQQApp,                 //QQ好友
    ThirdShareTencentWeiBo,          //腾讯微博
    ThirdShareRenRenWeb,             //人人网
    ThirdShareMessage,               //短信
    ThirdShareEmail,                 //邮件
    ThirdShareLocalAlbum,            //保存本地相册
    ThirdShareShareNone
}ThirdPlatformShareType;


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


//typedef enum{
//    CardType_PUKA = 1,
//    CardType_LIANTONG = 5,
//    CardType_XINGYE = 15,
//    CardType_BUDAN = 22,
//    CardType_12308 = 20,
//    CardType_KFOpenCard = 2,
//    CardType_StarWrist = 19,
//    CardType_Unkown = 0,
//    
//}CardType;

#pragma mark - BaseObject
/**
 *  基础对象 （实现copy协议，可以归档）
 */
@interface BaseObject : NSObject
@property (nonatomic,strong)NSString *ID;           //ID
@property (nonatomic,strong)NSString *code;         //代码
@property (nonatomic,strong)NSString *type;         //类型
@property (nonatomic,strong)NSString *name;         //名字
@property (nonatomic,strong)NSString *title;        //标题
@property (nonatomic,strong)NSString *content;      //内容
@property (nonatomic,strong)NSString *descriptions; //描述
@property (nonatomic,strong)NSString *note;         //备注
@property (nonatomic,strong)NSString *url;          //连接
@property (nonatomic,strong)NSString *tag;          //标记

+ (NSString *)getJSONString:(BaseObject*)object;

@end

#pragma mark - CommonObject
/**
 *  通用对象
 */
@interface CommonObject : BaseObject
@property (nonatomic,strong)NSString *sex;              //性别
@property (nonatomic,strong)NSString *organization;     //组织
@property (nonatomic,strong)NSString *mobile;           //移动电话
@property (nonatomic,strong)NSString *iconUrl;          //iocn
@property (nonatomic,strong)NSString *imageName;        //image名字
@property (nonatomic,strong)NSString *imageUrl;         //image地址
@property (nonatomic,strong)NSArray  *imageUrlArray;    //imageUrl数组
@property (nonatomic,strong)NSString *HTML;             //Html内容
@property (nonatomic,strong)NSString *webURL;           //网页链接
@property (nonatomic,strong)NSString *shareTitle;       //分享标题
@property (nonatomic,strong)NSString *shareURL;         //分享链接
@property (nonatomic,strong)NSString *password;         //密码
@property (nonatomic,strong)NSString *email;            //邮箱
@property (nonatomic,assign)NSInteger index;            //序号
@property (nonatomic,assign)NSInteger section;          //sectionNumber
@property (nonatomic,assign)BOOL      isSelected;       //是否选中
@property (nonatomic,strong)NSString *updateTime;       //更新时间
@property (nonatomic,strong)NSString *releaseTime;      //发布时间
@property (nonatomic,strong)NSString *date;             //日期
@property (nonatomic,strong)NSString *status;           //状态
/** status
 * UNPAID 未支付
 * PAYING 支付中，点了支付，最后却没有付款
 * PAID 已支付
 * LANDLORDCANCEL 房东取消
 * TENANTCANCEL 房客取消
 * REJECTED 房东拒绝
 * WAITTING 等待，暂时不处理
 * ACCEPTED 已接受
 * COMPLETED 已完成
 **/

//shop
@property (nonatomic,strong)NSString *price;            //价格

//分享
@property (nonatomic,assign)ThirdPlatformShareType shareType;   //分享类型

//定位
@property (nonatomic,strong)NSString *address;          //地址
@property (nonatomic,strong)NSString *longitude;        //经度
@property (nonatomic,strong)NSString *latitude;         //纬度

//网络加载
@property (nonatomic,assign)BOOL    needUpdate;         //是否需要更新
@property (nonatomic,assign)BOOL    needSave;           //是否需要保存
@property (nonatomic,assign)BOOL    isEdit;             //是否修改过
@property (nonatomic,assign)BOOL    isOpenBluetooth;    //是否加载蓝牙界面
@property (nonatomic,assign)BOOL    isOpenCardOperation;    //是否加载充值界面

@property (nonatomic,assign)BOOL    isLoaded;           //是否加载完成
@property (nonatomic,assign)NSInteger pageIndex;        //分页
@property (nonatomic,assign)NSInteger page;             //分页
@property (nonatomic,assign)BOOL    andMore;            //是否加载更多


//扩展
@property (nonatomic,copy)  Class           className;      //对象名
@property (nonatomic,strong)CommonObject    *subObject;     //子对象
@property (nonatomic,strong)NSArray         *subArray;      //数组扩展
@property (nonatomic,strong)NSMutableArray  *objectArray;   //可变数组扩展
@property (nonatomic,strong)id               vcObject;      //控制器对象
@property (nonatomic,strong)NSMutableArray  *displayViewArray;      //显示的试图数组
@property (nonatomic,strong)id               displayItem;           //显示的其他控件
@property (nonatomic,strong)NSData           *data;           //显示的其他控件

@end


#pragma mark - RequestResult
/*
@interface RequestResult1 : NSObject

//Info
@property(nonatomic,assign)NSInteger         status;            // -1、失败   0、成功
@property(nonatomic,strong)NSString         *code;              //返回代码
@property(nonatomic,strong)NSString         *message;           //返回消息
@property(nonatomic,strong)NSString         *reachEnd;          //是否取完数据（分页请求时 0、未取完 1、已取完）

//Data
@property(nonatomic,strong)NSArray          *results;           //Data数组
@property(nonatomic,strong)NSDictionary     *resultInfo;        //Data字典
@property(nonatomic,strong)NSString         *resultString;      //Data字符串
@property(nonatomic,strong)NSString         *timestamp;         //时间戳标示
@property(nonatomic,strong)NSString         *token;             //token

@end
 */

#pragma mark - UserInfo
@interface UserInfo : NSObject

//Archive
@property(strong,nonatomic)NSString         *state;
@property(nonatomic,strong)NSString         *ID;      //用户ID
@property(nonatomic,strong)NSString         *token;         //token
@property(nonatomic,strong)NSString         *openId;         //openId
@property(nonatomic,strong)NSString         *ptopenId;         //openId
@property(nonatomic,strong)NSString         *account;       //用户账号
@property(nonatomic,strong)NSString         *password;      //用户密码
@property(nonatomic,strong)NSString         *isLogin;       //是否登陆   "0"未登录   "1"已登录   "2"匿名登录
@property(strong,nonatomic) NSString        *createDate;
@property(strong,nonatomic) NSString        *updateDate;
@property(strong,nonatomic) NSString         *unionId;
//账号信息(acc)
@property(strong,nonatomic) NSString        *merchantCode;
@property(strong,nonatomic) NSString        *payPwd;
@property(strong,nonatomic) NSString        *crtfctNo;
@property(strong,nonatomic) NSString        *crtfctType;
@property(strong,nonatomic) NSString        *memberId;
@property(strong,nonatomic) NSString        *loginPwd;

//用户信息(tnt)
@property(nonatomic,strong) NSString         *nickName;      //昵称
@property(strong,nonatomic) NSString         *age;
@property(strong,nonatomic) NSString         *vocation;
@property(strong,nonatomic) NSString         *gender;         //性别
@property(nonatomic,strong) NSString         *phoneNo;
@property(nonatomic,strong) NSString         *profileImg;
@property(nonatomic,strong) NSString         *headImageUrl;
@property(nonatomic,strong) NSString         *weixinNo;


//
//@property(nonatomic,strong)NSString         *lastName;
//@property(nonatomic,strong)NSString         *firstName;
//@property(nonatomic,strong)NSString         *signature;
//@property(nonatomic,strong)NSString         *sex;           //性别  MALE,FEMALE,NOTSPECIFIED
//@property(nonatomic,strong)NSString         *skulName;
//@property(nonatomic,strong)NSString         *ocupId;
//@property(nonatomic,strong)NSString         *ocupName;
//@property(nonatomic,strong)NSString         *birthday;
//@property(nonatomic,strong)NSString         *descriptions;
//@property(nonatomic,strong)NSString         *qualifiedId;
//@property(nonatomic,strong)NSString         *qualifiedPhoneNo;
//@property(nonatomic,strong)NSString         *qualifiedPicture;
//@property(nonatomic,strong)NSString         *qualifiedEmail;
//@property(nonatomic,strong)NSString         *headImageUrl;


+ (UserInfo *)parseObject:(UserInfo *)object from:(id)source cover:(BOOL)cover;
+ (NSString *)getJSONString:(UserInfo *)object;
+ (UserInfo *)parseObject:(UserInfo *)object from:(id)source;

@end

#pragma mark - ProjectObject

#pragma mark ---- SourceObject 九宫格对象 ----
@interface SourceObject : CommonObject
@property (nonatomic, strong) NSString *imageResString;
@property (nonatomic, retain) NSString * menuId;
@property (nonatomic, retain) NSString * isHot;
@property (nonatomic, retain) NSString * clickType;
@property (nonatomic, retain) NSString * menuDesc;
@property (nonatomic, retain) NSString * menuClickUrl;
@property (nonatomic, retain) NSString * menuFontColor;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSString * isLogin;
@property (nonatomic, retain) NSString * menuIconTagUrl;
@property (nonatomic, retain) NSString * menuClickType;
@property (nonatomic, retain) NSString * isToken;
@property (nonatomic, retain) NSString * menuName;
@property (nonatomic, retain) NSString * isOpenId;
@property (nonatomic, retain) NSString * isIos;
@property (nonatomic, retain) NSString * updateDate;
@property (nonatomic, retain) NSString * menuIosUrl;
@property (nonatomic, retain) NSString * menuIconUrl;
+ (SourceObject *)parseObject:(SourceObject *)object from:(id)source cover:(BOOL)cover;

@end

#pragma mark - AddressObject
@interface AddressObject : CommonObject

@property(nonatomic,strong) NSString * zipcode;
@property(nonatomic,strong) NSString * addressId;
@property(nonatomic,strong) NSString * memberId;
@property(nonatomic,strong) NSString * flag;

//抬头
@property(nonatomic,strong) NSString * taxName;
@property(nonatomic,strong) NSString * taxNo;
@property(nonatomic,strong) NSString * phoneNo;
@property(nonatomic,strong) NSString * bankName;
@property(nonatomic,strong) NSString * bankNo;
@property(nonatomic,strong) NSString * deflaut;
@property(nonatomic,strong) NSString * zbankName;

+ (AddressObject *)parseObject:(AddressObject *)object from:(id)source cover:(BOOL)cover;
@end

#pragma mark - NotifObject
@interface NotifObject : NSObject
@property(nonatomic,strong)NSString         *ID;            //ID
@property(nonatomic,strong)NSString         *type;          //类型
@property(nonatomic,strong)NSString         *title;         //标题
@property(nonatomic,strong)NSString         *content;       //内容
@property(nonatomic,strong)NSString         *action;        //动作
@property(nonatomic,strong)id                object;        //对象
@end


#pragma mark ---- CalendarObject 日历对象 ----
@class OrderObject;
@interface CalendarObject : CommonObject
@property(nonatomic, assign)int     year;           //年
@property(nonatomic, assign)int     month;          //月
@property(nonatomic, assign)int     day;            //日

//状态
@property(nonatomic, assign)BOOL    isBooked;       //是否被预定
@property(nonatomic, assign)BOOL    isOptional;     //是否临时可选
@property(nonatomic, assign)BOOL    isNotoptional;  //是否不可选
@property(nonatomic, assign)BOOL    isUnavailable;  //是否不可用
@property(nonatomic, assign)BOOL    isOverdue;      //是否过期
@property(nonatomic, assign)int     statusTag;      //状态标记   0.普通  1.开始  2.离开
@property(nonatomic, strong)OrderObject*     orderObject;    //订单
@property(nonatomic, assign)NSInteger     orderStatus;      //形状标记   1.对半头  2.圆角头  3.圆角尾 4.长方形 0.无
@property(nonatomic, assign)NSInteger     orderColor1;      //颜色标记   1.蓝色  2.红色  3.灰色  0.无
@property(nonatomic, assign)NSInteger     orderColor2;      //颜色标记   1.蓝色  2.红色  3.灰色  0.无
- (id)initWith:(NSDate *)date;

- (NSComparisonResult)compareWithOtherDay:(CalendarObject *)day;

- (NSString *)getTimestamp;

@end


#pragma mark ---- OrderObject 订单对象 ----
@interface OrderObject : CommonObject
@property(nonatomic,strong) NSString * orderNo;//订单号
@property(nonatomic,strong) NSString * userMobile;//手机号
@property(nonatomic,strong) NSString * orderTime;//订单生成时间
@property(nonatomic,strong) NSString * transTime;//订单生成时间
@property(nonatomic,strong) NSString * orderSourceName;
@property(nonatomic,strong) NSString * orderMoney;//订单金额
@property(nonatomic,strong) NSString * orderStatus;//订单状态
@property(nonatomic,strong) NSString * orderSource;//订单支付方式  1:支付宝 2:微信 5:翼支付
@property(nonatomic,strong) NSString * orderType;//订单类型
//@property(nonatomic,strong) NSString * updateTime;//订单更新时间
@property(nonatomic,strong) NSString * remark;//备注
@property(nonatomic,strong) NSString * auditTime;
@property(nonatomic,strong) NSString * auditUserId;
@property(nonatomic,strong) NSString * memberId;
@property(nonatomic,strong) NSString* mac;
@property(nonatomic,strong) NSString* rechargeSystem;
@property(nonatomic,strong) NSString* rechargeSystemVersion;
@property(nonatomic,strong) NSString* sid;
@property(nonatomic,strong) NSString* sysBrand;//系统版本
@property(nonatomic,strong) NSString* thirdparty;//第三方支付方式
@property(nonatomic,strong) NSString* goodsNo;//商品好
@property(nonatomic,strong) NSString* settleStatus;
@property(nonatomic,strong) NSString* appVersion;//应用版本
@property(nonatomic,strong) NSString* payType;//支付方式
@property(nonatomic,strong) NSString* cardCode;
@property(nonatomic,strong) NSString* isThirdparty;//是否使用第三方支付
@property(nonatomic,strong) NSString* voucherId;//优惠券ID
@property(nonatomic,strong) NSString* accountPayMoney;//账户支付余额
@property(nonatomic,strong) NSString* rechargeCardSeq;
@property(nonatomic,strong) NSString* transNo;//支付流水号
@property(nonatomic,strong) NSString* settleTime;
@property(nonatomic,strong) NSString* rows;
@property(nonatomic,strong) NSString* voucherMoney;//优惠券金额
@property(nonatomic,strong) NSString* sztCardNo;//深圳通卡号
@property(nonatomic,strong) NSString* recargeCardType;//充值卡类型
//@property(nonatomic,strong) NSString* mobile;//当前登录用户
@property(nonatomic,strong) NSString* rechargeMobile;//充值手机号
@property(nonatomic,strong) NSString* cardType;
@property(nonatomic,strong) NSString* isVoucherPay;
@property(nonatomic,strong) NSString* token;
@property(nonatomic,strong) NSString* beginDate;//日期
@property(nonatomic,strong) NSString* thirdpartyMoney;//第三方支付金额
@property(nonatomic,strong) NSString* rechargeTime;//充值时间
@property(nonatomic,strong) NSString* endDate;
@property(nonatomic,strong) NSString* isAccountPay;//是否账户余额充值
@property(nonatomic,strong) NSString * outOrderNo;//外部订单
@property(nonatomic,strong) NSString * orderDetailUrl;//微商城订单
@property(nonatomic,strong) NSString *payMoney;
@property(nonatomic,strong) NSString *orderStatusName;
@property(nonatomic,strong) NSString *orderIsRefund;
@property(nonatomic,strong)NSString                 *detailUrl;
//退款
@property(nonatomic,strong) NSString * backBank;
@property(nonatomic,strong) NSString * cardMoney;
@property(nonatomic,strong) NSString * cardNo;
@property(nonatomic,strong) NSString * accountNo;
@property(nonatomic,strong) NSString * accountName;
@property(nonatomic,strong) NSString * accountOpenBankNo;
@property(nonatomic,strong) NSString * auditStatus;
@property(nonatomic,strong) NSString *  orderTypeName;

@property(nonatomic,strong) NSString * memberPhone;

@property(nonatomic,strong) NSString *  spid;

@property(nonatomic,strong) NSString * seType;
@property(nonatomic,strong) NSString * appletVersion;
@property(nonatomic,strong) NSString * lineName;



+ (OrderObject *)parseObject:(OrderObject *)object from:(id)source cover:(BOOL)cover;

@end

#pragma mark ---- PreorderObject 订单初始化对象 ----
@interface PreorderObject : CommonObject
@property(nonatomic,strong)NSMutableArray         *couponList;        //
@property(nonatomic,strong)NSString                 *accountMoney;
@property(nonatomic,strong)NSString                 *unicomOTAActive;
@property(nonatomic,strong)NSString                 *payMoney;
@property(nonatomic,strong)NSString                 *rechargeMoney;
@property(nonatomic,strong)NSString                 *activeId;


+ (PreorderObject *)parseObject:(PreorderObject *)object from:(id)source cover:(BOOL)cover;

@end

#pragma mark ---- Coupon 优惠券对象 ----
@interface Coupon : CommonObject
/**
 * 优惠券ID
 */
@property(nonatomic,strong)NSString     *couponId;

/**
 * 优惠券名称
 */
@property(nonatomic,strong)NSString     *couponName;
/**
 * 合作方券ID
 */
@property(nonatomic,strong)NSString     *voucherId;
/**
 * 优惠券描述
 */
@property(nonatomic,strong)NSString     *couponDesc;

/**
 * 优惠券类型：1. 现金抵用券 2,联通 SWP 3电信SWP 4联通OTA 5电信OTA
 */
@property(nonatomic,strong)NSString     * couponType;

/**
 * 商户ID（关联商户信息表）
 */
@property(nonatomic,strong)NSString     * merchantId;

/**
 * 发行数量
 */
@property(nonatomic,strong)NSString     * issueNum;

/**
 * 单张券金额
 */
@property(nonatomic,strong)NSString     * issueAmt;

/**
 * 状态 0：可用 1：失效
 */
//@property(nonatomic,strong)NSString     * state;

/**
 * 有效开始时间
 */
@property(nonatomic,strong)NSString     * beginDate;

/**
 * 有效结束时间
 */
@property(nonatomic,strong)NSString     * endDate;

/**
 * 创建人
 */
@property(nonatomic,strong)NSString     * creater;

/**
 * 图片
 */
@property(nonatomic,strong)NSString     * img;



+ (Coupon *)parseObject:(Coupon *)object from:(id)source cover:(BOOL)cover;

@end

#pragma mark ---- MessageObject 消息对象 ----
@interface MessageObject : CommonObject
@property(nonatomic,strong)NSString         *msgGroupId;        //会话组Id
@property(nonatomic,strong)NSString         *houseId;
@property(nonatomic,strong)NSString         *orderId;
@property(nonatomic,strong)NSString         *accSenderId;       //发送用户的accId
@property(nonatomic,strong)NSString         *tntSenderId;       //发送用户的tntId
@property(nonatomic,strong)NSString         *messageType;       //CHAT,聊天内容  HOUSE,房源信息
@property(nonatomic,strong)NSString         *contentType;       //HTML, TEXT, IMAGE
@property(nonatomic,strong)NSString         *isRead;
@property(nonatomic,strong)NSString         *isModified;
@property(nonatomic,strong)NSString         *isDeleted;


+ (MessageObject *)parseObject:(MessageObject *)object from:(id)source cover:(BOOL)cover;

+ (NSString *)getJSONString:(MessageObject *)object;

@end

#pragma mark ---- ChatObject 会话对象 ----
@interface ChatObject : CommonObject
@property(nonatomic,strong)NSString         *accId;                     //自己的
@property(nonatomic,strong)NSString         *tntId;
@property(nonatomic,strong)NSString         *accIdSide;                 //对方的
@property(nonatomic,strong)NSString         *tntIdSide;
@property(nonatomic,strong)NSString         *groupType;                 //聊天类型
@property(nonatomic,strong)NSString         *isDeleted;                 //
@property(nonatomic,strong)NSString         *unread;                    //未读条数
@property(nonatomic,strong)MessageObject    *lastestMessage;            //最近一条

@property(nonatomic,strong)NSMutableArray    *messageArray;             //消息列表

//聊天对象
@property(nonatomic,strong)UserInfo         *userInfoSide;      //聊天对象的用户信息

+ (ChatObject *)parseObject:(ChatObject *)object from:(id)source cover:(BOOL)cover;


@end

#pragma mark - 搜索对象
@interface SearchObject:CommonObject
@property(nonatomic,strong)CalendarObject         *startDate;                 //开始时间
@property(nonatomic,strong)CalendarObject         *endDate;                   //结束时间
@end

#pragma mark - MyCardObject
@interface MyCardObject : CommonObject


//@property(nonatomic,strong) NSString * mobile;//订单号
@property(nonatomic,strong) NSString * token;//手机号
@property(nonatomic,strong)NSString * rows;//订单生成时间
@property(nonatomic,strong)NSString * cardId;//订单状态
@property(nonatomic,strong)NSString * cardNo;//卡号
@property(nonatomic,strong)NSString * cardMoney;//订单类型
@property(nonatomic,strong)NSString * cardType;//卡片类型   2-电信手机深圳通
@property(nonatomic,strong)NSString * cardStatus;//订单更新时间
@property(nonatomic,strong)NSString * remark;//备注
@property(nonatomic,strong)NSString * isShow;//备注
@property(nonatomic,strong)NSString * openDate;//订单更新时间
@property(nonatomic,strong)NSString * cancleDate;//订单更新时间
@property(nonatomic,strong)NSString * iccid;//备注
@property(nonatomic,strong)NSString * cardCode;//备注
@property(nonatomic,strong)NSString * mobileNo;//备注
+ (MyCardObject *)parseObject:(MyCardObject *)object from:(id)source cover:(BOOL)cover;
@end

#pragma mark - VoucherObject
@interface VoucherObject : CommonObject
@property (nonatomic,retain) NSString * couponState;
@property (nonatomic,retain) NSString * couponId;
@property (nonatomic,retain) NSString * mcId;
@property (nonatomic,retain) NSString * couponEndDate;
@property (nonatomic,retain) NSString * mobileNo;
@property (nonatomic,retain) NSString * creater;
@property (nonatomic,retain) NSString * createDate;
@property (nonatomic,retain) NSString * couponBeginDate;
@property (nonatomic,retain) NSString * source;
@property (nonatomic,retain) NSString * memberId;
@property (nonatomic,retain) NSString * updateDate;
@property (nonatomic,retain) NSString * updater;
@property (nonatomic,retain) NSString * expireFlag;
@property (nonatomic,retain) NSString * couponType;
@property (nonatomic,retain) NSString * couponDesc;
@property (nonatomic,retain) NSString * couponIssueAmt;
@property (nonatomic,retain) NSString * couponName;
+ (VoucherObject *)parseObject:(VoucherObject *)object from:(id)source cover:(BOOL)cover;

@end

#pragma mark - StationLine
@interface CarModel : CommonObject
@property (nonatomic, retain) NSString * diff;//距离当前还有多少个站
@property (nonatomic, retain) NSString * distance;//离当前距离还有多少米
@property (nonatomic, retain) NSString * stationstate;
@property (nonatomic, retain) NSString * waittime;
@property (nonatomic, retain) NSString * gpstime;
@property (nonatomic, retain) NSString * stationid;
@property (nonatomic, retain) NSString * lng;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * carid;
//@property (nonatomic, retain) NSString * name;
+ (CarModel *)parseObject:(CarModel *)object from:(id)source cover:(BOOL)cover;

@end


#pragma mark - StationLine
@interface StationLine : CommonObject
@property (nonatomic, retain) NSString *station;
@property (nonatomic, retain) NSString *end_station7;
@property (nonatomic, retain) NSString *wait_time;
@property (nonatomic, retain) NSString *dir;
@property (nonatomic, retain) NSString *sublineid;
@property (nonatomic, retain) NSString *end_station;
@property (nonatomic, retain) NSString *start_station;
@property (nonatomic, retain) CarModel *car;
@property (nonatomic, retain) NSString *sublineid5;
//@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *diff;
@property (nonatomic, retain) NSString *isopen;
@property (nonatomic, retain) NSString *end_time;
@property (nonatomic, retain) NSString *line_name;
@property (nonatomic, retain) NSString *begin_time;

+ (StationLine *)parseObject:(StationLine *)object from:(id)source cover:(BOOL)cover;
@end


#pragma mark - HFFCard
@interface HFFCard : CommonObject
@property (nonatomic, retain) NSString *sztCardNo;
@property (nonatomic, retain) NSString *creditCardNo;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *reservedPhoneNo;
@property (nonatomic, retain) NSString *creditStatus;
@property (nonatomic, retain) NSString *sztCardStatus;
@property (nonatomic, retain) NSString *creditQuota;
@property (nonatomic, retain) NSString *rechargeMaxNum;
@property (nonatomic, retain) NSString *rechargeMinAmount;
@property (nonatomic, retain) NSString *perMaxConsume;
@property (nonatomic, retain) NSString *dayMaxConsume;
@property (nonatomic, retain) NSString *purseMaxBalance;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;

@property (nonatomic, retain) NSString *userIdType;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *bankId;
@property (nonatomic, retain) NSString *autoRechargeConsume;
@property (nonatomic, retain) NSString *creditEndDate;
@property (nonatomic, retain) NSString *cardType;
+ (HFFCard *)parseObject:(HFFCard *)object from:(id)source cover:(BOOL)cover;
@end

#pragma mark ---- ShouhuanObject 手环对象 ----
//@interface ShouhuanObject : CommonObject
//
//@property (nonatomic, assign) NSInteger step;
//@property (nonatomic, assign) CGFloat calorie;
//@property (nonatomic, retain) NSArray *sportDataAry;
//@property (nonatomic, retain) GDSleepDay *sleepDay;
//@property (nonatomic,retain) NSString *totalCalorie;
//@property (nonatomic,retain) NSString *totalStep;
//
//@property (nonatomic,retain) NSString *totalDistacce;
//
//@property (nonatomic,retain) NSString *avgDistance;
//
//@property (nonatomic,retain) NSString *avgStep;
//
//@property (nonatomic,retain) NSString *avgCalorie;
//
//@property (nonatomic,retain) NSArray *sportArr;
//@property (nonatomic,retain) NSArray *sleepArr;
//
//@property (nonatomic,retain) NSString *avgGotoSleep;
//@property (nonatomic,retain) NSString *avgGetUpSleep;
//
//@property (nonatomic,retain) NSString *avgWakeupTime;
//
//@property (nonatomic,retain) NSString *avgSleepTime;
//
//@property (nonatomic,retain) NSString *avgLightSleepTime;
//
//@property (nonatomic,retain) NSString *avgDeepSleepTime;
//
//@end
//
//@interface HFFCredit : CommonObject
//@property(nonatomic,strong) NSString* credit_quota;
//@property(nonatomic,strong) NSString* credit_enddate;
//@property(nonatomic,strong) NSString* currbalance;
//@property(nonatomic,strong) NSString* purse_max_balance;
//@property(nonatomic,strong) NSString* recharge_min_amount;
//@property(nonatomic,strong) NSString* Auto_recharge_consume;
//@property(nonatomic,strong) NSString* recharge_max_num;
//@property(nonatomic,strong) NSString* per_max_consume;
//@property(nonatomic,strong) NSString* day_max_consume;
//@property(nonatomic,strong) NSString* PreAuthorization;
//@property(nonatomic,strong) NSString* PCurrDate;
//@property(nonatomic,strong) NSString* Auto_recharge_sum;
//@property(nonatomic,strong) NSString* Curr_Pre_Amount;
//
//
//+ (HFFCredit *)parseObject:(HFFCredit *)object from:(id)source cover:(BOOL)cover;
//
//
//@end

