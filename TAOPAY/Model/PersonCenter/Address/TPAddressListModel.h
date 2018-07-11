//
//  TPAddressListModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPAddressModel;

@interface TPAddressListModel : YObject

//地址列表
@property (strong, nonatomic) NSMutableArray <TPAddressModel *>*list;

@end
