//
//  TPAddressListViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/7.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@interface TPAddressListViewModel : TPTableViewModel


/// 获取收货地址列表信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getAddressListSuccess:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure;

@end
