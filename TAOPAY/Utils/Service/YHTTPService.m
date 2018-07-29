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
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/AFNetworking.h>
#import "YUtil.h"
#import "NSString+YConvert.h"


@interface YHTTPService ()

@property (nonatomic, assign) TPPayTNType tnType;

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

//MARK: --  config service
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
    [self.requestSerializer setValue:[YUtil getAppLanguage] forHTTPHeaderField:@"language"];
  
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
  self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",                                        @"text/json",
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
                                                password:(NSString *)pwd
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"phone":phoneNumber, @"code":code, @"password":pwd};
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

//MARK: -- 登录接口
- (NSURLSessionDataTask *)requestLoginWithPhoneNumber:(NSString *)phoneNumber
                                             password:(NSString *)password
                                              success:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure {
  NSDictionary *dic = @{@"phone":phoneNumber, @"password":password};
  NSURLSessionDataTask *task =  [self POST:LoginRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
    success(response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    DLog(@"%@",error.localizedDescription);
    failure(error.localizedDescription);
  }];
  
  return task;
}

//MARK: -- 验证码接口
- (NSURLSessionDataTask *)requestAuthCodeWithPhoneNumber:(NSString *)phoneNumber
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure {
  NSDictionary *dic = @{@"phone":phoneNumber};
  NSURLSessionDataTask *task =  [self POST:SMSRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
    success(response);
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    DLog(@"%@",error.localizedDescription);
    failure(error.localizedDescription);
  }];
  
  return task;
}

