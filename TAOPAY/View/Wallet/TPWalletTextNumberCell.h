//
//  TPWalletTextNumberCell.h
//  TAOPAY
//
//  Created by admin on 2018/4/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "YBaseTableViewCell.h"

typedef void(^TPClickCellButtonsBlock)(UIButton *sender);

@interface TPWalletTextNumberCell : YBaseTableViewCell

@property (nonatomic, copy) TPClickCellButtonsBlock cellButtonBlock;
@end
