//
//  YHTTPService.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "YHTTPRequest.h"
#import "YHTTPResponse.h"
#import "TPUser.h"

typedef void (^requstSuccessBlock) (id success);
typedef void (^faliueBlock) (id error);

@interface YHTTPService : AFHTTPSessionManager
/// 单例
+(instancetype) sharedInstance;

//注册接口
- (NSURLSessionDataTask *)requestRegisterWithPhoneNumber:(NSString *)phoneNumber
                                                    authCode:(NSString *)code
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure;

//登录接口
- (NSURLSessionDataTask *)requestLoginWithPhoneNumber:(NSString *)phoneNumber
                                                password:(NSString *)password
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure;

//验证码接口
- (NSURLSessionDataTask *)requestAuthCodeWithPhoneNumber:(NSString *)phoneNumber
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure;

@end
