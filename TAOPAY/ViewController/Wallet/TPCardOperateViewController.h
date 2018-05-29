//
//  TPCardOperateViewController.h
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPTableViewController.h"

typedef void(^TPBackToWalletBlock)(id backValue);

@class TPCardOperateViewModel;

@interface TPCardOperateViewController : TPTableViewController

@property (nonatomic, strong) TPCardOperateViewModel *cardOperateViewModel;
@property (nonatomic, copy) TPBackToWalletBlock backBlock;


@end
