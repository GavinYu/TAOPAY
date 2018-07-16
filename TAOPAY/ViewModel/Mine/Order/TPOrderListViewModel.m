//
//  TPOrderListViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderListViewModel.h"

#import "YHTTPService.h"
#import "TPAppConfig.h"

#import "TPOrderListModel.h"
#import "TPOrderModel.h"
#import "TPOrderGoodsModel.h"
#import "TPCompanyModel.h"

@interface TPOrderListViewModel ()

@property (readwrite, strong, nonatomic) TPOrderListModel *orderListModel;

@end

@implementation TPOrderListViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = YES;
        self.shouldPullDownToRefresh = YES;
        self.shouldMultiSections = YES;
    }
    
    return self;
}

//MARK: --  获取我的订单列表信息 
- (void)getOrderListSuccess:(void(^)(id json))success
                    failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestOrderListSuccess:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPOrderListModel *tmpModel = TPOrderListModel.new;
            tmpModel = [TPOrderListModel modelWithDictionary:response.parsedResult];
            self.orderListModel = tmpModel;
            /// 转化数据
            NSArray *dataSource = [self viewModelsWithShopData:tmpModel];
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

//MARK: -- 处理订单列表数据
- (NSArray *)viewModelsWithShopData:(TPOrderListModel *)listData
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:listData.list.count];
    
    for (int i = 0; i < listData.list.count; ++i) {
        TPOrderModel *itemOrderModel = listData.list[i];
        NSMutableArray *tmpOrderArr = NSMutableArray.new;
        [itemOrderModel.company enumerateObjectsUsingBlock:^(TPCompanyModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tmpOrderArr addObject:obj];
            [obj.goods enumerateObjectsUsingBlock:^(TPOrderGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tmpOrderArr addObject:obj];
            }];
        }];
        
        [viewModels addObject:tmpOrderArr];
    }
    
    return viewModels;
}

@end
