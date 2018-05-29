//
//  TPLoginNavigationView.m
//  TAOPAY
//
//  Created by admin on 2018/4/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPLoginNavigationView.h"

#import "TPAppConfig.h"

@interface TPLoginNavigationView ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

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
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"TPLoginNavigationView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
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

- (void)setNavigationType:(TPNavigationType)navigationType {
    if (navigationType == TPNavigationTypeBlack) {
        self.backgroundColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_1;
        self.logoImageView.hidden = YES;
        [self.backButton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    } else {
        self.backgroundColor = TP_MAIN_NAVIGATIONBAR_BACKGROUNDCOLOR_2;
        self.logoImageView.hidden = NO;
        [self.backButton setImage:[UIImage imageNamed:@"icon_loginNavbar_back"] forState:UIControlStateNormal];
    }
}

@end
