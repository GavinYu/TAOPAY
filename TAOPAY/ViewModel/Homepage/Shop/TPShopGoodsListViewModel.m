//
//  TPShopGoodsListViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopGoodsListViewModel.h"

#import "YHTTPService.h"
#import "TPAppConfig.h"

#import "TPGoodsListModel.h"
#import "TPGoodsCategoryModel.h"
#import "TPShopGoodsModel.h"

#import "TPShopGoodsViewModel.h"

@interface TPShopGoodsListViewModel ()

@end

@implementation TPShopGoodsListViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;

        self.shopId = params[YViewModelIDKey];
        self.cat = @"";
        self.cat2 = @"";
    }
    return self;
}

//MARK: -- 获取商家的商品列表信息
- (void)getShopGoodsListSuccess:(void(^)(id json))success
                        failure:(void (^)(NSString *error))failure {
    
    NSInteger page = self.isPullDown?1:(self.page+1);
    
    @weakify(self);
    [[YHTTPService sharedInstance] requestShopGoodsWithCat:self.cat cat2:self.cat2 page:[NSString stringWithFormat:@"%li",(long)page] success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPGoodsListModel *tmpModel = TPGoodsListModel.new;
            tmpModel = [TPGoodsListModel modelWithDictionary:response.parsedResult];
            self.goodsListModel = tmpModel;
            
            /// 转化数据
            NSArray *dataSource = [self viewModelsWithGoodsData:tmpModel];
            /// 添加数据
            [self.dataSource addObjectsFromArray:dataSource];
            //分类
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
- (NSArray *)viewModelsWithGoodsData:(TPGoodsListModel *)goodsListData
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:goodsListData.list.count];
    
    for (TPShopGoodsModel *goods in goodsListData.list) {
        TPShopGoodsViewModel *itemViewModel = [[TPShopGoodsViewModel alloc] initWithGoods:goods];
        [viewModels addObject:itemViewModel];
        
        self.shopImage = goods.image;
    }
    
    return viewModels;
}

//MARK: -- handle ad data
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
