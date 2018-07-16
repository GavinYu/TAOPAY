//
//  TPOrderDetailSectionFooterView.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderDetailSectionFooterView.h"

#import "TPOrderInfoModel.h"

@interface TPOrderDetailSectionFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *realPayLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectSellerButton;
@property (weak, nonatomic) IBOutlet UIButton *telButton;

@end

@implementation TPOrderDetailSectionFooterView

//MARK: -- instance ShippingAddressTableFooterView
+ (TPOrderDetailSectionFooterView *)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
//MARK: -- 新增地址按钮事件
- (IBAction)clickConnectSellerButton:(UIButton *)sender {
    if (_clickConnectBlock) {
        _clickConnectBlock(sender);
    }
}

//MARK: -- 新增地址按钮事件
- (IBAction)clickTelButton:(UIButton *)sender {
    if (_clickTelBlock) {
        _clickTelBlock(sender);
    }
}

//MARK: -- 更新子视图
- (void)updateSubViews:(TPOrderInfoModel *)data {
    _realPayLabel.text = [NSString stringWithFormat:@"实付:￥%@(免运费)",data.total] ;
}
//MARK: -- Setter dataDictionary
- (void)setOrderInfoModel:(TPOrderInfoModel *)orderInfoModel {
    if (_orderInfoModel != orderInfoModel) {
        _orderInfoModel = orderInfoModel;
        
        [self updateSubViews:_orderInfoModel];
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
