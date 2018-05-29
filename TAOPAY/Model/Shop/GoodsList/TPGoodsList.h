//
//  TPGoodsList.h
//  TAOPAY
//
//  Created by admin on 2018/5/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPShopGoodsModel;
@class TPGoodsCategoryModel;

@interface TPGoodsList : YObject
//分类
@property (strong, nonatomic) NSArray <TPGoodsCategoryModel *>*category;
//商品列表
@property (strong, nonatomic) NSArray <TPShopGoodsModel *>*list;

@end
