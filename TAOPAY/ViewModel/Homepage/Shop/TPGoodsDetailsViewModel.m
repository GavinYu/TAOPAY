//
//  TPGoodsDetailsViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsDetailsViewModel.h"

#import "TPAppConfig.h"
#import "YHTTPService.h"

#import "TPGoodsInfoModel.h"

@interface TPGoodsDetailsViewModel ()

@end

@implementation TPGoodsDetailsViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
        self.shouldMultiSections = YES;
        
        self.goodsID = params[YViewModelIDKey];
    }
    return self;
}

//MARK: -- 获取商品的详情信息
- (void)getGoodsDetailSuccess:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestShopGoodsInfo:self.goodsID success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPGoodsInfoModel *tmpModel = TPGoodsInfoModel.new;
            tmpModel = [TPGoodsInfoModel modelWithDictionary:response.parsedResult];
            self.goodsInfoModel = tmpModel;
            for (int i = 0; i < 2; ++i) {
                [self.dataSource addObject:@[self.goodsInfoModel]];
                [self.goodsImageArray addObject:self.goodsInfoModel.image];
            }
            
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
//MARK: -- 收藏商品
- (void)collectGoodsSuccess:(void(^)(id json))success
                    failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestGoodsCollection:self.goodsID success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:response.message];
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
//MARK: -- 将商品添加到购物车
- (void)addGoodsToShoppingCartSuccess:(void(^)(id json))success
                              failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestAddShoppingCart:self.goodsID success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
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

- (NSMutableArray *)goodsImageArray {
    if (!_goodsImageArray) {
        _goodsImageArray = NSMutableArray.new;
    }
    
    return _goodsImageArray;
}
@end
