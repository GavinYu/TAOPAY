//
//  TPShopGoodsViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@class TPShopGoodsModel;

@interface TPShopGoodsViewModel : TPViewModel

/// 商品模型
@property (nonatomic, readonly, strong) TPShopGoodsModel *goods;
@property (readonly,copy, nonatomic) NSString *goodsID;
/// 初始化
- (instancetype)initWithGoods:(TPShopGoodsModel *)goods;

@end
