//
//  TPUserInfoModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/19.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPUserInfoModel.h"

@implementation TPUserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId":@"id",
             @"username":@"username",
             @"nick":@"nick",
             @"info":@"info",
             @"avatar":@"avatar"
             };
}

@end
