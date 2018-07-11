//
//  TPShoppingCartBottomView.m
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingCartBottomView.h"

@interface TPShoppingCartBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;

@end

@implementation TPShoppingCartBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: -- instanceShoppingCartBottomView
+ (TPShoppingCartBottomView *)instanceShoppingCartBottomView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubViews];
    
}

//MARK: -- Setup subView
- (void)setupSubViews {
    //FIXME:TODO: -- 配置国际语言
    //    [_freeLabel setText:TPLocalizedString(<#key#>)];
}

- (IBAction)clickAccountButton:(UIButton *)sender {
    if (_accounttBlock) {
        _accounttBlock(sender);
    }
}

- (IBAction)clickAllSelectButton:(UIButton *)sender {
    if (_allSelectBlock) {
        _allSelectBlock(sender);
    }
}

//MARK: -- setter area


@end
