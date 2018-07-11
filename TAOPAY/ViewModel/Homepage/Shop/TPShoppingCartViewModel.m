//
//  TPShoppingCartViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingCartViewModel.h"

#import "TPAppConfig.h"
#import "YHTTPService.h"

#import "TPShoppingCartModel.h"
#import "TPShoppingCartGoodsModel.h"
#import "TPWalletModel.h"

#import "TPCartGoodsViewModel.h"

@interface TPShoppingCartViewModel ()

@end

@implementation TPShoppingCartViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullUpToLoadMore = NO;
        self.shouldPullDownToRefresh = YES;
        self.shouldMultiSections = YES;
    }
    return self;
}

//MARK: -- config PayWay data
- (NSArray *)configPayWayData {
    NSMutableArray *tmpArr = NSMutableArray.new;
    
    TPWalletModel *itemModel = TPWalletModel.new;
    itemModel.icon = @"icon_pay_logo";
    itemModel.content = @"会员卡支付";
    itemModel.type = [NSString integerToString:TPPayTypeVIP];
    [tmpArr addObject:itemModel];
    
    TPWalletModel *itemModel1 = TPWalletModel.new;
    itemModel1.icon = @"icon_unionPay";
    itemModel1.content = @"银联卡支付";
    itemModel1.type = [NSString integerToString:TPPayTypeUnionpay];
    [tmpArr addObject:itemModel1];
    
    TPWalletModel *itemModel2 = TPWalletModel.new;
    itemModel2.icon = @"icon_pay_wechat";
    itemModel2.content = @"微信支付";
    itemModel2.type = [NSString integerToString:TPPayTypeWeChat];
    [tmpArr addObject:itemModel2];
    
    TPWalletModel *itemModel3 = TPWalletModel.new;
    itemModel3.icon = @"icon_pay_alipay";
    itemModel3.content = @"支付宝";
    itemModel3.type = [NSString integerToString:TPPayTypeAlipay];
    [tmpArr addObject:itemModel3];
    
    return tmpArr;
}


//MARK: --  获取购物车列表信息
- (void)getShoppingCartListSuccess:(void(^)(id json))success
                           failure:(void (^)(NSString *error))failure {
    @weakify(self);
    [[YHTTPService sharedInstance] requestShoppingCartSuccess:^(YHTTPResponse *response) {
        @strongify(self);
        if (response.code == YHTTPResponseCodeSuccess) {
            TPShoppingCartModel *tmpModel = TPShoppingCartModel.new;
            tmpModel = [TPShoppingCartModel modelWithDictionary:response.parsedResult];
            self.shoppingCartModel = tmpModel;
            //添加收货地址
            if (tmpModel.address) {
                [self.dataSource addObject:@[tmpModel.address]];
            } else {
                [self.dataSource addObject:@[]];
            }
            
            if (tmpModel.list.count > 0) {
                //判断是否是支付页的购物车
                if (self.isPayPage) {
                    [self.dataSource addObject:[self configPayWayData]];
                    /// 添加商品数据
                    [self.dataSource addObject:tmpModel.list];
                } else {
                    /// 转化数据
                    NSArray *dataSource = [self viewModelsWithGoodsData:tmpModel];
                    /// 添加商品数据
                    [self.dataSource addObject:dataSource];
                }
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

//MARK: -- 修改购物车的信息
- (void)modifyShoppingCartWithGoodsViewModel:(TPCartGoodsViewModel *)goodsViewModel
                                     success:(void(^)(id json))success
                                     failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestModifyShoppingCart:goodsViewModel.goodId type:[NSString stringWithFormat:@"%li",self.modifyType] count:goodsViewModel.goodsCount success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:response.parsedResult];
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

//MARK: -- 删除购物车的商品信息
- (void)deleteShoppingCartWithGoodsViewModel:(TPCartGoodsViewModel *)goodsViewModel
                                     success:(void(^)(id json))success
                                     failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestDeleteShoppingCart:goodsViewModel.goodId success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:response.parsedResult];
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

//MARK: -- 处理shoppingCartGoodsData
- (NSArray *)viewModelsWithGoodsData:(TPShoppingCartModel *)shoppingCartModel
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:shoppingCartModel.list.count];
    
    for (TPShoppingCartGoodsModel *goods in shoppingCartModel.list) {
        TPCartGoodsViewModel *itemViewModel = [[TPCartGoodsViewModel alloc] initWithGoods:goods];
        [viewModels addObject:itemViewModel];
    }
    
    return viewModels;
}

@end
