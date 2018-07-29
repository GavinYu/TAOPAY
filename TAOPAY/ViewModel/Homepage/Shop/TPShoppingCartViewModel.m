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
#import "TPRechargeModel.h"
#import "TPAddressModel.h"

#import "TPCartGoodsViewModel.h"

@interface TPShoppingCartViewModel ()

@property (readwrite, copy, nonatomic) NSString *currentOrderId;
@property (readwrite, strong, nonatomic) TPRechargeModel *currentTNModel;

@property (readwrite, strong, nonatomic) NSArray *goodsIds;
@property (readwrite, strong, nonatomic) NSArray *goodsNumbers;
@property (readwrite, copy, nonatomic) NSString *addressId;

@end

@implementation TPShoppingCartViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super initWithParams:params];
    if (self) {
        self.shouldPullDownToRefresh = YES;
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
    
//    TPWalletModel *itemModel2 = TPWalletModel.new;
//    itemModel2.icon = @"icon_pay_wechat";
//    itemModel2.content = @"微信支付";
//    itemModel2.type = [NSString integerToString:TPPayTypeWeChat];
//    [tmpArr addObject:itemModel2];
//
//    TPWalletModel *itemModel3 = TPWalletModel.new;
//    itemModel3.icon = @"icon_pay_alipay";
//    itemModel3.content = @"支付宝";
//    itemModel3.type = [NSString integerToString:TPPayTypeAlipay];
//    [tmpArr addObject:itemModel3];
    
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
            
            self.selectAddressModel = tmpModel.address;

            if (tmpModel.list.count > 0) {
                //判断是否是支付页的购物车
                if (self.isPayPage) {
                    /// 添加商品数据
                    [self.dataSource addObject:tmpModel.list];
                    //添加支付方式
                    
                    [self.dataSource addObject:[self configPayWayData]];
                    //计算支付总价
                    self.totalPayMoney = [self accountTotalPayMoneyForPayPage:tmpModel.list];
                    
                } else {
                    /// 转化数据
                    NSArray *dataSource = [self viewModelsWithGoodsData:tmpModel];
                    /// 添加商品数据
                    if (self.page == 1) {
                        [self.dataSource removeAllObjects];
                    }
                    [self.dataSource addObjectsFromArray:dataSource];
                    //计算支付总价
                    self.totalPayMoney = [self accountTotalPayMoney:dataSource];
                }
                //处理待支付的购物车
                [self handleGoodsInfo];
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

//MARK: --  创建订单
- (void)createOrder:(NSArray *)goodsIds
       withGoodsNum:(NSArray *)goodsNum
      withAddressId:(NSString *)addressId
            success:(void(^)(id json))success
            failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestShopOrderAdd:goodsIds withGoodsNumber:goodsNum withAddressId:addressId success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            self.currentOrderId = response.parsedResult[@"orderId"];
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

//MARK: -- 创建银联支付交易流水号
- (void)createUnionpay:(NSString *)orderId
              withType:(NSString *)type
               success:(void(^)(id json))success
               failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestOrderUnionpayRN:self.currentOrderId type:TPPayTNTypeShopping success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            TPRechargeModel *tmpModel = [TPRechargeModel modelWithDictionary:response.parsedResult];
            self.currentTNModel = tmpModel;
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//MARK: -- 查询订单支付结果
- (void)queryOrderPayResult:(NSString *)orderId
                    success:(void(^)(id json))success
                    failure:(void (^)(NSString *error))failure {
    [[YHTTPService sharedInstance] requestOrderUnionpayQuery:orderId type:TPPayTNTypeShopping success:^(YHTTPResponse *response) {
        if (response.code == YHTTPResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:response.parsedResult];
            success(@YES);
        } else {
            [SVProgressHUD showErrorWithStatus:response.message];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

//MARK: -- 计算支付总价
- (NSString *)accountTotalPayMoney:(NSArray *)goodsViewModelArray {
    CGFloat total = 0;
    for (TPCartGoodsViewModel *obj in goodsViewModelArray) {
        total += [obj.goodsTotalPrice floatValue];
    }
    
    return [NSString stringWithFormat:@"%.2f", total];
}
//MARK: -- 计算支付页面的支付总价
- (NSString *)accountTotalPayMoneyForPayPage:(NSArray *)goodsArray {
    CGFloat total = 0;
    for (TPShoppingCartGoodsModel *obj in goodsArray) {
        CGFloat goodsTotalPrice = [obj.price floatValue] * [obj.count integerValue];
        total += goodsTotalPrice;
    }
    
    return [NSString stringWithFormat:@"%.2f", total];
}

//MARK: -- 处理shoppingCartGoodsData
- (NSArray *)viewModelsWithGoodsData:(TPShoppingCartModel *)shoppingCartModel
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:shoppingCartModel.list.count];
    
    for (TPShoppingCartGoodsModel *goods in shoppingCartModel.list) {
        TPCartGoodsViewModel *itemViewModel = [[TPCartGoodsViewModel alloc] initWithGoods:goods];
        [viewModels addObject:itemViewModel];
        
        [self.selectedArray addObject:itemViewModel];
    }
    
    return viewModels;
}

//MARK: -- lazyload selectedArray
- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    
    return _selectedArray;
}

//MARK: -- 处理购物车数据，得到
- (void)handleGoodsInfo {
    NSMutableArray *goodsIdArr = [[NSMutableArray alloc] initWithCapacity:self.shoppingCartModel.list.count];
    NSMutableArray *goodsNumArr = [[NSMutableArray alloc] initWithCapacity:self.shoppingCartModel.list.count];
    for (TPShoppingCartGoodsModel *itemModel in self.shoppingCartModel.list) {
        [goodsIdArr addObject:itemModel.goodsID];
        [goodsNumArr addObject:itemModel.count];
    }
    
    self.goodsIds = goodsIdArr;
    self.goodsNumbers = goodsNumArr;
}

- (void)setSelectAddressModel:(TPAddressModel *)selectAddressModel {
    if (_selectAddressModel != selectAddressModel) {
        _selectAddressModel = selectAddressModel;
        
        self.addressId = _selectAddressModel.addressID;
    }
}

@end
