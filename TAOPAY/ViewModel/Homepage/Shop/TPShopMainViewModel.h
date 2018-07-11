//
//  TPShopMainViewModel.h
//  TAOPAY
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewModel.h"

@class YLocationModel;
@class TPShopHomepageModel;

@interface TPShopMainViewModel : TPTableViewModel

@property (strong, nonatomic) YLocationModel *currentLocationModel;
@property (strong, nonatomic) TPShopHomepageModel *shopHomepageModel;
@property (copy, nonatomic) NSString *cat;
@property (copy, nonatomic) NSString *cat2;
@property (strong, nonatomic) NSArray *bannerData;
@property (strong, nonatomic) NSArray *adData;
@property (strong, nonatomic) NSArray *cat1Array;


/// 获取商城首页信息 为了减少View对viewModel的状态的监听 这里采用block回调来减少状态的处理
- (void)getShopMainSuccess:(void(^)(id json))success
                   failure:(void (^)(NSString *error))failure;

@end
