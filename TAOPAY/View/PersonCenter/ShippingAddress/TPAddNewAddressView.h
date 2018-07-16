//
//  TPAddNewAddressView.h
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPClickSelectAreaButtonsHandler)(UIButton *sender);
typedef void(^TPClickSaveButtonsHandler)(BOOL success);

@interface TPAddNewAddressView : UIView <UITextFieldDelegate>

@property (copy, nonatomic) TPClickSelectAreaButtonsHandler selectAreaBlock;
@property (copy, nonatomic) TPClickSaveButtonsHandler saveNewAddressBlock;
@property (copy, nonatomic) NSString *selectAreaId;

@property (copy, nonatomic) NSString *areaString;

//MARK: -- instance AddNewAddressView
+ (TPAddNewAddressView *)instanceAddNewAddressView;
- (void)show;
- (void)close;
//新增收货地址接口
- (void)addShippingAddressSuccess:(void(^)(id json))success
                          failure:(void (^)(NSString *error))failure;
@end
