//
//  TPShoppingCartBottomView.m
//  TAOPAY
//
//  Created by admin on 2018/7/3.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShoppingCartBottomView.h"

#import "TPAppConfig.h"

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
    self.isAllSelected = YES;
    [self setupSubViews];
    
}

//MARK: -- Setup subView
- (void)setupSubViews {
    [self.allSelectButton setImage:[UIImage imageNamed:@"icon_address_normal"] forState:UIControlStateNormal];
    [self.allSelectButton setImage:[UIImage imageNamed:@"icon_shoppingCart_selected"] forState:UIControlStateSelected];
    //FIXME:TODO: -- 配置国际语言
    //    [_freeLabel setText:TPLocalizedString(<#key#>)];
}

- (IBAction)clickAccountButton:(UIButton *)sender {
    if (_accounttBlock) {
        _accounttBlock(sender);
    }
}

- (IBAction)clickAllSelectButton:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    
    if (_allSelectBlock) {
        _allSelectBlock(sender);
    }
}
//MARK: -- 更新子视图
- (void)updateSubViews:(NSString *)text {
    _totalMoneyLabel.text = [NSString stringWithFormat:@"￥%@", _totalMoney];
    
    CGFloat tmpWidth = [YUtil getTextWidthWithContent:_totalMoneyLabel.text withContentSizeOfHeight:_totalMoneyLabel.bounds.size.height withAttribute:@{NSFontAttributeName:_totalMoneyLabel.font}] + 15;
    [_totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accountButton.mas_left).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(tmpWidth, self.totalMoneyLabel.bounds.size.height));
    }];
    [_totalTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalMoneyLabel.mas_left);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(self.totalTipLabel.bounds.size);
    }];
    [self.totalMoneyLabel layoutIfNeeded];
    [self.totalTipLabel layoutIfNeeded];
    [self layoutIfNeeded];
}
//MARK: -- setter area
//MRAK: -- Setter total
- (void)setTotalMoney:(NSString *)totalMoney {
    if (_totalMoney != totalMoney) {
        _totalMoney = totalMoney;
        
        [self updateSubViews:_totalMoney];
    }
}

- (void)setIsAllSelected:(BOOL)isAllSelected {
    if (_isAllSelected != isAllSelected) {
        _isAllSelected = isAllSelected;
        
        [_allSelectButton setSelected:isAllSelected];
    }
}

@end
