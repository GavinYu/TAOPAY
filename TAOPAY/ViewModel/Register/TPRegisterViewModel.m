//
//  TPRegisterViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/4/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPRegisterViewModel.h"

#import "TPAppConfig.h"

@implementation TPRegisterViewModel
{
    FBKVOController *_KVOController;
}

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _KVOController = [FBKVOController controllerWithObserver:self];
    @weakify(self);
    [_KVOController y_observe:self keyPath:@"mobilePhone" block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self);
        NSString *mobilePhone = change[NSKeyValueChangeNewKey];
        if (![NSString y_isValidMobile:mobilePhone]) {
            return ;
        }
        /// 模拟从数据库获取用户头像的数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.75f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (void)registerSuccess:(void(^)(id json))success
                failure:(void (^)(NSError *error))failure {
    [SVProgressHUD showWithStatus:@"注册中..."];
    @weakify(self);
    [[YHTTPService sharedInstance] requestRegisterWithPhoneNumber:self.mobilePhone authCode:self.verifyCode password:self.password success:^(YHTTPResponse *response) {
        [SVProgressHUD dismiss];
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            self.token = response.parsedResult[TPTokenKey];
            [YUtil saveUserDefaultInfo:self.token forKey:YHTTPRequestTokenKey];
            [YUtil saveUserDefaultInfo:[NSNumber numberWithBool:YES] forKey:TPIsHaveRegisterKey];
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)getAuthCodeSuccess:(void(^)(id json))success
                   failure:(void (^)(NSError *error))failure {
    [[YHTTPService sharedInstance] requestAuthCodeWithPhoneNumber:self.mobilePhone success:^(YHTTPResponse *response) {
        [SVProgressHUD dismiss];
        if (response.code == YHTTPResponseCodeSuccess) {
            success(@(YES));
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (BOOL)validRegister {
    return (YStringIsNotEmpty(self.mobilePhone) && YStringIsNotEmpty(self.verifyCode) && YStringIsNotEmpty(self.password));
}

- (BOOL)validAuthCode {
    return [NSString y_isValidMobile:self.mobilePhone];
}

@end
