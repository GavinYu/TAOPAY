//
//  TPWalletTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/4/15.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletTableHeaderView.h"

@interface TPWalletTableHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation TPWalletTableHeaderView
//MARK: --  余额明细按钮事件
- (IBAction)clickdetailButton:(UIButton *)sender {
    if (_clickButtonBlock) {
        _clickButtonBlock(sender.tag);
    }
}
//MARK: --  填写户名按钮事件
- (IBAction)clickWriteUsernameButton:(UIButton *)sender {
    if (_clickButtonBlock) {
        _clickButtonBlock(sender.tag);
    }
}
//MARK: --  添加银行卡按钮事件
- (IBAction)clickAddBankCardButton:(UIButton *)sender {
    if (_clickButtonBlock) {
        _clickButtonBlock(sender.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
