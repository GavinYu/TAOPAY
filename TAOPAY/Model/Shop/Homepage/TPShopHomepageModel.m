//
//  TPShopHomepageModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopHomepageModel.h"

@implementation TPShopHomepageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"banner":@"TPBannerModel",
             @"event" :@"TPBannerModel",
             @"lsit"  :@"TPGoodsModel"};
}

@end
