//
//  TPOrderPayTableFooterView.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderPayTableFooterView.h"

@interface TPOrderPayTableFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@end

@implementation TPOrderPayTableFooterView
//MARK: -- instance TPOrderTableFooterView
+ (TPOrderPayTableFooterView *)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

//MARK: -- 取消订单按钮事件
- (IBAction)clickAllButton:(UIButton *)sender {
    if (_clickAllBlock) {
        _clickAllBlock(self);
    }
}

//MARK: -- 去支付按钮事件
- (IBAction)clickPayButton:(UIButton *)sender {
    if (_clickPayBlock) {
        _clickPayBlock(self);
    }
}

//MARK: -- 更新子视图
- (void)updateSubViews:(NSString *)totalPrice {
    _moneyLabel.text = totalPrice ;
}
//MARK: -- Setter dataDictionary
- (void)setTotalPrice:(NSString *)totalPrice {
    if (_totalPrice != totalPrice) {
        _totalPrice = totalPrice;
        
        [self updateSubViews:_totalPrice];
    }
}

- (void)setOrderId:(NSString *)orderId {
    if (_orderId != orderId) {
        _orderId = orderId;
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
