//
//  TPCompanyModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPCompanyModel.h"

@implementation TPCompanyModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"companyId":@"id",
             @"name":@"name",
             @"goods":@"goods"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"goods"  : @"TPOrderGoodsModel"
             };
}

@end
