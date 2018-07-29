//
//  TPPersonalHomepageTableHeaderView.m
//  TAOPAY
//
//  Created by admin on 2018/7/17.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPPersonalHomepageTableHeaderView.h"

#import "TPUserInfoModel.h"

#import "TPAppConfig.h"

@interface TPPersonalHomepageTableHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
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
- (void)updateSubViews:(TPUserInfoModel *)userInfo {
    [_avatarButton setImageWithURL:[NSURL URLWithString:userInfo.avatar] forState:UIControlStateNormal placeholder:nil];
    _nickNameLabel.text = userInfo.nick;
    _signatureLabel.text = userInfo.info;
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

//MARK: -- Setter area
//MARK: -- Setter userInfoModel
- (void)setUserInfoModel:(TPUserInfoModel *)userInfoModel {
    if (_userInfoModel != userInfoModel) {
        _userInfoModel = userInfoModel;
        
        [self updateSubViews:_userInfoModel];
    }
}

- (void)setTableHeaderViewType:(TPTableHeaderViewType)tableHeaderViewType {
    if (tableHeaderViewType == TPTableHeaderViewTypePersonal) {
        self.backgroundColor = [UIColor whiteColor];
        [self.menuButton setImage:[UIImage imageNamed:@"icon_friend_menu"] forState:UIControlStateNormal];
        [self.searchButton setImage:[UIImage imageNamed:@"icon_friend_search"] forState:UIControlStateNormal];
        self.nickNameLabel.textColor = UICOLOR_FROM_HEXRGB(0x2b2e33);
        self.signatureLabel.textColor = UICOLOR_FROM_HEXRGB(0x2b2e33);
    } else {
        self.backgroundColor = UICOLOR_FROM_HEXRGB(0x2b2e33);
        [self.menuButton setImage:[UIImage imageNamed:@"btn_nav_friendcircle_menu"] forState:UIControlStateNormal];
        [self.searchButton setImage:[UIImage imageNamed:@"btn_nav_friendcircle_search"] forState:UIControlStateNormal];
        self.nickNameLabel.textColor = [UIColor whiteColor];
        self.signatureLabel.textColor = UICOLOR_FROM_HEXRGB(0x949293);
    }
}

@end
