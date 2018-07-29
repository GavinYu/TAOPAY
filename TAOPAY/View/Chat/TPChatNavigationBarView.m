//
//  TPChatNavigationBarView.m
//  TAOPAY
//
//  Created by admin on 2018/7/22.
//  Copyright © 2018年 TAOPAY. All rights reserved.
//

#import "TPChatNavigationBarView.h"

#import "TPAppConfig.h"

@interface TPChatNavigationBarView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TPChatNavigationBarView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

//MARK: -- instance LoginNavigationView
+ (TPChatNavigationBarView *)instanceView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

//MARK: -- init subView
- (void)initSubViews {
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
