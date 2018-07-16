//
//  TPAddressListViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/7.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPAddressListViewModel.h"

#import "TPAppConfig.h"

#import "TPAddressListModel.h"
#import "TPAddressModel.h"

@interface TPAddressListViewModel ()

@end

@implementation TPAddressListViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
    }
    return self;
}

//MARK: --  获取收货地址列表信息
- (void)getAddressListSuccess:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestAddressSuccess:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPAddressListModel *tmpModel = TPAddressListModel.new;
            tmpModel = [TPAddressListModel modelWithDictionary:response.parsedResult];
            
            /// 转化数据
            NSArray *dataSource = [self viewModelsWithGoodsData:tmpModel];
            /// 添加数据
            [self.dataSource addObjectsFromArray:dataSource];
            
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

/// 删除收货地址
- (void)deleteAddress:(NSString *)addressId
              success:(void(^)(id json))success
              failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestDeleteAddress:addressId success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            [self.dataSource removeObject:self.selectedAddressModel];
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

//MARK: -- 处理goodsData
- (NSArray *)viewModelsWithGoodsData:(TPAddressListModel *)addressListData {
    return addressListData.list;
}


@end
