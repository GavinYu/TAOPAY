//
//  TPOrderDetailTableFooterView.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderDetailTableFooterView.h"

@interface TPOrderDetailTableFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UIButton *copNumButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;


@end

@implementation TPOrderDetailTableFooterView

//MARK: -- instance ShippingAddressTableFooterView
+ (TPOrderDetailTableFooterView *)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
//MARK: -- 新增地址按钮事件
- (IBAction)clickCpyButton:(UIButton *)sender {
    if (_clickCpyBlock) {
        _clickCpyBlock(sender);
    }
}

//MARK: -- 新增地址按钮事件
- (IBAction)clickCancelButton:(UIButton *)sender {
    if (_clickCancellBlock) {
        _clickCancellBlock(sender);
    }
}

//MARK: -- 新增地址按钮事件
- (IBAction)clickPayButton:(UIButton *)sender {
    if (_clickPayBlock) {
        _clickPayBlock(sender);
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