//MARK: -- 获取个人信息接口
- (NSURLSessionDataTask *)requestGetUserInfoWithPhones:(NSString *)phones
                                               success:(void (^)(YHTTPResponse *response))success
                                               failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[YUtil getUserDefaultInfo:YHTTPRequestTokenKey] forKey:@"token"];
    if (phones.length > 0) {
        [dic setValue:phones forKey:@"phone"];
    }
    
    NSURLSessionDataTask *task =  [self POST:UserInfoRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 获取明细列表接口
- (NSURLSessionDataTask *)requestBalanceDetailSuccess:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey]};
    NSURLSessionDataTask *task =  [self POST:BalanceDetailRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: -- 获取充值tn号接口
- (NSURLSessionDataTask *)requestBalanceRechargeWithAmount:(NSString *)amount
                                                   success:(void (^)(YHTTPResponse *response))success
                                                   failure:(void (^)(NSString *msg))failure {
    self.tnType = TPPayTNTypeRecharge;
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey], @"amount":amount};
    NSURLSessionDataTask *task =  [self POST:BalanceRechargeRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 转账接口
- (NSURLSessionDataTask *)requestBalanceTransferWithAmount:(NSString *)amount
                                                cardNumber:(NSString *)cardNum
                                              transferType:(NSString *)type
                                                   success:(void (^)(YHTTPResponse *response))success
                                                   failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey], @"amount":amount, @"cardNum":cardNum, @"type":type};
    NSURLSessionDataTask *task =  [self POST:BalanceTransferRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 聊天发红包（积分转账）接口
- (NSURLSessionDataTask *)requestBalanceTransferByMessage:(NSString *)username
                                               withAmount:(NSString *)amount
                                                     type:(NSString *)type
                                                  success:(void (^)(YHTTPResponse *response))success
                                                  failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey], @"amount":amount, @"username":username, @"type":type};
    NSURLSessionDataTask *task =  [self POST:BalanceTransferByMessage parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 查询支付结果接口
- (NSURLSessionDataTask *)requestBalanceQueryWithOrderId:(NSString *)orderId
                                                    type:(NSString *)type
                                                 success:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey], @"orderId":orderId, @"type":type};
    NSURLSessionDataTask *task =  [self POST:BalanceQueryRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 修改用户昵称接口
- (NSURLSessionDataTask *)requestUserUpdateNick:(NSString *)nickName
                                        success:(void (^)(YHTTPResponse *response))success
                                        failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey], @"nick":nickName};
    NSURLSessionDataTask *task =  [self POST:UserUpdateNickRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"][@"info"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

/***************--------商城相关接口------------*************************************/
//MARK: -- 商城首页接口
- (NSURLSessionDataTask *)requestShopMainWithLatitude:(NSString *)lat
                                            longitude:(NSString *)lon
                                                 page:(NSString *)page
                                              success:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"lng":lon, @"lat":lat,@"page":page, @"size":TPRequestPageSize};
    NSURLSessionDataTask *task =  [self POST:ShopMainRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 商家列表接口
- (NSURLSessionDataTask *)requestShopListWithLatitude:(NSString *)lat
                                            longitude:(NSString *)lon
                                                  cat:(NSString *)cat
                                                 cat2:(NSString *)cat2
                                                 page:(NSString *)page
                                              success:(void (^)(YHTTPResponse *response))success
                                              failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"lng":lon, @"lat":lat,@"cat":[NSString getStringFromString:cat], @"cat2":cat2,@"page":page, @"size":TPRequestPageSize};
    NSURLSessionDataTask *task =  [self POST:ShopCompanyRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: --商品列表接口
- (NSURLSessionDataTask *)requestShopGoodsWithCat:(NSString *)cat
                                             cat2:(NSString *)cat2
                                             page:(NSString *)page
                                          success:(void (^)(YHTTPResponse *response))success
                                          failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"cat":cat, @"cat2":cat2,@"page":page, @"size":TPRequestPageSize};
    NSURLSessionDataTask *task =  [self POST:ShopGoodsRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: --商品详情接口
- (NSURLSessionDataTask *)requestShopGoodsInfo:(NSString *)goodsId
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":goodsId};
    NSURLSessionDataTask *task =  [self POST:ShopGoodsInfoRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"][@"info"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: --商品收藏接口
- (NSURLSessionDataTask *)requestGoodsCollection:(NSString *)goodsId
                                         success:(void (^)(YHTTPResponse *response))success
                                         failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":goodsId};
    NSURLSessionDataTask *task =  [self POST:ShopGoodsCollectionRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --购物车列表接口
- (NSURLSessionDataTask *)requestShoppingCartSuccess:(void (^)(YHTTPResponse *response))success
                                             failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey]};
    NSURLSessionDataTask *task =  [self POST:ShopCartRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --购物车添加接口
- (NSURLSessionDataTask *)requestAddShoppingCart:(NSString *)goodsId
                                         success:(void (^)(YHTTPResponse *response))success
                                         failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":goodsId};
    NSURLSessionDataTask *task =  [self POST:ShopAddCartRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --购物车修改接口
- (NSURLSessionDataTask *)requestModifyShoppingCart:(NSString *)goodsId
                                               type:(NSString *)type
                                              count:(NSString *)count
                                            success:(void (^)(YHTTPResponse *response))success
                                            failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":goodsId,@"type":type,@"count":count};
    NSURLSessionDataTask *task =  [self POST:ShopModifyCartRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --购物车删除接口
- (NSURLSessionDataTask *)requestDeleteShoppingCart:(NSString *)goodsId
                                            success:(void (^)(YHTTPResponse *response))success
                                            failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":goodsId};
    NSURLSessionDataTask *task =  [self POST:ShopDelCartRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --收货地址接口
- (NSURLSessionDataTask *)requestAddressSuccess:(void (^)(YHTTPResponse *response))success
                                        failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey]};
    NSURLSessionDataTask *task =  [self POST:ShopAddressRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --添加收货地址接口
- (NSURLSessionDataTask *)requestAddAddress:(NSString *)address
                                       name:(NSString *)name
                                      phone:(NSString *)phone
                                     areaID:(NSString *)areaId
                                    success:(void (^)(YHTTPResponse *response))success
                                    failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"address":address,@"name":name,@"phone":phone,@"areaId":areaId};
    NSURLSessionDataTask *task =  [self POST:ShopAddAddressRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: -- 修改收货地址接口
//type-分类，0:设为默认地址 1:置顶 2:编辑收货地址
//areaId地区ID，type=2时 必填
//name-收货人名称，type=2时 必填
//phone-收货人手机号，type=2时 必填
//address-收货人详细地址，type=2时 必填
- (NSURLSessionDataTask *)requestModifyAddress:(NSString *)receivingId
                                          type:(NSString *)type
                                        areaID:(NSString *)areaId
                                       address:(NSString *)address
                                          name:(NSString *)name
                                         phone:(NSString *)phone
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":receivingId,@"type":type,@"areaId":areaId,@"address":address,@"name":name,@"phone":phone};
    NSURLSessionDataTask *task =  [self POST:ShopModifyAddressRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --删除收货地址接口
- (NSURLSessionDataTask *)requestDeleteAddress:(NSString *)addressId
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":addressId};
    NSURLSessionDataTask *task =  [self POST:ShopDelAddressRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: --省份城市地区列表接口
- (NSURLSessionDataTask *)requestAreaList:(NSString *)areaId
                                  success:(void (^)(YHTTPResponse *response))success
                                  failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"id":areaId};
    NSURLSessionDataTask *task =  [self POST:ShopAreaRequst parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: -- 创建订单接口
- (NSURLSessionDataTask *)requestShopOrderAdd:(NSArray *)goodsId
                              withGoodsNumber:(NSArray *)goodsNum
                                withAddressId:(NSString *)addressId
                                      success:(void (^)(YHTTPResponse *response))success
                                      failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"goodsId":goodsId,@"addressId":addressId,@"goodsNum":goodsNum};
    NSURLSessionDataTask *task =  [self POST:ShopOrderAddRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: -- 订单详情接口
- (NSURLSessionDataTask *)requestOrderInfo:(NSString *)orderId
                                   success:(void (^)(YHTTPResponse *response))success
                                   failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"orderId":orderId};
    NSURLSessionDataTask *task =  [self POST:ShopOrderInfoRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: -- 订单列表接口
- (NSURLSessionDataTask *)requestOrderListSuccess:(void (^)(YHTTPResponse *response))success
                                          failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey]};
    NSURLSessionDataTask *task =  [self POST:ShopOrderListRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: -- 订单银联支付交易流水号接口
//type: 分类，1:充值余额 2:商品购买
- (NSURLSessionDataTask *)requestOrderUnionpayRN:(NSString *)orderId
                                            type:(TPPayTNType)type
                                         success:(void (^)(YHTTPResponse *response))success
                                         failure:(void (^)(NSString *msg))failure {
    self.tnType = TPPayTNTypeShopping;
    
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"orderId":orderId,@"type":[NSString integerToString:type]};
    NSURLSessionDataTask *task =  [self POST:UnionpayRnRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARKA: -- 订单查询支付结果
- (NSURLSessionDataTask *)requestOrderUnionpayQuery:(NSString *)orderId
                                               type:(TPPayTNType)type
                                            success:(void (^)(YHTTPResponse *response))success
                                            failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey],@"orderId":orderId,@"type":[NSString integerToString:type]};
    NSURLSessionDataTask *task =  [self POST:UnionpayQueryRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
/***************--------商城相关接口------------*************************************/


/***************--------好友相关接口------------*************************************/
//MARK: -- 获取好友列表
- (NSURLSessionDataTask *)requestFriendListSuccess:(void (^)(YHTTPResponse *response))success
                                           failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey]};
    NSURLSessionDataTask *task =  [self POST:FriendListRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
//MARK: -- 添加好友
- (NSURLSessionDataTask *)requestAddFriend:(NSString *)friendId
                                     phone:(NSString *)phoneNumber
                                   success:(void (^)(YHTTPResponse *response))success
                                   failure:(void (^)(NSString *msg))failure {
    NSMutableDictionary *dic = NSMutableDictionary.new;
    
    if (friendId.length > 0) {
        [dic setValue:friendId forKey:@"userId"];
    }
    
    [dic setValue:phoneNumber forKey:@"phone"];
    [dic setValue:[YUtil getUserDefaultInfo:YHTTPRequestTokenKey] forKey:@"token"];

    NSURLSessionDataTask *task =  [self POST:FriendAddRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 发布朋友圈
- (NSURLSessionDataTask *)requestAddFriendArticle:(NSString *)content
                                       imageFiles:(NSArray *)imageFiles
                                          success:(void (^)(YHTTPResponse *response))success
                                          failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey], @"content":content, @"FriendArticleFiles[file][]":imageFiles};
    NSURLSessionDataTask *task =  [self POST:FriendAddArticleRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}

//MARK: -- 获取朋友圈列表
- (NSURLSessionDataTask *)requestFriendArticle:(NSString *)page
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure {
    NSDictionary *dic = @{@"token":[YUtil getUserDefaultInfo:YHTTPRequestTokenKey], @"page":page, @"size":TPRequestPageSize};
    NSURLSessionDataTask *task =  [self POST:FriendArticleRequest parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YHTTPResponse *response = [[YHTTPResponse alloc] initWithResponseObject:responseObject parsedResult:responseObject[@"data"]];
        success(response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@",error.localizedDescription);
        failure(error.localizedDescription);
    }];
    
    return task;
}
/***************--------好友相关接口------------*************************************/

//MARK: -- lazyload area
//MARK: -- lazyload
- (TPUser *)currentUser {
    if (!_currentUser) {
        _currentUser = TPUser.new;
    }
    
    return _currentUser;
}

@end

