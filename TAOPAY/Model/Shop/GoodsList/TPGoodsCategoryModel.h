//
//  TPGoodsCategoryModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@interface TPGoodsCategoryModel : YObject

//分类ID
@property (copy, nonatomic) NSString *categoryID;
//分类名
@property (copy, nonatomic) NSString *name;

@end
