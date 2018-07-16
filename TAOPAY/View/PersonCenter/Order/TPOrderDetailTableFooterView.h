//
//  TPOrderDetailTableFooterView.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPClickCpyHandler)(UIButton *sender);
typedef void(^TPClickCancelHandler)(UIButton *sender);
typedef void(^TPClickPayHandler)(UIButton *sender);

@interface TPOrderDetailTableFooterView : UIView

@property (copy, nonatomic) TPClickCpyHandler clickCpyBlock;
@property (copy, nonatomic) TPClickCancelHandler clickCancellBlock;
@property (copy, nonatomic) TPClickPayHandler clickPayBlock;

//MARK: -- instance TPOrderDetailTableFooterView
+ (TPOrderDetailTableFooterView *)instanceView;

@end
