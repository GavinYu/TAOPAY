//
//  TPShoppingCartBottomView.h
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPShoppingCartAllSelectHandler)(UIButton *sender);
typedef void(^TPShoppingCartAccountHandler)(UIButton *sender);

@interface TPShoppingCartBottomView : UIView

@property (copy, nonatomic) TPShoppingCartAllSelectHandler allSelectBlock;
@property (copy, nonatomic) TPShoppingCartAccountHandler accounttBlock;

+ (TPShoppingCartBottomView *)instanceShoppingCartBottomView;

@end
