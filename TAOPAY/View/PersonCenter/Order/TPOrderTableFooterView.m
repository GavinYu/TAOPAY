//
//  TPOrderTableFooterView.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderTableFooterView.h"

#import "TPOrderModel.h"

@interface TPOrderTableFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *realPayLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (readwrite, copy, nonatomic) NSString *orderId;
@property (readwrite, copy, nonatomic) NSString *price;

@end

@implementation TPOrderTableFooterView

//MARK: -- instance TPOrderTableFooterView
+ (TPOrderTableFooterView *)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

//MARK: -- 取消订单按钮事件
- (IBAction)clickCancelButton:(UIButton *)sender {
    if (_clickCancellBlock) {
        _clickCancellBlock(self);
    }
}

//MARK: -- 去支付按钮事件
- (IBAction)clickPayButton:(UIButton *)sender {
    if (_clickPayBlock) {
        _clickPayBlock(self);
    }
}

//MARK: -- 更新子视图
- (void)updateSubViews:(TPOrderModel *)orderModel {
    _realPayLabel.text = [NSString stringWithFormat:@"实付:￥%@(免运费)", orderModel.price] ;
}

//MARK: -- Setter orderModel
- (void)setOrderModel:(TPOrderModel *)orderModel {
    if (_orderModel != orderModel) {
        _orderModel = orderModel;
        self.orderId = _orderModel.orderId;
        self.price = _orderModel.price;
        [self updateSubViews:_orderModel];
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
