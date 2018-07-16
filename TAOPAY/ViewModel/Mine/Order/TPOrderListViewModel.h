//
//  TPOrderListViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@class TPOrderListModel;

@interface TPOrderListViewModel : TPTableViewModel

@property (readonly ,strong, nonatomic) TPOrderListModel *orderListModel;

/// 获取我的订单列表信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getOrderListSuccess:(void(^)(id json))success
                    failure:(void (^)(NSString *error))failure;

@end
