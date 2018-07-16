//
//  TPOrderDetailViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

#import "TPConstEnum.h"

@class TPAddressModel;
@class TPOrderInfoModel;

@interface TPOrderDetailViewModel : TPTableViewModel

@property (readonly ,copy, nonatomic) NSString *orderId;
@property (readonly ,copy, nonatomic) NSString *tn;
@property (readonly, strong, nonatomic) TPOrderInfoModel *orderInfoModel;

/// 获取订单的详情信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getOrderInfoSuccess:(void(^)(id json))success
                    failure:(void (^)(NSString *error))failure;
/// 修改收货地址
- (void)modifyAddress:(TPAddressModel *)addressModel
       withModifyType:(TPAddressModifyType)modifyType
              success:(void(^)(id json))success
              failure:(void (^)(NSString *error))failure;

@end
