//
//  TPConstEnum.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#ifndef TPConstEnum_h
#define TPConstEnum_h

/// tababr item tag
typedef NS_ENUM(NSUInteger, TPTabBarItemTagType) {
  TPTabBarItemTagTypeHomepage = 0,    /// 首页
  TPTabBarItemTagTypeFriend,         /// 好友
  TPTabBarItemTagTypeChat,         /// 聊天
  TPTabBarItemTagTypeWallet,          /// 钱包
};

//支付方式
typedef NS_ENUM(NSInteger, TPPayType) {
    TPPayTypeVIP = 0,          //会员卡
    TPPayTypeUnionpay,         //银联
    TPPayTypeWeChat,           //微信
    TPPayTypeAlipay,            //支付宝
    TPPayTypeOther
};

//购物车修改的方式
typedef NS_ENUM(NSInteger, TPCartModifyType) {
    TPCartModifyTypeAdd = 0,
    TPCartModifyTypeSub,
    TPCartModifyTypeCount
};

//导航栏类型
typedef NS_ENUM(NSInteger, TPNavigationType) {
    TPNavigationTypeBlack,
    TPNavigationTypeWhite
};
//订单分类
typedef NS_ENUM(NSInteger, TPOrderType) {
    TPOrderTypeObligation = 0,    /// 待付款
    TPOrderTypeWaitDispatch,         /// 待发货
    TPOrderTypeWaitReceiving,         ///待收货
    TPOrderTypeWaitEvaluate          /// 待评价
};

////订单分类
//typedef NS_ENUM(NSInteger, TPPersonCenterFunctionType) {
//    TPPersonCenterFunctionTypeOrder = 0,    /// 订单
//    TPPersonCenterFunctionTypeIntegral,         /// 待发货
//    TPPersonCenterFunctionTypeInviteFriendGetIntegral,  //邀请好友领积分
//    TPPersonCenterFunctionTypeReceivingAddress,     /// 待评价
//    TPPersonCenterFunctionTypeSetting,         /// 待发货
//    TPPersonCenterFunctionTypeInviteFriendGetIntegral,  //邀请好友领积分
//    TPPersonCenterFunctionType,          /// 待评价
//    TPPersonCenterFunctionTypeIntegral,         /// 待发货
//    TPPersonCenterFunctionTypeInviteFriendGetIntegral,  //邀请好友领积分
//    TPPersonCenterFunctionType          /// 待评价
//};


/// 切换根控制器类型
typedef NS_ENUM(NSUInteger, TPSwitchRootViewControllerFromType) {
  TPSwitchRootViewControllerFromTypeNewFeature = 0,  /// 新特性
  TPSwitchRootViewControllerFromTypeLogin,           /// 登录
  TPSwitchRootViewControllerFromTypeLogout,          /// 登出
};

/// 用户登录的渠道
typedef NS_ENUM(NSUInteger, TPUserLoginChannelType) {
  TPUserLoginChannelTypeQQ = 0,           /// qq登录
  TPUserLoginChannelTypeEmail,            /// 邮箱登录
  TPUserLoginChannelTypeWeChatId,         /// 微信号登录
  TPUserLoginChannelTypePhone,            /// 手机号登录
};

/// 用户性别
typedef NS_ENUM(NSUInteger, TPUserGenderType) {
  TPUserGenderTypeMale =0,           /// 男
  TPUserGenderTypeFemale,         /// 女
};

/// 插件详情说明
typedef NS_ENUM(NSUInteger, TPPlugDetailType) {
  TPPlugDetailTypeLook = 0,     /// 看一看
  TPPlugDetailTypeSearch,       /// 搜一搜
};


#endif /* TPConstEnum_h */
