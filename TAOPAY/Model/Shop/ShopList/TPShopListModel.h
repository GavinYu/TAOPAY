//
//  TPShopListModel.h
//  TAOPAY
//
//  Created by admin on 2018/6/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPGoodsCategoryModel;
@class TPShopModel;

@interface TPShopListModel : YObject

//分类
@property (strong, nonatomic) NSArray <TPGoodsCategoryModel *>*category;
//商品列表
@property (strong, nonatomic) NSArray <TPShopModel *>*list;

@end
