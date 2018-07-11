//
//  TPShoppingTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/5/21.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPTabToolItemIndex) {
    TPTabToolItemIndexCate = 101,
    TPTabToolItemIndexHotel,
    TPTabToolItemIndexRecreation,
    TPTabToolItemIndexTaxFreeShop,
    TPTabToolItemIndexShopping
};

@class TPShopMainViewModel;

//banner 点击事件
typedef void(^TPClickBannerHandler)(NSInteger bannerIndex);
//滑动导航条 点击事件
typedef void(^TPClickScrollTabToolHandler)(TPTabToolItemIndex itemIndex);
// 点击广告事件
typedef void(^TPClickADHandler)(NSInteger adIndex);

@interface TPShoppingTableHeaderView : UIView

@property (nonatomic, copy) TPClickBannerHandler clickBannerBlock;
@property (nonatomic, copy) TPClickScrollTabToolHandler clickToolBlock;
@property (nonatomic, copy) TPClickADHandler clickADBlock;

@property (nonatomic, strong) TPShopMainViewModel *viewModel;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSArray *adsArray;

+ (TPShoppingTableHeaderView *)instanceShoppingTableHeaderView;


@end
