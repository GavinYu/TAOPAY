//
//  TPShopItemViewModel.m
//  TAOPAY
//
//  Created by admin on 2018/7/1.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShopItemViewModel.h"

#import "TPShopModel.h"

@interface TPShopItemViewModel ()
/// 商品模型
@property (nonatomic, readwrite, strong) TPShopModel *shop;
@property (readwrite, copy, nonatomic) NSString *shopID;
@property (readwrite,copy, nonatomic) NSString *shopName;

@end

@implementation TPShopItemViewModel

- (instancetype)initWithShop:(TPShopModel *)shop {
    if (self = [super init]) {
        self.shop = shop;
        self.shopID = shop.shopID;
        self.shopName = shop.name;
    }
    
    return self;
}

@end
