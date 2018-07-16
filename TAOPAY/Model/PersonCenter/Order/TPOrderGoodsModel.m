//
//  TPOrderGoodsModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderGoodsModel.h"

@implementation TPOrderGoodsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsId":@"id",
             @"name":@"name",
             @"price":@"price",
             @"image":@"image",
             @"count":@"count",
             @"info":@"info",
             @"companyId":@"company_id"
             };
}

@end
