//
//  FNNetManager.m
//
//
//  Created by feinno on 15/1/28.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import "FNNetManager.h"
#import "FNLoginBO.h"
#import "UIView+Toast.h"
BOOL isIgnore;

NS_ASSUME_NONNULL_BEGIN

NSString *FNNetParamToken = @"";

static NSInteger _port;

static NSString *_role;

static BOOL _isUserInfo;

static BOOL _isWX;

static BOOL _isJSONSerializer;

@interface FNNetManager()
{
    
    FNNetType *_tempNetType;                //请求类型
    
    NSString *_tempURL;                     //临时存储URL，为了让重新登录时，能够知道url
    
    NSDictionary *_tempPara;                //临时存储参数，为了重新登录能够使用
    
    void (^_tempFinish) (id result);        //临时存储返回Block，为了重新登录能够使用
    
    void (^_tempFail) (NSError *_error);    //临时存储返回Block，为了重新登录能够使用
    
}

#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wconversion"

@property(nonatomic,retain)AFHTTPSessionManager *sessionManager;

@end

@implementation FNNetManager

+(FNNetManager *)shared
{
    static FNNetManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[FNNetManager alloc]init];
        
        manager.sessionManager = [AFHTTPSessionManager manager];
        
        manager.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

        [manager.sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        manager.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", @"image/jpeg",@"application/x-png", nil];
        
        [manager.sessionManager.requestSerializer setTimeoutInterval:20];
        
        _isUserInfo = YES;
        
        _isWX = NO;
        
        _isJSONSerializer = YES;
    });
    
    return manager;
}

- (id) getArguWithType:(FNNetType)type argus:(id)argus
{
    
    [FNUserAccountArgs getUserAccountInfo];
    
    switch (type)
    {
        case FNNetTypeGET:
        {
            NSMutableString *string = [NSMutableString string];

            argus = [NSMutableDictionary dictionaryWithDictionary:argus];
            
            [argus setObject:@(FNClientTypeiOS) forKey:@"clientType"];
            
            [argus setObject:APP_ARGUS_VERSION forKey:@"version"];
            
            if (FNUserAccountInfo && _isUserInfo)
            {
                [argus addEntriesFromDictionary:FNUserAccountInfo];
            }
            
            for (NSString *key in [argus allKeys])
            {
                [string appendFormat:@"%@=%@&",key,[argus valueForKey:key]];
            }
            _isUserInfo = YES;
            
            return string;
        }
            
        case FNNetTypePOST:
        {
            argus = [NSMutableDictionary dictionaryWithDictionary:argus];
            
            [argus setObject:@(FNClientTypeiOS) forKey:@"clientType"];
            
            [argus setObject:APP_ARGUS_VERSION forKey:@"version"];
            
            if (FNUserAccountInfo && [FNUserAccountInfo isKindOfClass:[NSDictionary class]] && _isUserInfo)
            {
                [argus setValue:[NSString stringWithFormat:@"%@",FNUserAccountInfo[@"userId"]] forKey:@"userId"];
                [argus setValue:FNUserAccountInfo[@"token"] forKey:@"token"];
                [argus setValue:FNUserAccountInfo[@"ppInfo"] forKey:@"ppInfo"];
                [argus setValue:[FNDevice idfa] forKey:@"browser"];
            }
            _isUserInfo = YES;

            return argus;
        }
    }
}

- (void) getURL:(NSString *)url paras:(id)paras finish:(void (^) (id result))finish fail:(void (^) (NSError *error))fail
{
    NSMutableString *string = [NSMutableString string];

    [string appendFormat:@"?%@",[self getArguWithType:FNNetTypeGET argus:paras]];
    
    string.length ? [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)] : nil;
    
    NSString *join;
    
#if TARGET_DEV
   join = [NSString stringWithFormat:@"%@%@%@%@",(_isWX ? URL_WECHAT_BASE : URL_BASE),(_isWX ? @"" : [NSString stringWithFormat:@":%ld/%@/",(long)_port,_role]),url,string];
#else
   join = [NSString stringWithFormat:@"%@%@%@%@",(_isWX ? URL_WECHAT_BASE : URL_BASE),(_isWX ? @"" : [NSString stringWithFormat:@"/%@/",_role]),url,string];
#endif
    
    _isWX = NO;
    NSString *encoded = [join stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self makeGetURL:encoded paras:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dict[@"code"] integerValue] == 501)
        {
            [FNLoadingView  hide];

            if(isIgnore == YES)
            {
                return ;
            }
            [self errorWithInfo:dict];
        }
        else
        {
            if (finish)
            {
                finish(dict);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(fail)
        {
            fail(error);
        }
        
        [self error:error];
    }];
}

