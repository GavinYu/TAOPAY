//
//  TPAddressModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAddressModel.h"

@implementation TPAddressModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"addressID":@"id",
             @"name":@"name",
             @"phone":@"phone",
             @"address":@"address",
             @"defaultAddress":@"default",
             };
}

@end
