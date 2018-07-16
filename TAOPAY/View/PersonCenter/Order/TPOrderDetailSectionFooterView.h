//
//  TPOrderDetailSectionFooterView.h
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPOrderInfoModel;

typedef void(^TPClickConnectSellerHandler)(UIButton *sender);
typedef void(^TPClickTelHandler)(UIButton *sender);

@interface TPOrderDetailSectionFooterView : UIView

@property (copy, nonatomic) TPClickConnectSellerHandler clickConnectBlock;
@property (copy, nonatomic) TPClickTelHandler clickTelBlock;
@property (strong, nonatomic) TPOrderInfoModel *orderInfoModel;

//MARK: -- instance TPOrderDetailSectionFooterView
+ (TPOrderDetailSectionFooterView *)instanceView;

@end
