//
//  TPLoginViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@class YHTTPResponse;

@interface TPLoginViewModel : TPViewModel
/// 手机号
@property (nonatomic, readwrite, copy) NSString *mobilePhone;
/// 密码
@property (nonatomic, readwrite, copy) NSString *password;
/// 登录按钮的点击状态
@property (nonatomic, readonly, assign) BOOL validLogin;

/// 用户登录 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)loginSuccess:(void(^)(id json))success
                failure:(void (^)(NSError *error))failure;

@end
