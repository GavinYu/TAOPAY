//
//  TPBalanceDetailModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPBalanceDetailModel.h"

@implementation TPBalanceDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list"  : @"TPBalanceDetailItemModel"
             };
}
@end
