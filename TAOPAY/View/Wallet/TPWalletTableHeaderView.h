//
//  TPWalletTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/4/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPMacros.h"

@class TPWalletTableHeaderViewModel;

typedef NS_ENUM(NSUInteger, TPButtonEvent) {
    TPButtonEventBalanceDetail = BASETAG,
    TPButtonEventWriteUsername,
    TPButtonEventAddBankCard
};

typedef void(^TPClickWalletTableHeaderViewButtonEventBlock)(TPButtonEvent buttonEvent);

@interface TPWalletTableHeaderView : UIView

@property (nonatomic, copy) TPClickWalletTableHeaderViewButtonEventBlock clickButtonBlock;

@property (nonatomic, strong) TPWalletTableHeaderViewModel *viewModel;

+ (TPWalletTableHeaderView *)instanceWalletTableHeaderView;



@end
