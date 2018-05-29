//
//  YHTTPService.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "TPURLConfigure.h"
#import "YHTTPRequest.h"
#import "YHTTPResponse.h"
#import "TPUser.h"

typedef void (^requstSuccessBlock) (id success);
typedef void (^faliueBlock) (id error);

@interface YHTTPService : AFHTTPSessionManager

/// currentLoginUser
@property (nonatomic, readwrite, strong) TPUser *currentUser;

/// 单例
+(instancetype) sharedInstance;

//注册接口
- (NSURLSessionDataTask *)requestRegisterWithPhoneNumber:(NSString *)phoneNumber
                                                authCode:(NSString *)code
                                                password:(NSString *)pwd
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

//获取个人信息接口
- (NSURLSessionDataTask *)requestGetUserInfoSuccess:(void (^)(YHTTPResponse *response))success
                                            failure:(void (^)(NSString *msg))failure;
//获取明细列表接口
- (NSURLSessionDataTask *)requestBalanceDetailSuccess:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure;
//获取充值tn号接口
- (NSURLSessionDataTask *)requestBalanceRechargeWithAmount:(NSString *)amount
                                                   success:(void (^)(YHTTPResponse *response))success
                                                   failure:(void (^)(NSString *msg))failure;
//转账接口
- (NSURLSessionDataTask *)requestBalanceTransferWithAmount:(NSString *)amount
                                                cardNumber:(NSString *)cardNum
                                              transferType:(NSString *)type
                                                   success:(void (^)(YHTTPResponse *response))success
                                                   failure:(void (^)(NSString *msg))failure;

//查询支付结果接口
- (NSURLSessionDataTask *)requestBalanceQueryWithOrderId:(NSString *)orderId
                                                    type:(NSString *)type
                                                success:(void (^)(YHTTPResponse *response))success
                                                failure:(void (^)(NSString *msg))failure;
//修改用户昵称接口
- (NSURLSessionDataTask *)requestUserUpdateNick:(NSString *)nickName
                                        success:(void (^)(YHTTPResponse *response))success
                                        failure:(void (^)(NSString *msg))failure;
/***************--------商城相关接口------------*************************************/
//商城首页/商家列表的接口
- (NSURLSessionDataTask *)requestShopMainWithLatitude:(NSString *)lat
                                            longitude:(NSString *)lon
                                                 page:(NSString *)page
                                              success:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure;
//商家列表的接口
- (NSURLSessionDataTask *)requestShopListWithLatitude:(NSString *)lat
                                            longitude:(NSString *)lon
                                                  cat:(NSString *)cat
                                                 cat2:(NSString *)cat2
                                                 page:(NSString *)page
                                              success:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure;
//商品列表接口
- (NSURLSessionDataTask *)requestShopGoodsWithCat:(NSString *)cat
                                             cat2:(NSString *)cat2
                                             page:(NSString *)page
                                          success:(void (^)(YHTTPResponse *response))success
                                          failure:(void (^)(NSString *msg))failure;
/***************--------商城相关接口------------*************************************/

@end
