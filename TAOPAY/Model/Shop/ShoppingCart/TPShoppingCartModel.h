//
//  TPShoppingCartModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPShoppingCartGoodsModel;
@class TPAddressModel;

@interface TPShoppingCartModel : YObject

//地址
@property (strong, nonatomic) TPAddressModel *address;
//购物车商品列表
@property (strong, nonatomic) NSArray <TPShoppingCartGoodsModel *>*list;

@end
