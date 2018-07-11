//
//  TPShopModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/26.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopModel.h"

@implementation TPShopModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"shopID":@"id",
             @"name":@"name",
             @"image":@"image",
             @"star":@"star",
             @"orderCount":@"orderCount",
             @"goodsCount":@"goodsCount",
             @"distance":@"distance"
             };
}

@end
