//
//  FNPayManager.m
//  BonusStore
//
//  Created by Nemo on 16/4/1.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNPayManager.h"

@implementation FNPayManager

+ (void)configAll
{
    [WXApi registerApp:FN_WECHAT_ID withDescription:APP_ARGUS_NAME];
}

+ (void)payWeChatWithResult:(id)result
{
    [FNStraddleService setStraddleType:FNStraddleTypeWXPay];

    PayReq *request = [[PayReq alloc] init];
    request.partnerId = result[@"partnerid"];
    request.prepayId= result[@"prepayid"];
    request.package = result[@"packageInfo"];
    request.nonceStr= result[@"noncestr"];
    request.timeStamp= [result[@"timestamp"] doubleValue];
    request.sign= result[@"sign"];
    request.openID = result[@"appid"];
    [WXApi sendReq:request];
}

+ (void)payAliWithResult:(id)result
{
    [FNStraddleService setStraddleType:FNStraddleTypeAliPay];
    
    Order *order = [[Order alloc] init];
    order.productDescription = result[@"body"];
    order.seller = result[@"seller_id"];
    order.partner = result[@"partner"];
    order.notifyURL = result[@"notify_url"];
    order.tradeNO = result[@"out_trade_no"];
    order.amount = result[@"total_fee"];
    order.productName = result[@"subject"];
    
    order.service = result[@"service"];
    order.paymentType = result[@"payment_type"];
    order.inputCharset = result[@"_input_charset"];
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";

    NSString *sign_type = result[@"sign_type"];
    
    NSString *orderSpec = [order description];
    
    id<DataSigner> signer = CreateRSADataSigner(@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBANVmgr9np6ygCEqVoJiRBKxqQkOy0ihwlOtcKc2gUTmYVYbKYQ5a/CPiLLt1AJrAcTO5w1iqTKpQKZKbBoYRrkK//4VAkNgwh8KbeT8zPqfkmXUx8I7IQkmOqRDzwrDC/z46TJvU9oW0l5HB5KJqBiob1s2lYXqvYEZNcV9bDOipAgMBAAECgYBNsHM7IY5ujxhVpuF/iZQM/OZA5TITXOEqSjRB0vKfKDFC0BzDcCZJHgcw+6iLrjHIJgHTHrSocGSiJeQbHQa2RhTgNee4GE93H1Gez7U72I1nlMvaKHNz1UHfaFouE2f85RHtnpGHFrkhdJke+6Gw+QEK5vn6ddzTn66x8+BDAQJBAPB9dChnRzjUllZabAolbcVw0H6UGxljhxRJtWDFzBfDKMLWWeZcwrkpejHLqVCqVKlrobDUb4jGfydkUhD9P4kCQQDjKc0UxcTxI1Yr+8T+alDyMtiLXewe6fVcg89jX7WPJ4XDWuOwDjx7jRPXs491AS7JJYwzVOwqRGV9/PuUQ/ghAkAW4Sia63B4NKl037dlo7f0z83WLQsC+FgSkwyhf0/ydsu69Z+p7etMqGiKskCSfxH86FOCukM+NPxF6CJyoVVZAkAbM95DJou29KxVCAlHDiQzXLNhvRWRfiLLuV0UYVm0kt8JzdCGPK4xfWtq4S3ErSeVHtHzM7A0P4yH0cuurZUBAkBuN2qOcmGFA/1+GJuCsDo86qFO0Dq3j1JWwq9Q1dUvDNjmn5DmHibq3+EncQ71NyuHmofWx3nBl+VYAAU1NpYI");
   
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    
    if (signedString != nil) {
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, sign_type];
        
        //在支付宝界面点击X号后这个方法结束
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:APP_ARGUS_ID callback:^(NSDictionary *resultDic) {
            

            
        }];
    }
}

+ (void)payHebaoWithResult:(id)result
{
    
}

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    srand((unsigned)time(0));
    
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    
    return resultStr;
}

