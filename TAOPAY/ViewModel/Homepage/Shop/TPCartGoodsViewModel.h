//
//  TPCartGoodsViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@class TPShoppingCartGoodsModel;

@interface TPCartGoodsViewModel : TPTableViewModel

@property (readonly,copy, nonatomic) NSString *goodId;
////修改方式，0:增加一个 1:减少一个 2: 修改成指定数量
//@property (assign, nonatomic) TPCartModifyType modifyType;
////商品数量，type=2时指定的商品数量
@property (copy, nonatomic) NSString *goodsCount;
////商品总价
@property (copy, nonatomic) NSString *goodsTotalPrice;
//商品是否勾选
@property (assign, nonatomic) BOOL isSelected;
/// 购物车的商品模型
@property (nonatomic, readonly, strong) TPShoppingCartGoodsModel *goods;

- (instancetype)initWithGoods:(TPShoppingCartGoodsModel *)goods;

@end
