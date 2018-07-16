//
//  TPCompanyModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPOrderGoodsModel;

@interface TPCompanyModel : YObject

//商家ID
@property (copy, nonatomic) NSString *companyId;
//商家名称
@property (copy, nonatomic) NSString *name;
//订单的商品
@property (strong, nonatomic) NSArray <TPOrderGoodsModel *>*goods;


@end
