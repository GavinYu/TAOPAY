//
//  TPPersonalHomepageViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonalHomepageViewModel.h"

#import "TPAppConfig.h"

@implementation TPPersonalHomepageViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
    }
    return self;
}

//MARK: --  获取消息列表信息
- (void)getMessageListSuccess:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure {
    
}

@end
