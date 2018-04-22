//
//  TPConstant.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPConstant.h"

@implementation TPConstant

/// 登录的手机号
NSString *const TPLoginPhoneKey = @"TPLoginPhoneKey";
/// TOKEN
NSString *const TPTokenKey = @"token";

////////////////// MVVM ViewModel Params中的key //////////////////
/// MVVM View
/// The base map of 'params'
/// The `params` parameter in `-initWithParams:` method.
/// Key-Values's key
/// 传递唯一ID的key：例如：商品id 用户id...
NSString *const YViewModelIDKey = @"YViewModelIDKey";
/// 传递导航栏title的key：例如 导航栏的title...
NSString *const YViewModelTitleKey = @"YViewModelTitleKey";
/// 传递数据模型的key：例如 商品模型的传递 用户模型的传递...
NSString *const YViewModelUtilKey = @"YViewModelUtilKey";
/// 传递webView Request的key：例如 webView request...
NSString *const YViewModelRequestKey = @"YViewModelRequestKey";

@end
