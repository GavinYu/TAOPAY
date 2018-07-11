//
//  TPWalletTableFooterView.m
//  TAOPAY
//
//  Created by admin on 2018/5/5.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPWalletTableFooterView.h"

#import "TPMacros.h"

@interface TPWalletTableFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation TPWalletTableFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: -- instance WalletTableFooterView
+ (TPWalletTableFooterView *)instanceWalletTableFooterView {
NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TPWalletTableFooterView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//MARK: -- awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configSubViews];
}
//MARK: -- 配置子视图
- (void)configSubViews {
    [self.nextStepButton setTitle:TPLocalizedString(@"wallet_next_step") forState:UIControlStateNormal];
}
//MARK: -- 按钮事件
- (IBAction)clickNextButton:(UIButton *)sender {
    if (_clickNextButtonBlock) {
        _clickNextButtonBlock(sender);
    }
}

@end
