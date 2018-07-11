//
//  TPShopItemViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/7/1.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPViewModel.h"

@class TPShopModel;

@interface TPShopItemViewModel : TPViewModel

/// 商铺模型
@property (nonatomic, readonly, strong) TPShopModel *shop;
@property (readonly,copy, nonatomic) NSString *shopID;
@property (readonly,copy, nonatomic) NSString *shopName;
/// 初始化
- (instancetype)initWithShop:(TPShopModel *)shop;

@end