- (void) postURL:(NSString *)url paras:(id)paras finish:(void (^) (id result))finish fail:(void (^) (NSError *error))fail
{
    NSMutableDictionary *p = [NSMutableDictionary dictionaryWithDictionary:paras];

    [p addEntriesFromDictionary:[self getArguWithType:FNNetTypePOST argus:paras]];
    
#if TARGET_DEV
    url = [NSString stringWithFormat:@"%@%@%@",(_isWX ? URL_WECHAT_BASE : URL_BASE),(_isWX ? @"" : [NSString stringWithFormat:@":%ld/%@/",(long)_port,_role]),url];
#else
    url = [NSString stringWithFormat:@"%@/%@%@",(_isWX ? URL_WECHAT_BASE : URL_BASE),(_isWX ? @"" : [NSString stringWithFormat:@"%@/",_role]),url];
#endif

    _isWX = NO;
    
    [self makePostURL:url paras:p success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dict[@"code"] integerValue] == 501)
        {
            [FNLoadingView  hide];

            if(isIgnore == YES)
            {
                return ;
            }
            [self errorWithInfo:dict];
        }
        else
        {
            if (finish)
            {
                finish(dict);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(fail)
        {
            fail(error);
        }
        
        [self error:error];
    }];
}

- (void) makeGetURL:(NSString *)url paras:(id)paras success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    // Default is JSON serializer, but it's HTTP when _isJSONSerializer is NO;
    if (!_isJSONSerializer)
    {
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _isJSONSerializer = YES;
    }
    else
    {
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    [self.sessionManager GET:url parameters:paras success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task, error);
    }];
}

- (void) makePostURL:(NSString *)url paras:(id)paras success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure
{
    // Default is JSON serializer, but it's HTTP when _isJSONSerializer is NO;
    if (!_isJSONSerializer)
    {
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _isJSONSerializer = YES;
    }
    else
    {
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    [self.sessionManager POST:url parameters:paras success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(task, responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(task, error);
    }];
}

- (void)uploadImageWithUrl:(NSString *)url image:(NSString *)image finish:(void (^) (id result))finish fail:(void (^) (NSError *error))fail
{
    url = [NSString stringWithFormat:@"%@/%@",URL_BASE,url];
    
    [self.sessionManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:image] name:@"Filedata" fileName:@"image.png" mimeType:@"image/png"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        finish(dict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self error:error];

    }];
}

- (void)errorWithInfo:(NSDictionary *)info
{

    BOOL isShow = NO;
    NSMutableDictionary *infos = [NSMutableDictionary dictionaryWithDictionary:[FNUserAccountArgs getUserAccount]];
    if([NSString isEmptyString:[infos objectForKey:@"pwdEnc"]])
    {
        // 已经处理过了
        isShow = YES;
        [FNLoginBO loginAuthFail];

    }else
    {
        isShow = NO;
        
    }
    if ([info[@"code"] integerValue] == 501 && !isShow)
    {
    
        isIgnore = YES;
    
        [UIAlertView alertWithTitle:APP_ARGUS_NAME message:@"您的帐号已在其他设备登录，是否重新登录" cancelTitle:@"确定" actionBlock:^(NSInteger bIndex) {
            
            if (bIndex == 0)
            {

                [FNLoginBO loginAuthFail];
            }
            else
            {
                [FNLoginBO loginCancel];

            }
            
        } otherTitle:@"取消", nil];
        
    }
}

- (void)error:(NSError *)error
{    

}

- (void)setPort:(NSInteger)port
{
    _port = port;
    
    if (_port == 18001)
    {
        _role = @"shop";
    }
    else if (_port == 18002)
    {
        _role = @"buyer";
    }
    else if (_port == 18003)
    {
        _role = @"seller";
    }
    else if (_port == 18004)
    {
        _role = @"manager";
    }
}

- (void)setUserInfo:(BOOL)isInfo
{
    _isUserInfo = isInfo;
}

- (void)setUrlIsWX:(BOOL)isWX
{
    _isWX = isWX;
}

- (void)setIsJSONSerializer:(BOOL)isJSONSerializer
{
    _isJSONSerializer = isJSONSerializer;
}

- (void)setTempType:(FNNetType)type url:(NSString *)url para:(NSDictionary *)para finish:(void (^) (id result))finish fail:(void (^) (NSError *error))fail
{
    _tempNetType = type;
    
    _tempURL = url;
    
    _tempPara = para;
    
    _tempFinish = finish;
    
    _tempFail = fail;
}

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
