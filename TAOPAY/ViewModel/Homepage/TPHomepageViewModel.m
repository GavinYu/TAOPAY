//
//  TPHomepageViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/6.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPHomepageViewModel.h"

#import "TPAppConfig.h"
#import "YHTTPService.h"

@interface TPHomepageViewModel ()


@end

@implementation TPHomepageViewModel
////MARK: -- lazyload user
//- (TPUser *)user {
//    if (!_user) {
//        _user = TPUser.new;
//    }
//
//    return _user;
//}

//MARK: --  获取用户信息
- (void)getUserInfoSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestGetUserInfoWithPhones:nil success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [YHTTPService sharedInstance].currentUser = [TPUser modelWithDictionary:response.parsedResult[@"info"]];
            self.user = [TPUser modelWithDictionary:response.parsedResult[@"info"]];
            success(@YES);
        } else {
            [YUtil removeUserDefaultInfo:YHTTPRequestTokenKey];
//            [SVProgressHUD showErrorWithStatus:response.message];
            failure(response.message);
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

@end
