//
//  TPOrderModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderModel.h"

@implementation TPOrderModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"company"  : @"TPCompanyModel"
             };
}

@end
