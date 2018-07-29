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

typedef NS_ENUM(NSInteger, TPShoppingCartModifyType) {
    TPShoppingCartModifyTypeAdd = 0,
    TPShoppingCartModifyTypeSub,
    TPShoppingCartModifyTypeNumber
};

typedef NS_ENUM(NSUInteger, TPPayTNType) {
    TPPayTNTypeRecharge = 1,
    TPPayTNTypeShopping
};

typedef void (^requstSuccessBlock) (id success);
typedef void (^faliueBlock) (id error);

@interface YHTTPService : AFHTTPSessionManager

/// currentLoginUser
@property (nonatomic, readwrite, strong) TPUser *currentUser;
@property (nonatomic, readonly, assign) TPPayTNType tnType;

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
//phones: 以“，”分隔
- (NSURLSessionDataTask *)requestGetUserInfoWithPhones:(NSString *)phones
                                               success:(void (^)(YHTTPResponse *response))success
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

//聊天发红包（积分转账）接口
//分类 0:会员之间转账
- (NSURLSessionDataTask *)requestBalanceTransferByMessage:(NSString *)username
                                               withAmount:(NSString *)amount
                                                     type:(NSString *)type
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
//商城首页的接口
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
//商品详情接口
- (NSURLSessionDataTask *)requestShopGoodsInfo:(NSString *)goodsId
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure;
//商品收藏接口
- (NSURLSessionDataTask *)requestGoodsCollection:(NSString *)goodsId
                                         success:(void (^)(YHTTPResponse *response))success
                                         failure:(void (^)(NSString *msg))failure;
//购物车列表接口
- (NSURLSessionDataTask *)requestShoppingCartSuccess:(void (^)(YHTTPResponse *response))success
                                             failure:(void (^)(NSString *msg))failure;
//购物车添加接口
- (NSURLSessionDataTask *)requestAddShoppingCart:(NSString *)goodsId
                                         success:(void (^)(YHTTPResponse *response))success
                                         failure:(void (^)(NSString *msg))failure;
//购物车修改接口
- (NSURLSessionDataTask *)requestModifyShoppingCart:(NSString *)goodsId
                                               type:(NSString *)type
                                              count:(NSString *)count
                                            success:(void (^)(YHTTPResponse *response))success
                                            failure:(void (^)(NSString *msg))failure;
//购物车删除接口
- (NSURLSessionDataTask *)requestDeleteShoppingCart:(NSString *)goodsId
                                            success:(void (^)(YHTTPResponse *response))success
                                            failure:(void (^)(NSString *msg))failure;
//收货地址接口
- (NSURLSessionDataTask *)requestAddressSuccess:(void (^)(YHTTPResponse *response))success
                                                 failure:(void (^)(NSString *msg))failure;
//添加收货地址接口
- (NSURLSessionDataTask *)requestAddAddress:(NSString *)address
                                       name:(NSString *)name
                                      phone:(NSString *)phone
                                     areaID:(NSString *)areaId
                                    success:(void (^)(YHTTPResponse *response))success
                                    failure:(void (^)(NSString *msg))failure;
//修改收货地址接口

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
                                       failure:(void (^)(NSString *msg))failure;
//删除收货地址接口
- (NSURLSessionDataTask *)requestDeleteAddress:(NSString *)addressId
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure;
//省份城市地区列表接口
- (NSURLSessionDataTask *)requestAreaList:(NSString *)areaId
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure;
//创建订单接口
- (NSURLSessionDataTask *)requestShopOrderAdd:(NSArray *)goodsId
                              withGoodsNumber:(NSArray *)goodsNum
                                withAddressId:(NSString *)addressId
                                      success:(void (^)(YHTTPResponse *response))success
                                      failure:(void (^)(NSString *msg))failure;
//订单详情接口
- (NSURLSessionDataTask *)requestOrderInfo:(NSString *)orderId
                                   success:(void (^)(YHTTPResponse *response))success
                                   failure:(void (^)(NSString *msg))failure;
//订单列表接口
- (NSURLSessionDataTask *)requestOrderListSuccess:(void (^)(YHTTPResponse *response))success
                                          failure:(void (^)(NSString *msg))failure;
//订单银联支付交易流水号接口
//type: 分类，1:充值余额 2:商品购买
- (NSURLSessionDataTask *)requestOrderUnionpayRN:(NSString *)orderId
                                            type:(TPPayTNType)type
                                         success:(void (^)(YHTTPResponse *response))success
                                         failure:(void (^)(NSString *msg))failure;
//订单查询支付结果
//type:分类，1:钱包充值 2:购物支付
- (NSURLSessionDataTask *)requestOrderUnionpayQuery:(NSString *)orderId
                                               type:(TPPayTNType)type
                                            success:(void (^)(YHTTPResponse *response))success
                                            failure:(void (^)(NSString *msg))failure;

/***************--------商城相关接口------------*************************************/

/***************--------好友相关接口------------*************************************/
//获取好友列表
- (NSURLSessionDataTask *)requestFriendListSuccess:(void (^)(YHTTPResponse *response))success
                                           failure:(void (^)(NSString *msg))failure;
//添加好友
- (NSURLSessionDataTask *)requestAddFriend:(NSString *)friendId
                                     phone:(NSString *)phoneNumber
                                   success:(void (^)(YHTTPResponse *response))success
                                   failure:(void (^)(NSString *msg))failure;
//发布朋友圈
- (NSURLSessionDataTask *)requestAddFriendArticle:(NSString *)content
                                       imageFiles:(NSArray *)imageFiles
                                          success:(void (^)(YHTTPResponse *response))success
                                          failure:(void (^)(NSString *msg))failure;
//获取朋友圈列表
- (NSURLSessionDataTask *)requestFriendArticle:(NSString *)page
                                       success:(void (^)(YHTTPResponse *response))success
                                       failure:(void (^)(NSString *msg))failure;
/***************--------好友相关接口------------*************************************/




@end
