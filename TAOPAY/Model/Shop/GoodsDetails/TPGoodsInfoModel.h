//
//  TPGoodsInfoModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/30.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPGoodsInfoModel : YObject

//商品ID
@property (copy, nonatomic) NSString *goodsID;
//商品名称
@property (copy, nonatomic) NSString *name;
//商品详情
@property (copy, nonatomic) NSString *info;
//商家简介
@property (copy, nonatomic) NSString *sinfo;
//商品价格
@property (copy, nonatomic) NSString *price;
//商品原价
@property (copy, nonatomic) NSString *originPrice;
//商品图片
@property (copy, nonatomic) NSString *image;

@end
