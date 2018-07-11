//
//  TPShoppingCartViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

#import "TPConstEnum.h"

@class TPShoppingCartModel;
@class TPAddressModel;
@class TPWalletModel;
@class TPCartGoodsViewModel;

@interface TPShoppingCartViewModel : TPTableViewModel

@property (strong, nonatomic) TPShoppingCartModel *shoppingCartModel;
@property (strong, nonatomic) TPAddressModel *selectAddressModel;
@property (assign, nonatomic) BOOL isPayPage;
@property (strong, nonatomic) TPWalletModel *selectedPayWay;

//修改方式，0:增加一个 1:减少一个 2: 修改成指定数量
@property (assign, nonatomic) TPCartModifyType modifyType;

/// 获取购物车列表信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getShoppingCartListSuccess:(void(^)(id json))success
                           failure:(void (^)(NSString *error))failure;

//修改购物车的信息
- (void)modifyShoppingCartWithGoodsViewModel:(TPCartGoodsViewModel *)goodsViewModel
                                     success:(void(^)(id json))success
                                     failure:(void (^)(NSString *error))failure;
// 删除购物车的商品信息
- (void)deleteShoppingCartWithGoodsViewModel:(TPCartGoodsViewModel *)goodsViewModel
                                     success:(void(^)(id json))success
                                     failure:(void (^)(NSString *error))failure;


@end
