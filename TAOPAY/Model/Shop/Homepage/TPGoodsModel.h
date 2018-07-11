//
//  TPGoodsModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPGoodsModel : YObject

//商家ID
@property (copy, nonatomic) NSString *company_id;
//商品ID
@property (copy, nonatomic) NSString *goodsID;
//商品名称
@property (copy, nonatomic) NSString *name;
//商品简介
@property (copy, nonatomic) NSString *info;
//商品价格
@property (copy, nonatomic) NSString *price;
//商品原价
@property (copy, nonatomic) NSString *originPrice;
//商品图片
@property (copy, nonatomic) NSString *image;
//商品已售数量
@property (copy, nonatomic) NSString *count;
//商家距离
@property (copy, nonatomic) NSString *distance;

@end
