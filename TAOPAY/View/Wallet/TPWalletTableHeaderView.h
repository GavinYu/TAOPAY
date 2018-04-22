//
//  TPWalletTableHeaderView.h
//  TAOPAY
//
//  Created by admin on 2018/4/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TPMacros.h"

typedef NS_ENUM(NSUInteger, WTButtonEvent) {
    WTButtonEventBalanceDetail = BASETAG,
    WTButtonEventWriteUsername,
    WTButtonEventAddBankCard
};

typedef void(^WTClickWalletTableHeaderViewButtonEventBlock)(WTButtonEvent buttonEvent);

@interface TPWalletTableHeaderView : UIView

@property (nonatomic, copy) WTClickWalletTableHeaderViewButtonEventBlock clickButtonBlock;

@end
