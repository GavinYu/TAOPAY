//
//  TPOrderListModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderListModel.h"

@implementation TPOrderListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list"  : @"TPOrderModel"
             };
}

@end
