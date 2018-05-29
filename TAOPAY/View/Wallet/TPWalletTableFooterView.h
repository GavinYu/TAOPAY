//
//  TPWalletTableFooterView.h
//  TAOPAY
//
//  Created by admin on 2018/5/5.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TPWalletTableFooterButtonEventBlock)(UIButton *sender);

@interface TPWalletTableFooterView : UIView

@property (nonatomic, copy) TPWalletTableFooterButtonEventBlock clickNextButtonBlock;

+ (TPWalletTableFooterView *)instanceWalletTableFooterView;

@end
