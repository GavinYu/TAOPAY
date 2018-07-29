//
//  TPPersonalHomepageViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonalHomepageViewModel.h"

#import "TPAppConfig.h"

#import "TPFriendListModel.h"

@interface TPPersonalHomepageViewModel ()
@property (readwrite, strong, nonatomic) TPUserInfoModel *userInfoModel;

@end

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

//MARK: --  获取好友列表信息
- (void)getMessageListSuccess:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestFriendListSuccess:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPFriendListModel *tmpModel = TPFriendListModel.new;
            tmpModel = [TPFriendListModel modelWithDictionary:response.parsedResult];
            self.userInfoModel = tmpModel.info;
            
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }
            
            /// 添加数据
            [self.dataSource addObjectsFromArray:tmpModel.list];
            
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
            failure(response.message);
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        failure(msg);
    }];
}

@end
