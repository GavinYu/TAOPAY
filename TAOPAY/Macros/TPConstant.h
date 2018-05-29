//
//  TPConstant.h
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPConstant : NSObject

/// MVVM Without RAC
/// 登录的手机号
FOUNDATION_EXTERN NSString *const TPLoginPhoneKey;
/// TOKEN
FOUNDATION_EXTERN NSString *const TPTokenKey;

////////////////// MVVM ViewModel Params中的key //////////////////
/// MVVM View
/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
/// 传递唯一ID的key：例如：商品id 用户id...
FOUNDATION_EXTERN NSString *const YViewModelIDKey;
/// 传递导航栏title的key：例如 导航栏的title...
FOUNDATION_EXTERN NSString *const YViewModelTitleKey;
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
FOUNDATION_EXTERN NSString *const YViewModelUtilKey;
/// 传递webView Request的key：例如 webView request...
FOUNDATION_EXTERN NSString *const YViewModelRequestKey;

//相关的KEY
//表示是否注册过App
FOUNDATION_EXTERN NSString *const TPIsHaveRegisterKey;
//表示每次运行App
FOUNDATION_EXTERN NSString *const TPAppEverLaunchKey;
//表示是否是第一次运行App
FOUNDATION_EXTERN NSString *const TPAppFirstLaunchKey;


@end
