//
//  TPShopHomepageModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YObject.h"

@class TPBannerModel;
@class TPGoodsModel;

@interface TPShopHomepageModel : YObject

@property (strong, nonatomic) NSArray <TPBannerModel *> *banner;
@property (strong, nonatomic) NSArray <TPBannerModel *> *event;
@property (strong, nonatomic) NSArray <TPGoodsModel *> *lsit;

@end
