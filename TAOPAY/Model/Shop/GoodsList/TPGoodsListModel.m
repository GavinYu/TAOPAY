//
//  TPGoodsListModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsListModel.h"

@implementation TPGoodsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"category":@"TPGoodsCategoryModel",
             @"list"  : @"TPShopGoodsModel"
             };
}

@end
