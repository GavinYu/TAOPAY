//
//  TPShoppingCartGoodsModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingCartGoodsModel.h"

@implementation TPShoppingCartGoodsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsID":@"id",
             @"name":@"name",
             @"price":@"price",
             @"image":@"image",
             @"count":@"count"
             };
}

@end
