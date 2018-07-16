//
//  TPReceiveAddressView.m
//  TAOPAY
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPReceiveAddressView.h"

#import "TPAddressModel.h"
#import "TPAppConfig.h"

@interface TPReceiveAddressView ()

@property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *tapButton;

@end

@implementation TPReceiveAddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (TPReceiveAddressView *)instanceReceiveAddressView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initSubViews];
}

//MARK: -- initSubView
- (void)initSubViews {
    _modifyButton.layer.cornerRadius = 5;
    _modifyButton.layer.masksToBounds = YES;
    _modifyButton.layer.borderWidth = 1.0;
    _modifyButton.layer.borderColor = TP_BG_RED_COLOR.CGColor;
}
//MARK: -- 更新子视图
- (void)updateSubView:(TPAddressModel *)addressModel {
    if (addressModel) {
        _nameLabel.text = addressModel.name;
        
        CGFloat nameWidth = [YUtil getTextWidthWithContent:_nameLabel.text withContentSizeOfHeight:_nameLabel.bounds.size.height withAttribute:@{NSFontAttributeName:_nameLabel.font}] + 5;
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressIconImageView.mas_right).offset(12);
            make.top.equalTo(self).offset(18);
            make.size.mas_equalTo(CGSizeMake(nameWidth, self.nameLabel.bounds.size.height));
        }];
        
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_right).offset(12);
            make.top.equalTo(self.nameLabel).offset(2);
            make.size.mas_equalTo(self.phoneLabel.bounds.size);
        }];
        _phoneLabel.text = addressModel.phone;
        _addressLabel.text = addressModel.address;
    }
}
//MARK: -- 修改按钮事件
- (IBAction)clickModifyButton:(UIButton *)sender {
    if (_modifyAddressBlock) {
        _modifyAddressBlock(self);
    }
}
//MARK: -- 点击整个地址栏事件
- (IBAction)clickTapButton:(UIButton *)sender {
    if (_tapBlock) {
        _tapBlock(sender);
    }
}

//MARK: -- Setter isShowModifyButton
- (void)setIsShowModifyButton:(BOOL)isShowModifyButton {
    if (_isShowModifyButton != isShowModifyButton) {
        _isShowModifyButton = isShowModifyButton;
        
        _addressIconImageView.image = [UIImage imageNamed:_isShowModifyButton?@"icon_order_address":@"icon_addressLocation"];
        _modifyButton.hidden = !_isShowModifyButton;
        _rightArrowImageView.hidden = !_modifyButton.hidden;
    }
}
//MARK: -- Setter addressModel
- (void)setAddressModel:(TPAddressModel *)addressModel {
    if (_addressModel != addressModel) {
        _addressModel = addressModel;
    
        [self updateSubView:_addressModel];
    }
}

@end
