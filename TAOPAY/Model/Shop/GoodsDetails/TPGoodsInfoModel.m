//
//  TPGoodsInfoModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/30.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsInfoModel.h"

@implementation TPGoodsInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsID":@"id",
             @"name":@"name",
             @"info":@"info",
             @"sinfo":@"sinfo",
             @"price":@"price",
             @"originPrice":@"originPrice",
             @"image":@"image"
             };
}

@end
