//
//  FNNetManager.h
//  
//
//  Created by feinno on 15/1/28.
//  Copyright (c) 2015年 feinno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FNHeader.h"
#import <Foundation/NSURLSession.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *FNNetParamToken;
FOUNDATION_EXTERN BOOL isIgnore;

typedef NS_ENUM(NSUInteger, FNNetType)
{
    FNNetTypeGET,
    FNNetTypePOST,
};

@interface FNNetManager : NSObject

+ (FNNetManager *) shared;

- (id) getArguWithType:(FNNetType)type argus:(id)argus;

- (void) getURL:(NSString *)url paras:(id)paras finish:(void (^) (id result))finish fail:(void (^) (NSError *error))fail;

- (void) postURL:(NSString *)url paras:(id)paras finish:(void (^) (id result))finish fail:(void (^) (NSError *error))fail;

- (void) makeGetURL:(NSString *)url paras:(id)paras success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void) makePostURL:(NSString *)url paras:(id)paras success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

- (void) uploadImageWithUrl:(NSString *)url image:(NSString *)image finish:(void (^) (id result))finish fail:(void (^) (NSError *error))fail;

- (void)setPort:(NSInteger)port;

- (void)setUserInfo:(BOOL)isInfo;

- (void)setUrlIsWX:(BOOL)isWX;

- (void)setIsJSONSerializer:(BOOL)isJSONSerializer;

@end

NS_ASSUME_NONNULL_END
