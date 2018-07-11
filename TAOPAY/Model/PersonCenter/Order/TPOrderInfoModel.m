//
//  TPOrderInfoModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderInfoModel.h"

@implementation TPOrderInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list"  : @"TPGoodsModel"
             };
}

@end
