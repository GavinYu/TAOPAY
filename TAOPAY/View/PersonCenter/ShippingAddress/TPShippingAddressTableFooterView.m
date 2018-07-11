//
//  TPShippingAddressTableFooterView.m
//  TAOPAY
//
//  Created by admin on 2018/6/9.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPShippingAddressTableFooterView.h"

@implementation TPShippingAddressTableFooterView

//MARK: -- instance ShippingAddressTableFooterView
+ (TPShippingAddressTableFooterView *)instanceShippingAddressTableFooterView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];

}
//MARK: -- 新增地址按钮事件
- (IBAction)clickAddAddressButton:(UIButton *)sender {
    if (_clickAddBlock) {
        _clickAddBlock(sender);
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
