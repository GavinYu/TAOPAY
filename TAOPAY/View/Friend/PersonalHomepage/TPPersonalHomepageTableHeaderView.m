//
//  TPPersonalHomepageTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonalHomepageTableHeaderView.h"

@interface TPPersonalHomepageTableHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@end

@implementation TPPersonalHomepageTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: -- instance TPOrderTableHeaderView
+ (TPPersonalHomepageTableHeaderView *)instanceView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubViews];
}

- (void)initSubViews {

}

//MARK: -- 更新子视图
- (void)updateSubViews:(id )orderModel {
 
}

- (IBAction)clickMenuButton:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    
    if (_clickMenuBlock) {
        _clickMenuBlock(sender);
    }
}
- (IBAction)clickSearchButton:(UIButton *)sender {
    if (_clickSearchBlock) {
        _clickSearchBlock(sender);
    }
}
- (IBAction)tapAvatarButton:(UIButton *)sender {
    if (_clickAvatarBlock) {
        _clickAvatarBlock(self);
    }
}

@end
