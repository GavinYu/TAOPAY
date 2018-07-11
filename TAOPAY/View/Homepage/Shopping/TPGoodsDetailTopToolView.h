//
//  TPGoodsDetailTopToolView.h
//  TAOPAY
//
//  Created by admin on 2018/6/24.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPGoodsDetailBackHandle)(UIButton *sender);
typedef void(^TPGoodsDetailShareHandle)(UIButton *sender);

@interface TPGoodsDetailTopToolView : UIView

@property (copy, nonatomic) TPGoodsDetailBackHandle clickBackBlock;
@property (copy, nonatomic) TPGoodsDetailShareHandle clickShareBlock;

+ (TPGoodsDetailTopToolView *)instanceGoodsDetailTopToolView;

@end
