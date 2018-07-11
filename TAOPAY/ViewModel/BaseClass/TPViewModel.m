//
//  TPViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TPConstant.h"
#import "TPUser.h"

@interface TPViewModel ()
/// The `params` parameter in `-initWithServices:params` method.
@property (nonatomic, readwrite, copy) NSDictionary *params;

@end
@implementation TPViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init])
    {
        self.params = params;
        self.title = params[YViewModelTitleKey];
    }
    return self;
}

/// request remote data
- (void)loadData:(void(^)(id json))success
         failure:(void (^)(NSError *error))failure {
    // 子类重载
}

- (TPUser *)user {
    if (!_user) {
        _user = TPUser.new;
    }
    
    return _user;
}

@end
