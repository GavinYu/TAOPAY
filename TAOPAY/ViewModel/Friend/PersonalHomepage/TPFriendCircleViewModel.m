//
//  TPFriendCircleViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/28.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPFriendCircleViewModel.h"

#import "TPAppConfig.h"

#import "TPFriendCircleItemViewModel.h"

#import "TPFriendArticleListModel.h"
#import "TPFriendArticleModel.h"
#import "TPUserInfoModel.h"

@interface TPFriendCircleViewModel ()
@property (readwrite, strong, nonatomic) TPUserInfoModel *userInfoModel;

@end

@implementation TPFriendCircleViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
    }
    return self;
}

//MARK: --  获取朋友圈列表信息
- (void)getFriendCircleListSuccess:(void(^)(id json))success
                           failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestFriendArticle:[NSString integerToString:self.page] success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPFriendArticleListModel *tmpModel = TPFriendArticleListModel.new;
            tmpModel = [TPFriendArticleListModel modelWithDictionary:response.parsedResult];
            self.userInfoModel = tmpModel.info;
            
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }
            
            /// 添加数据
            NSArray *tmpData = [self viewModelsWithFriendArticleData:tmpModel];
            [self.dataSource addObjectsFromArray:tmpData];
            
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

//MARK: -- 处理TPFriendArticleListModel data
- (NSArray *)viewModelsWithFriendArticleData:(TPFriendArticleListModel *)model {
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:model.list.count];
    
    for (TPFriendArticleModel *itemModel in model.list) {
        TPFriendCircleItemViewModel *itemViewModel = [[TPFriendCircleItemViewModel alloc] initWithGoods:itemModel];
        [viewModels addObject:itemViewModel];
    }
    
    return viewModels;
}

@end
