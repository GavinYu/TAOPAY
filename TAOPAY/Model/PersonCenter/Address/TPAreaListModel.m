//
//  TPAreaListModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAreaListModel.h"

@implementation TPAreaListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"list"  : @"TPAreaModel"
             };
}
@end
