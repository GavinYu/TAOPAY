//
//  TPFriendCircleViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@class TPUserInfoModel;

@interface TPFriendCircleViewModel : TPTableViewModel

@property (readonly, strong, nonatomic) TPUserInfoModel *userInfoModel;

/// 获取朋友圈列表信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getFriendCircleListSuccess:(void(^)(id json))success
                           failure:(void (^)(NSString *error))failure;


@end
