//
//  TPShopGoodsViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopGoodsViewModel.h"

#import "TPShopGoodsModel.h"

@interface TPShopGoodsViewModel ()
/// 商品模型
@property (nonatomic, readwrite, strong) TPShopGoodsModel *goods;
@property (readwrite, copy, nonatomic) NSString *goodsID;

@end

@implementation TPShopGoodsViewModel

- (instancetype)initWithGoods:(TPShopGoodsModel *)goods {
    if (self = [super init]) {
        self.goods = goods;
        self.goodsID = goods.goodsID;
    }
    
    return self;
}

@end
