//
//  TPHomepageViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@class TPUser;

@interface TPHomepageViewModel : TPViewModel

////用户信息
//@property (nonatomic, strong) TPUser *user;

/// 获取用户信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getUserInfoSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure;

@end
