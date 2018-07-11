//
//  TPShopGoodsListViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPCollectionViewModel.h"

@class TPGoodsListModel;

@interface TPShopGoodsListViewModel : TPCollectionViewModel

@property (strong, nonatomic) TPGoodsListModel *goodsListModel;
@property (copy, nonatomic) NSString *shopId;
@property (copy, nonatomic) NSString *cat;
@property (copy, nonatomic) NSString *cat2;
@property (strong, nonatomic) NSArray *catArray;


/// 获取商家的商品列表信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getShopGoodsListSuccess:(void(^)(id json))success
                        failure:(void (^)(NSString *error))failure;

@end