/*
 
 
 #import <foundation foundation.h="">
 #import WXUtil.h
 #import ApiXml.h
 #import WXApi.h
 
 // 账号帐户资料
 // 更改商户把相关参数后可测试
 #define APP_ID          @wx@@@@@@@@@@@@@@@@        //APPID
 #define APP_SECRET      @                          //appsecret,看起来好像没用
 //商户号，填写商户对应参数
 #define MCH_ID          @@@@@@@@@@@
 //商户API密钥，填写相应参数
 #define PARTNER_ID      @12345678901234567890123456789012
 //支付结果回调页面
 #define NOTIFY_URL      @http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php
 //获取服务器端支付数据地址（商户自定义）(在小吉这里，签名算法直接放在APP端，故不需要自定义)
 #define SP_URL          @http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php
 
 
 @interface WechatPayManager : NSObject
 {
 }
 
 
 //预支付网关url地址
 @property (nonatomic,strong) NSString* payUrl;
 
 //debug信息
 @property (nonatomic,strong) NSMutableString *debugInfo;
 @property (nonatomic,assign) NSInteger lastErrCode;//返回的错误码
 
 //商户关键信息
 @property (nonatomic,strong) NSString *appId,*mchId,*spKey;
 
 
 //初始化函数
 -(id)initWithAppID:(NSString*)appID
 mchID:(NSString*)mchID
 spKey:(NSString*)key;
 
 //获取当前的debug信息
 -(NSString *) getDebugInfo;
 
 //获取预支付订单信息（核心是一个prepayID）
 - (NSMutableDictionary*)getPrepayWithOrderName:(NSString*)name
 price:(NSString*)price
 device:(NSString*)device;
 
 //  WechatPayManager.m
 //
 //  Created by HuangCharlie on 5/24/15.
 //
 //
 
 #import WechatPayManager.h
 
 @implementation WechatPayManager
 
 //初始化函数
 -(id)initWithAppID:(NSString*)appID mchID:(NSString*)mchID spKey:(NSString*)key
 {
 self = [super init];
 if(self)
 {
 //初始化私有参数，主要是一些和商户有关的参数
 self.payUrl    = @https://api.mch.weixin.qq.com/pay/unifiedorder;
 if (self.debugInfo == nil){
 self.debugInfo  = [NSMutableString string];
 }
 [self.debugInfo setString:@];
 self.appId = appID;//微信分配给商户的appID
 self.mchId = mchID;//
 self.spKey = key;//商户的密钥
 }
 return self;
 }
 
 //获取debug信息
 -(NSString*) getDebugInfo
 {
 NSString *res = [NSString stringWithString:self.debugInfo];
 [self.debugInfo setString:@];
 return res;
 }
 
 //创建package签名
 -(NSString*) createMd5Sign:(NSMutableDictionary*)dict
 {
 NSMutableString *contentString  =[NSMutableString string];
 NSArray *keys = [dict allKeys];
 //按字母顺序排序
 NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
 return [obj1 compare:obj2 options:NSNumericSearch];
 }];
 //拼接字符串
 for (NSString *categoryId in sortedArray) {
 if (   ![[dict objectForKey:categoryId] isEqualToString:@]
 && ![categoryId isEqualToString:@sign]
 && ![categoryId isEqualToString:@key]
 )
 {
 [contentString appendFormat:@%@=%@&, categoryId, [dict objectForKey:categoryId]];
 }
 
 }
 //添加key字段
 [contentString appendFormat:@key=%@, self.spKey];
 //得到MD5 sign签名
 NSString *md5Sign =[WXUtil md5:contentString];
 
 //输出Debug Info
 [self.debugInfo appendFormat:@MD5签名字符串：
 %@
 
 ,contentString];
 
 return md5Sign;
 }
 
 //获取package带参数的签名包
 -(NSString *)genPackage:(NSMutableDictionary*)packageParams
 {
 NSString *sign;
 NSMutableString *reqPars=[NSMutableString string];
 //生成签名
 sign        = [self createMd5Sign:packageParams];
 //生成xml的package
 NSArray *keys = [packageParams allKeys];
 [reqPars appendString:@<xml>
 ];
 for (NSString *categoryId in keys) {
 [reqPars appendFormat:@<%@>%@<!--%@-->
 , categoryId, [packageParams objectForKey:categoryId],categoryId];
 }
 [reqPars appendFormat:@<sign>%@</sign>
 </xml>, sign];
 
 return [NSString stringWithString:reqPars];
 }
 
 //提交预支付
 -(NSString *)sendPrepay:(NSMutableDictionary *)prePayParams
 {
 NSString *prepayid = nil;
 
 //获取提交支付
 NSString *send      = [self genPackage:prePayParams];
 
 //输出Debug Info
 [self.debugInfo appendFormat:@API链接:%@
 , self.payUrl];
 [self.debugInfo appendFormat:@发送的xml:%@
 , send];
 
 //发送请求post xml数据
 NSData *res = [WXUtil httpSend:self.payUrl method:@POST data:send];
 
 //输出Debug Info
 [self.debugInfo appendFormat:@服务器返回：
 %@
 
 ,[[NSString alloc] initWithData:res encoding:NSUTF8StringEncoding]];
 
 XMLHelper *xml  = [[XMLHelper alloc] autorelease];
 
 //开始解析
 [xml startParse:res];
 
 NSMutableDictionary *resParams = [xml getDict];
 
 //判断返回
 NSString *return_code   = [resParams objectForKey:@return_code];
 NSString *result_code   = [resParams objectForKey:@result_code];
 if ( [return_code isEqualToString:@SUCCESS] )
 {
 //生成返回数据的签名
 NSString *sign      = [self createMd5Sign:resParams ];
 NSString *send_sign =[resParams objectForKey:@sign] ;
 
 //验证签名正确性
 if( [sign isEqualToString:send_sign]){
 if( [result_code isEqualToString:@SUCCESS]) {
 //验证业务处理状态
 prepayid    = [resParams objectForKey:@prepay_id];
 return_code = 0;
 
 [self.debugInfo appendFormat:@获取预支付交易标示成功！
 ];
 }
 }else{
 self.lastErrCode = 1;
 [self.debugInfo appendFormat:@gen_sign=%@
 _sign=%@
 ,sign,send_sign];
 [self.debugInfo appendFormat:@服务器返回签名验证错误！！！
 ];
 }
 }else{
 self.lastErrCode = 2;
 [self.debugInfo appendFormat:@接口返回错误！！！
 ];
 }
 
 return prepayid;
 }
 
 - (NSMutableDictionary*)getPrepayWithOrderName:(NSString*)name
 price:(NSString*)price
 device:(NSString*)device
 {
 //订单标题，展示给用户
 NSString* orderName = name;
 //订单金额,单位（分）
 NSString* orderPrice = price;//以分为单位的整数
 //支付设备号或门店号
 NSString* orderDevice = device;
 //支付类型，固定为APP
 NSString* orderType = @APP;
 //发器支付的机器ip,暂时没有发现其作用
 NSString* orderIP = @196.168.1.1;
 
 //随机数串
 srand( (unsigned)time(0) );
 NSString *noncestr  = [NSString stringWithFormat:@%d, rand()];
 NSString *orderNO   = [NSString stringWithFormat:@%ld,time(0)];
 
 //================================
 //预付单参数订单设置
 //================================
 NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
 
 [packageParams setObject: self.appId  forKey:@appid];       //开放平台appid
 [packageParams setObject: self.mchId  forKey:@mch_id];      //商户号
 [packageParams setObject: orderDevice  forKey:@device_info]; //支付设备号或门店号
 [packageParams setObject: noncestr     forKey:@nonce_str];   //随机串
 [packageParams setObject: orderType    forKey:@trade_type];  //支付类型，固定为APP
 [packageParams setObject: orderName    forKey:@body];        //订单描述，展示给用户
 [packageParams setObject: NOTIFY_URL  forKey:@notify_url];  //支付结果异步通知
 [packageParams setObject: orderNO      forKey:@out_trade_no];//商户订单号
 [packageParams setObject: orderIP      forKey:@spbill_create_ip];//发器支付的机器ip
 [packageParams setObject: orderPrice   forKey:@total_fee];       //订单金额，单位为分
 
 //获取prepayId（预支付交易会话标识）
 NSString *prePayid;
 prePayid = [self sendPrepay:packageParams];
 
 if(prePayid == nil)
 {
 [self.debugInfo appendFormat:@获取prepayid失败！
 ];
 return nil;
 }
 
 //获取到prepayid后进行第二次签名
 NSString    *package, *time_stamp, *nonce_str;
 //设置支付参数
 time_t now;
 time(&now);
 time_stamp  = [NSString stringWithFormat:@%ld, now];
 nonce_str = [WXUtil md5:time_stamp];
 //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
 //package       = [NSString stringWithFormat:@Sign=%@,package];
 package         = @Sign=WXPay;
 //第二次签名参数列表
 NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
 [signParams setObject: self.appId  forKey:@appid];
 [signParams setObject: self.mchId  forKey:@partnerid];
 [signParams setObject: nonce_str    forKey:@noncestr];
 [signParams setObject: package      forKey:@package];
 [signParams setObject: time_stamp   forKey:@timestamp];
 [signParams setObject: prePayid     forKey:@prepayid];
 
 //生成签名
 NSString *sign  = [self createMd5Sign:signParams];
 
 //添加签名
 [signParams setObject: sign         forKey:@sign];
 
 [self.debugInfo appendFormat:@第二步签名成功，sign＝%@
 ,sign];
 
 //返回参数列表
 return signParams;
 }
 */
@end
