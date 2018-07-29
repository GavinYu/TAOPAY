//
//  TPUserInfoListModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPUserInfoListModel.h"

@implementation TPUserInfoListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"info"  : @"TPUserInfoModel"
             };
}

@end
