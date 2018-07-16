//
//  TPOrderTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/7/14.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPOrderTableHeaderView.h"

#import "TPAppConfig.h"

#import "TPOrderModel.h"

@interface TPOrderTableHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitPayLabel;

@end

@implementation TPOrderTableHeaderView

//MARK: -- instance TPOrderTableHeaderView
+ (TPOrderTableHeaderView *)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubViews];
}

- (void)initSubViews {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
    [self addGestureRecognizer:tapGesture];
}

//MARK: -- Tap 手势
- (void)tapGestureEvent:(UIGestureRecognizer *)sender {
    if (_tapGestureBlock) {
        _tapGestureBlock(self);
    }
}

//MARK: -- 更新子视图
- (void)updateSubViews:(TPOrderModel *)orderModel {
//    [_logoImageView setImageWithURL:[NSURL URLWithString:data[@"logo"]] placeholder:nil];
//    _shopNameLabel.text = data[@"name"];
    _waitPayLabel.text = orderModel.status;
}
//MARK: -- Setter dataDictionary
- (void)setOrderModel:(TPOrderModel *)orderModel {
    if (_orderModel != orderModel) {
        _orderModel = orderModel;
        
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
