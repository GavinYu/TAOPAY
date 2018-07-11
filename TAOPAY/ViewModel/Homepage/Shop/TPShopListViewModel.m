//
//  TPShopListViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopListViewModel.h"

#import "YHTTPService.h"
#import "TPAppConfig.h"

#import "TPShopListModel.h"
#import "TPGoodsCategoryModel.h"
#import "YLocationModel.h"
#import "TPShopItemViewModel.h"

@implementation TPShopListViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
    
        self.cat = params[YViewModelIDKey];
        
        self.cat2 = @"";
    }
    return self;
}

//// 加载数据
//- (void)loadData:(void (^)(id))success failure:(void (^)(NSError *))failure configFooter:(void (^)(BOOL))configFooter {
//    NSString *tmpLat = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.latitude];
//    NSString *tmpLon = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.longitude];
//    NSInteger page = self.isPullDown?1:(self.page+1);
//
//    @weakify(self);
//    [[YHTTPService sharedInstance] requestShopListWithLatitude:tmpLat longitude:tmpLon cat:self.cat cat2:self.cat2 page:[NSString stringWithFormat:@"%li",(long)page] success:^(YHTTPResponse *response) {
//        @strongify(self);
//        if (response.code == YHTTPResponseCodeSuccess) {
//            if (page == 1) {
//                [self.dataSource removeAllObjects];
//            }
//
//            TPShopListModel *tmpModel = TPShopListModel.new;
//            tmpModel = [TPShopListModel modelWithDictionary:response.parsedResult];
//            self.shopListModel = tmpModel;
//
//            /// 添加数据
//            //FIXME:TODO -- 测试看效果，后续改
//            for (int i = 0; i < 8; ++i) {
//                [self.dataSource addObjectsFromArray:tmpModel.list];
//            }
//
//
//            self.catArray = [self handleCatStrings:tmpModel.category];
//
//            success(@YES);
//        } else {
//            [SVProgressHUD showErrorWithStatus:response.message];
//            NSError *error = [NSError errorWithDomain:NSLocalizedDescriptionKey code:404 userInfo:@{@"error":response.message}];
//            failure(error);
//        }
//    } failure:^(NSString *msg) {
//        [SVProgressHUD showErrorWithStatus:msg];
//    }];
//}

/// 获取商家列表信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getShopListSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure {
    NSString *tmpLat = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.latitude];
    NSString *tmpLon = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.longitude];
    NSInteger page = self.isPullDown?1:(self.page+1);
    
    @weakify(self);
    [[YHTTPService sharedInstance] requestShopListWithLatitude:tmpLat longitude:tmpLon cat:self.cat cat2:self.cat2 page:[NSString stringWithFormat:@"%li",(long)page] success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPShopListModel *tmpModel = TPShopListModel.new;
            tmpModel = [TPShopListModel modelWithDictionary:response.parsedResult];
            self.shopListModel = tmpModel;
            
            /// 转化数据
            NSArray *dataSource = [self viewModelsWithShopData:tmpModel];
            /// 添加数据
            //FIXME:TODO -- 测试看效果，后续改
            for (int i = 0; i < 4; ++i) {
                /// 添加数据
                [self.dataSource addObjectsFromArray:dataSource];
            }
            
//            self.catArray = [self handleCatStrings:tmpModel.category];
            self.catArray = tmpModel.category;
            
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
- (NSArray *)viewModelsWithShopData:(TPShopListModel *)shopListData
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:shopListData.list.count];
    
    for (TPShopModel *shop in shopListData.list) {
        TPShopItemViewModel *itemViewModel = [[TPShopItemViewModel alloc] initWithShop:shop];
        [viewModels addObject:itemViewModel];
    }
    
    return viewModels;
}

//MARK: -- handle cat data
- (NSArray *)handleCatStrings:(NSArray *)catArray {
    NSMutableArray *catString = [NSMutableArray arrayWithCapacity:catArray.count];
    
    [catArray enumerateObjectsUsingBlock:^(TPGoodsCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (YStringIsNotEmpty(obj.name)) {
            [catString addObject:obj.name];
        }
    }];
    
    return catString;
}
@end
