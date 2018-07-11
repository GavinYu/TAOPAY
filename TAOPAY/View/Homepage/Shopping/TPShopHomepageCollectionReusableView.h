//
//  TPShopHomepageCollectionReusableView.h
//  TAOPAY
//
//  Created by admin on 2018/7/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TPSHOP_COLLECTION_HEADDERVIEW_HEIGHT 306.0

@class YSliderView;
@class TPShopGoodsListViewModel;

@interface TPShopHomepageCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) TPShopGoodsListViewModel *viewModel;
@property (strong, nonatomic) YSliderView *sliderView;
@property (strong, nonatomic) NSArray *catArray;

+ (TPShopHomepageCollectionReusableView *)instanceShopHomepageCollectionHeaderView;

@end
