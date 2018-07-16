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
        self.isSelected = YES;
        self.goodsCount = goods.count;
        self.goods = goods;
        self.goodId = goods.goodsID;
        self.goodsTotalPrice = [self accountGoodsTotalPrice:goods];
    }
    
    return self;
}
//MARK: -- 计算某件商品的总价
- (NSString *)accountGoodsTotalPrice:(TPShoppingCartGoodsModel *)goods {
    CGFloat price = [goods.price floatValue];
    NSInteger count = [goods.count integerValue];
    
    CGFloat total = price * count;
    
    return [NSString stringWithFormat:@"%.2f", total];
}

//MARK: -- Setter isSelected
- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        
        self.goodsTotalPrice = [self accountGoodsTotalPrice:self.goods];
    }
}

@end
