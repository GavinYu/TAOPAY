//
//  TPOrderInfoModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPGoodsModel;
@class TPAddressModel;

@interface TPOrderInfoModel : YObject

//订单详情收货地址
@property (strong, nonatomic) TPAddressModel *address;
//订单详情商品列表
@property (strong, nonatomic) NSArray <TPGoodsModel *>*list;
//订单总价
@property (copy, nonatomic) NSString *total;

@end
