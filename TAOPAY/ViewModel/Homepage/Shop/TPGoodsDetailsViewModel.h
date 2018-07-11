//
//  TPGoodsDetailsViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@class TPGoodsInfoModel;

@interface TPGoodsDetailsViewModel : TPTableViewModel

@property (copy, nonatomic) NSString *goodsID;
@property (strong, nonatomic) TPGoodsInfoModel *goodsInfoModel;
@property (strong, nonatomic) NSMutableArray *goodsImageArray;

/// 获取商品的详情信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getGoodsDetailSuccess:(void(^)(id json))success
                      failure:(void (^)(NSString *error))failure;
- (void)collectGoodsSuccess:(void(^)(id json))success
                    failure:(void (^)(NSString *error))failure;
- (void)addGoodsToShoppingCartSuccess:(void(^)(id json))success
                              failure:(void (^)(NSString *error))failure;

@end
