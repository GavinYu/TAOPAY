//
//  TPShippingAddressTableFooterView.h
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPClickAddAddressHandler)(UIButton *sender);

@interface TPShippingAddressTableFooterView : UIView

@property (copy, nonatomic) TPClickAddAddressHandler clickAddBlock;

//MARK: -- instance ShippingAddressTableFooterView
+ (TPShippingAddressTableFooterView *)instanceShippingAddressTableFooterView;

@end
