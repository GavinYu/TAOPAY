//
//  TPWalletTextNumberCell.h
//  TAOPAY
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

@class TPCardOperateViewModel;

typedef void(^TPClickCellButtonsBlock)(UIButton *sender);

@interface TPWalletTextNumberCell : YBaseTableViewCell

@property (nonatomic, copy) TPClickCellButtonsBlock cellButtonBlock;

@property (strong, nonatomic) TPCardOperateViewModel *viewModel;

@end
