//
//  YHTTPService.m
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YHTTPService.h"

#import "TPMacros.h"
#import "TPConstInline.h"
#import <YYKit/YYKit.h>
#import "TPURLConfigure.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/AFNetworking.h>

@interface YHTTPService ()
/// currentLoginUser
@property (nonatomic, readwrite, strong) TPUser *currentUser;
@end

@implementation YHTTPService
static id service_ = nil;
#pragma mark -  HTTPService
+(instancetype) sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service_ = [[self alloc] initWithBaseURL:[NSURL URLWithString:TAOPAY_BASE_URL] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  });
  return service_;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service_ = [super allocWithZone:zone];
  });
  return service_;
}
- (id)copyWithZone:(NSZone *)zone {
  return service_;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration{
  if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
    /// 配置
    [self _configHTTPService];
  }
  return self;
}

/// config service
- (void)_configHTTPService{
  AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
#if DEBUG
  responseSerializer.removesKeysWithNullValues = NO;
#else
  responseSerializer.removesKeysWithNullValues = YES;
#endif
  responseSerializer.readingOptions = NSJSONReadingAllowFragments;
  /// config
  self.responseSerializer = responseSerializer;
  self.requestSerializer = [AFHTTPRequestSerializer serializer];
  self.requestSerializer.timeoutInterval = TimeoutInterval;
  
//FIXME: -- 暂时使用HTTP，注释此段代码
//  /// 安全策略
//  AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//  //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
//  //如果是需要验证自建证书，需要设置为YES
//  securityPolicy.allowInvalidCertificates = YES;
//  //validatesDomainName 是否需要验证域名，默认为YES；
//  //假如证书的域名与你请求的域名不一致，需把该项设置为NO
//  //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//  securityPolicy.validatesDomainName = NO;
//
//  self.securityPolicy = securityPolicy;
  /// 支持解析
  self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                    @"text/json",
                                                    @"text/javascript",
                                                    @"text/html",
                                                    @"text/plain",
                                                    @"text/html; charset=UTF-8",
                                                    nil];
  
  /// 开启网络监测
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    
    if (status == AFNetworkReachabilityStatusUnknown) {
      //            [JDStatusBarNotification showWithStatus:@"网络状态未知" styleName:JDStatusBarStyleWarning];
      //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
      NSLog(@"--- 未知网络 ---");
    }else if (status == AFNetworkReachabilityStatusNotReachable) {
      //            [JDStatusBarNotification showWithStatus:@"网络不给力，请检查网络" styleName:JDStatusBarStyleWarning];
      //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
      NSLog(@"--- 无网络 ---");
    }else{
      NSLog(@"--- 有网络 ---");
      //            [JDStatusBarNotification dismiss];
    }
  }];
  [self.reachabilityManager startMonitoring];
}
//MARK: -- 注册接口
- (NSURLSessionDataTask *)requestRegisterWithPhoneNumber:(NSString *)phoneNumber
                                                authCode:(NSString *)code
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure {
  NSDictionary *dic = @{@"phone":phoneNumber, @"code":code};
  NSURLSessionDataTask *task =  [self POST:RegisterRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
    success(response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    DLog(@"%@",error.localizedDescription);
    failure(error.localizedDescription);
  }];
  
  return task;
}

//登录接口
- (NSURLSessionDataTask *)requestLoginWithPhoneNumber:(NSString *)phoneNumber
                                             password:(NSString *)password
                                              success:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure {
  NSDictionary *dic = @{@"phone":phoneNumber, @"password":password};
  NSURLSessionDataTask *task =  [self POST:RegisterRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
    success(response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    DLog(@"%@",error.localizedDescription);
    failure(error.localizedDescription);
  }];
  
  return task;
}

//验证码接口
- (NSURLSessionDataTask *)requestAuthCodeWithPhoneNumber:(NSString *)phoneNumber
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure {
  NSDictionary *dic = @{@"phone":phoneNumber};
  NSURLSessionDataTask *task =  [self POST:RegisterRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
    success(response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    DLog(@"%@",error.localizedDescription);
    failure(error.localizedDescription);
  }];
  
  return task;
}

@end

