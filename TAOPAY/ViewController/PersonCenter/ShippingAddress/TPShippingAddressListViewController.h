//
//  TPShippingAddressListViewController.h
//  TAOPAY
//
//  Created by admin on 2018/6/2.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewController.h"

@class TPAddressModel;

typedef void(^TPSelectAddressHandler)(TPAddressModel *selectedAddressModel);

@interface TPShippingAddressListViewController : TPTableViewController

@property (copy, nonatomic) TPSelectAddressHandler selectAddressBlock;

@end
