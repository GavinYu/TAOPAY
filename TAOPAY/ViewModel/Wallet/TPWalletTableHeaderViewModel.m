//
//  TPWalletTableHeaderViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletTableHeaderViewModel.h"

#import "TPAppConfig.h"

@implementation TPWalletTableHeaderViewModel

//MARK: 用户更新用户名接口
- (void)userUpdateNickSuccess:(void (^)(id json))success failure:(void (^)(NSError *errorMsg))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestUserUpdateNick:self.nickName success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            [YHTTPService sharedInstance].currentUser = [TPUser modelWithDictionary:response.parsedResult];
            self.user = [TPUser modelWithDictionary:response.parsedResult];
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//MARK: -- 加载用户信息
- (void)loadUserInfoSuccess:(void (^)(id json))success failure:(void (^)(NSError *errorMsg))failure {
    // 子类重载
    [[YHTTPService sharedInstance] requestGetUserInfoWithPhones:nil success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [YHTTPService sharedInstance].currentUser = [TPUser modelWithDictionary:response.parsedResult[@"info"]];
            self.user = [TPUser modelWithDictionary:response.parsedResult[@"info"]];
            success(@YES);
        } else {
            [YUtil removeUserDefaultInfo:YHTTPRequestTokenKey];
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}

@end
