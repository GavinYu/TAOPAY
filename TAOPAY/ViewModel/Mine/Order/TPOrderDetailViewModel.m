//
//  TPOrderDetailViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderDetailViewModel.h"

#import "YHTTPService.h"
#import "TPAppConfig.h"

#import "TPOrderInfoModel.h"
#import "TPAddressModel.h"

@interface TPOrderDetailViewModel ()

@property (readwrite, copy, nonatomic) NSString *orderId;
@property (readwrite, strong, nonatomic) TPOrderInfoModel *orderInfoModel;

@end

@implementation TPOrderDetailViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.orderId = params[YViewModelIDKey];
        self.shouldPullDownToRefresh = YES;
    }
    
    return self;
}

//MARK: --  获取订单的详情信息 
- (void)getOrderInfoSuccess:(void(^)(id json))success
                    failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestOrderInfo:self.orderId success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPOrderInfoModel *tmpModel = TPOrderInfoModel.new;
            tmpModel = [TPOrderInfoModel modelWithDictionary:response.parsedResult];
            self.orderInfoModel = tmpModel;
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

//MARK: -- 修改收货地址
- (void)modifyAddress:(TPAddressModel *)addressModel
       withModifyType:(TPAddressModifyType)modifyType
              success:(void(^)(id json))success
              failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestModifyAddress:self.orderInfoModel.address.addressID type:[NSString integerToString:modifyType] areaID:addressModel.addressID address:addressModel.address name:addressModel.name phone:addressModel.phone success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:response.parsedResult];
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        failure(msg);
    }];
}

//MARK: -- 处理订单的详情数据
- (NSArray *)viewModelsWithShopData:(TPOrderInfoModel *)listData {
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:listData.list.count];
    
    [viewModels addObjectsFromArray:listData.list];
    
    return viewModels;
}

@end
