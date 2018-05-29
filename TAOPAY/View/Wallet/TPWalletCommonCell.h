//
//  TPWalletCommonCell.h
//  TAOPAY
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

@class TPCardOperateViewModel;

@interface TPWalletCommonCell : YBaseTableViewCell

@property (nonatomic, strong) TPCardOperateViewModel *cardOperateViewModel;

@end
