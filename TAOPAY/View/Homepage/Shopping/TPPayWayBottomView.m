//
//  TPPayWayBottomView.m
//  TAOPAY
//
//  Created by admin on 2018/7/7.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPayWayBottomView.h"

#import "TPAppConfig.h"

@interface TPPayWayBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTipLabel;

@end

@implementation TPPayWayBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: -- instanceGoodsDetailBottomView
+ (TPPayWayBottomView *)instancePayWayBottomView {
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

- (void)updateSubViews:(NSString *)totalMoney {
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@", _totalMoney];
    
    CGFloat tmpWidth = [YUtil getTextWidthWithContent:_moneyLabel.text withContentSizeOfHeight:CGRectGetHeight(_moneyLabel.frame) withAttribute:@{NSFontAttributeName:_moneyLabel.font}] + 10;
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.freeLabel.mas_left).offset(-3);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(tmpWidth, 20));
    }];
    
    [_payTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel.mas_left).offset(-3);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(52, 16));
    }];
    

}

- (IBAction)clickPayButton:(UIButton *)sender {
    if (_payBlock) {
        _payBlock(sender);
    }
}

//MARK: -- setter area
//MRAK: -- Setter total
- (void)setTotalMoney:(NSString *)totalMoney {
    if (_totalMoney != totalMoney) {
        _totalMoney = totalMoney;
        [self updateSubViews:_totalMoney];
    }
}

@end
