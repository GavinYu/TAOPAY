//
//  TPGoodsModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsModel.h"

@implementation TPGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"company_id":@"company_id",
             @"goodsID":@"id",
             @"name":@"name",
             @"info":@"info",
             @"price":@"price",
             @"originPrice":@"originPrice",
             @"image":@"image",
             @"orderCount":@"orderCount",
             @"distance":@"distance"
             };
}

@end
