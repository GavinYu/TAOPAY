//
//  TPRegisterViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@interface TPRegisterViewModel : TPViewModel
/// 手机号
@property (nonatomic, readwrite, copy) NSString *mobilePhone;
/// 验证码
@property (nonatomic, readwrite, copy) NSString *verifyCode;
/// 注册按钮的点击状态
@property (nonatomic, readonly, assign) BOOL validRegister;
/// 验证码的点击状态
@property (nonatomic, readonly, assign) BOOL validAuthCode;

/// 用户注册 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)registerSuccess:(void(^)(id json))success
                failure:(void (^)(NSError *error))failure;
@end
