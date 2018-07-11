//
//  TPGoodsViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/5/23.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPGoodsViewModel.h"

#import "TPGoodsModel.h"

@interface TPGoodsViewModel ()
/// 商品模型
@property (nonatomic, readwrite, strong) TPGoodsModel *goods;
@property (readwrite, copy, nonatomic) NSString *goodsID;

@end

@implementation TPGoodsViewModel

- (instancetype)initWithGoods:(TPGoodsModel *)goods {
    if (self = [super init]) {
        self.goods = goods;
        self.goodsID = goods.goodsID;
    }
    
    return self;
}

@end
