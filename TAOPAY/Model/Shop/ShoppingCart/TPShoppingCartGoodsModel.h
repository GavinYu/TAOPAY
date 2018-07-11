//
//  TPShoppingCartGoodsModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPShoppingCartGoodsModel : YObject

//商品ID
@property (copy, nonatomic) NSString *goodsID;
//商品名称
@property (copy, nonatomic) NSString *name;
//商品价格
@property (copy, nonatomic) NSString *price;
//商品图片
@property (copy, nonatomic) NSString *image;
//商品已售数量
@property (copy, nonatomic) NSString *count;

@end
