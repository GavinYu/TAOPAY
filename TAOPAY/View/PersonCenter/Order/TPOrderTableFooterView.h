//
//  TPOrderTableFooterView.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOrderTableFooterView;

@class TPOrderModel;

typedef void(^TPClickCancelHandler)(TPOrderTableFooterView *sender);
typedef void(^TPClickPayHandler)(TPOrderTableFooterView *sender);

@interface TPOrderTableFooterView : UIView

@property (copy, nonatomic) TPClickCancelHandler clickCancellBlock;
@property (copy, nonatomic) TPClickPayHandler clickPayBlock;

@property (strong, nonatomic) TPOrderModel *orderModel;
@property (readonly, copy, nonatomic) NSString *orderId;
@property (readonly, copy, nonatomic) NSString *price;

//MARK: -- instance TPOrderTableFooterView
+ (TPOrderTableFooterView *)instanceView;



@end
