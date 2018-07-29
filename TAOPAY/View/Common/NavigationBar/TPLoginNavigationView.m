//
//  TPLoginNavigationView.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPLoginNavigationView.h"

#import "TPAppConfig.h"
#import "AppDelegate.h"

#import "TPPersonCenterViewController.h"

@interface TPLoginNavigationView ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIImageView *downarrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *downarrowButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *personCenterButton;

@end

@implementation TPLoginNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//MARK: -- instance LoginNavigationView
+ (TPLoginNavigationView *)instanceLoginNavigationView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

//MARK: -- init subView
- (void)initSubViews {
    
}

- (IBAction)clickHomeButton:(UIButton *)sender {
    if (_clickHomeHandler) {
        _clickHomeHandler(sender);
    }
}
- (IBAction)clcikMeButton:(UIButton *)sender {
    if (_clickMeHandler) {
        _clickMeHandler(sender);
    }
}
- (IBAction)clickBackButton:(UIButton *)sender {
    if (_clickBackHandler) {
        _clickBackHandler(sender);
    }
}
- (IBAction)clickDownarrowButton:(UIButton *)sender {
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}

- (void)setIsShowBackButton:(BOOL)isShowBackButton {
    _isShowBackButton = isShowBackButton;
    
    self.backButton.hidden = !_isShowBackButton;
    if (isShowBackButton) {
        [self.logoImageView setImage:[UIImage imageNamed:@"icon_loginNavbar_detail_logo"]];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backButton.mas_right).offset(10);
            make.centerY.equalTo(self.backButton);
            make.size.mas_equalTo(CGSizeMake(51, 10));
        }];
    } else {
        [self.logoImageView setImage:[UIImage imageNamed:@"icon_loginNavbar_logo"]];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(31);
            make.size.mas_equalTo(CGSizeMake(80, 23));
        }];
    }
}

- (void)setIsShowNavRightButtons:(BOOL)isShowNavRightButtons {
    _isShowNavRightButtons = isShowNavRightButtons;
    
    self.homeButton.hidden = !_isShowNavRightButtons;
    self.personCenterButton.hidden = !_isShowNavRightButtons;
    self.searchButton.hidden = !_isShowNavRightButtons;
    
}

- (void)setIsShowDownArrowImage:(BOOL)isShowDownArrowImage {
    _isShowDownArrowImage = isShowDownArrowImage;
    
    self.downarrowImageView.hidden = !_isShowDownArrowImage;
    self.downarrowButton.hidden = !_isShowDownArrowImage;
}

- (void)setNavigationType:(TPNavigationType)navigationType {
    if (navigationType == TPNavigationTypeBlack) {
        self.backgroundColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
        self.titleLabel.textColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_2;
        self.logoImageView.hidden = YES;
        [self.backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    } else {
        self.backgroundColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_2;
        self.titleLabel.textColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
        self.logoImageView.hidden = NO;
        [self.backButton setImage:[UIImage imageNamed:@"icon_loginNavbar_back"] forState:UIControlStateNormal];
    }
}

- (void)setIsHiddenSearchButton:(BOOL)isHiddenSearchButton{
    if (_isHiddenSearchButton != isHiddenSearchButton) {
        _isHiddenSearchButton = isHiddenSearchButton;
        
        self.searchButton.hidden = isHiddenSearchButton;
    }
}

- (void)setIsHiddenHomepageButton:(BOOL)isHiddenHomepageButton {
    if (_isHiddenHomepageButton != isHiddenHomepageButton) {
        _isHiddenHomepageButton = isHiddenHomepageButton;
        
        self.homeButton.hidden = _isHiddenHomepageButton;
    }
}

- (void)setUpdateMeImageName:(NSString *)updateMeImageName {
    if (_updateMeImageName != updateMeImageName) {
        _updateMeImageName = updateMeImageName;
        
        [self.personCenterButton setImage:[UIImage imageNamed:updateMeImageName] forState:UIControlStateNormal];
    }
}

@end
