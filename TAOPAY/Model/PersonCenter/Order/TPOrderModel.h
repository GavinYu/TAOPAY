//
//  TPOrderModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPCompanyModel;

@interface TPOrderModel : YObject

//订单ID
@property (copy, nonatomic) NSString *orderId;
//订单状态-- 0:未支付 1:已支付 2:取消 3:退款
@property (copy, nonatomic) NSString *status;
//订单总价
@property (copy, nonatomic) NSString *price;
//订单的商品
@property (strong, nonatomic) NSArray <TPCompanyModel *>*company;

@end
