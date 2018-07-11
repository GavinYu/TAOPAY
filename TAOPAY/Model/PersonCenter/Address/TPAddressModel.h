//
//  TPAddressModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPAddressModel : YObject

//地址ID
@property (copy, nonatomic) NSString *addressID;
//收货人姓名
@property (copy, nonatomic) NSString *name;
//收货人手机号
@property (copy, nonatomic) NSString *phone;
//详细地址
@property (copy, nonatomic) NSString *address;
//默认地址
@property (copy, nonatomic) NSString *defaultAddress;

@end
