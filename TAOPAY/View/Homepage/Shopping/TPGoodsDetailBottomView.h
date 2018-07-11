//
//  TPGoodsDetailBottomView.h
//  TAOPAY
//
//  Created by admin on 2018/6/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPGoodsInfoModel;

typedef void(^TPGoodsDetailCollectHandler)(UIButton *sender);
typedef void(^TPGoodsDetailServiceHandler)(UIButton *sender);
typedef void(^TPGoodsDetailIntagralBuyHandler)(UIButton *sender);
typedef void(^TPGoodsDetailBuyHandler)(UIButton *sender);

@interface TPGoodsDetailBottomView : UIView

@property (copy, nonatomic) TPGoodsDetailCollectHandler collectBlock;
@property (copy, nonatomic) TPGoodsDetailServiceHandler serviceBlock;
@property (copy, nonatomic) TPGoodsDetailIntagralBuyHandler intagralBuyBlock;
@property (copy, nonatomic) TPGoodsDetailBuyHandler buyBlock;
@property (assign, nonatomic) BOOL isCollect;

+ (TPGoodsDetailBottomView *)instanceGoodsDetailBottomView;

- (void)configData:(TPGoodsInfoModel *)goodsInfo;

@end
