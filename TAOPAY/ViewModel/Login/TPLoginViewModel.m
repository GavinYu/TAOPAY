//
//  TPLoginViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/4/13.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPLoginViewModel.h"

#import "TPUser.h"
#import "TPAppConfig.h"


@interface TPLoginViewModel ()

@end


@implementation TPLoginViewModel
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

- (void)loginSuccess:(void (^)(id json))success failure:(void (^)(NSError *))failure{
    [SVProgressHUD showWithStatus:@"登录中..."];
    @weakify(self);
    [[YHTTPService sharedInstance] requestLoginWithPhoneNumber:self.mobilePhone password:self.password success:^(YHTTPResponse *response) {
        [SVProgressHUD dismiss];
        
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            self.token = response.parsedResult[TPTokenKey];
            [YUtil saveUserDefaultInfo:self.mobilePhone forKey:TPLoginPhoneKey];
            [YUtil saveUserDefaultInfo:self.token forKey:YHTTPRequestTokenKey];
            [YHTTPService sharedInstance].currentUser = [TPUser modelWithDictionary:response.parsedResult];
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//MARK: -- Setter validLogin
- (BOOL)validLogin {
    return (YStringIsNotEmpty(self.mobilePhone) && YStringIsNotEmpty(self.password));
}

@end
