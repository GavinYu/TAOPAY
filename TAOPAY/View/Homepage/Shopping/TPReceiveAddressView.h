//
//  TPReceiveAddressView.h
//  TAOPAY
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPAddressModel;
@class TPReceiveAddressView;

typedef void(^TPModifyAddressHandler)(TPReceiveAddressView *sender);
typedef void(^TPAddressTapEventHandler)(UIButton *sender);

@interface TPReceiveAddressView : UIView

@property (copy, nonatomic) TPModifyAddressHandler modifyAddressBlock;
@property (copy, nonatomic) TPAddressTapEventHandler tapBlock;

@property (assign, nonatomic) BOOL isShowModifyButton;
@property (strong, nonatomic) TPAddressModel *addressModel;

+ (TPReceiveAddressView *)instanceReceiveAddressView;

@end
