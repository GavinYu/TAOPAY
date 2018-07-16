//
//  TPOrderTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOrderTableHeaderView;

@class TPOrderModel;

typedef void(^TPTapGestureHandler)(TPOrderTableHeaderView *sender);

@interface TPOrderTableHeaderView : UIView

@property (copy, nonatomic) TPTapGestureHandler tapGestureBlock;
@property (strong, nonatomic) TPOrderModel *orderModel;

//MARK: -- instance TPOrderTableHeaderView
+ (TPOrderTableHeaderView *)instanceView;

@end
