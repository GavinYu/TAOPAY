//
//  TPAreaModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAreaModel.h"

@implementation TPAreaModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"areaID":@"id",
             @"name":@"name"
             };
}

@end
