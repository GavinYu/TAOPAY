//
//  TPOrderPayTableFooterView.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOrderPayTableFooterView;

typedef void(^TPClickAlllHandler)(TPOrderPayTableFooterView *sender);
typedef void(^TPClickPayHandler)(TPOrderPayTableFooterView *sender);

@interface TPOrderPayTableFooterView : UIView

@property (copy, nonatomic) TPClickAlllHandler clickAllBlock;
@property (copy, nonatomic) TPClickPayHandler clickPayBlock;

@property (strong, nonatomic) NSString *totalPrice;
@property (copy, nonatomic) NSString *orderId;

//MARK: -- instance TPOrderPayTableFooterView
+ (TPOrderPayTableFooterView *)instanceView;

@end
