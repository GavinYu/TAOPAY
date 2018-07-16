//
//  TPOrderListModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPOrderModel;

@interface TPOrderListModel : YObject

//订单列表
@property (strong, nonatomic) NSMutableArray <TPOrderModel *>*list;

@end
