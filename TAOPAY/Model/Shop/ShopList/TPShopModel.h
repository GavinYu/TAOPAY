//
//  TPShopModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/26.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPShopModel : YObject

//商家ID
@property (copy, nonatomic) NSString *id;
//商家名称
@property (copy, nonatomic) NSString *name;
//商家封面图片
@property (copy, nonatomic) NSString *image;
//商家评分
@property (copy, nonatomic) NSString *star;
//商家商品已售数量
@property (copy, nonatomic) NSString *orderCount;
//商家商品数量
@property (copy, nonatomic) NSString *goodsCount;
//商家距离
@property (copy, nonatomic) NSString *distance;

@end
