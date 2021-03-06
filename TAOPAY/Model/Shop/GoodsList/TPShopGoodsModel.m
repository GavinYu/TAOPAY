//
//  TPShopGoodsModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopGoodsModel.h"

@implementation TPShopGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsID":@"id",
             @"name":@"name",
             @"price":@"price",
             @"image":@"image",
             @"orderCount":@"orderCount",
             @"star":@"star"
             };
}

@end
