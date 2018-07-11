//
//  TPGoodsCategoryModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsCategoryModel.h"

@implementation TPGoodsCategoryModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"categoryID":@"id",
             @"name":@"name"
             };
}

@end
