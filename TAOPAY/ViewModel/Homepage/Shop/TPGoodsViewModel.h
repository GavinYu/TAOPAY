//
//  TPGoodsViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/23.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

#import <UIKit/UIKit.h>

@class TPGoodsModel;

@interface TPGoodsViewModel : TPViewModel

/// 商品模型
@property (nonatomic, readonly, strong) TPGoodsModel *goods;
@property (readonly,copy, nonatomic) NSString *goodsID;
/// 初始化
- (instancetype)initWithGoods:(TPGoodsModel *)goods;

@end
