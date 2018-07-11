//
//  TPCartGoodsViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPCartGoodsViewModel.h"

#import "TPAppConfig.h"
#import "YHTTPService.h"

#import "TPShoppingCartModel.h"
#import "TPShoppingCartGoodsModel.h"

@interface TPCartGoodsViewModel ()
/// 商品模型
@property (nonatomic, readwrite, strong) TPShoppingCartGoodsModel *goods;
@property (readwrite, copy, nonatomic) NSString *goodId;
@end

@implementation TPCartGoodsViewModel

- (instancetype)initWithGoods:(TPShoppingCartGoodsModel *)goods {
    if (self = [super init]) {
        self.goods = goods;
        self.goodId = goods.goodsID;
    }
    
    return self;
}



@end
