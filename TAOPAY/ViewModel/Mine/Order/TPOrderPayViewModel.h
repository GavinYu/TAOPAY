//
//  TPOrderPayViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@class TPWalletCommonModel;

@interface TPOrderPayViewModel : TPTableViewModel

@property (strong, nonatomic) TPWalletCommonModel *commonModel;
@property (readonly ,copy, nonatomic) NSString *orderId;
@property (readonly ,copy, nonatomic) NSString *tn;
@property (copy, nonatomic) NSString *payPrice;

/// 获取订单的tn信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getOrderTnSuccess:(void(^)(id json))success
                  failure:(void (^)(NSString *error))failure;

@end
