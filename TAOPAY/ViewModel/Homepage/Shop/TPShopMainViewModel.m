//
//  TPShopMainViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopMainViewModel.h"

#import "YHTTPService.h"
#import "TPAppConfig.h"

#import "YLocationModel.h"
#import "TPShopHomepageModel.h"
#import "TPBannerModel.h"
#import "TPGoodsModel.h"

#import "TPGoodsViewModel.h"

@implementation TPShopMainViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
        [self configCat1Data];
    }
    return self;
}

//MARK: -- 配置分类数据
- (void)configCat1Data {
    self.cat1Array = @[@"美食",@"酒店住宿",@"休闲娱乐",@"免税店",@"购物"];
}

//MARK: --  获取商城首页信息
- (void)getShopMainSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure {
    NSString *tmpLat = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.latitude];
    NSString *tmpLon = [NSString stringWithFormat:@"%.8f", self.currentLocationModel.currentLocation.coordinate.longitude];
    NSInteger page = self.isPullDown?1:(self.page+1);
    
    @weakify(self);
    [[YHTTPService sharedInstance] requestShopMainWithLatitude:tmpLat longitude:tmpLon page:[NSString stringWithFormat:@"%li",page] success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPShopHomepageModel *tmpModel = TPShopHomepageModel.new;
            tmpModel = [TPShopHomepageModel modelWithDictionary:response.parsedResult];
            self.shopHomepageModel = tmpModel;
            
            self.bannerData = [self bannerImageUrlStringsWithBanners:tmpModel.banner];
            self.adData = [self adImageUrlStringsWithADs:tmpModel.event];
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


//MARK: -- handle banner data
- (NSArray *)bannerImageUrlStringsWithBanners:(NSArray *)banners {
    NSMutableArray *bannerImageUrlString = [NSMutableArray arrayWithCapacity:banners.count];
    
    [banners enumerateObjectsUsingBlock:^(TPBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (YStringIsNotEmpty(obj.image)) {
            [bannerImageUrlString addObject:obj.image];
        } else {
            [bannerImageUrlString addObject:@""];
        }
    }];
    return bannerImageUrlString;
}

//MARK: -- handle ad data
- (NSArray *)adImageUrlStringsWithADs:(NSArray *)ADs {
    NSMutableArray *ADImageUrlString = [NSMutableArray arrayWithCapacity:ADs.count];
    
    [ADs enumerateObjectsUsingBlock:^(TPBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (YStringIsNotEmpty(obj.image)) {
            [ADImageUrlString addObject:obj.image];
        } else {
            [ADImageUrlString addObject:@""];
        }
    }];
    return ADImageUrlString;
}

//MARK: -- 处理goodsData
- (NSArray *)viewModelsWithGoodsData:(TPShopHomepageModel *)goodsData
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:goodsData.lsit.count];
    
    for (TPGoodsModel *goods in goodsData.lsit) {
        TPGoodsViewModel *itemViewModel = [[TPGoodsViewModel alloc] initWithGoods:goods];
        [viewModels addObject:itemViewModel];
    }
    
    return viewModels;
}

//- (NSMutableArray *)bannerData {
//    if (!_bannerData) {
//        _bannerData = NSMutableArray.new;
//    }
//
//    return _bannerData;
//}

@end
