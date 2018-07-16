//
//  TPOrderPayViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderPayViewModel.h"

#import "YHTTPService.h"
#import "TPAppConfig.h"

#import "TPWalletCommonModel.h"
#import "TPRechargeModel.h"

@interface TPOrderPayViewModel ()
@property (readwrite ,copy, nonatomic) NSString *orderId;
@property (readwrite,copy, nonatomic) NSString *tn;
@end

@implementation TPOrderPayViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.orderId = params[YViewModelIDKey];
        
        TPWalletCommonModel *tmpModel = TPWalletCommonModel.new;
        tmpModel.icon = @"icon_logo_small";
        tmpModel.mainTitle = @"淘易付会员卡";
        tmpModel.subTitle = [NSString stringWithFormat:@"卡号%@", [YHTTPService sharedInstance].currentUser.cardNum];
        self.commonModel = tmpModel;
    }
    
    return self;
}

//MARK: --   获取订单的tn信息
- (void)getOrderTnSuccess:(void(^)(id json))success
                  failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestOrderUnionpayRN:self.orderId type:TPPayTNTypeShopping success:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPRechargeModel *tmpModel = [TPRechargeModel modelWithDictionary:response.parsedResult];
            self.tn = tmpModel.tn;
            
            success(@YES);
        } else {
            failure(response.message);
        }
    } failure:^(NSString *msg) {
        failure(msg);
    }];
}

- (void)setCommonModel:(TPWalletCommonModel *)commonModel {
    if (_commonModel != commonModel) {
        _commonModel = commonModel;
        
        [self.dataSource addObject:commonModel];
    }
}

@end
